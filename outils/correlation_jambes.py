"""Correlation mensuelle entre deux jambes, a partir des sorties datees de parjeu.py.

Usage :
    python outils/correlation_jambes.py <csv_jambe_A> <csv_jambe_B> [etiquetteA] [etiquetteB]

Entree attendue : la sortie DATEE de parjeu.py --csv, trois colonnes avec en-tete,
    jeu|prix , mois , net
C'est le meme format que celui lu par correlation_golddaily1_goldtradeh.py.
La sortie agregee par NIVEAU DE PRIX sans mois ne convient pas : sans date, aucune
correlation n'est calculable.

Sortie : le net mensuel de chaque jambe, le nombre de mois communs, et le Pearson.
Seuil du crible : au-dela de +0,50 la redondance est disqualifiante.
"""
import csv, collections, sys

sys.stdout.reconfigure(encoding='utf-8')

SEUIL = 0.50


def net_par_mois(chemin):
    par_mois = collections.defaultdict(float)
    with open(chemin, encoding='utf-8') as f:
        lignes = list(csv.reader(f))
    if not lignes:
        raise SystemExit(f"{chemin} est vide.")
    for ligne in lignes[1:]:                      # on saute l'en-tete
        if len(ligne) < 3:
            continue
        _, mois, net = ligne[0], ligne[1], ligne[2]
        try:
            par_mois[mois] += float(net)
        except ValueError:
            raise SystemExit(
                f"{chemin} : la troisieme colonne n'est pas un nombre ({net!r}).\n"
                "Ce fichier n'est probablement pas la sortie DATEE de parjeu.py --csv."
            )
    if not par_mois:
        raise SystemExit(f"{chemin} : aucune ligne exploitable.")
    return par_mois


def pearson(a, b, mois):
    xs = [a.get(m, 0.0) for m in mois]
    ys = [b.get(m, 0.0) for m in mois]
    n = len(xs)
    mx, my = sum(xs) / n, sum(ys) / n
    cov = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    vx = sum((x - mx) ** 2 for x in xs)
    vy = sum((y - my) ** 2 for y in ys)
    if vx == 0 or vy == 0:
        return None
    return cov / (vx * vy) ** 0.5


def main():
    if len(sys.argv) < 3:
        raise SystemExit(__doc__)
    csv_a, csv_b = sys.argv[1], sys.argv[2]
    nom_a = sys.argv[3] if len(sys.argv) > 3 else "jambe A"
    nom_b = sys.argv[4] if len(sys.argv) > 4 else "jambe B"

    a, b = net_par_mois(csv_a), net_par_mois(csv_b)
    mois = sorted(set(a) | set(b))
    communs = sorted(set(a) & set(b))

    print(f"\n{nom_a:28s} : net {sum(a.values()):9.0f} $ sur {len(a)} mois")
    print(f"{nom_b:28s} : net {sum(b.values()):9.0f} $ sur {len(b)} mois")
    print(f"{'Mois communs':28s} : {len(communs)} (union {len(mois)})")

    if len(communs) < 12:
        print("\nATTENTION : moins de 12 mois communs, la correlation n'est pas interpretable.")

    r = pearson(a, b, mois)
    if r is None:
        print("\nVariance nulle sur une des deux jambes : correlation non definie.")
        return
    verdict = "REDONDANT — disqualifiant" if r > SEUIL else "pas de redondance"
    print(f"\nCorrelation de Pearson mensuelle : {r:+.3f}   (seuil {SEUIL:+.2f})  ->  {verdict}")
    print("\nRappel : la faiblesse n'est pas un disqualifiant, la redondance l'est.")


if __name__ == "__main__":
    main()
