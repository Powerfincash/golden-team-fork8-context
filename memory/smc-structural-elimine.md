---
name: smc-structural-elimine
description: "SMC_Structural_H1M15_Institutional elimine le 28/08/2026, et les deux constats transferables qu'il a produits"
metadata: 
  node_type: memory
  type: project
  originSessionId: 0a08b05d-baec-41f7-85b6-be56c9dc701d
  modified: 2026-08-28T17:57:55.609Z
---

**Elimine le 28/08/2026**, meme journee que [[smc-fvg-elimine]]. Deux EA SMC mesures,
deux ecartes. Source et rapports dans `MQL5\Experts\_revue_tmp` du terminal PU Prime
(`smc512_oos.htm`, `smc512_noexit.htm`, `smc512_grid.xml`).

**La mesure qui tranche.** XAUUSD.p, M15, ticks reels, 2021.10 -> 2024.12 (fenetre qui
n'a PAS servi a choisir les reglages), depot 10 000 USD.

| | gestion active | sorties coupees |
|---|---:|---:|
| trades | 587 | 451 |
| esperance | **−0,06 R** | **−0,04 R** |
| facteur de profit | 0,88 | 0,95 |
| rapport gain/perte realise | 1,35 | 3,05 |
| gagnants | 39,9 % | 24,0 % |

Le seuil est +0,10 R. Negatif trois annees sur quatre (seule 2022 positive, de 152 USD).
**Ne pas reprendre, ne pas en tester une variante de reglage.**

## Constat 1 — un breakeven a 1,5 R avec un TP a 3 R detruit la geometrie

Le gain moyen realise etait de **1,13 R au lieu des 3 R vises**, la perte moyenne de
0,84 R au lieu de 1 R. Le BE refermait a zero des trades qui allaient au TP, tout en
n'adoucissant les pertes que de 16 %. Sorties debranchees, le rapport remonte a **3,05**,
soit exactement la geometrie voulue.

**A transferer vers [[lazyalgo-multistrategy-state]]**, ou le BE portait 63 % du resultat :
le meme mecanisme peut donc jouer dans les deux sens. La question a se poser sur tout EA
a BE : *quel est le rapport gain/perte REALISE, compare a celui que le TP annonce ?*
Un ecart franc signale que la gestion mange la geometrie. Le chiffre se lit directement
dans le rapport MT5 (« Moyenne position gagnante » / « Moyenne position perdante »).

## Constat 2 — le balayage de liquidite asiatique ne se declenche pas assez sur l'or

Grille de 24 combinaisons sur 2025, lue **en frequence uniquement** :

- sweep asiatique **actif** : 3 a 19 trades/an, quoi qu'on relache par ailleurs ;
- sweep **coupe** : 46 a 309 trades/an.

Un facteur 15, qui ecrase les trois autres leviers (volume, ADX, sessions) reunis.
**Meme au maximum de relachement, le sweep plafonne a ~19 trades/an**, soit ~95 sur cinq
ans contre les 300 exiges. La condition ne se produit pas assez souvent sur XAUUSD : ce
n'est pas un probleme de reglage. Garder le sweep imposerait de le redefinir (autre poche
de liquidite, autre fenetre), pas de l'assouplir.

Consequence : atteindre la frequence obligeait a retirer l'une des deux briques « SMC »
de cet EA. Ce qui restait — order block + deplacement + volume + structure H1 — n'avait
plus grand-chose de specifiquement SMC.

## Ce que la friction confirme une fois de plus

A rapport 3,05, le seuil de rentabilite est 24,7 % de gagnants ; il y en a 23,95 %.
Il manque **0,75 point**, et les commissions pesent ~1 020 USD sur les 1 770 de perte.
Les entrees sont a un cheveu du hasard et ce sont les frais qui font le signe — la
signature exacte decrite dans [[trading-friction-timeframe]] : la performance predite
par le cout, jamais par la logique du signal.

Voir [[backtest-acceptance-criteria]] et [[mt5-pieges-outillage]].
