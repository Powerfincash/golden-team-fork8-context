//+------------------------------------------------------------------+
//| GT_Controle.mq4 — même espion que GT_Controle.mq5, pour MT4      |
//|                                                                  |
//| LECTURE SEULE : aucune fonction de trading n'est appelée          |
//| (aucune occurrence de OrderSend / OrderClose / OrderModify).      |
//| Mêmes fichiers, même format : tableau.py lit les deux.            |
//|                                                                  |
//| Différences imposées par MT4 :                                   |
//|  - pas d'événement d'exécution : les ordres nouveaux ou fermés    |
//|    sont repérés à chaque relevé (5 s), le spread et le ping notés |
//|    sont ceux de ce relevé ;                                      |
//|  - le prix demandé d'une entrée au marché n'existe pas en MT4 :   |
//|    le glissement n'est mesuré que sur stop ou objectif touché ;   |
//|  - pas de délai serveur.                                         |
//+------------------------------------------------------------------+
#property copyright "Golden Team fork 8"
#property version   "1.00"
#property strict
#property description "Contrôle en lecture seule : n'envoie aucun ordre."

input int  PeriodeSecondes    = 5;
input int  PeriodeEquiteSec   = 60;
input int  PeriodeHistoMin    = 15;
input int  PeriodeReglagesMin = 5;

string   g_dossier;
datetime g_dernEquite = 0, g_dernHisto = 0, g_dernReglages = 0;
bool     g_connecte = true;
datetime g_debutCoupure = 0;
string   g_graphiquesJson = "[]";
int      g_ouverts[];          // tickets ouverts au relevé précédent
int      g_nbHisto = -1;       // taille de l'historique au relevé précédent

string   g_spSym[];
double   g_spMin[], g_spMax[], g_spSom[];
int      g_spN[];

//+------------------------------------------------------------------+
string Esc(string s)
  {
   StringReplace(s, "\\", "\\\\");
   StringReplace(s, "\"", "\\\"");
   StringReplace(s, "\r", "");
   StringReplace(s, "\n", " ");
   StringReplace(s, "\t", " ");
   return s;
  }
string Q(string s) { return "\"" + Esc(s) + "\""; }
string D(double v, int dig = 2) { return DoubleToString(v, dig); }
string Horo(datetime t) { return TimeToString(t, TIME_DATE | TIME_SECONDS); }
string Csv(string s) { StringReplace(s, ";", ","); StringReplace(s, "\n", " "); return s; }
long   Decal() { return (long)(TimeCurrent() - TimeGMT()); }

bool EcrireFichier(string nom, string contenu)
  {
   string tmp = g_dossier + nom + ".tmp";
   int h = FileOpen(tmp, FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_COMMON, 0, CP_UTF8);
   if(h == INVALID_HANDLE) return false;
   FileWriteString(h, contenu);
   FileClose(h);
   return FileMove(tmp, FILE_COMMON, g_dossier + nom, FILE_COMMON | FILE_REWRITE);
  }

void AjouterLigne(string nom, string entete, string ligne)
  {
   string chemin = g_dossier + nom;
   bool neuf = !FileIsExist(chemin, FILE_COMMON);
   int h = FileOpen(chemin, FILE_READ | FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_COMMON | FILE_SHARE_READ, 0, CP_UTF8);
   if(h == INVALID_HANDLE) return;
   FileSeek(h, 0, SEEK_END);
   if(neuf) FileWriteString(h, entete + "\n");
   FileWriteString(h, ligne + "\n");
   FileClose(h);
  }

double PingMs() { return TerminalInfoInteger(TERMINAL_PING_LAST) / 1000.0; }

double ValeurMouvement(string sym, double ecartPrix, double volume)
  {
   double tv = MarketInfo(sym, MODE_TICKVALUE);
   double ts = MarketInfo(sym, MODE_TICKSIZE);
   if(ts <= 0) return 0;
   return ecartPrix / ts * tv * volume;
  }

void AjouterUnique(string &liste[], string s)
  {
   for(int i = 0; i < ArraySize(liste); i++) if(liste[i] == s) return;
   int n = ArraySize(liste); ArrayResize(liste, n + 1); liste[n] = s;
  }

bool EstTrade(int type) { return type == OP_BUY || type == OP_SELL; }

