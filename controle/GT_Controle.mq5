//+------------------------------------------------------------------+
//| GT_Controle.mq5 — espion en LECTURE SEULE pour les outils A, B, C |
//|                                                                  |
//| Ne passe AUCUN ordre, ne modifie AUCUNE position, AUCUN réglage.  |
//| Aucune fonction de trading n'est appelée dans ce fichier          |
//| (vérifiable : aucune occurrence de OrderSend / CTrade).           |
//|                                                                  |
//| A. exécution : latence (ping, délai serveur), spread, glissement  |
//| B. performance : positions, équité, historique des transactions   |
//| C. surveillance : graphiques ouverts, robot chargé, ses réglages  |
//| + exposition par symbole/sens, marge, coupures, swaps             |
//|                                                                  |
//| Écrit dans le dossier commun des terminaux :                      |
//|   %APPDATA%\MetaQuotes\Terminal\Common\Files\GT_Controle\<compte>\ |
//| Un seul exemplaire par terminal, sur n'importe quel graphique.    |
//+------------------------------------------------------------------+
#property copyright "Golden Team fork 8"
#property version   "1.00"
#property description "Contrôle en lecture seule : n'envoie aucun ordre."

input int  PeriodeSecondes    = 5;    // relevé de l'état (positions, spread, ping)
input int  PeriodeEquiteSec   = 60;   // une ligne d'équité toutes les N secondes
input int  PeriodeHistoMin    = 15;   // réécriture de l'historique des transactions
input int  PeriodeReglagesMin = 5;    // relecture des robots et réglages des graphiques
input int  JoursHistorique    = 400;  // profondeur de l'historique exporté

string   g_dossier;
datetime g_dernEquite = 0, g_dernHisto = 0, g_dernReglages = 0;
bool     g_connecte = true;
datetime g_debutCoupure = 0;
string   g_graphiquesJson = "[]";

// accumulateurs de spread par symbole, vidés à chaque ligne d'équité
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

