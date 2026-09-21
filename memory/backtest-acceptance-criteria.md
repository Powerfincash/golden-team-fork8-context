---
name: backtest-acceptance-criteria
description: "Critères d'acceptation convenus pour valider une stratégie de trading avant de la retenir"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 907ca3d0-8f0e-456d-b240-59d0b83576d3
  modified: 2026-08-21T19:30:26.917Z
---

Critères fixés d'avance avec l'utilisateur le 21/08/2026, à appliquer avant de retenir
toute stratégie : **≥ 300 trades**, espérance **≥ +0,10 R** après frais réels, résultat
tenant **hors échantillon** (2026.07–08 gardés de côté), forme en **plateau** de réglages
voisins et non en pic isolé, et fonctionnement sur **au moins deux instruments**.

Règle d'arrêt convenue : tester quatre ou cinq effets mécaniques, un par session, chacun
tué ou gardé. Si aucun ne franchit les critères, arrêter l'approche au lieu de proposer
une variante de plus.

**Why:** l'utilisateur avait « tout essayé » sans succès — démarche qui fabrique des faux
positifs si l'on teste jusqu'à ce qu'une configuration passe. Une seule journée a produit
deux constats spectaculaires qui se sont inversés en élargissant l'échantillon (un mois
→ 18 mois), et une stratégie apparemment rentable sur 78 trades s'est révélée devoir 82 %
de son profit à une seule année.

**How to apply:** annoncer ces seuils avant de lancer une mesure, les tenir même quand un
résultat est encourageant, et regarder **la fréquence avant le P&L**. Ne jamais ajuster un
paramètre jusqu'à ce qu'un résultat colle. Voir aussi [[trading-friction-timeframe]] et
[[lazyalgo-multistrategy-state]].
