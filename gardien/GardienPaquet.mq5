//+------------------------------------------------------------------+
//| GardienPaquet.mq5 — gardien extérieur, à poser sur UN graphique  |
//| du symbole à garder (argent). Il n'ouvre jamais rien : il ferme  |
//| tout un sens quand le paquet perd plus que le plafond.           |
//+------------------------------------------------------------------+
#property copyright "Golden Team"
#property version   "1.00"
#property description "Ferme tout le paquet (un sens) quand sa perte atteint le plafond : 450 par 0,01 lot à 64,44 $, proportionnel au prix."
#include "GardienPaquet.mqh"

int OnInit()
{
   GP_Init(_Symbol);
   EventSetTimer(1);            // garde aussi quand les ticks sont rares
   PrintFormat("GardienPaquet %s : plafond %.0f à %.2f, aujourd'hui %.2f pour 0,01 lot%s", _Symbol, GP_Plafond, GP_PrixRef,
               GP_PlafondCompte(0.01), GP_Observation ? " — OBSERVATION" : "");
   return INIT_SUCCEEDED;
}
void OnDeinit(const int r) { EventKillTimer(); Comment(""); }
void OnTick()  { GP_Tick(); }
void OnTimer() { GP_Tick(); Comment(GP_Etat()); }
