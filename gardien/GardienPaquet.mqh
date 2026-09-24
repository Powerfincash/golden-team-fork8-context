//+------------------------------------------------------------------+
//| GardienPaquet.mqh — ferme tout un paquet (un sens, un symbole)   |
//| dès que sa perte atteint le plafond. Décidé le 24/09/2026 :      |
//| 450 par 0,01 lot à 64,44 $ l'argent, proportionnel au prix.      |
//| Paquet = de 0 position d'un sens à nouveau 0. Perte du paquet =  |
//| positions ouvertes (profit + swap) + tout ce que le paquet a     |
//| déjà réalisé depuis son ouverture (sorties, commissions, swaps). |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

input group "Gardien de paquet"
input double GP_Plafond      = 450;    // plafond au prix de référence, par 0,01 lot (monnaie du compte ; USC sur compte cent)
input double GP_PrixRef      = 64.44;  // prix de référence (le plafond suit le prix : environ 7 x le prix de l'argent)
input long   GP_Magic        = -1;     // -1 = toutes les positions du symbole ; sinon ce magic seulement
input int    GP_PauseMinutes = 0;      // après une coupe, referme aussitôt ce qui rouvre du même sens pendant N minutes (0 = non)
input bool   GP_Observation  = false;  // true = alerte seulement, ne ferme rien
input bool   GP_Notifier     = true;   // notification sur le téléphone à chaque coupe

CTrade   gp_trade;
string   gp_sym;
datetime gp_debut[2];                  // 0 = achats, 1 = ventes ; 0 = pas de paquet ouvert
double   gp_realise[2];
double   gp_volMemo[2];
int      gp_nbMemo[2];
datetime gp_pauseJusqua[2];
bool     gp_alerte[2];
double   gp_pire[2];
int      gp_coupes = 0;
bool     gp_enCoupe[2];                // coupe décidée : on insiste jusqu'à ce que le paquet soit vide
datetime gp_prochainEssai[2];          // marché fermé ou refus : nouvel essai toutes les 2 s

string GP_Cle(int s) { return "GP_" + gp_sym + (s == 0 ? "_achats" : "_ventes"); }

bool GP_Retenue(ulong tk)
{
   if(!PositionSelectByTicket(tk)) return false;
   if(PositionGetString(POSITION_SYMBOL) != gp_sym) return false;
   if(GP_Magic >= 0 && PositionGetInteger(POSITION_MAGIC) != GP_Magic) return false;
   return true;
}

void GP_Init(string sym)
{
   gp_sym = sym;
   gp_trade.SetDeviationInPoints(100);
   gp_trade.SetTypeFillingBySymbol(sym);
   for(int s = 0; s < 2; s++)
   {
      gp_debut[s] = 0; gp_realise[s] = 0; gp_volMemo[s] = -1; gp_nbMemo[s] = -1; gp_pauseJusqua[s] = 0; gp_alerte[s] = false; gp_pire[s] = 0; gp_enCoupe[s] = false; gp_prochainEssai[s] = 0;
      // après un redémarrage, reprend le début exact du paquet en cours
      if(!MQLInfoInteger(MQL_TESTER) && GlobalVariableCheck(GP_Cle(s))) gp_debut[s] = (datetime)GlobalVariableGet(GP_Cle(s));
   }
}

// ce que le paquet a déjà réalisé depuis son ouverture
double GP_Realise(int s)
{
   if(!HistorySelect(gp_debut[s] - 1, TimeCurrent() + 60)) return gp_realise[s];
   double r = 0;
   int n = HistoryDealsTotal();
   for(int i = 0; i < n; i++)
   {
      ulong d = HistoryDealGetTicket(i);
      if(HistoryDealGetString(d, DEAL_SYMBOL) != gp_sym) continue;
      if(GP_Magic >= 0 && HistoryDealGetInteger(d, DEAL_MAGIC) != GP_Magic) continue;
      long typ = HistoryDealGetInteger(d, DEAL_TYPE), ent = HistoryDealGetInteger(d, DEAL_ENTRY);
      if(typ != DEAL_TYPE_BUY && typ != DEAL_TYPE_SELL) continue;
      int cote;
      if(ent == DEAL_ENTRY_IN) cote = (typ == DEAL_TYPE_BUY) ? 0 : 1;
      else                     cote = (typ == DEAL_TYPE_SELL) ? 0 : 1;   // une sortie vente ferme un achat
      if(cote != s) continue;
      r += HistoryDealGetDouble(d, DEAL_COMMISSION) + HistoryDealGetDouble(d, DEAL_SWAP) + HistoryDealGetDouble(d, DEAL_FEE);
      if(ent != DEAL_ENTRY_IN) r += HistoryDealGetDouble(d, DEAL_PROFIT);
   }
   return r;
}

// plafond dans la monnaie du compte, pour le lot unitaire du paquet
double GP_PlafondCompte(double lotUnitaire)
{
   double tv = SymbolInfoDouble(gp_sym, SYMBOL_TRADE_TICK_VALUE_LOSS), ts = SymbolInfoDouble(gp_sym, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0) tv = SymbolInfoDouble(gp_sym, SYMBOL_TRADE_TICK_VALUE);
   double prix = SymbolInfoDouble(gp_sym, SYMBOL_BID);
   if(ts <= 0 || tv <= 0 || prix <= 0 || GP_PrixRef <= 0 || lotUnitaire <= 0) return GP_Plafond;
   double parDollar = tv / ts * lotUnitaire;           // gain ou perte pour 1 $ de mouvement du prix, lot unitaire
   return GP_Plafond * (prix / GP_PrixRef) * parDollar / (0.01 * 5000.0);   // référence : 0,01 lot x 5000 oz
}

