# -*- coding: utf-8 -*-
"""parjeu.py <rapport.htm> [--csv]  — mesure jeu par jeu d'un rapport UBS multi-jeux (un symbole ou plusieurs).
Attribution des sorties : la table des ORDRES du rapport donne, pour chaque ordre d'entrée, son S/L, son T/P et le jeu
(commentaire). Une sortie 'sl <prix>' va à la position ouverte de même sens dont le S/L initial est le plus proche du
prix ; 'tp <prix>' idem avec le T/P ; autre sortie (fermée par le robot) à l'entrée de prix le plus proche.
Par jeu : transactions, net, PF, gain moyen, creux max de sa propre courbe de solde ($), rapport net/creux, net par
année. --csv écrit outils/parjeu_<rapport>.csv (jeu, mois, net) pour les corrélations."""
import sys, re, html, os, collections, datetime as dt
sys.stdout.reconfigure(encoding='utf-8')
import mesure as M
def lignes(s):
    out = []
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>', s, flags=re.S | re.I):
        t = [html.unescape(re.sub(r'<[^>]+>', '', x)).strip() for x in re.findall(r'<td[^>]*>(.*?)</td>', r, flags=re.S | re.I)]
        if t and re.match(r'\d{4}\.\d{2}\.\d{2}', t[0]): out.append(t)
    return out
def analyse(p):
    s = M.charge(p)
    # ordres (11 colonnes) : Heure | Ordre | Symbole | Type | Volume | Prix | S/L | T/P | Heure | Etat | Commentaire
    # deals (13 colonnes) : Heure | Deal | Symbole | Type | Direction | Volume | Prix | Ordre | Comm | Swap | Profit | Solde | Commentaire
    ordres = {}; rows = []
    for t in lignes(s):
        if len(t) == 11 and t[1].isdigit(): ordres[int(t[1])] = dict(sl=M.num(t[6]) or 0, tp=M.num(t[7]) or 0, com=t[10])
        elif len(t) >= 13 and t[3].lower() in ('buy', 'sell') and t[4] in ('in', 'out'): rows.append(t)
    rows.sort(key=lambda t: int(t[1]))
    opens = []; par = collections.defaultdict(list); nonattr = 0
    for t in rows:
        heure = dt.datetime.strptime(t[0][:19], '%Y.%m.%d %H:%M:%S'); typ = t[3].lower(); dr = t[4]; sym = t[2]
        vol = M.num(t[5]) or 0; px = M.num(t[6]) or 0; no = int(t[7]) if t[7].isdigit() else 0
        pl = (M.num(t[8]) or 0) + (M.num(t[9]) or 0) + (M.num(t[10]) or 0); com = t[12]
        if dr == 'in':
            o = ordres.get(no, {}); jeu = re.sub(r'\.set$', '', (o.get('com') or com or '?')).strip()
            opens.append(dict(typ=typ, sym=sym, px=px, vol=vol, jeu=jeu, sl=o.get('sl', 0), tp=o.get('tp', 0)))
            if pl: par[jeu].append((heure, pl, 'comm'))  # commission d'entrée, au jeu
        else:
            side = 'sell' if typ == 'buy' else 'buy'; sortie = (com.split()[0].lower() if com else 'ea')
            cands = [o for o in opens if o['typ'] == side and o['sym'] == sym and o['vol'] > 1e-9]
            if not cands: nonattr += 1; continue
            key = {'sl': (lambda o: abs(o['sl'] - px) if o['sl'] else 9e9), 'tp': (lambda o: abs(o['tp'] - px) if o['tp'] else 9e9)}.get(sortie, lambda o: abs(o['px'] - px))
            o = min(cands, key=key); take = min(o['vol'], vol); o['vol'] -= take
            par[o['jeu']].append((heure, pl, sortie))
            if o['vol'] <= 1e-9: opens.remove(o)
    return par, nonattr, len(rows), M.entete(s)
def stats(tr):
    net = sum(x[1] for x in tr); g = sum(x[1] for x in tr if x[1] > 0 and x[2] != 'comm'); l = -sum(x[1] for x in tr if x[1] < 0 and x[2] != 'comm') - -sum(x[1] for x in tr if x[2] == 'comm')
    solde = 0; pic = 0; creux = 0
    for h, pl, _ in sorted(tr):
        solde += pl; pic = max(pic, solde); creux = max(creux, pic - solde)
    an = collections.defaultdict(float); nan = collections.defaultdict(int)
    for h, pl, k in tr:
        an[h.year] += pl
        if k != 'comm': nan[h.year] += 1
    tr = [x for x in tr if x[2] != 'comm'] or tr
    return dict(nan=nan, n=len(tr), net=net, pf=(g / l if l > 0 else float('inf')), moy=net / len(tr) if tr else 0, creux=creux, an=an,
                sl=sum(1 for x in tr if x[2] == 'sl'), tp=sum(1 for x in tr if x[2] == 'tp'))
if __name__ == '__main__':
    p = sys.argv[1]; par, nonattr, nrows, en = analyse(p)
    annees = sorted({h.year for tr in par.values() for h, _, _ in tr})
    print(f"{os.path.basename(p)} — {en.get('expert')} · {en.get('symbole')} · {nrows} lignes de deals · sorties non attribuées : {nonattr}")
    print(f"{'jeu':22s} {'tr':>5s} {'net $':>8s} {'PF':>5s} {'moy':>6s} {'creux$':>7s} {'net/cr':>6s} {'sl':>4s} {'tp':>4s} | " + " ".join(f"{a:>9d}" for a in annees))
    tot = []; 
    for jeu, tr in sorted(par.items(), key=lambda kv: -sum(x[1] for x in kv[1])):
        st = stats(tr); tot += tr
        print(f"{jeu[:22]:22s} {st['n']:5d} {st['net']:8.0f} {st['pf']:5.2f} {st['moy']:6.2f} {st['creux']:7.0f} {(st['net']/st['creux'] if st['creux']>0 else 0):6.2f} {st['sl']:4d} {st['tp']:4d} | " + " ".join(f"{st['an'].get(a,0):5.0f}/{st['nan'].get(a,0):<3d}" for a in annees))
    st = stats(tot)
    print(f"{'ENSEMBLE':22s} {st['n']:5d} {st['net']:8.0f} {st['pf']:5.2f} {st['moy']:6.2f} {st['creux']:7.0f} {(st['net']/st['creux'] if st['creux']>0 else 0):6.2f} {st['sl']:4d} {st['tp']:4d} | " + " ".join(f"{st['an'].get(a,0):5.0f}/{st['nan'].get(a,0):<3d}" for a in annees))
    if '--csv' in sys.argv:
        out = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'parjeu_' + os.path.basename(p).replace('.htm', '.csv'))
        with open(out, 'w', encoding='utf-8') as f:
            f.write('jeu,mois,net\n')
            for jeu, tr in par.items():
                m = collections.defaultdict(float)
                for h, pl, _ in tr: m[h.strftime('%Y-%m')] += pl
                for k in sorted(m): f.write(f"{jeu},{k},{m[k]:.2f}\n")
        print("csv :", out)
