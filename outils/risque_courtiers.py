#!/usr/bin/env python3
"""Risque d'un livre face aux règles d'Axi Select et de Darwinex, à partir de sa série journalière.

Usage :
    python outils/risque_courtiers.py <serie_journaliere.csv> [--col NOM] [--capital 5000 10000 ...]

Entrée : le CSV journalier en dollars produit par le fil des tests (séparateur ;), par exemple
forex\\livre_eo_propre_journalier.csv. Une colonne de date puis une ou plusieurs colonnes de gain
en $. Sans --col : colonne « total »/« livre »/« net » si elle existe, sinon la seule colonne
numérique, sinon la somme de toutes (le script dit laquelle il a prise).

Sortie, sans rien estimer hors de la série :
  1. Darwinex. VaR mensuelle à 95 % (horizon 21 jours de bourse, historique sur fenêtres
     glissantes), en $ puis en % de chaque capital demandé. Rendement mensuel moyen ramené au
     risque cible de Darwinex (VaR 6,5 % puis 3,25 %) : c'est ce que ferait le DARWIN, quel que
     soit le capital, puisque le moteur de risque rééchelonne tout sur cette cible.
     Pire VaR sur 45 jours glissants contre meilleure : Darwinex tolère un rapport 2.
  2. Axi Select. Pour chaque capital : pire creux en % du capital de départ (règle -7 % fixe,
     latent compris), et tirage par blocs de 21 jours : probabilité d'atteindre +7 % avant -7 %,
     et délai médian.
"""
import csv
import random
import statistics
import sys
from datetime import datetime

JOURS_MOIS = 21
NB_TIRAGES = 5000
HORIZON_MAX = 252 * 2


def nombre(txt):
    txt = (txt or "").strip().replace(" ", "").replace(" ", "")
    if not txt:
        return None
    if "," in txt and "." not in txt:
        txt = txt.replace(",", ".")
    try:
        return float(txt)
    except ValueError:
        return None


def lire(chemin, col):
    with open(chemin, encoding="utf-8-sig", errors="replace") as f:
        brut = f.read()
    sep = ";" if brut.count(";") >= brut.count(",") else ","
    lignes = [l for l in csv.reader(brut.splitlines(), delimiter=sep) if l]
    entete = [h.strip() for h in lignes[0]]
    donnees = lignes[1:]
    numeriques = [i for i in range(1, len(entete))
                  if all(nombre(r[i]) is not None for r in donnees[:50] if len(r) > i)]
    if col:
        choix = [entete.index(col)]
    else:
        prefere = [i for i in numeriques if entete[i].lower() in ("total", "livre", "net", "pnl", "gain")]
        choix = prefere[:1] or (numeriques if len(numeriques) == 1 else numeriques)
    print(f"Fichier : {chemin}")
    print(f"En-tête : {entete}")
    print(f"Colonne(s) prise(s) : {[entete[i] for i in choix]}"
          + ("  (SOMME de plusieurs colonnes : vérifier que ce ne sont que des jambes)" if len(choix) > 1 else ""))
    serie = []
    for r in donnees:
        v = sum(nombre(r[i]) or 0.0 for i in choix if len(r) > i)
        serie.append((r[0].strip(), v))
    print(f"Jours : {len(serie)}, du {serie[0][0]} au {serie[-1][0]}, total {sum(v for _, v in serie):,.0f} $")
    return serie


def quantile(vals, q):
    s = sorted(vals)
    k = (len(s) - 1) * q
    lo, hi = int(k), min(int(k) + 1, len(s) - 1)
    return s[lo] + (s[hi] - s[lo]) * (k - lo)


def sommes_glissantes(vals, n):
    out, acc = [], sum(vals[:n])
    out.append(acc)
    for i in range(n, len(vals)):
        acc += vals[i] - vals[i - n]
        out.append(acc)
    return out


