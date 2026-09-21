---
name: clone-wolf-or-gbpusd
description: Découverte du 06/09 — le clone Wolf maison fonctionne sur l'or (rapport 4,29, décorrélé d'UBS à +0,16) et apporte +20 % sur GBPUSD ; rien sur USDJPY
metadata:
  type: project
---

**Le clone MQL5 de Wolf, validé à 1,5 % près sur EURUSD** ([[wolf-scalper-projet]]), a été porté sur
d'autres marchés avec les paramètres transposés par volatilité. **Tous les chiffres ci-dessous incluent
un délai d'exécution aléatoire**, donc la version défavorable.

| marché | transactions | net | PF | rapport annuel |
|---|---|---|---|---|
| **OR** (stop 725, suivi 36, profondeur 12) | 598 | +351 $ | **3,23** | **4,28** |
| GBPUSD (stop 264, suivi 13) | 755 | +39 $ | 1,31 | 0,51 |
| USDJPY (stop 296, suivi 15) | 670 | +29 $ | 1,30 | 0,36 |

**L'or est la découverte.** Un seul jeu maison fait aussi bien que les 14 jeux or d'UBS réunis (4,29
contre 4,33) et **ne corrèle avec eux qu'à +0,16** alors qu'ils tradent le même métal, sur le même
courtier, sur les mêmes 4 ans. **Ce qui décorrèle, c'est le MÉCANISME, pas le marché** — UBS casse des
niveaux avec des stops larges, le clone suit des pivots de ZigZag avec un stop très serré.

**Validation** : 2021-2022 PF 3,81 ; 2023-2024 PF 1,99 ; **2025 en réserve véritable PF 2,47** sur 126
transactions. Les trois positives. Réserve : la seconde moitié est deux fois plus faible que la
première.

**Ce qui a rouvert la porte** : sa question du 06/09 sur les jeux adaptés du concepteur. L'or avait été
« définitivement réfuté » le 30/08 avec un stop transposé mais **le suivi laissé à sa valeur d'origine**
— or c'est le suivi qui fait tout le travail. Leçon : quand on transpose par volatilité, transposer
TOUS les paramètres de distance, pas seulement le stop.

**Dosages retenus, validés sur les deux moitiés** : clone or ×8 (+84 % / +47 %), clone GBPUSD ×30
(+25 % / +22 %, remplit un poste vacant où Advanced Scalper donnait 0,28 et Gecko 0,06).
**Clone USDJPY écarté** : +6 % sur une moitié, **−24 %** sur l'autre.

**Portefeuille résultant, 6 briques** : rapport annuel **13,96**, creux 269 $ — INFÉRIEUR à celui de la
jambe or seule (340 $) pour 2,6 fois le rendement. Détail complet dans
`forex/outils/PORTEFEUILLE-06-09-2026.md`.

## Ajout de USDJPY reteste et rejete (07/09/2026)

La note du 06/09 ("+6 % sur une moitie, -24 % sur l'autre") venait de `CloneWolf_v2` (n74), une version
anterieure a `Zebra_v1`. Reteste avec `n95_jpy` (Zebra_v1 actuel, 2021-2024) : les deux moities sont
POSITIVES (rapport 3,53 puis 0,81), corr avec or/GBP/EUR = 0,08-0,13, et l'ajout ameliore meme le
rapport prop firm de +4 % (7,42 -> 7,73).

**Teste ensuite sur 2025, reserve jamais touchee (n102_jpy_reserve2025)** : net **-10 $**, rapport
**-0,86**. La reserve refute. Le gain de 2021-2024 etait un ajustement a l'echantillon, pas un edge reel.

**USDJPY reste exclu**, decision confirmee par une methode differente de celle qui l'avait exclu la
premiere fois — mais la meme conclusion. Le portefeuille Zebra reste a trois briques : or, GBPUSD, EURUSD.
