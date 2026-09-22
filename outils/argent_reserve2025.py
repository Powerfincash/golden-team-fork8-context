import csv, collections, sys
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'C:\Users\User\OneDrive\Documents\forex\outils')
from diag_sorties import positions

T = r"C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\E62C655ED163FFC555DD40DBEA67E6BB"

# --- A. Jeu par jeu, net 2025 (agrégé sur tous les sous-niveaux de prix) ---
rows = list(csv.reader(open("C:/Users/User/OneDrive/Documents/forex/outils/parjeu_r25f_eagleowl_xag.csv", encoding='utf-8')))[1:]
par_jeu_mois = collections.defaultdict(lambda: collections.defaultdict(float))
JEUX = ("AGA04", "AGA06", "AGA09")
for jeu, mois, net in rows:
    for j in JEUX:
        if j in jeu:
            par_jeu_mois[j][mois] += float(net)
            break

print("=== A. Réserve 2025, jeu par jeu (profil fidèle, v1.47) ===")
for j in JEUX:
    net_total = sum(par_jeu_mois[j].values())
    print(f"  {j} : net 2025 = {net_total:+.0f} $  {'POSITIF' if net_total > 0 else 'NEGATIF -> sort seul'}")

# --- C. Corrélation à la jambe or EN 2025 (n66, seule fenêtre 2025 disponible sur l'or) ---
def mensuel_positions(path):
    P = positions(path, "")
    par_mois = collections.defaultdict(float)
    for p in P:
        m = p['tin'].strftime('%Y-%m')
        par_mois[m] += p.get('pl', 0.0)
    return par_mois

def pearson(a, b, mois_list):
    xs = [a.get(m, 0.0) for m in mois_list]; ys = [b.get(m, 0.0) for m in mois_list]
    n = len(xs); mx = sum(xs)/n; my = sum(ys)/n
    cov = sum((x-mx)*(y-my) for x, y in zip(xs, ys))
    vx = sum((x-mx)**2 for x in xs); vy = sum((y-my)**2 for y in ys)
    if vx == 0 or vy == 0: return None
    return cov / (vx*vy)**0.5

argent_total_mois = collections.defaultdict(float)
for j in JEUX:
    for m, v in par_jeu_mois[j].items():
        argent_total_mois[m] += v

or_2025 = mensuel_positions(T + r"\n66_eagleowl_reserve2025.htm")
mois_list = sorted(set(argent_total_mois) | set(or_2025))
r = pearson(argent_total_mois, or_2025, mois_list)
print(f"\n=== C. Corrélation argent (2025, 3 jeux) / or (2025, n66 SetsB compte propre) ===")
print(f"  ATTENTION : protocole demandait n132 (or 2021-2024) — aucun mois commun avec argent 2025.")
print(f"  Substitué par n66 (or SetsB, réserve 2025) pour une mesure interprétable (même fenêtre).")
print(f"  Corrélation de Pearson mensuelle : {r:+.3f}  (seuil +0.50)  -> {'REDONDANT' if r and r > 0.5 else 'pas de redondance'}")

# --- D. Concentration 2023-2024 dans le net total (2021-2024 depuis n150 + 2025 depuis r25f) ---
print(f"\n=== D. Concentration temporelle, avant/après ajout de 2025 ===")

# --- B. Redosage sur la volatilité courante, creux au pire des deux moitiés ---
print(f"\n=== B. Redosage sur la volatilité courante ===")
FACTEUR_VOL = 2.5  # argent 62$ pese ~2.5x son modele 2021-2024 (protocole)
P = positions(T + r"\r25f_eagleowl_xag.htm", "")
P.sort(key=lambda p: p['tin'])
solde = 0.0; pic = 0.0
creux_s1 = 0.0; creux_s2 = 0.0
for p in P:
    solde += p.get('pl', 0.0)
    pic = max(pic, solde)
    creux = pic - solde
    if p['tin'].month <= 6:
        creux_s1 = max(creux_s1, creux)
    else:
        creux_s2 = max(creux_s2, creux)
pire_moitie = max(creux_s1, creux_s2)
print(f"  Creux S1 (jan-juin) au lot 0.01 : {creux_s1:.0f} $")
print(f"  Creux S2 (juil-dec) au lot 0.01 : {creux_s2:.0f} $")
print(f"  Pire des deux moitiés (lot 0.01, backtest) : {pire_moitie:.0f} $")
print(f"  Redosé x{FACTEUR_VOL} (volatilité actuelle vs modèle 2021-2024) : {pire_moitie*FACTEUR_VOL:.0f} $")
depot = 100000
print(f"  Soit {100*pire_moitie*FACTEUR_VOL/depot:.2f} % du dépôt de référence ({depot} $)")

# --- D. Concentration 2023-2024, avant/après ajout de 2025 ---
rows150 = list(csv.reader(open("C:/Users/User/OneDrive/Documents/forex/outils/parjeu_n150_eagleowl_xag.csv", encoding='utf-8')))[1:]
net_2021, net_2022, net_2023, net_2024 = 0.0, 0.0, 0.0, 0.0
for jeu, mois, net in rows150:
    an = mois[:4]
    v = float(net)
    if an == '2021': net_2021 += v
    elif an == '2022': net_2022 += v
    elif an == '2023': net_2023 += v
    elif an == '2024': net_2024 += v
net_2025 = sum(sum(par_jeu_mois[j].values()) for j in JEUX)
net_2324 = net_2023 + net_2024
net_total_avant = net_2021 + net_2022 + net_2023 + net_2024
net_total_apres = net_total_avant + net_2025

print("\n=== D. Concentration 2023-2024 dans le net, avant/après ajout de 2025 ===")
print(f"  2021 : {net_2021:+.0f} $   2022 : {net_2022:+.0f} $   2023 : {net_2023:+.0f} $   2024 : {net_2024:+.0f} $   2025 : {net_2025:+.0f} $")
print(f"  Avant 2025 : net total {net_total_avant:.0f} $, part 2023-2024 = {100*net_2324/net_total_avant:.1f} %")
print(f"  Après 2025 : net total {net_total_apres:.0f} $, part 2023-2024 = {100*net_2324/net_total_apres:.1f} %")
if 100*net_2324/net_total_apres < 100*net_2324/net_total_avant:
    print(f"  -> BAISSE : {100*net_2324/net_total_avant:.1f} % -> {100*net_2324/net_total_apres:.1f} %. Pas un artefact de fenêtre.")
else:
    print(f"  -> NE BAISSE PAS : artefact de fenêtre, à signaler.")
