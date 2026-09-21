import csv, collections, sys
sys.stdout.reconfigure(encoding='utf-8')

def charge(path):
    rows = list(csv.reader(open(path, encoding='utf-8')))[1:]  # header
    return rows

def agrege(rows, prefixe):
    # net par mois pour toutes les sous-clés jeu|prix qui commencent par prefixe
    par_mois = collections.defaultdict(float)
    autres_par_mois = collections.defaultdict(float)
    tous_mois = set()
    for jeu, mois, net in rows:
        net = float(net)
        tous_mois.add(mois)
        if jeu.split('|')[0] == prefixe:
            par_mois[mois] += net
        else:
            autres_par_mois[mois] += net
    return par_mois, autres_par_mois, sorted(tous_mois)

def correlation(a, b, mois_list):
    xs = [a.get(m, 0.0) for m in mois_list]
    ys = [b.get(m, 0.0) for m in mois_list]
    n = len(xs)
    mx = sum(xs)/n; my = sum(ys)/n
    cov = sum((x-mx)*(y-my) for x, y in zip(xs, ys))
    vx = sum((x-mx)**2 for x in xs)
    vy = sum((y-my)**2 for y in ys)
    if vx == 0 or vy == 0: return None
    return cov / (vx*vy)**0.5

for rapport, label in [
    ("C:/Users/User/OneDrive/Documents/forex/outils/parjeu_n121_eagleowl_or_reverif.csv", "n121 (compte propre, SetsB)"),
    ("C:/Users/User/OneDrive/Documents/forex/outils/parjeu_n132_eagleowl_or_b2.csv", "n132 (prop firm, SetsB2)"),
]:
    rows = charge(rapport)
    print(f"\n=== {label} ===")
    for jeu in ("GoldDaily1", "goldtrade_H"):
        par_jeu, reste, mois_list = agrege(rows, jeu)
        r = correlation(par_jeu, reste, mois_list)
        net_total = sum(par_jeu.values())
        n_mois_actifs = sum(1 for v in par_jeu.values() if v != 0)
        print(f"{jeu:14s} : net total {net_total:8.0f} $ sur {n_mois_actifs} mois actifs / {len(mois_list)} mois — corrélation au reste du panier : {r:.3f}" if r is not None else f"{jeu} : variance nulle, corrélation non définie")
