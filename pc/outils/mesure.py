# -*- coding: utf-8 -*-
"""mesure.py <rapport MT5 .htm> [historique M1 .hst]

LA mesure d'un rapport, avec ses controles integres.
AUCUN chiffre n'est imprime si un controle echoue.

  C1  depot lu dans l'en-tete ; solde cumule (ordre du fichier) == colonne solde a 0,01 pres ;
      net recalcule == net de l'en-tete
  C2  ordre d'execution = numero de deal ; l'heure ne recule jamais
  C3  fenetre et annualisation lues dans l'en-tete
  C4  fonds : tous les deals appliques, zero position restante, fonds final == solde final ;
      historique M1 couvrant >= 97 % des minutes de bourse de la fenetre, sinon "non mesurable"

Le creux est TOUJOURS relatif au pic glissant — pas la convention MT5 (plus grand creux en
argent, rapporte a un pic qui n'est pas le sien).
"""
import re, html, sys, os, datetime as dt, statistics as st
sys.stdout.reconfigure(encoding='utf-8')
UTC = dt.timezone.utc
CONTRAT = 100.0  # onces par lot sur l'or


def num(x):
    x = str(x).replace(' ', '').replace(' ', '').replace(' ', '').replace(',', '.')
    m = re.match(r'^-?\d+(\.\d+)?', x)
    return float(m.group(0)) if m else None


def charge(p):
    b = open(p, 'rb').read()
    return b.decode('utf-16') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('cp1252', 'replace')


