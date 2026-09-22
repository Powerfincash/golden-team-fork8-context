"""Chiffre le RESIDU de Kestrel en comparant deux sorties parjeu.py de versions encadrant
une regle de fidelite.

Principe : une version ANTERIEURE a l'adoption d'une regle se comporte comme cette regle
debranchee, c'est-a-dire comme Kestrel sur ce point. La difference entre les deux rapports
est donc ce que la regle a retire : le residu.

Usage :
    python outils/residu_par_versions.py <csv_regle_OFF> <csv_regle_ON> [etiquette]

Exemple (regle « swing depasse = mort » en deca, etendue a l'or en v1.32) :
    python outils/residu_par_versions.py \
        mesures/parjeu_n121_eagleowl_or_reverif_v131.csv \
        mesures/parjeu_n121_eagleowl_or_reverif_v132.csv "n121 SetsB"

Ce que cet outil PEUT dire : la taille du residu (trades, net, creux marginal) et donc s'il
merite un chantier de code. Ce qu'il NE PEUT PAS dire : un dosage ni un verdict — c'est une
difference de deux rapports, pas un rapport unique. Seul un rapport unique decide.
"""
import collections, sys

sys.stdout.reconfigure(encoding='utf-8')

SEUIL_TRADES = 300      # seuil deja retenu pour valider un EA maison


def lignes(path):
    for ligne in open(path, encoding='utf-8', errors='replace'):
        if ' |' not in ligne:
            continue
        gauche = ligne.split(' |')[0]
        t = gauche.split()
        if len(t) < 9:
            continue
        nom = ' '.join(t[:-8])
        try:
            yield nom, dict(tr=int(t[-8]), net=float(t[-7]), pf=float(t[-6]),
                            creux=float(t[-4]), ratio=float(t[-3]))
        except ValueError:
            continue


def ensemble(path):
    for nom, v in lignes(path):
        if nom.startswith('ENSEMBLE'):
            return v
    raise SystemExit(f"{path} : ligne ENSEMBLE introuvable.")


def par_jeu(path):
    d = collections.defaultdict(lambda: [0, 0.0])
    for nom, v in lignes(path):
        if nom.startswith('ENSEMBLE'):
            continue
        base = nom.split('|')[0].strip()
        d[base][0] += v['tr']
        d[base][1] += v['net']
    return d


def main():
    if len(sys.argv) < 3:
        raise SystemExit(__doc__)
    off, on = sys.argv[1], sys.argv[2]
    lib = sys.argv[3] if len(sys.argv) > 3 else ''

    a, b = ensemble(off), ensemble(on)
    dtr, dnet, dcreux = a['tr'] - b['tr'], a['net'] - b['net'], a['creux'] - b['creux']

    print(f"\n=== {lib} ===" if lib else "")
    print(f"  regle DEBRANCHEE (Kestrel sur ce point) : {a['tr']} tr · net {a['net']:.0f} $ · "
          f"creux {a['creux']:.0f} $ · PF {a['pf']} · rapport {a['ratio']}")
    print(f"  regle POSEE      (Eagle-owl fidele)     : {b['tr']} tr · net {b['net']:.0f} $ · "
          f"creux {b['creux']:.0f} $ · PF {b['pf']} · rapport {b['ratio']}")
    print(f"\n  RESIDU : {dtr:+d} trades · {dnet:+.0f} $ de net · {dcreux:+.0f} $ de creux en plus")
    if a['tr']:
        print(f"  soit {dtr / a['tr'] * 100:.0f} % des trades et {dnet / a['net'] * 100:.0f} % du net")
    if dcreux > 0:
        print(f"  rapport MARGINAL du residu : {dnet / dcreux:.1f}  (la jambe fidele est a {b['ratio']})")
    print(f"  taille : {'AU-DESSUS' if dtr >= SEUIL_TRADES else 'EN DESSOUS'} du seuil de {SEUIL_TRADES} trades")

    ja, jb = par_jeu(off), par_jeu(on)
    inchanges = [j for j in ja
                 if ja[j][0] == jb.get(j, [0, 0.0])[0] and abs(ja[j][1] - jb.get(j, [0, 0.0])[1]) >= 1]
    if inchanges:
        ecart = sum(abs(ja[j][1] - jb[j][1]) for j in inchanges)
        print(f"\n  INTERACTION : {len(inchanges)} jeux gardent le MEME nombre de trades mais changent "
              f"de net ({ecart:.0f} $ cumules).")
        print("  Le residu n'est donc pas une soustraction : les trades en plus changent ce qui suit.")

    print(f"\n{'jeu':26s} {'tr OFF':>7s} {'tr ON':>7s} {'d tr':>6s} {'net OFF':>8s} {'net ON':>8s} {'d net':>7s}")
    for jeu in sorted(set(ja) | set(jb)):
        ta, na = ja.get(jeu, [0, 0.0])
        tb, nb = jb.get(jeu, [0, 0.0])
        if ta == tb and abs(na - nb) < 0.5:
            continue
        print(f"{jeu:26s} {ta:7d} {tb:7d} {ta - tb:+6d} {na:8.0f} {nb:8.0f} {na - nb:+7.0f}")


if __name__ == '__main__':
    main()
