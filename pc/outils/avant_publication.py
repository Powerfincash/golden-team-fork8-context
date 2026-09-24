# -*- coding: utf-8 -*-
"""avant_publication.py <produit> — inventaire OBLIGATOIRE avant d'annoncer un resultat mesure.

Ne du reproche du 06/09/2026 : « tout etait valide puis plus rien ». Trois fois dans la meme journee
j'ai publie une conclusion avant d'avoir lu ce qui etait deja sur le disque (Luna AI, rapports Advanced
Scalper, jeux de reglages de Wolf). Le defaut n'est pas de retester, c'est d'ANNONCER TROP TOT.

Liste tout ce que le disque contient sur un produit : jeux de reglages, manuels, rapports, mentions dans
nos documents et dans la memoire. Sortie = une liste de choses A LIRE avant de conclure.
Code retour 1 s'il reste des sources non lues (pour bloquer un enchainement automatique).
"""
import sys, os, re, glob

sys.stdout.reconfigure(encoding='utf-8')

RACINES = [r"C:\Users\User\OneDrive\Documents\forex",
           r"C:\Users\User\AppData\Roaming\MetaQuotes\Terminal",
           r"C:\Users\User\OneDrive\Documents\Denis"]
MEM = r"C:\Users\User\.claude\projects\C--Users-User--claude\memory"
OUT = os.path.dirname(os.path.abspath(__file__))
IGNORE = ('node_modules', '.git', 'cache', 'bases', 'liveupdate')


def cherche(terme):
    t = terme.lower()
    mots = [m for m in re.split(r'[\s_-]+', t) if len(m) > 2]
    res = {'jeux': [], 'manuels': [], 'rapports': [], 'documents': [], 'memoire': []}
    for r in RACINES:
        if not os.path.isdir(r):
            continue
        for dp, dn, fn in os.walk(r):
            bas = dp.lower()
            if any(x in bas for x in IGNORE):
                continue
            for f in fn:
                p = os.path.join(dp, f)
                bl = p.lower()
                if not all(m in bl for m in mots):
                    continue
                e = f.lower().rsplit('.', 1)[-1]
                if e == 'set':
                    res['jeux'].append(p)
                elif e in ('pdf', 'txt', 'doc', 'docx'):
                    res['manuels'].append(p)
                elif e in ('htm', 'html'):
                    res['rapports'].append(p)
    for f in glob.glob(os.path.join(OUT, '*.md')) + glob.glob(os.path.join(MEM, '*.md')):
        try:
            s = open(f, encoding='utf-8', errors='replace').read().lower()
        except Exception:
            continue
        if all(m in s for m in mots):
            (res['memoire'] if MEM in f else res['documents']).append(f)
    return res


TITRES = (
    ('jeux', "JEUX DE REGLAGES du vendeur — ils contiennent des parametres que le comportement\n"
             "   observable ne revele PAS : filtres d'ecart, de glissement, horaires, decalages"),
    ('manuels', "MANUELS"),
    ('rapports', "RAPPORTS DEJA PRODUITS — ne pas refaire un test qui existe"),
    ('documents', "NOS DOCUMENTS"),
    ('memoire', "MEMOIRE — un verdict deja rendu s'y trouve peut-etre, avec un motif plus fort"),
)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('usage : python avant_publication.py "<nom du produit>"')
        sys.exit(2)
    terme = ' '.join(sys.argv[1:])
    r = cherche(terme)
    print(f"=== A LIRE avant d'annoncer quoi que ce soit sur « {terme} » ===\n")
    total = 0
    for cle, titre in TITRES:
        vus = sorted(set(r[cle]))
        if not vus:
            continue
        print(f"-- {titre}")
        for p in vus[:15]:
            print("   ", p)
        if len(vus) > 15:
            print(f"    ... et {len(vus) - 15} autres")
        total += len(vus)
        print()
    if total == 0:
        print("rien sur le disque — la mesure part de zero, seul cas ou l'on peut conclure")
        print("sans lecture prealable")
        sys.exit(0)
    print(f"{total} source(s) a lire. REGLE : tant qu'une seule ne l'est pas, aucun chiffre ne sort.")
    print("Et une comparaison entre deux mesures n'a de sens que si les DEUX ont les memes")
    print("conditions : meme fenetre, meme lot, meme modele de ticks, meme delai d'execution.")
    sys.exit(1)
