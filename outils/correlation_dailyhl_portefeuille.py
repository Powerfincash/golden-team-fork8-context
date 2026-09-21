import sys, collections
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'C:\Users\User\OneDrive\Documents\forex\outils')
from diag_sorties import positions

T = r"C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\E62C655ED163FFC555DD40DBEA67E6BB"
TV = r"C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\725B72F25E46C780EF59F57016D58156"

def mensuel(path):
    P = positions(path, "")
    par_mois = collections.defaultdict(float)
    for p in P:
        m = p['tin'].strftime('%Y-%m')
        par_mois[m] += p.get('pl', 0.0)
    return par_mois

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

or_2025 = mensuel(T + r"\n66_eagleowl_reserve2025.htm")
dhl_2025 = mensuel(TV + r"\d01_dailyhlbreakout_2025.htm")

mois_list = sorted(set(or_2025) | set(dhl_2025))
r = correlation(or_2025, dhl_2025, mois_list)

print("Mois  |  Or (jambe cassure, n66)  |  Daily HighLow Breakout (NAS100.r)")
for m in mois_list:
    print(f"{m}  |  {or_2025.get(m,0):8.1f}  |  {dhl_2025.get(m,0):8.1f}")
print(f"\nTotal or 2025      : {sum(or_2025.values()):.0f} $")
print(f"Total DHL 2025     : {sum(dhl_2025.values()):.0f} $")
print(f"\nCorrélation mensuelle Daily HighLow Breakout / jambe or (n66, réserve 2025) : {r:.3f}" if r is not None else "corrélation non définie (variance nulle)")
