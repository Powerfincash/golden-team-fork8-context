# -*- coding: utf-8 -*-
"""duka_symbole.py <symbole courtier> <chemin tds.config>

Rend le nom du dossier Dukascopy correspondant. Le nom n'est PAS toujours celui
du courtier : pour les indices un mappage figure dans tds.config, section du
symbole, cle SymbolPath-Dukascopy (NAS100.s -> USATECHIDXUSD).
A defaut de mappage, retire le suffixe du courtier (.p, .s, m, .raw).
"""
import io, os, re, sys
sym = sys.argv[1]
cfg = sys.argv[2] if len(sys.argv) > 2 else ""
if cfg and os.path.exists(cfg):
    t = io.open(cfg, encoding='utf-8', errors='replace').read()
    m = re.search(r'<%s>(.*?)</%s>' % (re.escape(sym), re.escape(sym)), t, re.S)
    if m:
        d = re.search(r'SymbolPath-Dukascopy"\s+value="([^"]+)"', m.group(1))
        if d:
            print(d.group(1)); raise SystemExit
print(re.sub(r'(\.[A-Za-z]+|m)$', '', sym))