def darwinex(vals, capitaux):
    mois = sommes_glissantes(vals, JOURS_MOIS)
    var95 = -quantile(mois, 0.05)
    moyenne = statistics.mean(mois)
    print("\n== Darwinex (VaR mensuelle 95 %, fenêtres glissantes de 21 jours) ==")
    print(f"VaR 95 % mensuelle : {var95:,.0f} $   gain mensuel moyen : {moyenne:,.0f} $   rapport gain/VaR : {moyenne / var95:.2f}")
    for cible in (6.5, 3.25):
        print(f"  DARWIN ramené à une VaR de {cible} % : gain mensuel moyen ≈ {moyenne / var95 * cible:.2f} %"
              f"  (≈ {((1 + moyenne / var95 * cible / 100) ** 12 - 1) * 100:.0f} %/an composé)")
    # stabilité du risque sur 45 jours glissants (fenêtre du moteur de Darwinex)
    vars45 = []
    for i in range(45, len(vals) + 1):
        bloc = vals[i - 45:i]
        m = sommes_glissantes(bloc, JOURS_MOIS)
        vars45.append(-quantile(m, 0.05) if min(m) < 0 else 0.0)
    positifs = [v for v in vars45 if v > 0]
    if positifs:
        print(f"  VaR sur 45 jours glissants : médiane {statistics.median(positifs):,.0f} $, "
              f"10e centile {quantile(positifs, 0.10):,.0f} $, 90e centile {quantile(positifs, 0.90):,.0f} $ "
              f"(rapport 90e/10e : {quantile(positifs, 0.90) / max(quantile(positifs, 0.10), 1e-9):.1f} ; "
              f"Darwinex tolère 2)")
    for c in capitaux:
        print(f"  capital {c:>8,.0f} $ : VaR mensuelle {var95 / c * 100:5.2f} % du capital")


def creux_max(vals):
    pic = cum = 0.0
    pire = 0.0
    for v in vals:
        cum += v
        pic = max(pic, cum)
        pire = min(pire, cum - pic)
    return -pire


def pire_sous_depart(vals, fenetre):
    """Pire perte sous le point de départ, pour tout départ possible, sur `fenetre` jours."""
    pire = 0.0
    for d in range(0, len(vals) - 1):
        cum = 0.0
        for v in vals[d:d + fenetre]:
            cum += v
            pire = min(pire, cum)
    return -pire


def axi(vals, capitaux):
    print("\n== Axi Select (perte max -7 % du capital de début d'étape, objectif +7 %) ==")
    print("   NB : série de clôture journalière ; le latent intrajournalier n'y est pas, la marge réelle doit le couvrir.")
    cm = creux_max(vals)
    p60 = pire_sous_depart(vals, 60)
    print(f"Pire creux (pic à creux) : {cm:,.0f} $   pire perte sous le départ en 60 jours : {p60:,.0f} $")
    blocs = [vals[i:i + JOURS_MOIS] for i in range(0, len(vals) - JOURS_MOIS + 1)]
    rnd = random.Random(20260926)
    for c in capitaux:
        haut, bas = 0.07 * c, -0.07 * c
        gagnes, perdus, delais = 0, 0, []
        for _ in range(NB_TIRAGES):
            cum, j, fini = 0.0, 0, False
            while j < HORIZON_MAX and not fini:
                for v in rnd.choice(blocs):
                    cum += v
                    j += 1
                    if cum <= bas:
                        perdus += 1
                        fini = True
                        break
                    if cum >= haut:
                        gagnes += 1
                        delais.append(j)
                        fini = True
                        break
        print(f"  capital {c:>8,.0f} $ : pire creux {cm / c * 100:5.2f} %, pire perte sous départ {p60 / c * 100:5.2f} % ; "
              f"+7 % avant -7 % : {gagnes / NB_TIRAGES * 100:5.1f} %, -7 % d'abord : {perdus / NB_TIRAGES * 100:5.1f} %, "
              f"délai médian {statistics.median(delais) if delais else float('nan'):.0f} j de bourse")


def main():
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        sys.exit(1)
    chemin, col, capitaux = args[0], None, [2000, 5000, 10000, 20000]
    if "--col" in args:
        col = args[args.index("--col") + 1]
    if "--capital" in args:
        i = args.index("--capital") + 1
        capitaux = []
        while i < len(args) and not args[i].startswith("--"):
            capitaux.append(float(args[i]))
            i += 1
    serie = lire(chemin, col)
    vals = [v for _, v in serie]
    darwinex(vals, capitaux)
    axi(vals, capitaux)


if __name__ == "__main__":
    main()