//+------------------------------------------------------------------+
bool EcrireFichier(string nom, string contenu)
  {
   // écriture dans un fichier temporaire puis remplacement : le lecteur
   // ne voit jamais un fichier à moitié écrit
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

// valeur en devise du compte d'un mouvement de prix, pour un volume donné
double ValeurMouvement(string sym, double ecartPrix, double volume)
  {
   double tv = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
   double ts = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   if(ts <= 0) return 0;
   return ecartPrix / ts * tv * volume;
  }

//+------------------------------------------------------------------+
void NoterSpread(string sym)
  {
   if(!SymbolSelect(sym, true)) return;
   double sp = (double)SymbolInfoInteger(sym, SYMBOL_SPREAD);
   int n = ArraySize(g_spSym), i;
   for(i = 0; i < n; i++) if(g_spSym[i] == sym) break;
   if(i == n)
     {
      ArrayResize(g_spSym, n + 1); ArrayResize(g_spMin, n + 1); ArrayResize(g_spMax, n + 1);
      ArrayResize(g_spSom, n + 1); ArrayResize(g_spN, n + 1);
      g_spSym[i] = sym; g_spMin[i] = sp; g_spMax[i] = sp; g_spSom[i] = 0; g_spN[i] = 0;
     }
   if(g_spN[i] == 0) { g_spMin[i] = sp; g_spMax[i] = sp; }
   g_spMin[i] = MathMin(g_spMin[i], sp);
   g_spMax[i] = MathMax(g_spMax[i], sp);
   g_spSom[i] += sp; g_spN[i]++;
  }

// symboles surveillés = ceux des graphiques + ceux des positions
void SymbolesSurveilles(string &liste[])
  {
   ArrayResize(liste, 0);
   long c = ChartFirst();
   while(c >= 0)
     {
      AjouterUnique(liste, ChartSymbol(c));
      c = ChartNext(c);
     }
   for(int i = PositionsTotal() - 1; i >= 0; i--)
      if(PositionGetTicket(i) > 0) AjouterUnique(liste, PositionGetString(POSITION_SYMBOL));
  }
void AjouterUnique(string &liste[], string s)
  {
   for(int i = 0; i < ArraySize(liste); i++) if(liste[i] == s) return;
   int n = ArraySize(liste); ArrayResize(liste, n + 1); liste[n] = s;
  }

//+------------------------------------------------------------------+
// C. graphiques : robot chargé et ses réglages, lus dans un modèle
//    sauvegardé du graphique (écrit un fichier, ne change rien au graphique)
// Lecture d'un bloc (binaire) : un modèle peut peser plusieurs Mo quand un robot
// accumule des objets (Zebra or : 5,4 Mo, 13 011 objets, le 24/09) ; la lecture ligne à
// ligne par concaténation y restait bloquée. On ne lit que le début : le bloc <expert>
// précède les fenêtres et leurs objets.
#define GT_MAX_MODELE 1048576
string LireFichierTexte(string nom, bool &tronque)
  {
   tronque = false;
   int h = FileOpen(nom, FILE_READ | FILE_BIN | FILE_SHARE_READ);
   if(h == INVALID_HANDLE) return "";
   ulong taille = FileSize(h);
   int n = (int)MathMin(taille, (ulong)GT_MAX_MODELE);
   tronque = (taille > (ulong)GT_MAX_MODELE);
   uchar b[];
   int lus = (int)FileReadArray(h, b, 0, n);
   FileClose(h);
   if(lus < 2) return "";
   // UTF-16LE (avec ou sans BOM) : un octet nul sur deux
   bool utf16 = (b[0] == 0xFF && b[1] == 0xFE) || (lus > 3 && b[1] == 0 && b[3] == 0);
   if(!utf16) return CharArrayToString(b, 0, lus, CP_UTF8);
   int debut = (b[0] == 0xFF && b[1] == 0xFE) ? 2 : 0;
   int m = (lus - debut) / 2;
   ushort u[];
   ArrayResize(u, m);
   for(int k = 0; k < m; k++) u[k] = (ushort)(b[debut + 2 * k] | (b[debut + 2 * k + 1] << 8));
   return ShortArrayToString(u, 0, m);
  }

string ReglagesGraphique(long id, string &etat)
  {
   string nom = "GT_Controle_modele_" + IntegerToString(id);
   etat = "ok";
   if(!ChartSaveTemplate(id, "\\Files\\" + nom)) { etat = "modele_non_sauve"; return "{}"; }
   bool tronque = false;
   string txt = LireFichierTexte(nom + ".tpl", tronque);
   FileDelete(nom + ".tpl");
   if(StringFind(txt, "<chart>") < 0) { etat = "modele_illisible"; return "{}"; }
   int e0 = StringFind(txt, "<expert>");
   if(e0 < 0) { etat = (tronque ? "modele_trop_gros" : "aucun_robot"); return "{}"; }
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
      string robot = ChartGetString(c, CHART_EXPERT_NAME);
      string etat = "aucun_robot", reglages = "{}";
      if(c != ChartID()) reglages = ReglagesGraphique(c, etat);
      if(c == ChartID()) etat = "espion";
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
// A + B + ajouts : état instantané
void EcrireEtat()
  {
   string sym[];
   SymbolesSurveilles(sym);
   for(int i = 0; i < ArraySize(sym); i++) NoterSpread(sym[i]);

   string pos = "[";
   bool premPos = true;
   for(int i = 0; i < PositionsTotal(); i++)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0) continue;
      string s = PositionGetString(POSITION_SYMBOL);
      long type = PositionGetInteger(POSITION_TYPE);
      double vol = PositionGetDouble(POSITION_VOLUME);
      double po = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl = PositionGetDouble(POSITION_SL);
      // perte si le stop est touché, à partir du prix d'entrée (null = sans stop)
      string perteSl = "null";
      if(sl > 0)
        {
         double ecart = (type == POSITION_TYPE_BUY) ? (sl - po) : (po - sl);
         perteSl = D(ValeurMouvement(s, ecart, vol));
        }
      pos += (premPos ? "" : ",") + "{\"ticket\":" + IntegerToString((long)t)
             + ",\"symbole\":" + Q(s)
             + ",\"sens\":" + Q(type == POSITION_TYPE_BUY ? "achat" : "vente")
             + ",\"volume\":" + D(vol, 2)
             + ",\"prix\":" + D(po, (int)SymbolInfoInteger(s, SYMBOL_DIGITS))
             + ",\"sl\":" + D(sl, (int)SymbolInfoInteger(s, SYMBOL_DIGITS))
             + ",\"tp\":" + D(PositionGetDouble(POSITION_TP), (int)SymbolInfoInteger(s, SYMBOL_DIGITS))
             + ",\"profit\":" + D(PositionGetDouble(POSITION_PROFIT))
             + ",\"swap\":" + D(PositionGetDouble(POSITION_SWAP))
             + ",\"perte_au_sl\":" + perteSl
             + ",\"magic\":" + IntegerToString(PositionGetInteger(POSITION_MAGIC))
             + ",\"commentaire\":" + Q(PositionGetString(POSITION_COMMENT))
             + ",\"ouverture_utc\":" + Q(Horo((datetime)PositionGetInteger(POSITION_TIME) - (TimeTradeServer() - TimeGMT())))
             + "}";
      premPos = false;
     }
   pos += "]";

   string sp = "[";
   for(int i = 0; i < ArraySize(sym); i++)
      sp += (i > 0 ? "," : "") + "{\"symbole\":" + Q(sym[i])
            + ",\"spread_points\":" + IntegerToString(SymbolInfoInteger(sym[i], SYMBOL_SPREAD))
            + ",\"point\":" + DoubleToString(SymbolInfoDouble(sym[i], SYMBOL_POINT), 8) + "}";
   sp += "]";

   string json = "{\"version\":\"1.00\""
      + ",\"releve_utc\":" + Q(Horo(TimeGMT()))
      + ",\"decalage_serveur_s\":" + IntegerToString((long)(TimeTradeServer() - TimeGMT()))
      + ",\"compte\":{"
      + "\"numero\":" + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))
      + ",\"serveur\":" + Q(AccountInfoString(ACCOUNT_SERVER))
      + ",\"courtier\":" + Q(AccountInfoString(ACCOUNT_COMPANY))
      + ",\"devise\":" + Q(AccountInfoString(ACCOUNT_CURRENCY))
      + ",\"reel\":" + (AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_REAL ? "true" : "false")
      + ",\"solde\":" + D(AccountInfoDouble(ACCOUNT_BALANCE))
      // equite = argent propre : le crédit (bonus) du courtier n'est pas retirable et fausserait le
      // creux (Ultima 405 $ et Vantage 750 $ de crédit le 24/09)
      + ",\"equite\":" + D(AccountInfoDouble(ACCOUNT_EQUITY) - AccountInfoDouble(ACCOUNT_CREDIT))
      + ",\"credit\":" + D(AccountInfoDouble(ACCOUNT_CREDIT))
      + ",\"equite_courtier\":" + D(AccountInfoDouble(ACCOUNT_EQUITY))
      + ",\"marge\":" + D(AccountInfoDouble(ACCOUNT_MARGIN))
      + ",\"marge_libre\":" + D(AccountInfoDouble(ACCOUNT_MARGIN_FREE))
      + ",\"niveau_marge\":" + D(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL))
      + ",\"appel_marge\":" + D(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL))
      + ",\"stop_out\":" + D(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO))
      + ",\"levier\":" + IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE))
      + "}"
      + ",\"terminal\":{"
      + "\"connecte\":" + (TerminalInfoInteger(TERMINAL_CONNECTED) ? "true" : "false")
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
   double credit   = AccountInfoDouble(ACCOUNT_CREDIT);
   double propre   = AccountInfoDouble(ACCOUNT_EQUITY) - credit;
   double flottant = propre - AccountInfoDouble(ACCOUNT_BALANCE);
   // nouveau fichier : equite.csv (avant le 24/09 soir) comptait le crédit dans l'équité
   AjouterLigne("equite_v2.csv",
                "utc;solde;equite;flottant;niveau_marge;marge_libre;positions;ping_ms;connecte;credit",
                Horo(TimeGMT()) + ";" + D(AccountInfoDouble(ACCOUNT_BALANCE)) + ";"
                + D(propre) + ";" + D(flottant) + ";"
                + D(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL)) + ";" + D(AccountInfoDouble(ACCOUNT_MARGIN_FREE)) + ";"
                + IntegerToString(PositionsTotal()) + ";" + D(PingMs(), 1) + ";"
                + (TerminalInfoInteger(TERMINAL_CONNECTED) ? "1" : "0") + ";" + D(credit));
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
   bool c = (bool)TerminalInfoInteger(TERMINAL_CONNECTED);
   if(c == g_connecte) return;
   if(!c) g_debutCoupure = TimeGMT();
   else
      AjouterLigne("coupures.csv", "debut_utc;fin_utc;duree_s",
                   Horo(g_debutCoupure) + ";" + Horo(TimeGMT()) + ";"
                   + IntegerToString((long)(TimeGMT() - g_debutCoupure)));
   g_connecte = c;
  }