//+------------------------------------------------------------------+
void NoterSpread(string sym)
  {
   double sp = MarketInfo(sym, MODE_SPREAD);
   int n = ArraySize(g_spSym), i;
   for(i = 0; i < n; i++) if(g_spSym[i] == sym) break;
   if(i == n)
     {
      ArrayResize(g_spSym, n + 1); ArrayResize(g_spMin, n + 1); ArrayResize(g_spMax, n + 1);
      ArrayResize(g_spSom, n + 1); ArrayResize(g_spN, n + 1);
      g_spSym[i] = sym; g_spSom[i] = 0; g_spN[i] = 0;
     }
   if(g_spN[i] == 0) { g_spMin[i] = sp; g_spMax[i] = sp; }
   g_spMin[i] = MathMin(g_spMin[i], sp);
   g_spMax[i] = MathMax(g_spMax[i], sp);
   g_spSom[i] += sp; g_spN[i]++;
  }

void SymbolesSurveilles(string &liste[])
  {
   ArrayResize(liste, 0);
   long c = ChartFirst();
   while(c >= 0) { AjouterUnique(liste, ChartSymbol(c)); c = ChartNext(c); }
   for(int i = OrdersTotal() - 1; i >= 0; i--)
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && EstTrade(OrderType())) AjouterUnique(liste, OrderSymbol());
  }

//+------------------------------------------------------------------+
// C. réglages lus dans un modèle sauvegardé du graphique
string LireFichierTexte(string nom)
  {
   string txt = "";
   int h = FileOpen(nom, FILE_READ | FILE_TXT | FILE_ANSI | FILE_SHARE_READ);
   if(h != INVALID_HANDLE)
     {
      while(!FileIsEnding(h)) txt += FileReadString(h) + "\n";
      FileClose(h);
     }
   if(StringFind(txt, "<chart>") < 0)
     {
      txt = "";
      h = FileOpen(nom, FILE_READ | FILE_TXT | FILE_UNICODE | FILE_SHARE_READ);
      if(h != INVALID_HANDLE)
        {
         while(!FileIsEnding(h)) txt += FileReadString(h) + "\n";
         FileClose(h);
        }
     }
   return txt;
  }

string ReglagesGraphique(long id, string &robot, string &etat)
  {
   string nom = "GT_Controle_modele_" + IntegerToString(id);
   etat = "ok"; robot = "";
   // « \Files\ » : le modèle est écrit dans MQL4\Files, lisible par l'espion
   if(!ChartSaveTemplate(id, "\\Files\\" + nom)) { etat = "modele_non_sauve"; return "{}"; }
   string txt = LireFichierTexte(nom + ".tpl");
   FileDelete(nom + ".tpl");
   if(txt == "") { etat = "modele_illisible"; return "{}"; }
   int e0 = StringFind(txt, "<expert>");
   if(e0 < 0) { etat = "aucun_robot"; return "{}"; }
   int n0 = StringFind(txt, "name=", e0);
   if(n0 > 0)
     {
      int n1 = StringFind(txt, "\n", n0);
      robot = StringSubstr(txt, n0 + 5, n1 - n0 - 5);
      StringTrimRight(robot);
     }
   int i0 = StringFind(txt, "<inputs>", e0);
   int i1 = StringFind(txt, "</inputs>", e0);
   if(i0 < 0 || i1 < 0) return "{}";
   string bloc = StringSubstr(txt, i0 + 8, i1 - i0 - 8);
   string lignes[];
   int n = StringSplit(bloc, '\n', lignes);
   string json = "{";
   bool premier = true;
   for(int k = 0; k < n; k++)
     {
      string l = lignes[k];
      StringTrimLeft(l); StringTrimRight(l);
      int eq = StringFind(l, "=");
      if(eq <= 0) continue;
      json += (premier ? "" : ",") + Q(StringSubstr(l, 0, eq)) + ":" + Q(StringSubstr(l, eq + 1));
      premier = false;
     }
   return json + "}";
  }

void RelireGraphiques()
  {
   string json = "[";
   long c = ChartFirst();
   bool premier = true;
   while(c >= 0)
     {
      string robot = "", etat = "espion", reglages = "{}";
      if(c != ChartID()) reglages = ReglagesGraphique(c, robot, etat);
      else robot = WindowExpertName();
      json += (premier ? "" : ",") + "{\"id\":" + IntegerToString(c)
              + ",\"symbole\":" + Q(ChartSymbol(c))
              + ",\"periode\":" + Q(StringSubstr(EnumToString(ChartPeriod(c)), 7))
              + ",\"robot\":" + Q(robot)
              + ",\"etat\":" + Q(etat)
              + ",\"reglages\":" + reglages + "}";
      premier = false;
      c = ChartNext(c);
     }
   g_graphiquesJson = json + "]";
  }

