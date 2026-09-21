---
name: zebra-couplage-pivots
description: "Zebra n'ouvre rien du tout si l'un des deux pivots a été franchi — piste d'amélioration ouverte le 10/09/2026, à mesurer avant toute application"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-10T04:35:38.556Z
---

`ZigZagPortage()` de `Zebra_v1.mq5` se termine par `return(sommet > 0.0 && creux > 0.0)`, et
`OnTick()` fait `if(!ok) return;`. **Conséquence : si un seul des deux pivots a été franchi depuis sa
confirmation, Zebra ne pose AUCUN ordre** — y compris celui de l'autre côté, qui serait valide.

Effet observé en réel le 10/09/2026 : EURUSD muet 15 h pendant que GBPUSD posait 9 ordres. EURUSD
grimpait sans interruption (8/09 12:00 → 9/09 16:00), chaque sommet éligible se faisait dépasser ;
GBPUSD était en range et gardait ses deux pivots.

**Ce n'est pas un défaut, c'est le système mesuré.** Silence médian entre deux poses sur les 5 ans de
`zebra_eurusd` : **19 h**, 55 % des silences dépassent 15 h, maximum 227 h (9,5 jours). Un long
silence est le régime normal, pas un symptôme.

**Découpler a été mesuré le 10/09 et RÉFUTÉ.** `Zebra_v5.mq5` (interrupteur `InpPivotsDecouples`,
`false` par défaut = v1). Comparaison propre sans délai, 2021-2024 : le découplage ajoute 5,6 à 9 %
de transactions qui ne rapportent **rien** (+21 $ sur l'or, +1 $ sur GBPUSD, 0 $ sur EURUSD) et
ajoutent du creux ; le rapport **baisse sur les trois marchés**. L'ordre posé du côté valide pendant
que l'autre pivot est enfoncé est un pile ou face, et un pile ou face coûte l'écart.
**v1 reste la version de production.** Ne pas rouvrir cette piste.

La réserve 2025-2026 n'a **pas** été engagée : on ne dépense une réserve que pour tenter de réfuter
ce qui a l'air bon. Détail : `outils/DECOUPLAGE-PIVOTS-REFUTE.md`. Le témoin de ce test a révélé
[[bruit-delai-aleatoire]], plus important que la question posée. Voir aussi [[banc-mesure-ultima]] et
[[backtest-refute-ne-confirme-pas]].