int GP_Fermer(int s, string motif)
{
   int refus = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(!GP_Retenue(tk)) continue;
      if(PositionGetInteger(POSITION_TYPE) != (s == 0 ? POSITION_TYPE_BUY : POSITION_TYPE_SELL)) continue;
      if(!gp_trade.PositionClose(tk)) refus++;
   }
   if(refus > 0)
      PrintFormat("GardienPaquet : %s — %d fermeture(s) refusée(s) (%u %s), nouvel essai dans 2 s", motif, refus,
                  gp_trade.ResultRetcode(), gp_trade.ResultRetcodeDescription());
   else Print("GardienPaquet : ", motif);
   return refus;
}

void GP_Tick()
{
   for(int s = 0; s < 2; s++)
   {
      int nb = 0; double vol = 0, flottant = 0, lotMin = 0; datetime plusVieille = 0;
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         ulong tk = PositionGetTicket(i);
         if(!GP_Retenue(tk)) continue;
         if(PositionGetInteger(POSITION_TYPE) != (s == 0 ? POSITION_TYPE_BUY : POSITION_TYPE_SELL)) continue;
         double v = PositionGetDouble(POSITION_VOLUME);
         nb++; vol += v; flottant += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
         if(lotMin == 0 || v < lotMin) lotMin = v;
         datetime t = (datetime)PositionGetInteger(POSITION_TIME);
         if(plusVieille == 0 || t < plusVieille) plusVieille = t;
      }
      string sens = (s == 0 ? "achats" : "ventes");
      if(nb == 0)
      {
         if(gp_debut[s] != 0)
         {
            gp_debut[s] = 0; gp_alerte[s] = false; gp_pire[s] = 0;
            if(gp_enCoupe[s]) PrintFormat("GardienPaquet : %s paquet %s entièrement fermé", gp_sym, sens);
            gp_enCoupe[s] = false;
            if(!MQLInfoInteger(MQL_TESTER)) GlobalVariableDel(GP_Cle(s));
         }
         gp_volMemo[s] = 0; gp_nbMemo[s] = 0;
         continue;
      }
      // coupe en cours : on insiste jusqu'à ce que tout soit fermé, même si la perte se réduit entre-temps
      if(gp_enCoupe[s])
      {
         if(TimeCurrent() >= gp_prochainEssai[s] && GP_Fermer(s, StringFormat("%s %s : reprise de la fermeture", gp_sym, sens)) > 0)
            gp_prochainEssai[s] = TimeCurrent() + 2;
         continue;
      }
      // pause après une coupe : ce qui rouvre du même sens est refermé aussitôt
      if(!GP_Observation && gp_pauseJusqua[s] > TimeCurrent())
      {
         GP_Fermer(s, StringFormat("%s %s rouvert pendant la pause : refermé", gp_sym, sens));
         continue;
      }
      if(gp_debut[s] == 0 || gp_debut[s] > plusVieille)
      {
         gp_debut[s] = plusVieille; gp_volMemo[s] = -1;
         if(!MQLInfoInteger(MQL_TESTER)) GlobalVariableSet(GP_Cle(s), (double)gp_debut[s]);
      }
      if(nb != gp_nbMemo[s] || MathAbs(vol - gp_volMemo[s]) > 1e-9)   // une entrée ou une sortie : on relit l'historique
      {
         gp_realise[s] = GP_Realise(s); gp_nbMemo[s] = nb; gp_volMemo[s] = vol;
      }
      double paquet = gp_realise[s] + flottant;
      double plafond = GP_PlafondCompte(lotMin);
      if(paquet < gp_pire[s]) gp_pire[s] = paquet;
      if(paquet <= -plafond)
      {
         string m = StringFormat("%s paquet %s de %d positions a %.2f, plafond %.2f : %s", gp_sym, sens, nb, paquet, plafond,
                                 GP_Observation ? "ALERTE (observation, rien ferme)" : "COUPE");
         if(GP_Observation)
         {
            if(!gp_alerte[s]) { Print("GardienPaquet : ", m); if(GP_Notifier && !MQLInfoInteger(MQL_TESTER)) SendNotification(m); gp_alerte[s] = true; }
            continue;
         }
         gp_coupes++; gp_enCoupe[s] = true;
         if(GP_Fermer(s, m) > 0) gp_prochainEssai[s] = TimeCurrent() + 2;
         if(GP_Notifier && !MQLInfoInteger(MQL_TESTER)) SendNotification(m);
         if(GP_PauseMinutes > 0) gp_pauseJusqua[s] = TimeCurrent() + GP_PauseMinutes * 60;
      }
   }
}

string GP_Etat()
{
   string t = "Gardien de paquet " + gp_sym + (GP_Observation ? " (OBSERVATION)" : "") +
              StringFormat(" — plafond du jour %.2f pour 0,01 lot\n", GP_PlafondCompte(0.01));
   for(int s = 0; s < 2; s++)
      t += StringFormat("%s : %s\n", s == 0 ? "achats" : "ventes", gp_debut[s] == 0 ? "aucun paquet" :
           StringFormat("paquet depuis %s, pire %.2f", TimeToString(gp_debut[s]), gp_pire[s]));
   return t;
}