//+------------------------------------------------------------------+
void EcrireEtat()
  {
   string sym[];
   SymbolesSurveilles(sym);
   for(int i = 0; i < ArraySize(sym); i++) NoterSpread(sym[i]);

   string pos = "[";
   bool prem = true;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES) || !EstTrade(OrderType())) continue;
      string s = OrderSymbol();
      int dg = (int)MarketInfo(s, MODE_DIGITS);
      double sl = OrderStopLoss(), po = OrderOpenPrice();
      string perteSl = "null";
      if(sl > 0) perteSl = D(ValeurMouvement(s, OrderType() == OP_BUY ? sl - po : po - sl, OrderLots()));
      pos += (prem ? "" : ",") + "{\"ticket\":" + IntegerToString(OrderTicket())
             + ",\"symbole\":" + Q(s)
             + ",\"sens\":" + Q(OrderType() == OP_BUY ? "achat" : "vente")
             + ",\"volume\":" + D(OrderLots())
             + ",\"prix\":" + D(po, dg)
             + ",\"sl\":" + D(sl, dg)
             + ",\"tp\":" + D(OrderTakeProfit(), dg)
             + ",\"profit\":" + D(OrderProfit() + OrderCommission())
             + ",\"swap\":" + D(OrderSwap())
             + ",\"perte_au_sl\":" + perteSl
             + ",\"magic\":" + IntegerToString(OrderMagicNumber())
             + ",\"commentaire\":" + Q(OrderComment())
             + ",\"ouverture_utc\":" + Q(Horo(OrderOpenTime() - (datetime)Decal()))
             + "}";
      prem = false;
     }
   pos += "]";

   string sp = "[";
   for(int i = 0; i < ArraySize(sym); i++)
      sp += (i > 0 ? "," : "") + "{\"symbole\":" + Q(sym[i])
            + ",\"spread_points\":" + D(MarketInfo(sym[i], MODE_SPREAD), 0)
            + ",\"point\":" + DoubleToString(MarketInfo(sym[i], MODE_POINT), 8) + "}";
   sp += "]";

   string json = "{\"version\":\"1.00-mt4\""
      + ",\"releve_utc\":" + Q(Horo(TimeGMT()))
      + ",\"decalage_serveur_s\":" + IntegerToString(Decal())
      + ",\"compte\":{"
      + "\"numero\":" + IntegerToString(AccountNumber())
      + ",\"serveur\":" + Q(AccountServer())
      + ",\"courtier\":" + Q(AccountCompany())
      + ",\"devise\":" + Q(AccountCurrency())
      + ",\"reel\":" + (IsDemo() ? "false" : "true")
      + ",\"solde\":" + D(AccountBalance())
      + ",\"equite\":" + D(AccountEquity())
      + ",\"marge\":" + D(AccountMargin())
      + ",\"marge_libre\":" + D(AccountFreeMargin())
      + ",\"niveau_marge\":" + D(AccountMargin() > 0 ? 100 * AccountEquity() / AccountMargin() : 0)
      + ",\"appel_marge\":" + D(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL))
      + ",\"stop_out\":" + D(AccountStopoutLevel())
      + ",\"levier\":" + IntegerToString(AccountLeverage())
      + "}"
      + ",\"terminal\":{"
      + "\"connecte\":" + (IsConnected() ? "true" : "false")
      + ",\"ping_ms\":" + D(PingMs(), 1)
      + ",\"algo_autorise\":" + (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) ? "true" : "false")
      + ",\"compte_autorise_robots\":" + (AccountInfoInteger(ACCOUNT_TRADE_EXPERT) ? "true" : "false")
      + ",\"cpu\":" + IntegerToString(TerminalInfoInteger(TERMINAL_CPU_CORES))
      + ",\"memoire_utilisee_mo\":" + IntegerToString(TerminalInfoInteger(TERMINAL_MEMORY_USED))
      + ",\"build\":" + IntegerToString(TerminalInfoInteger(TERMINAL_BUILD))
      + ",\"chemin\":" + Q(TerminalInfoString(TERMINAL_DATA_PATH))
      + "}"
      + ",\"positions\":" + pos
      + ",\"spreads\":" + sp
      + ",\"graphiques\":" + g_graphiquesJson
      + "}";
   EcrireFichier("etat.json", json);
  }

