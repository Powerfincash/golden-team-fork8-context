---
name: backtest-refute-ne-confirme-pas
description: "Sa remarque du 03/09 — un backtest réfute de façon fiable, il confirme de façon non fiable ; il sert à éliminer, jamais à choisir"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ad015105-f722-4c5f-9697-c4b1c268474a
  modified: 2026-09-03T05:42:09.847Z
---

**« les backtests ne valent pas grand-chose alors ! même à rien à part à
overfitter ! »** — 03/09/2026.

Il a raison sur l'essentiel, et c'est chiffrable.

**Là où le backtest a menti, dans le sens flatteur les deux fois :**

| | backtest | réel |
|---|---|---|
| facteur de profit de Gold Phantom | 1,75 | **1,32** (459 transactions live) |
| creux | 19,75 % sur 17 ans | ses autres robots or, en réel : **32 à 60 %** |

**Là où il a tranché gratuitement, en une nuit :** Xuepro (99,98 % de creux,
compte détruit), EA Hamster (66,75 %), QuantGoldMaster (PF 0,54), SMC_FVG
(−88,5 %), l'EA maison (50 trades sur 9 753 portaient 73 % du résultat), Wolf
hors EURUSD (négatif sur 5 paires), le DAX ajouté à Revert Edge (aucun apport).

**La règle : un backtest RÉFUTE de façon fiable, il CONFIRME de façon non
fiable.** Asymétrie, pas inutilité.

**Deux conséquences opérationnelles :**
1. Le backtest ne sert qu'à **éliminer**, jamais à choisir. Un bon résultat n'est
   pas une raison d'acheter ; un mauvais est une raison définitive de ne pas.
2. Ce qui survit ne se départage que par du **réel** — signal live, ou location
   d'un mois avec prédiction écrite d'avance ([[essai-en-avant]] /
   `ESSAI-EN-AVANT.md`).

**Le corollaire :** 459 transactions en argent réel valent mieux que 27 000
simulées. Le signal live dit ce que le testeur ne sait pas reproduire — écart
réel, remplissages, glissement, et l'impossibilité pour le concepteur de revenir
changer un paramètre.

Détail dans `forex/outils/BACKTEST-CE-QUIL-VAUT.md`.
Voir [[pas-de-formule-de-portefeuille]], [[backtest-acceptance-criteria]].
