# -*- coding: utf-8 -*-
"""sonde_ticks_ecart.py — suite (25/09) : prix bid et volumes concordent presque partout avant le 31/10/2024,
mais le testeur declare « tick prices mismatch » sur ~95 % des minutes. On teste ici l'ask, l'ecart (spread) de la
barre, l'ordre des horodatages, les ticks aberrants (bid >= ask, prix nuls).
Usage : python sonde_ticks_ecart.py SYMBOLE AAAA-MM-JJ [...]. Ferme le terminal PU Prime a la fin."""
import sys, datetime as dt, subprocess, time
import numpy as np
import MetaTrader5 as mt5
EXE = r"C:\Program Files\PU Prime MT5 Terminal\terminal64.exe"
if not mt5.initialize(path=EXE): print("initialize KO :", mt5.last_error()); sys.exit(1)
sym = sys.argv[1]; mt5.symbol_select(sym, True); pt = mt5.symbol_info(sym).point
try:
    for jour in sys.argv[2:]:
        d0 = dt.datetime.strptime(jour, "%Y-%m-%d"); d1 = d0 + dt.timedelta(days=1)
        r = mt5.copy_rates_range(sym, mt5.TIMEFRAME_M1, d0, d1)
        t = mt5.copy_ticks_range(sym, d0, d1, mt5.COPY_TICKS_ALL)
        tm = t['time_msc']; tt = tm // 1000; bid = t['bid']; ask = t['ask']
        sp = np.rint((ask - bid) / pt).astype(int)
        print("%s %s : %d ticks | recul d'horodatage %d | bid<=0 %d | ask<=0 %d | ask<=bid %d | ecart ticks min/med/max %d/%d/%d"
              % (sym, jour, len(t), int((np.diff(tm) < 0).sum()), int((bid <= 0).sum()), int((ask <= 0).sum()), int((ask <= bid).sum()), sp.min(), np.median(sp), sp.max()))
        eq = lt = gt = 0; ex = []
        for b in r:
            m = (tt >= b['time']) & (tt < b['time'] + 60)
            if not m.any(): continue
            s = sp[m].min(); bs = int(b['spread'])
            eq += s == bs; lt += bs < s; gt += bs > s
            if s != bs and len(ex) < 4: ex.append("%s barre %d ticks min %d" % (dt.datetime.utcfromtimestamp(int(b['time'])).strftime('%H:%M'), bs, s))
        print("   ecart de barre = ecart min des ticks : %d | barre < ticks %d | barre > ticks %d | ex. %s" % (eq, lt, gt, "; ".join(ex)))
        print("   volume reel barres %d ticks %d" % (int(r['real_volume'].sum()), int(t['volume'].sum())))
finally:
    mt5.shutdown(); time.sleep(2)
    subprocess.run(['powershell', '-NoProfile', '-Command', "Get-Process terminal64 -ErrorAction Ignore | Where-Object { try { $_.Path -eq '%s' } catch { $false } } | Stop-Process -Force" % EXE])
    print("terminal ferme")
