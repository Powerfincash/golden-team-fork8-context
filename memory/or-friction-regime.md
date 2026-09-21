---
name: or-friction-regime
description: Le scalping M1 sur l'or n'est devenu possible qu'en 2025 - friction rapportee a l'ATR, timeframe par timeframe et annee par annee
metadata:
  type: reference
---

Mesure du 01/09/2026, lue en lecture seule dans le terminal PU Prime (paquet Python
`MetaTrader5`), XAUUSD.p, point = 0,01. Ecart live releve ce jour : **16 points**
(et non 12 comme note le 28/08 — il varie). Friction retenue **23 points** aller-retour,
spread + commission. `stops_level` 20 points.

## ATR median par timeframe, fenetre commune (depuis 2026-06)

| TF | M1 | M5 | M15 | M30 | H1 | H4 |
|---|---|---|---|---|---|---|
| ATR14 median, points | 179 | 434 | 797 | 1172 | 1729 | 3682 |

L'echelle est coherente (x2,4 puis x1,8 puis x1,5) — **verifier toujours ce ratio** :
un premier calcul donnait 439/474/516/569, plat, parce que chaque timeframe couvrait
une **epoque differente** (le terminal garde peu de M1, beaucoup de H4). Comparer des
timeframes exige une fenetre commune, sinon on compare des niveaux de prix.

## Friction en % de l'ATR, par annee (seuil sain <= 4 %)

| annee | or $ | M1 | M5 | M15 | M30 | H1 | H4 | TF minimal sain |
|---|---|---|---|---|---|---|---|---|
| 2018 | 1239 | 117% | 48% | 26% | 18% | 12% | 6% | aucun |
| 2019 | 1406 | 103% | 42% | 23% | 16% | 11% | 5% | aucun |
| 2020 | 1774 | 47% | 19% | 11% | 7% | 5% | 2% | H4 |
| 2021 | 1794 | 63% | 26% | 14% | 10% | 7% | 3% | H4 |
| 2022 | 1805 | 57% | 24% | 13% | 9% | 6% | 3% | H4 |
| 2023 | 1945 | 67% | 27% | 15% | 10% | 7% | 3% | H4 |
| 2024 | 2381 | 46% | 19% | 10% | 7% | 5% | 2% | H4 |
| 2025 | 3345 | 24% | 10% | 5% | 4% | 2% | 1% | M30 |
| 2026 | 4568 | 12% | 5% | 3% | 2% | 1% | 1% | M15 |

**Why:** la friction est **fixe en points**, l'ATR suit le niveau du prix. L'or est passe
de 1 239 $ a 4 568 $ et son ATR H1 a ete multiplie par **9,6** (190 -> 1819 points). Donc
un scalpeur or M1 calibre en 2026 travaille dans le seul regime ou le M1 or a jamais ete
praticable. Hors de 2025-2026 il est structurellement mort, sans que sa logique soit en cause.

**How to apply:**
1. Sur l'or, **aucun parametre en points fixes ne se transpose d'une epoque a l'autre**.
   Toute reconstruction doit exprimer ecart, SL, TP et trailing en **multiples d'ATR**,
   sinon les fenetres hors-echantillon ne testent pas la meme strategie.
2. Un EA or dont le magic number ou la date de compilation est recente et qui travaille
   en M1/M5 doit etre suspecte d'etre cale sur le regime 2025-2026.
3. Verifier si [[ea-commerciaux-or]] Gold Phantom raisonne en points fixes : valide sur
   2021-2026, il couvre des ratios de friction allant de 63 % a 12 % selon l'annee — sa
   performance recente est possiblement flattee par la volatilite de 2025-2026.

*Limites :* les colonnes M1 a M30 des annees passees sont **extrapolees** du ratio
intraday/H1 mesure sur la fenetre recente ; seul le H1 est mesure directement chaque annee.
La direction est certaine, les pourcentages sous-H1 des vieilles annees sont des estimations.
Les ecarts courtiers etaient probablement **plus larges** avant, donc le passe est plutot
pire que montre. Voir [[trading-friction-timeframe]] et [[reperes-m15-puprime]].