void EcrireEquite()
  {
   AjouterLigne("equite.csv",
                "utc;solde;equite;flottant;niveau_marge;marge_libre;positions;ping_ms;connecte",
                Horo(TimeGMT()) + ";" + D(AccountBalance()) + ";" + D(AccountEquity()) + ";"
                + D(AccountEquity() - AccountBalance()) + ";"
                + D(AccountMargin() > 0 ? 100 * AccountEquity() / AccountMargin() : 0) + ";"
                + D(AccountFreeMargin()) + ";" + IntegerToString(OrdersTotal()) + ";"
                + D(PingMs(), 1) + ";" + (IsConnected() ? "1" : "0"));
   for(int i = 0; i < ArraySize(g_spSym); i++)
     {
      if(g_spN[i] == 0) continue;
      AjouterLigne("spreads.csv", "utc;symbole;min;moyen;max;releves",
                   Horo(TimeGMT()) + ";" + g_spSym[i] + ";" + D(g_spMin[i], 0) + ";"
                   + D(g_spSom[i] / g_spN[i], 1) + ";" + D(g_spMax[i], 0) + ";" + IntegerToString(g_spN[i]));
      g_spN[i] = 0; g_spSom[i] = 0;
     }
  }

void SuivreConnexion()
  {
   bool c = IsConnected();
   if(c == g_connecte) return;
   if(!c) g_debutCoupure = TimeGMT();
   else
      AjouterLigne("coupures.csv", "debut_utc;fin_utc;duree_s",
                   Horo(g_debutCoupure) + ";" + Horo(TimeGMT()) + ";" + IntegerToString((long)(TimeGMT() - g_debutCoupure)));
   g_connecte = c;
  }

//+------------------------------------------------------------------+
// historique : un ordre MT4 fermé = une ligne d'entrée + une ligne de sortie,
// pour garder le format de la version MT5
void EcrireHistorique()
  {
   string txt = "utc;ticket;ordre;position;symbole;type;entree;volume;prix;profit;swap;commission;frais;magic;commentaire\n";
   long dc = Decal();
   int n = OrdersHistoryTotal();
   for(int i = 0; i < n; i++)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
      int t = OrderType();
      string s = OrderSymbol();
      if(t == 6 || t == 7)   // dépôt, retrait, crédit
        {
         txt += Horo(OrderOpenTime() - (datetime)dc) + ";" + IntegerToString(OrderTicket()) + ";0;0;;solde;in;0;0;"
                + D(OrderProfit()) + ";0;0;0;0;" + Csv(OrderComment()) + "\n";
         continue;
        }
      if(!EstTrade(t)) continue;
      int dg = (int)MarketInfo(s, MODE_DIGITS);
      string sensIn = (t == OP_BUY) ? "achat" : "vente", sensOut = (t == OP_BUY) ? "vente" : "achat";
      string tk = IntegerToString(OrderTicket());
      txt += Horo(OrderOpenTime() - (datetime)dc) + ";" + tk + ";" + tk + ";" + tk + ";" + s + ";" + sensIn + ";in;"
             + D(OrderLots()) + ";" + D(OrderOpenPrice(), dg) + ";0;0;0;0;" + IntegerToString(OrderMagicNumber()) + ";" + Csv(OrderComment()) + "\n";
      txt += Horo(OrderCloseTime() - (datetime)dc) + ";" + tk + ";" + tk + ";" + tk + ";" + s + ";" + sensOut + ";out;"
             + D(OrderLots()) + ";" + D(OrderClosePrice(), dg) + ";" + D(OrderProfit()) + ";" + D(OrderSwap()) + ";"
             + D(OrderCommission()) + ";0;" + IntegerToString(OrderMagicNumber()) + ";" + Csv(OrderComment()) + "\n";
     }
   EcrireFichier("historique.csv", txt);
  }