//+------------------------------------------------------------------+
// B + swaps + écart réel/test : historique complet des transactions
void EcrireHistorique()
  {
   datetime fin = TimeTradeServer() + 86400;
   if(!HistorySelect(fin - (datetime)JoursHistorique * 86400, fin)) return;
   long decal = (long)(TimeTradeServer() - TimeGMT());
   string txt = "utc;ticket;ordre;position;symbole;type;entree;volume;prix;profit;swap;commission;frais;magic;commentaire\n";
   int n = HistoryDealsTotal();
   for(int i = 0; i < n; i++)
     {
      ulong d = HistoryDealGetTicket(i);
      if(d == 0) continue;
      long type = HistoryDealGetInteger(d, DEAL_TYPE);
      string ty = (type == DEAL_TYPE_BUY) ? "achat" : (type == DEAL_TYPE_SELL) ? "vente"
                  : (type == DEAL_TYPE_BALANCE) ? "solde" : "autre";
      long en = HistoryDealGetInteger(d, DEAL_ENTRY);
      string e = (en == DEAL_ENTRY_IN) ? "in" : (en == DEAL_ENTRY_OUT) ? "out"
                 : (en == DEAL_ENTRY_INOUT) ? "inout" : "out_by";
      string s = HistoryDealGetString(d, DEAL_SYMBOL);
      txt += Horo((datetime)HistoryDealGetInteger(d, DEAL_TIME) - decal) + ";"
             + IntegerToString((long)d) + ";"
             + IntegerToString(HistoryDealGetInteger(d, DEAL_ORDER)) + ";"
             + IntegerToString(HistoryDealGetInteger(d, DEAL_POSITION_ID)) + ";"
             + s + ";" + ty + ";" + e + ";"
             + D(HistoryDealGetDouble(d, DEAL_VOLUME)) + ";"
             + DoubleToString(HistoryDealGetDouble(d, DEAL_PRICE), s == "" ? 2 : (int)SymbolInfoInteger(s, SYMBOL_DIGITS)) + ";"
             + D(HistoryDealGetDouble(d, DEAL_PROFIT)) + ";"
             + D(HistoryDealGetDouble(d, DEAL_SWAP)) + ";"
             + D(HistoryDealGetDouble(d, DEAL_COMMISSION)) + ";"
             + D(HistoryDealGetDouble(d, DEAL_FEE)) + ";"
             + IntegerToString(HistoryDealGetInteger(d, DEAL_MAGIC)) + ";"
             + Csv(HistoryDealGetString(d, DEAL_COMMENT)) + "\n";
     }
   EcrireFichier("historique.csv", txt);
  }

