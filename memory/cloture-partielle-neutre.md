---
name: cloture-partielle-neutre
description: La cloture partielle a 1 R ne change pas l esperance, elle redistribue les resultats ; formule, seuils, et pourquoi il l a choisie quand meme le 05/09/2026
metadata:
  type: reference
---

Choix de l'utilisateur le 05/09/2026 (« cloture partielle OUI ») : fermer 50 % a 1 R, laisser le stop
initial, viser 2 R avec le reste. Decide apres un plan SMC H1/M5/M1 (biais H1, BOS M5, pullback M1,
Fibonacci discount/premium) qu'il m'a soumis pour avis.

**Ce que la partielle fait.** Esperance par trade = **-1 + q + 1,5 p**, avec q la part des trades qui
touchent 1 R avant le stop et p la part qui touchent 2 R avant le stop. Marche aleatoire : q = 50 %,
p = 33,3 %, esperance 0 — exactement comme sans partielle. Elle ne cree pas d'avantage, elle
change la distribution : plus de trades a 0, gain maximal 1,5 R au lieu de 2 R, meme esperance.
Ce qu'elle evite : le stop a l'entree qui ferme a zero des trades allant au but
([[smc-structural-elimine]], constat 1 : 1,13 R realise pour 3 R vises).

**Seuils fixes d'avance** pour le journal Powerfin : q > 50 % et **p > 36,7 %** (= +0,10 R par trade
a 2 R, [[reperes-m15-puprime]]). Lecture a 50 trades, conclusion a 300 ([[backtest-acceptance-criteria]]).

**Ce que je lui ai dit du plan SMC** : le cadre de gestion est propre (sessions, 3 trades/jour,
-2 %/jour, 1 % par trade) mais rien n'y prouve l'avantage de l'entree ; deux mecanisations SMC sont
deja mortes ([[smc-fvg-elimine]] -88,5 %, [[smc-structural-elimine]] -0,04 R) ; le stop M1 de 5 pips
sur EURUSD laisse 7 % du risque aux frais ; GBPJPY n'a jamais ete mesure chez PU Prime.

**How to apply:** ne jamais presenter la partielle comme « mathematiquement superieure » ; c'est une
regle de confort qui protege la geometrie, pas une source de rendement. Juger l'entree sur q et p.
