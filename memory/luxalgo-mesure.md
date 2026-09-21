---
name: luxalgo-mesure
description: LuxAlgo mesure puis ecarte — six releves du 23/08/2026, et pourquoi filtrer degradait
metadata:
  type: project
---

**LuxAlgo est clos depuis le 23/08/2026.** Six releves M15 sur EURUSD, XAUUSD et GBPJPY,
dans les deux sens, signal `Any Bullish / Bearish Confirmation` filtre par nos quatre
indicateurs. Detail chiffre dans
`MQL5\Experts\LazyAlgo\Reference\MESURES_LuxAlgo_23-08-2026.md`.

| | mesures | t portefeuille |
|---|---|---|
| signal brut | 214 | 0,75 |
| **filtre par le TPI** | 133 | **0,23** |

**Filtrer degradait** : 38 % des signaux jetes pour un t divise par trois. Ce constat
n'apparaissait sur aucun marche pris isolement — il fallait le raisonnement portefeuille
qu'il reclamait depuis le 20/08.

Le TPI a enfin pu etre mesure ce jour-la : le test demande **trois indicateurs sur le
graphique** (LuxAlgo + TPI + le script), impossible avant son passage au plan payant
TradingView. Son intuition — « le TPI filtre les faux signaux » — donne 1,67 sur EURUSD,
0,42 sur l'or, 0,06 sur GBPJPY, et −1,91 sur EURUSD a la vente. Reelle sur un marche,
absente ailleurs.

**Why:** c'etait le dernier fil ouvert du remplacement de LazyAlgo. La reconstruction de
la logique LuxAlgo, envisagee pour se premunir d'une perte d'acces, n'a plus d'objet.

**How to apply:** ne pas rouvrir sans element nouveau — la regle d'arret du 21/08 a joue.
Deux controles a refaire systematiquement ailleurs : **une source `input.source` non
branchee retombe sur le prix de cloture** et laisse tout passer ; **un seuil doit
s'appliquer symetriquement** (+s a l'achat, −s a la vente). Dans les deux cas le symptome
est identique — les chiffres du filtre collent a ceux de la ligne sans filtre. Voir
[[backtest-acceptance-criteria]] et [[trading-friction-timeframe]].