//+------------------------------------------------------------------+
// A : chaque exécution. Le spread et le ping sont pris à l'instant où
// l'exécution arrive ; l'ordre d'origine (prix demandé, délai serveur)
// n'est pas toujours déjà dans l'historique à cet instant, donc la ligne
// est écrite au passage suivant du minuteur.
ulong    g_atDeal[];
long     g_atSpread[];
double   g_atPing[];
datetime g_atQuand[];

void OnTradeTransaction(const MqlTradeTransaction &tr, const MqlTradeRequest &req, const MqlTradeResult &res)
  {
   if(tr.type != TRADE_TRANSACTION_DEAL_ADD) return;
   if(tr.deal_type != DEAL_TYPE_BUY && tr.deal_type != DEAL_TYPE_SELL) return;
   int n = ArraySize(g_atDeal);
   ArrayResize(g_atDeal, n + 1); ArrayResize(g_atSpread, n + 1);
   ArrayResize(g_atPing, n + 1); ArrayResize(g_atQuand, n + 1);
   g_atDeal[n] = tr.deal;
   g_atSpread[n] = SymbolInfoInteger(tr.symbol, SYMBOL_SPREAD);
   g_atPing[n] = PingMs();
   g_atQuand[n] = TimeLocal();
  }

void TraiterExecutions()
  {
   int n = ArraySize(g_atDeal);
   if(n == 0) return;
   datetime fin = TimeTradeServer() + 86400;
   HistorySelect(fin - 7 * 86400, fin);
   int garde = 0;
   for(int i = 0; i < n; i++)
     {
      if(!EcrireExecution(g_atDeal[i], g_atSpread[i], g_atPing[i], TimeLocal() - g_atQuand[i] > 60))
        {
         g_atDeal[garde] = g_atDeal[i]; g_atSpread[garde] = g_atSpread[i];
         g_atPing[garde] = g_atPing[i]; g_atQuand[garde] = g_atQuand[i];
         garde++;
        }
     }
   ArrayResize(g_atDeal, garde); ArrayResize(g_atSpread, garde);
   ArrayResize(g_atPing, garde); ArrayResize(g_atQuand, garde);
  }

