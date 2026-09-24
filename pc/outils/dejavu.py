# -*- coding: utf-8 -*-
"""dejavu.py <nom ou numéro de produit> [...] — « l'avons-nous DÉJÀ vu ? »
À lancer AVANT toute recherche web sur un robot, un signal, un indicateur ou une paire.
Cherche le terme dans : nos documents de travail (outils/*.md, *.txt), la mémoire Claude,
les jeux de réglages UBS (SetsB/SetsC, y compris UTF-16), et les noms de rapports du terminal MT5.
Né de l'erreur du 06/09/2026 : recherche web sur Luna AI Pro, déjà criblé et éliminé le 31/08.
Sortie : chaque endroit où le terme apparaît, avec la ligne. Rien = jamais rencontré, la recherche est justifiée."""
import sys, os, re, glob
sys.stdout.reconfigure(encoding='utf-8')
OUT = os.path.dirname(os.path.abspath(__file__))
MEM = r"C:\Users\User\.claude\projects\C--Users-User--claude\memory"
SETS = r"C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\Common\Files"
TERM = r"C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\E62C655ED163FFC555DD40DBEA67E6BB"
def lire(p):
    try:
        b = open(p, 'rb').read()
        return b.decode('utf-16', 'replace') if b[:2] in (b'\xff\xfe', b'\xfe\xff') else b.decode('utf-8', 'replace')
    except Exception:
        return ''
def cherche(terme):
    t = terme.lower(); trouve = []
    sources = [("document", glob.glob(os.path.join(OUT, '*.md')) + glob.glob(os.path.join(OUT, '*.txt'))),
               ("mémoire", glob.glob(os.path.join(MEM, '*.md'))),
               ("jeu UBS", glob.glob(os.path.join(SETS, 'Sets*', '*.set')))]
    for genre, fichiers in sources:
        for f in fichiers:
            s = lire(f)
            if t in s.lower():
                for i, l in enumerate(s.splitlines(), 1):
                    if t in l.lower():
                        trouve.append((genre, os.path.basename(f), i, l.strip()[:200]))
                        break
    for f in glob.glob(os.path.join(TERM, '*.htm')):
        if t in os.path.basename(f).lower(): trouve.append(("rapport", os.path.basename(f), 0, ''))
    return trouve
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("usage : python dejavu.py <nom du robot / numéro de produit> [...]"); sys.exit(2)
    total = 0
    for terme in sys.argv[1:]:
        r = cherche(terme)
        print(f"\n=== « {terme} » : {len(r)} trace(s)")
        for genre, f, i, l in r[:12]:
            print(f"  [{genre}] {f}" + (f":{i}  {l}" if i else ""))
        if len(r) > 12: print(f"  … et {len(r)-12} autres")
        if not r: print("  jamais rencontré — la recherche extérieure est justifiée")
        total += len(r)
    sys.exit(1 if total else 0)
