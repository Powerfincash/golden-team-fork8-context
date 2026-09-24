#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
empilement.py — combien de positions un robot empile, et ce que coute le paquet.

Ne 24/09/2026 du reel du 16/09 : au moins 13 ventes d'argent a 0,01 ouvertes en
16 minutes, fermees ensemble a perte. Le lot etait minimum ; le nombre de
positions ouvertes a la fois faisait le risque. Ce controle n'avait jamais ete fait.

Lit UN rapport de testeur MT5 (HTML, UTF-16 ou UTF-8), table des transactions,
et compte. Il ne conclut rien : il donne des comptes, pas un verdict.

  python empilement.py <rapport.htm> [--symbole XAGUSD] [--jour 2026.09.16 ...]

Definitions (les memes pour le test et pour le reel) :
  - positions ouvertes a un instant = volume ouvert / plus petit lot d'entree vu ;
    compte separement les ventes et les achats (un paquet est d'un seul cote) ;
  - paquet = periode ou un cote passe de 0 position a au moins 1, puis revient a 0 ;
    resultat du paquet = somme profit + commission + swap des sorties de la periode.
"""
import re, sys, html, argparse, collections

DATE = re.compile(r'^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}(:\d{2})?$')
ENTREE = {'in', 'entrée', 'entree'}
SORTIE = {'out', 'sortie', 'out by'}
ACHAT = {'buy', 'achat'}
VENTE = {'sell', 'vente'}


def lire(chemin):
    brut = open(chemin, 'rb').read()
    if brut[:2] in (b'\xff\xfe', b'\xfe\xff'):
        return brut.decode('utf-16')
    for enc in ('utf-8', 'cp1252'):
        try:
            return brut.decode(enc)
        except UnicodeDecodeError:
            pass
    return brut.decode('latin-1')


def lignes(texte):
    for tr in re.findall(r'<tr[^>]*>(.*?)</tr>', texte, re.S | re.I):
        cellules = re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>', tr, re.S | re.I)
        yield [html.unescape(re.sub(r'<[^>]+>', '', c)).strip() for c in cellules]


def nombre(s):
    s = s.replace('\xa0', '').replace(' ', '').replace(',', '.')
    try:
        return float(s)
    except ValueError:
        return 0.0


def transactions(texte, symbole):
    """Table des transactions MT5 : 13 colonnes, Direction en 5e."""
    sortie = []
    for c in lignes(texte):
        if len(c) != 13 or not DATE.match(c[0]):
            continue
        sens, cote = c[4].lower(), c[3].lower()
        if sens not in ENTREE | SORTIE or cote not in ACHAT | VENTE:
            continue
        if symbole and symbole.lower() not in c[2].lower():
            continue
        sortie.append({
            'heure': c[0], 'symbole': c[2], 'type': cote in ACHAT and 'buy' or 'sell',
            'sens': sens in ENTREE and 'in' or 'out', 'volume': nombre(c[5]),
            'net': nombre(c[8]) + nombre(c[9]) + nombre(c[10]), 'commentaire': c[12],
        })
    return sortie


def compter(deals):
    lot = min((d['volume'] for d in deals if d['sens'] == 'in' and d['volume'] > 0), default=0.01)
    ouvert = {'sell': 0.0, 'buy': 0.0}
    paquets, en_cours = [], {}
    pic = {'sell': (0, ''), 'buy': (0, ''), 'tous': (0, '')}
    for d in deals:
        # une entree vente ouvre une vente ; une sortie de type achat ferme une vente
        cote = d['type'] if d['sens'] == 'in' else ('sell' if d['type'] == 'buy' else 'buy')
        if d['sens'] == 'in':
            if ouvert[cote] < 1e-9:
                en_cours[cote] = {'cote': cote, 'debut': d['heure'], 'fin': '', 'max': 0,
                                  'entrees': 0, 'net': 0.0, 'jeux': collections.Counter()}
            ouvert[cote] += d['volume']
            p = en_cours[cote]
            p['entrees'] += 1
            p['jeux'][d['commentaire'][:20]] += 1
            n = round(ouvert[cote] / lot)
            p['max'] = max(p['max'], n)
            if n > pic[cote][0]:
                pic[cote] = (n, d['heure'])
            tous = round((ouvert['sell'] + ouvert['buy']) / lot)
            if tous > pic['tous'][0]:
                pic['tous'] = (tous, d['heure'])
        else:
            ouvert[cote] = max(0.0, ouvert[cote] - d['volume'])
            if cote in en_cours:
                en_cours[cote]['net'] += d['net']
                if ouvert[cote] < 1e-9:
                    en_cours[cote]['fin'] = d['heure']
                    paquets.append(en_cours.pop(cote))
    for p in en_cours.values():
        p['fin'] = '(encore ouvert en fin de test)'
        paquets.append(p)
    return lot, pic, paquets


def tranche(n):
    for borne, nom in ((1, '1'), (3, '2 a 3'), (6, '4 a 6'), (10, '7 a 10'), (20, '11 a 20')):
        if n <= borne:
            return nom
    return 'plus de 20'


def main():
    a = argparse.ArgumentParser()
    a.add_argument('rapport')
    a.add_argument('--symbole', default='')
    a.add_argument('--jour', nargs='*', default=[])
    o = a.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')

    deals = transactions(lire(o.rapport), o.symbole)
    print(f'# Empilement — {o.rapport.replace(chr(92), "/").split("/")[-1]}')
    print()
    if not deals:
        print('AUCUNE TRANSACTION LUE : table introuvable ou format inattendu. Aucun chiffre.')
        return 1
    lot, pic, paquets = compter(deals)
    print(f'Transactions lues : {len(deals)} (du {deals[0]["heure"]} au {deals[-1]["heure"]}), '
          f'lot unitaire vu : {lot:g}. Heures = heure du serveur du testeur.')
    print()
    print('## Positions ouvertes en meme temps (maximum)')
    print()
    print(f'- ventes : **{pic["sell"][0]}** (atteint le {pic["sell"][1]})')
    print(f'- achats : **{pic["buy"][0]}** (atteint le {pic["buy"][1]})')
    print(f'- tous cotes : **{pic["tous"][0]}** (atteint le {pic["tous"][1]})')
    print()
    print('## Paquets, par taille')
    print()
    print('| Positions dans le paquet | Paquets | Gagnants | Resultat cumule | Pire paquet |')
    print('|---|---|---|---|---|')
    groupes = collections.OrderedDict((k, []) for k in
                                      ('1', '2 a 3', '4 a 6', '7 a 10', '11 a 20', 'plus de 20'))
    for p in paquets:
        groupes[tranche(p['max'])].append(p)
    for k, g in groupes.items():
        if g:
            print(f'| {k} | {len(g)} | {sum(p["net"] > 0 for p in g)} | '
                  f'{sum(p["net"] for p in g):+.2f} | {min(p["net"] for p in g):+.2f} |')
    print()

    def table(titre, liste):
        print(f'## {titre}')
        print()
        print('| Cote | Ouvert le | Ferme le | Positions max | Entrees | Resultat | Jeux |')
        print('|---|---|---|---|---|---|---|')
        for p in liste:
            jeux = ', '.join(f'{j or "?"}×{n}' for j, n in p['jeux'].most_common(4))
            print(f'| {p["cote"]} | {p["debut"]} | {p["fin"]} | {p["max"]} | {p["entrees"]} | '
                  f'{p["net"]:+.2f} | {jeux} |')
        print()

    table('Les 10 plus gros paquets', sorted(paquets, key=lambda p: -p['max'])[:10])
    table('Les 10 pires paquets', sorted(paquets, key=lambda p: p['net'])[:10])
    for jour in o.jour:
        table(f'Paquets ouverts le {jour}', [p for p in paquets if p['debut'].startswith(jour)])
    print('> Comptes tires de ce seul rapport. Le resultat net global reste celui de `mesure.py`.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