//+------------------------------------------------------------------+
// A : exécutions repérées au relevé (ordres apparus, ordres fermés)
void LigneExecution(string s, string sens, string entree, string typeOrdre, double vol,
                    double demande, double obtenu, int ticket, int magic, string comm, datetime quand)
  {
   int dg = (int)MarketInfo(s, MODE_DIGITS);
   double pt = MarketInfo(s, MODE_POINT);
   string gp = "", ga = "";
   if(demande > 0 && pt > 0)
     {
      double g = (sens == "achat") ? (obtenu - demande) : (demande - obtenu);
      gp = D(g / pt, 1); ga = D(ValeurMouvement(s, g, vol));
     }
   string tk = IntegerToString(ticket);
   AjouterLigne("executions.csv",
                "utc;ticket;ordre;position;symbole;sens;entree;type_ordre;volume;prix_demande;prix_obtenu;glissement_points;glissement_argent;delai_serveur_ms;spread_points;ping_ms;magic;commentaire",
                Horo(quand - (datetime)Decal()) + ";" + tk + ";" + tk + ";" + tk + ";" + s + ";" + sens + ";" + entree + ";"
                + typeOrdre + ";" + D(vol) + ";" + (demande > 0 ? DoubleToString(demande, dg) : "") + ";"
                + DoubleToString(obtenu, dg) + ";" + gp + ";" + ga + ";;"
                + D(MarketInfo(s, MODE_SPREAD), 0) + ";" + D(PingMs(), 1) + ";" + IntegerToString(magic) + ";" + Csv(comm));
  }

bool DansListe(int &liste[], int v)
  {
   for(int i = 0; i < ArraySize(liste); i++) if(liste[i] == v) return true;
   return false;
  }

void SuivreExecutions()
  {
   int maintenant[];
   ArrayResize(maintenant, 0);
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES) || !EstTrade(OrderType())) continue;
      int n = ArraySize(maintenant); ArrayResize(maintenant, n + 1); maintenant[n] = OrderTicket();
      if(g_nbHisto >= 0 && !DansListe(g_ouverts, OrderTicket()))
         LigneExecution(OrderSymbol(), OrderType() == OP_BUY ? "achat" : "vente", "in",
                        OrderType() == OP_BUY ? "BUY" : "SELL", OrderLots(), 0, OrderOpenPrice(),
                        OrderTicket(), OrderMagicNumber(), OrderComment(), OrderOpenTime());
     }
   // ordres fermés depuis le relevé précédent
   int nh = OrdersHistoryTotal();
   if(g_nbHisto >= 0)
      for(int k = 0; k < ArraySize(g_ouverts); k++)
        {
         if(DansListe(maintenant, g_ouverts[k])) continue;
         if(!OrderSelect(g_ouverts[k], SELECT_BY_TICKET, MODE_HISTORY) || OrderCloseTime() == 0) continue;
         string c = OrderComment();
         double demande = 0; string typeOrdre = "FERMETURE";
         if(StringFind(c, "[sl]") >= 0) { demande = OrderStopLoss(); typeOrdre = "STOP_TOUCHE"; }
         else if(StringFind(c, "[tp]") >= 0) { demande = OrderTakeProfit(); typeOrdre = "OBJECTIF_TOUCHE"; }
         else if(StringFind(c, "so:") >= 0) typeOrdre = "STOP_OUT";
         LigneExecution(OrderSymbol(), OrderType() == OP_BUY ? "vente" : "achat", "out", typeOrdre,
                        OrderLots(), demande, OrderClosePrice(), OrderTicket(), OrderMagicNumber(), c, OrderCloseTime());
        }
   ArrayResize(g_ouverts, ArraySize(maintenant));
   if(ArraySize(maintenant) > 0) ArrayCopy(g_ouverts, maintenant);
   g_nbHisto = nh;
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   g_dossier = "GT_Controle\\" + IntegerToString(AccountNumber()) + "\\";
   g_connecte = IsConnected();
   if(!g_connecte) g_debutCoupure = TimeGMT();
   SuivreExecutions();          // premier passage : mémorise l'existant sans l'écrire
   RelireGraphiques();
   EcrireHistorique();
   EcrireEtat();
   g_dernReglages = g_dernHisto = TimeLocal();
   EventSetTimer(MathMax(1, PeriodeSecondes));
   Print("GT_Controle MT4 : lecture seule, fichiers dans Common\\Files\\", g_dossier);
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason) { EventKillTimer(); }

void OnTimer()
  {
   datetime now = TimeLocal();
   SuivreConnexion();
   SuivreExecutions();
   if(now - g_dernReglages >= PeriodeReglagesMin * 60) { RelireGraphiques(); g_dernReglages = now; }
   EcrireEtat();
   if(now - g_dernEquite >= PeriodeEquiteSec) { EcrireEquite(); g_dernEquite = now; }
   if(now - g_dernHisto >= PeriodeHistoMin * 60) { EcrireHistorique(); g_dernHisto = now; }
  }

void OnTick() {}
//+------------------------------------------------------------------+
