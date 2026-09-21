---
name: quatre-standards-corriges-10-09
description: Les quatre standards recalcules le 10/09 avec le rapport hors tirage — le compte propre passe de 17,38 (surevalue) a 13,80
metadata:
  type: project
---

Suite de [[bruit-delai-aleatoire]] et [[banc-mesure-ultima]] : `etat_portefeuilles.py` optimise
desormais sur la MOYENNE de trois tirages (TIRAGES_AJUST) et publie le rapport evalue sur trois
tirages neufs jamais vus par l'optimiseur (TIRAGES_EVAL). C'est ce second chiffre, « hors tirage »,
qu'il faut citer — pas le rapport optimise, qui reste gonfle par construction.

**Les quatre standards, 10/09/2026** (`outils/QUATRE-STANDARDS-10-09.txt`) :

| compte | rapport hors tirage | dosage retenu |
|---|---|---|
| 1. Compte propre | **13,80** | UBS or ×1 · UBS hors or ×1 · AdvSc JPY ×25 · Zebra or ×12 · Zebra GBP ×40 · Zebra EUR ×20 · Heron AUDCAD ×2 |
| 2. Axi Select (maison) | **10,32** | Eagle-owl ×1 · Zebra or ×12 · Zebra GBP ×60 · Zebra EUR ×20 · Heron AUDCAD ×2 · Heron NZDCAD ×2 |
| 3. Prop firm classique | **12,87** | UBS or ×1 · UBS hors or ×2 · AdvSc JPY ×20 · Zebra or ×8 · Zebra GBP ×40 · Zebra EUR ×40 · Heron AUDCAD ×2 · Heron NZDCAD ×2 |
| 4. Zebra seul | **6,37** | Zebra or ×30 · Zebra GBP ×80 · Zebra EUR ×100 |

Le compte propre était annoncé 17,38 le 07-09/09 ; c'était le rapport optimisé sur un seul tirage,
surévalué d'environ 21 %. Zebra reste dans le portefeuille — voir [[zebra-couplage-pivots]] pour la
mesure de sa contribution (11,6 hors tirage contre 8,41 sans lui).

**Zebra seul** reste construit sur un dosage unique, sans moyenne possible faute d'autre source à
mélanger : c'est le standard le plus sensible au bruit résiduel.

Remplace les chiffres de [[quatre-standards]] (07/09) pour toute citation future.