def entete(s):
    cells = [html.unescape(re.sub(r'<[^>]+>', '', c)).strip()
             for c in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>', s[:400000], flags=re.S | re.I)]
    d = {}
    for i, c in enumerate(cells):
        k = re.sub(r'[^a-z]', '', c.lower())
        if i + 1 < len(cells) and k:
            d.setdefault(k, cells[i + 1])
    g = lambda *ks: next((d[k] for k in ks if k in d), None)
    dep = num(g('dptinitial', 'depotinitial', 'initialdeposit'))
    per = g('priode', 'periode', 'period') or ''
    m = re.search(r'(\d{4})\.(\d{2})\.(\d{2})\s*-\s*(\d{4})\.(\d{2})\.(\d{2})', per)
    a = dt.datetime(*map(int, m.groups()[:3]), tzinfo=UTC) if m else None
    b = dt.datetime(*map(int, m.groups()[3:]), tzinfo=UTC) if m else None
    return dict(depot=dep, debut=a, fin=b, expert=g('expert'), symbole=g('symbole', 'symbol'),
                dd_solde_mt5=g('soldedrawdownmaximal', 'balancedrawdownmaximal'),
                dd_fonds_mt5=g('fonddrawdownmaximal', 'equitydrawdownmaximal'),
                net_mt5=num(g('profittotalnet', 'totalnetprofit')))


def deals(s):
    out = []
    for r in re.findall(r'<tr[^>]*>(.*?)</tr>', s, flags=re.S | re.I):
        t = [html.unescape(re.sub(r'<[^>]+>', '', x)).strip()
             for x in re.findall(r'<td[^>]*>(.*?)</td>', r, flags=re.S | re.I)]
        if len(t) >= 12 and re.match(r'\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}', t[0]) \
                and t[3].lower() in ('buy', 'sell') and t[4] in ('in', 'out', 'in/out'):
            out.append(dict(t=dt.datetime.strptime(t[0][:19], '%Y.%m.%d %H:%M:%S').replace(tzinfo=UTC),
                            no=int(t[1]), typ=t[3].lower(), dr=t[4], vol=num(t[5]), px=num(t[6]),
                            pl=(num(t[8]) or 0) + (num(t[9]) or 0) + (num(t[10]) or 0), bal=num(t[11])))
    return out


def q(v, f):
    v = sorted(v)
    k = (len(v) - 1) * f
    i = int(k)
    return v[i] + (v[min(i + 1, len(v) - 1)] - v[i]) * (k - i)


def episodes(curve):
    """curve : liste (t, valeur). Creux relatifs au pic glissant."""
    pk = curve[0][1]; pkt = curve[0][0]; ep = []; cur = None; yrs = {}; gaps = []
    for t, v in curve:
        if v >= pk:
            if cur:
                cur['fin'] = t; ep.append(cur); cur = None
            pk = v; pkt = t; gaps.append(0.0)
        else:
            d = (pk - v) / pk * 100
            gaps.append(d); yrs[t.year] = max(yrs.get(t.year, 0), d)
            if cur is None:
                cur = dict(debut=pkt, creux=d, ct=t)
            elif d > cur['creux']:
                cur['creux'] = d; cur['ct'] = t
    if cur:
        cur['fin'] = None; ep.append(cur)
    big = [e['creux'] for e in ep if e['creux'] >= 1]
    return dict(max=max(gaps), ep=sorted(ep, key=lambda e: -e['creux']), big=big, yrs=yrs, gap_moy=st.mean(gaps))


def ligne_ep(big):
    return (f"episodes >= 1 % : {len(big)} ; moyenne {st.mean(big):.2f}  Q1 {q(big, .25):.2f}  "
            f"mediane {q(big, .5):.2f}  Q3 {q(big, .75):.2f}  P90 {q(big, .9):.2f}") if big else "aucun episode >= 1 %"


def main():
    p = sys.argv[1]; s = charge(p); H = entete(s); D = deals(s); err = []
    if not D:
        print("NON VERIFIE : aucune ligne de deal MT5 lisible"); return
    if not H['depot']:
        err.append("C1 depot introuvable dans l'en-tete")
    else:
        bal = H['depot']; e = 0.0
        for d in D:
            bal += d['pl']
            if d['bal'] is not None:
                e = max(e, abs(bal - d['bal']))
        if e > 0.011:
            err.append(f"C1 solde cumule vs colonne solde : ecart {e:.2f} $")
        if H['net_mt5'] is not None and abs(bal - H['depot'] - H['net_mt5']) > 0.011:
            err.append(f"C1 net recalcule {bal - H['depot']:.2f} vs en-tete {H['net_mt5']}")
    D.sort(key=lambda d: d['no'])
    if any(D[i]['t'] < D[i - 1]['t'] for i in range(1, len(D))):
        err.append("C2 l'heure recule dans l'ordre des deals")
    if not (H['debut'] and H['fin']):
        err.append("C3 fenetre introuvable dans l'en-tete")
    if err:
        print("NON VERIFIE :")
        for x in err:
            print("  -", x)
        return
    ans = (H['fin'] - H['debut']).days / 365.25
    dep = H['depot']; fin = dep + sum(d['pl'] for d in D)
    cagr = ((fin / dep) ** (1 / ans) - 1) * 100 if fin > 0 else -100
    bal = dep; curve = []
    for d in D:
        bal += d['pl']; curve.append((d['t'], bal))
    S = episodes(curve)
    print(f"VERIFIE (C1 C2 C3) — {H['expert']} · {H['symbole']} · {H['debut']:%Y-%m-%d} → {H['fin']:%Y-%m-%d} "
          f"({ans:.1f} ans) · depot {dep:.0f} · {len(D)} deals")
    print(f"  rendement annualise            {cagr:8.1f} %/an   (solde final {fin:.0f})")
    print(f"  creux max de SOLDE / pic       {S['max']:8.2f} %      (MT5 affiche : {H['dd_solde_mt5']})")
    print(f"  rapport rendement/creux solde  {(cagr / S['max']) if S['max'] else float('inf'):8.2f}")
    print("  creux solde par annee          " + "  ".join(f"{y}: {v:.2f} %" for y, v in sorted(S['yrs'].items())))
    print("  " + ligne_ep(S['big']))
    if len(sys.argv) > 2 and os.path.exists(sys.argv[2]):
        import numpy as np
        dtp = np.dtype([('t', '<i8'), ('o', '<f8'), ('h', '<f8'), ('l', '<f8'), ('c', '<f8'),
                        ('v', '<i8'), ('sp', '<i4'), ('rv', '<i8')])
        a = np.fromfile(sys.argv[2], dtype=dtp, offset=148)
        t0 = int(D[0]['t'].timestamp()); t1 = int(D[-1]['t'].timestamp())
        m = (a['t'] >= t0 - 3600) & (a['t'] <= t1 + 3600)
        bt = a['t'][m]; bc = a['c'][m]
        attendu = (t1 - t0) / 60 * 5 / 7 * (23 / 24)
        couv = len(bt) / attendu if attendu > 0 else 0
        if couv < 0.97:
            print(f"  creux de FONDS                 non mesurable : l'historique M1 couvre {100 * couv:.0f} % de la fenetre (< 97 %)")
        else:
            balc = dep; opens = []; di = 0; eq = []; n = len(D)
            for k in range(len(bt)):
                while di < n and int(D[di]['t'].timestamp()) < bt[k] + 60:
                    d = D[di]; di += 1; balc += d['pl']
                    if d['dr'] == 'in':
                        opens.append([1 if d['typ'] == 'buy' else -1, d['vol'], d['px']])
                    else:
                        side = -1 if d['typ'] == 'buy' else 1; v = d['vol']
                        for o in opens:
                            if o[0] == side and v > 1e-9:
                                take = min(o[1], v); v -= take; o[1] -= take
                        opens = [o for o in opens if o[1] > 1e-9]
                fl = sum(o[0] * (bc[k] - o[2]) * o[1] * CONTRAT for o in opens)
                eq.append((dt.datetime.fromtimestamp(int(bt[k]), UTC), balc + fl))
            if di < n or opens or abs(eq[-1][1] - fin) > 0.011:
                print(f"  creux de FONDS                 NON VERIFIE : deals appliques {di}/{n}, positions restantes {len(opens)}, "
                      f"fonds final {eq[-1][1]:.2f} vs solde {fin:.2f}")
            else:
                E = episodes(eq)
                print(f"  creux max de FONDS / pic       {E['max']:8.2f} %      (MT5 affiche : {H['dd_fonds_mt5']}) — C4 OK, M1 couvre {100 * couv:.0f} %")
                print(f"  rapport rendement/creux fonds  {cagr / E['max']:8.2f}")
                print("  creux fonds par annee          " + "  ".join(f"{y}: {v:.2f} %" for y, v in sorted(E['yrs'].items())))
                print("  " + ligne_ep(E['big']))
    else:
        print("  creux de FONDS                 non mesure (pas d'historique M1 fourni)")


if __name__ == '__main__':
    main()
