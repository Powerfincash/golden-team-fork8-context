---
name: reperes-m15-puprime
description: "Reperes M15 mesures sur EURUSD.p et XAUUSD.p chez PU Prime - ATR, friction, et le seuil de 27,5 % qu'une entree doit franchir"
metadata: 
  node_type: memory
  type: reference
  originSessionId: abe78243-a1cf-47f1-943b-5af3296434e6
  modified: 2026-08-28T16:30:47.955Z
---

Mesures du 28/08/2026, lues directement dans l'historique M15 du terminal PU Prime
(paquet Python `MetaTrader5` branche sur le terminal en cours, lecture seule).
Fenetre disponible : **2022-06 a 2025-12** seulement — le terminal plafonne sa
profondeur de graphique, on n'obtient pas 2021 par cette voie. Heures de session
Londres 07-10 et NY 12-16 GMT, decalage serveur mesure **+3 h**.

| | EURUSD.p | XAUUSD.p |
|---|---|---|
| ATR(14) M15 median | **75,6 points** (7,6 pips) | **301 points** (3,01 USD) |
| SL a 1,5 ATR, median | 113 points | 452 points |
| `stops_level` | **0** | 20 points |
| spread live | 2 points | 12 points |
| friction / risque | **1,8 %** | **2,7 %** |

**Ce que ca corrige.** J'avais estime l'ATR M15 d'EURUSD a 1-2 pips et conclu que la
friction mangeait 15 a 20 % du risque — **faux d'un facteur six**. Un stop a 1,5 ATR
M15 fait 11 pips, pas 2. On est dans le regime M15 de [[trading-friction-timeframe]],
pas dans le regime M1. Et le plancher `stops_level` ne mord sur **aucune** barre des
deux actifs. Ces deux objections ne sont pas des motifs valables pour ecarter un EA
M15 chez ce courtier.

## Le chiffre qui sert de juge : la geometrie R est neutre

Test de premier franchissement sur toutes les barres M15 de session (~25 000 par
actif), sans aucun signal : depuis chaque cloture, le prix atteint-il +N R avant
−1 R, avec R = 1,5 ATR et un horizon de 24 h ?

| cible | EURUSD.p | XAUUSD.p | seuil de rentabilite | requis pour +0,10 R |
|---|---|---|---|---|
| +3 R | 24,2 % long / 23,6 % short | 25,9 % / 23,6 % | **25,0 %** | **27,5 %** |
| +2 R | 33,1 % / 32,8 % | 34,3 % / 32,0 % | 33,3 % | 36,7 % |

**Lecture :** la marche aleatoire donne exactement le seuil de rentabilite. Le choix
du couple TP/SL n'apporte donc **rien** en soi — ni avantage, ni handicap. Tout repose
sur l'entree, et la barre est chiffree : **faire passer le taux de reussite de ~25 %
a 27,5 %**, soit 2,5 points absolus, pour atteindre le +0,10 R de
[[backtest-acceptance-criteria]]. C'est un critere falsifiable a opposer a n'importe
quelle strategie a TP/SL fixes sur ces actifs.

*Limites :* mesure inconditionnelle, elle etablit le point nul, pas la valeur d'un
signal. Faite sur OHLC M15, donc l'ordre intra-barre est inconnu — l'encadrement
pessimiste/optimiste ne s'ecarte que de 0,5 point. Le +2 points du long sur l'or
contre le short est la derive haussiere de 2022-2025, pas un edge.

Voir [[smc-fvg-elimine]] pour la correction du `stops_level`, et
[[lazyalgo-multistrategy-state]].
