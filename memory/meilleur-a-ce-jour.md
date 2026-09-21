---
name: meilleur-a-ce-jour
description: Le meilleur resultat verifie et exploitable a ce jour (Gold Phantom ticks reels), et ou est le rapport qui le garde
metadata:
  type: project
---

Fixe avec lui le 04/09/2026, garde dans `forex/outils/MEILLEUR-A-CE-JOUR.md` (git).

**Gold Phantom, ticks reels, 2021 a mi-2026 : 41,6 %/an pour 5,23 % de creux de fonds**
(`gp_ticks.htm`, 4 625 transactions, PF 2,12). Il ne le possede PAS (demo seulement, corrige le 05/09) ; insensible au modele de prix,
tient hors echantillon. A levier x3 sous plafond de concentration, apres les deux corrections
(importe flatte de 27 % ; creux de fonds = 1,7 x creux de solde) : **75-80 %/an pour 22-25 %
de creux vecu**.

**MIS A JOUR 04/09 09h40** : le test de regime 2021-2024 est termine et verifie (C1-C4, creux de fonds
reconstruit 17,13 % = MT5 17,01 %). **Gold Reaper (reglage du signal) prend les deux places** :
83,4 %/an pour 12,49 % de creux de solde et 17,13 % de fonds (rapport 6,68 / 4,87), contre Phantom
36,6 %/an, 6,98 % / 8,13 % (5,24 / 4,50) sur la meme fenetre. Reaper fait +39 % en 2021 (or -3,6 %)
et +44 % en 2022 (or -0,3 %) : plancher ~40 %/an en or plat, rendement croissant avec la tendance.
En reel (correction -37 % mesuree sur le signal) : ~55 %/an pour 12,5 % / 17 % de creux.

**How to apply:** c'est la barre. Ne le remplacer que par un resultat VERIFIE (reel ou ticks
reels + hors echantillon), jamais par un backtest seul. Candidat en attente : signal Gold
Reaper (111 %/16,9 % en reel) selon le test de regime 2021-2024. Voir [[reperes-chiffres-or]],
[[levier-et-plafond]], [[ea-commerciaux-or]].


## Etat au 08/09/2026 (soir) — apres Eagle-owl et Heron

Recalculable par `python outils/etat_portefeuilles.py`. Marge de securite 50 % partout.

| compte | rapport | mensuel corrige | mois neg. | capital mini | instances |
|---|---|---|---|---|---|
| **1. Compte propre** | **17,38** | +9,71 % | 5/48 | **1 149 $** | 29 |
| 3. Prop firm classique | 16,36 | +4,32 % | **2/48** | 7 181 $ | 30 |
| 2. Axi Select (maison) | 12,49 | +2,68 % | 5/48 | 10 811 $ | 18 |
| 4. Zebra seul | 7,57 | +1,91 % | 10/48 | **359 $** | 3 |

**Trois briques nouvelles dans la journee** : [[moteur-multi-jeux]] Eagle-owl valide (5 criteres sur 5),
et Heron (retour a la moyenne maison sur AUDCAD et NZDCAD, voir [[retour-moyenne-croisees]]).

**Zebra seul reste le seul point d'entree** pour un premier compte reel : 359 $, trois instances.
