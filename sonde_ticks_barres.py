# -*- coding: utf-8 -*-
"""sonde_ticks_barres.py — pourquoi le testeur PU Prime ecarte-t-il les vrais ticks 2021-2024 (25/09) ?
Compare, minute par minute, les barres M1 du serveur et les ticks du serveur (pont MetaTrader5) :
 - nombre de ticks dans la minute contre tick_volume de la barre,
 - plus haut / plus bas des bid contre plus haut / plus bas de la barre,
 - meme chose en decalant les ticks de -3 h a +3 h (hypothese : barres et ticks pas dans le meme fuseau).
Usage : python sonde_ticks_barres.py SYMBOLE AAAA-MM-JJ [AAAA-MM-JJ ...]
Le pont ouvre le terminal PU Prime : le script le FERME a la fin (sinon lance_chaine refuse)."""
import sys, datetime as dt, subprocess, time
import numpy as np
import MetaTrader5 as mt5
EXE = r"C:\Program Files\PU Prime MT5 Terminal\terminal64.exe"
if not mt5.initialize(path=EXE): print("initialize KO :", mt5.last_error()); sys.exit(1)
sym = sys.argv[1]; mt5.symbol_select(sym, True)
pt = mt5.symbol_info(sym).point
try:
    for jour in sys.argv[2:]:
        d0 = dt.datetime.strptime(jour, "%Y-%m-%d"); d1 = d0 + dt.timedelta(days=1)
        r = mt5.copy_rates_range(sym, mt5.TIMEFRAME_M1, d0, d1)
        t = mt5.copy_ticks_range(sym, d0 - dt.timedelta(hours=4), d1 + dt.timedelta(hours=4), mt5.COPY_TICKS_ALL)
        if r is None or t is None or len(r) == 0 or len(t) == 0:
            print(sym, jour, "RIEN", mt5.last_error()); continue
        tt = t['time_msc'] // 1000; bid = t['bid']
        print("\n%s %s : %d barres M1, %d ticks (+/-4 h), tick_volume total des barres %d" % (sym, jour, len(r), len(t), int(r['tick_volume'].sum())))
        for dec in (-3, -2, -1, 0, 1, 2, 3):
            ts = tt + dec * 3600; ok = 0; nhaut = nbas = 0; ecart = []; ntk = 0
            for b in r:
                m = (ts >= b['time']) & (ts < b['time'] + 60); x = bid[m & (bid > 0)]
                if len(x) == 0: continue
                ntk += len(x)
                hh = abs(x.max() - b['high']) < pt / 2; ll = abs(x.min() - b['low']) < pt / 2
                nhaut += hh; nbas += ll; ok += hh and ll
                ecart.append(max(abs(x.max() - b['high']), abs(x.min() - b['low'])) / pt)
            e = np.array(ecart) if ecart else np.array([np.nan])
            print("  decalage %+d h : minutes avec ticks %4d | haut=bid max %4d | bas=bid min %4d | les deux %4d (%3.0f %%) | ecart median %6.1f pts | ticks %d"
                  % (dec, len(ecart), nhaut, nbas, ok, 100 * ok / max(1, len(ecart)), np.nanmedian(e), ntk))
        # 5 minutes d'exemple a decalage 0
        for b in r[600:603]:
            m = (tt >= b['time']) & (tt < b['time'] + 60); x = bid[m]
            print("   %s barre O %.5f H %.5f L %.5f C %.5f vol %d | ticks %d bid max %s min %s premier %s dernier %s" % (
                dt.datetime.utcfromtimestamp(int(b['time'])).strftime('%H:%M'), b['open'], b['high'], b['low'], b['close'], b['tick_volume'],
                len(x), x.max() if len(x) else '-', x.min() if len(x) else '-', x[0] if len(x) else '-', x[-1] if len(x) else '-'))
finally:
    mt5.shutdown(); time.sleep(2)
    subprocess.run(['powershell', '-NoProfile', '-Command', "Get-Process terminal64 -ErrorAction Ignore | Where-Object { try { $_.Path -eq '%s' } catch { $false } } | Stop-Process -Force" % EXE])
    print("terminal ferme")