// renvoie false s'il faut réessayer plus tard (ordre pas encore dans l'historique)
bool EcrireExecution(ulong d, long spread, double ping, bool forcer)
  {
   if(!HistoryDealSelect(d)) return forcer;
   long type = HistoryDealGetInteger(d, DEAL_TYPE);
   string s = HistoryDealGetString(d, DEAL_SYMBOL);
   double prix = HistoryDealGetDouble(d, DEAL_PRICE);
   double vol = HistoryDealGetDouble(d, DEAL_VOLUME);
   ulong o = (ulong)HistoryDealGetInteger(d, DEAL_ORDER);
   double demande = 0; long setup = 0, fait = 0; string typeOrdre = "";
   bool ordreVu = (o > 0 && HistoryOrderSelect(o));
   if(!ordreVu && !forcer) return false;
   if(ordreVu)
     {
      demande = HistoryOrderGetDouble(o, ORDER_PRICE_OPEN);
      setup = HistoryOrderGetInteger(o, ORDER_TIME_SETUP_MSC);
      fait = HistoryOrderGetInteger(o, ORDER_TIME_DONE_MSC);
      typeOrdre = StringSubstr(EnumToString((ENUM_ORDER_TYPE)HistoryOrderGetInteger(o, ORDER_TYPE)), 11);
     }
   // un stop ou un objectif qui ferme : le prix demandé est le niveau du stop/objectif
   long raison = HistoryDealGetInteger(d, DEAL_REASON);
   if(raison == DEAL_REASON_SL || raison == DEAL_REASON_TP)
     {
      double niveau = HistoryDealGetDouble(d, raison == DEAL_REASON_SL ? DEAL_SL : DEAL_TP);
      if(niveau > 0) demande = niveau;
      typeOrdre = (raison == DEAL_REASON_SL) ? "STOP_TOUCHE" : "OBJECTIF_TOUCHE";
     }
   else if(raison == DEAL_REASON_SO) typeOrdre = "STOP_OUT";
   double pt = SymbolInfoDouble(s, SYMBOL_POINT);
   int dg = (int)SymbolInfoInteger(s, SYMBOL_DIGITS);
   // glissement positif = défavorable (payé plus cher à l'achat, vendu moins cher à la vente)
   string glisPts = "", glisArgent = "";
   if(demande > 0 && pt > 0)
     {
      double g = (type == DEAL_TYPE_BUY) ? (prix - demande) : (demande - prix);
      glisPts = D(g / pt, 1);
      glisArgent = D(ValeurMouvement(s, g, vol));
     }
   long decal = (long)(TimeTradeServer() - TimeGMT());
   AjouterLigne("executions.csv",
                "utc;ticket;ordre;position;symbole;sens;entree;type_ordre;volume;prix_demande;prix_obtenu;glissement_points;glissement_argent;delai_serveur_ms;spread_points;ping_ms;magic;commentaire",
                Horo((datetime)HistoryDealGetInteger(d, DEAL_TIME) - decal) + ";"
                + IntegerToString((long)d) + ";" + IntegerToString((long)o) + ";"
                + IntegerToString(HistoryDealGetInteger(d, DEAL_POSITION_ID)) + ";" + s + ";"
                + (type == DEAL_TYPE_BUY ? "achat" : "vente") + ";"
                + (HistoryDealGetInteger(d, DEAL_ENTRY) == DEAL_ENTRY_IN ? "in" : "out") + ";"
                + typeOrdre + ";" + D(vol) + ";"
                + (demande > 0 ? DoubleToString(demande, dg) : "") + ";"
                + DoubleToString(prix, dg) + ";"
                + glisPts + ";" + glisArgent + ";"
                + ((setup > 0 && fait >= setup) ? IntegerToString(fait - setup) : "") + ";"
                + IntegerToString(spread) + ";" + D(ping, 1) + ";"
                + IntegerToString(HistoryDealGetInteger(d, DEAL_MAGIC)) + ";"
                + Csv(HistoryDealGetString(d, DEAL_COMMENT)));
   return true;
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   g_dossier = "GT_Controle\\" + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + "\\";
   g_connecte = (bool)TerminalInfoInteger(TERMINAL_CONNECTED);
   if(!g_connecte) g_debutCoupure = TimeGMT();
   RelireGraphiques();
   EcrireHistorique();
   EcrireEtat();
   g_dernReglages = g_dernHisto = TimeLocal();
   EventSetTimer(MathMax(1, PeriodeSecondes));
   Print("GT_Controle : lecture seule, fichiers dans Common\\Files\\", g_dossier);
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason) { EventKillTimer(); }

void OnTimer()
  {
   datetime now = TimeLocal();
   SuivreConnexion();
   if(now - g_dernReglages >= PeriodeReglagesMin * 60) { RelireGraphiques(); g_dernReglages = now; }
   TraiterExecutions();
   EcrireEtat();
   if(now - g_dernEquite >= PeriodeEquiteSec) { EcrireEquite(); g_dernEquite = now; }
   if(now - g_dernHisto >= PeriodeHistoMin * 60) { EcrireHistorique(); g_dernHisto = now; }
  }

void OnTick() {}
//+------------------------------------------------------------------+
