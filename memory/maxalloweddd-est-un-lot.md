---
name: maxalloweddd-est-un-lot
description: "MaxAllowedDD n'est pas un plafond de creux mais l'entrée de risque du dimensionnement — mêmes 1 816 positions, lots divisés par 3, et le rapport tombe de 3,34 à 2,42"
metadata:
  type: project
---

Mesuré le 03/09/2026, Gold Phantom, XAUUSD.p M15, ticks réels, 10 000 $, 2021-2022.
`MaxAllowedDD` 30 % → 9 %, rien d'autre changé. Détail dans
`forex/outils/RESULTAT-PLAFOND-03-09.md`.

| | net | %/an | creux fonds | rapport | positions | lot moyen |
|---|---|---|---|---|---|---|
| `MaxAllowedDD`=30 | +5 569 $ | 24,9 % | 7,45 % | 3,34 | 1 816 | ~0,032 |
| `MaxAllowedDD`=9 | +1 875 $ | 9,0 % | 3,72 % | 2,42 | 1 816 | 0,0102 |

**Exactement les mêmes 1 816 positions aux mêmes dates.** Le paramètre ne coupe
rien : il divise les lots, ratio 0,315 ≈ 9/30. **Le nom trompe.**

**Ce qu'il coûte** : le rapport perd 28 %. Le profit suit les lots (0,337 contre
0,315) mais **le creux ne tombe qu'à 0,499** — deux fois moins vite. C'est le
levier non linéaire pris à l'envers : réduire les lots n'achète pas de la
tranquillité au prorata. Voir [[levier-et-plafond]].

**Réserve** : à 10 000 $ avec 9 %, 97,7 % des positions sont au lot minimum 0,01.
La passe mesure aussi le plancher du courtier. Refaire à 50 000 $ pour trancher.

**Conséquences pratiques** :
- ne pas utiliser `MaxAllowedDD` pour réduire le risque : il coûte 28 % de rapport
- le vrai plafond quotidien est `PropFirmMaxDailyDD`, paramètre distinct
- le curseur 17 %→46 % de creux de Gold Reaper n'est pas celui-là, c'est
  `MaxTrades` et l'espacement, voir [[profalgo-un-seul-moteur]]

Voir [[ubs-or-ticks-reels]], [[reperes-chiffres-or]].
