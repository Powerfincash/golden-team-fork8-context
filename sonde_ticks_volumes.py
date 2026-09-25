# -*- coding: utf-8 -*-
"""sonde_ticks_volumes.py — suite de sonde_ticks_barres.py (25/09) : a decalage nul, les prix des barres et des ticks
concordent ; on compare ici ouverture/cloture et volume de ticks, minute par minute.
Usage : python sonde_ticks_volumes.py SYMBOLE AAAA-MM-JJ [...]. Ferme le terminal PU Prime a la fin."""
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
        tt = t['time_msc'] // 1000; bid = t['bid']; fl = t['flags']
        fbid = (fl & mt5.TICK_FLAG_BID) > 0
        n = len(r); o = c = h = l = 0; vol_eq_all = vol_eq_bid = vol_gt = vol_lt = 0; rap = []; sans = 0
        for b in r:
            m = (tt >= b['time']) & (tt < b['time'] + 60)
            x = bid[m]; xb = bid[m & fbid]
            if len(x) == 0: sans += 1; continue
            o += abs(x[0] - b['open']) < pt / 2; c += abs(x[-1] - b['close']) < pt / 2
            h += abs(x.max() - b['high']) < pt / 2; l += abs(x.min() - b['low']) < pt / 2
            v = int(b['tick_volume']); vol_eq_all += (len(x) == v); vol_eq_bid += (len(xb) == v)
            vol_gt += v > len(x); vol_lt += v < len(xb); rap.append(v / max(1, len(xb)))
        print("%s %s : %d barres, %d sans tick | O=1er bid %d  C=dernier bid %d  H %d  L %d | vol=ticks %d  vol=ticks bid %d  vol>ticks %d  vol<ticks bid %d | vol/ticks bid median %.2f"
              % (sym, jour, n, sans, o, c, h, l, vol_eq_all, vol_eq_bid, vol_gt, vol_lt, np.median(rap)))
        fr = t['flags']; u, k = np.unique(fr, return_counts=True)
        print("   drapeaux des ticks :", dict(zip([int(a) for a in u], [int(a) for a in k])))
finally:
    mt5.shutdown(); time.sleep(2)
    subprocess.run(['powershell', '-NoProfile', '-Command', "Get-Process terminal64 -ErrorAction Ignore | Where-Object { try { $_.Path -eq '%s' } catch { $false } } | Stop-Process -Force" % EXE])
    print("terminal ferme")
