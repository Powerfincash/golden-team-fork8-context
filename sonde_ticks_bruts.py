# -*- coding: utf-8 -*-
"""sonde_ticks_bruts.py — suite (25/09) : affiche les ticks bruts (tous champs) de quelques minutes, pour comparer
2023 (ticks ecartes par le testeur) et 2025 (ticks acceptes). Usage : python sonde_ticks_bruts.py SYMBOLE "AAAA-MM-JJ HH:MM" [...]"""
import sys, datetime as dt, subprocess, time
import MetaTrader5 as mt5
EXE = r"C:\Program Files\PU Prime MT5 Terminal\terminal64.exe"
if not mt5.initialize(path=EXE): print("initialize KO :", mt5.last_error()); sys.exit(1)
sym = sys.argv[1]; mt5.symbol_select(sym, True)
try:
    for q in sys.argv[2:]:
        d0 = dt.datetime.strptime(q, "%Y-%m-%d %H:%M")
        r = mt5.copy_rates_range(sym, mt5.TIMEFRAME_M1, d0, d0 + dt.timedelta(minutes=1))
        t = mt5.copy_ticks_range(sym, d0, d0 + dt.timedelta(seconds=59, milliseconds=999), mt5.COPY_TICKS_ALL)
        print("\n%s %s : barre %s" % (sym, q, [(float(b['open']), float(b['high']), float(b['low']), float(b['close']), int(b['tick_volume']), int(b['spread'])) for b in r]))
        for x in t[:25]:
            print("   %s.%03d bid %.5f ask %.5f last %.5f vol %d volr %.2f flags %d" % (dt.datetime.utcfromtimestamp(int(x['time'])).strftime('%H:%M:%S'), x['time_msc'] % 1000, x['bid'], x['ask'], x['last'], x['volume'], x['volume_real'], x['flags']))
        print("   ... %d ticks" % len(t))
finally:
    mt5.shutdown(); time.sleep(2)
    subprocess.run(['powershell', '-NoProfile', '-Command', "Get-Process terminal64 -ErrorAction Ignore | Where-Object { try { $_.Path -eq '%s' } catch { $false } } | Stop-Process -Force" % EXE])
    print("terminal ferme")
