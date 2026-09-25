//+------------------------------------------------------------------+
//| ImporteTicks.mq5 — copie les ticks d'un symbole du courtier dans  |
//| un symbole personnalise (25/09/2026).                             |
//| Pourquoi : avant le 31/10/2024, le testeur PU Prime ecarte 85 a   |
//| 99 % des vrais ticks (« tick prices mismatch ») et les remplace   |
//| par des ticks generes. Dans un symbole personnalise, les barres   |
//| M1 sont reconstruites A PARTIR des ticks : ils concordent donc et |
//| le testeur les garde. Specifications copiees du symbole modele.   |
//| Lance au demarrage du terminal ([StartUp] Expert=Outils\...),     |
//| ferme le terminal a la fin. Journal : MQL5\Files\importe_ticks.log|
//+------------------------------------------------------------------+
#property copyright "maison"
#property version   "1.00"
input string   InpModele  = "XAUUSD.p";      // symbole du courtier
input string   InpSymbole = "XAUUSD_VRAI";   // symbole personnalise cree / remplace
input datetime InpDebut   = D'2021.01.01';
input datetime InpFin     = D'2026.09.24';
input bool     InpFermer  = true;            // fermer le terminal a la fin

int fj = INVALID_HANDLE;
void J(string m) { Print(m); if(fj != INVALID_HANDLE) { FileWriteString(fj, TimeToString(TimeLocal(), TIME_DATE | TIME_SECONDS) + "  " + m + "\r\n"); FileFlush(fj); } }

bool Importe()
{
   if(InpDebut < D'2000.01.01' || InpFin <= InpDebut) { J("REFUS : dates invalides (" + TimeToString(InpDebut) + " / " + TimeToString(InpFin) + ")"); return false; }
   bool existe = false;
   if(!SymbolExist(InpSymbole, existe) || !existe)
   {
      if(!CustomSymbolCreate(InpSymbole, "Reel", InpModele)) { J("ECHEC creation " + InpSymbole + " : " + (string)GetLastError()); return false; }
      J("cree " + InpSymbole + " sur le modele de " + InpModele);
   }
   else J(InpSymbole + " existe deja : ses ticks sont remplaces mois par mois");
   SymbolSelect(InpModele, true);
   long total = 0;
   MqlDateTime d; TimeToStruct(InpDebut, d); d.day = 1; d.hour = 0; d.min = 0; d.sec = 0;
   datetime m0 = StructToTime(d);
   while(m0 < InpFin && !IsStopped())
   {
      MqlDateTime e = d; e.mon++; if(e.mon > 12) { e.mon = 1; e.year++; }
      datetime m1 = StructToTime(e); if(m1 > InpFin) m1 = InpFin;
      ulong a = (ulong)m0 * 1000, b = (ulong)m1 * 1000 - 1;
      MqlTick t[]; int n = -1;
      for(int essai = 0; essai < 30 && n <= 0; essai++)
      {
         n = CopyTicksRange(InpModele, t, COPY_TICKS_ALL, a, b);
         if(n <= 0) Sleep(2000);
      }
      if(n <= 0) { J(StringFormat("%s : AUCUN tick (%d), mois saute", TimeToString(m0, TIME_DATE), GetLastError())); }
      else
      {
         int r = CustomTicksReplace(InpSymbole, (long)a, (long)b, t);
         J(StringFormat("%s : %d ticks lus, %d ecrits%s", TimeToString(m0, TIME_DATE), n, r, r == n ? "" : "  ECART"));
         if(r != n) return false;
         total += n;
      }
      d = e; m0 = m1;
   }
   MqlRates rr[]; int nb = CopyRates(InpSymbole, PERIOD_M1, InpDebut, InpFin, rr);
   J(StringFormat("FIN : %I64d ticks copies ; %d barres M1 reconstruites dans %s", total, nb, InpSymbole));
   return total > 0 && nb > 0;
}

int OnInit() { EventSetTimer(2); return INIT_SUCCEEDED; }
void OnTimer()
{
   EventKillTimer();
   fj = FileOpen("importe_ticks.log", FILE_WRITE | FILE_READ | FILE_TXT | FILE_ANSI | FILE_SHARE_READ);
   if(fj != INVALID_HANDLE) FileSeek(fj, 0, SEEK_END);
   J("=== import " + InpModele + " -> " + InpSymbole + " du " + TimeToString(InpDebut, TIME_DATE) + " au " + TimeToString(InpFin, TIME_DATE));
   bool ok = Importe();
   J(ok ? "IMPORT OK" : "IMPORT EN ECHEC");
   if(fj != INVALID_HANDLE) FileClose(fj);
   if(InpFermer) TerminalClose(0);
}
void OnTick() {}
