# -*- coding: utf-8 -*-
"""sonde_ticks_grille.py — suite (25/09) : les prix des ticks sont-ils sur la grille du symbole (digits) ?
Un prix a 6 decimales sur un symbole a 5 decimales ne coincide jamais exactement avec la barre.
Usage : python sonde_ticks_grille.py SYMBOLE AAAA-MM-JJ [...]. Ferme le terminal PU Prime a la fin."""
import sys, datetime as dt, subprocess, time
import numpy as np
import MetaTrader5 as mt5
EXE = r"C:\Program Files\PU Prime MT5 Terminal\terminal64.exe"
if not mt5.initialize(path=EXE): print("initialize KO :", mt5.last_error()); sys.exit(1)
sym = sys.argv[1]; mt5.symbol_select(sym, True); si = mt5.symbol_info(sym); pt = si.point
print(sym, "digits", si.digits, "point", pt)
def hors(x): return np.abs(x / pt - np.rint(x / pt)) > 1e-3
try:
    for jour in sys.argv[2:]:
        d0 = dt.datetime.strptime(jour, "%Y-%m-%d"); d1 = d0 + dt.timedelta(days=1)
        r = mt5.copy_rates_range(sym, mt5.TIMEFRAME_M1, d0, d1)
        t = mt5.copy_ticks_range(sym, d0, d1, mt5.COPY_TICKS_ALL)
        hb, ha = hors(t['bid']), hors(t['ask']); tt = t['time_msc'] // 1000
        mins = set((tt[hb | ha] // 60).tolist())
        hr = sum(int(hors(r[k]).sum()) for k in ('open', 'high', 'low', 'close'))
        ex = t['bid'][hb][:3]
        print("%s : ticks %d | bid hors grille %d (%.0f %%) | ask hors grille %d | minutes touchees %d / %d | prix de barres hors grille %d | ex. %s"
              % (jour, len(t), hb.sum(), 100 * hb.mean(), ha.sum(), len(mins), len(r), hr, ["%.8f" % v for v in ex]))
finally:
    mt5.shutdown(); time.sleep(2)
    subprocess.run(['powershell', '-NoProfile', '-Command', "Get-Process terminal64 -ErrorAction Ignore | Where-Object { try { $_.Path -eq '%s' } catch { $false } } | Stop-Process -Force" % EXE])
    print("terminal ferme")
