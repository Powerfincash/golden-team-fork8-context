---
name: bruit-delai-aleatoire
description: "Le délai d'exécution aléatoire du testeur MT5 porte ±24 % sur le rapport rendement/creux — mesuré le 10/09/2026"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-10T05:06:19.185Z
---

Quatre exécutions du **même système** (Zebra_v1, or, 2021-2024, `ExecutionMode=-1`, ticks réels) :
transactions **stables** (598 à chaque fois), net à **±3,7 %** (324 à 349 $), mais creux de **14,82 à
23,50 $** et **rapport de 3,66 à 5,89**. Le délai aléatoire décale les prix de remplissage sans
changer les décisions ; un seul mauvais enchaînement creuse le pire épisode, et le rapport, qui
divise par le creux, hérite de tout.

**Why** : le rapport rendement/creux est la métrique de tout le livre — les quatre standards, le choix
des briques, les dosages. Sur un run unique à délai aléatoire il porte **±24 %** d'incertitude. Deux
des trois résultats du test de découplage tombaient sous ce seuil : les conclure aurait été une faute.
Sans délai (`ExecutionMode=0`) le testeur est **déterministe** — vérifié, deux runs identiques au
chiffre près.

**How to apply** : pour COMPARER deux systèmes, `ExecutionMode=0`. Pour estimer le RÉALISME d'un
système, `ExecutionMode=-1`. Dans cet ordre : comparer sans délai → vérifier le gagnant avec délai →
puis seulement la réserve. Un écart de rapport inférieur à ~25 % entre deux runs uniques à délai
aléatoire **n'est pas un résultat**. Les runs UBS (`n18` et suivants) sont en `ExecutionMode=0` et ne
sont pas concernés ; les runs Zebra sont en `-1` et le sont.

Né du test de découplage des pivots — voir [[zebra-couplage-pivots]],
`outils/DECOUPLAGE-PIVOTS-REFUTE.md`. Le témoin qui échoue a appris plus que la question posée : voir
[[garde-fous-mesure]].
