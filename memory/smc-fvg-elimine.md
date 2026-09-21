---
name: smc-fvg-elimine
description: "EA SMC_FVG_MultiAsset_Elite v9 elimine le 28/08/2026 sur les criteres du 21/08, et les contraintes courtier PU Prime decouvertes au passage"
metadata: 
  node_type: memory
  type: project
  originSessionId: e4b07d73-95a2-4c19-8053-ed964ea15772
  modified: 2026-08-28T17:59:50.140Z
---

**Elimine le 28/08/2026.** L'EA `SMC_FVG_MultiAsset_Elite_v9` (SMC / Fair Value Gaps,
M1, panier multi-actifs) ne franchit pas les criteres du 21/08. Ne pas le reprendre,
ne pas en tester une variante de reglage.

**La mesure qui tranche :** XAUUSD.p, 2021.01 -> 2025.12, ticks reels PU Prime, depot
10 000 USD, filtre d'annonces coupe, 2026 garde hors echantillon.
**962 trades** (seuil de 300 largement franchi) pour un solde final de **1 152,64 USD**,
soit **-88,5 %**. Esperance derivee **≈ -0,22 R par trade** (`1152,64 = 10000 x
Π(1+0,01·Ri)` donne `ΣRi ≈ -216`), contre le critere de +0,10 R.

**Rapport MT5 complet (passe rejouee, resultat identique au dollar pres) :**
`facteur de profit 0,70`, `esperance -8,73 USD/trade`, `chute maximale 88,78 %`,
`Sharpe -5,00`, **1 013 positions**, 32,9 % de gagnantes, gain moyen 63,38 pour perte
moyenne -39,41, jusqu'a **21 pertes consecutives**. Duree de tenue : mini 1 seconde,
moyenne **4 min 23 s**, maxi 39 min.
**Le chiffre le plus parlant : correlation LR = -0,95.** La courbe d'equite descend en
ligne quasi droite — ce n'est pas un episode ni un regime defavorable, c'est une
erosion constante sur cinq ans. Aucun reglage ne redresse ca.

*Piege de lecture :* le rapport affiche « Qualite de l'Historique : 99 % ticks reel »
alors que le journal du testeur signale 68 % des barres M1 en ticks regeneres. **Les
deux metriques ne mesurent pas la meme chose** ; c'est le journal qui dit la verite sur
la couverture reelle. Ne pas se fier au 99 % du rapport.

**Trois faits structurels, pas des reglages :**
- **R2 jamais atteint, zero fois sur 962 trades** (101 ecretages a 1R). La sortie
  echelonnee est batie sur un niveau que le marche ne donne jamais.
- **Trailing inoperant a 92 %** : 7 133 modifications de SL sautees contre 640
  appliquees — la structure M1 visee est presque toujours plus proche du marche
  que le minimum negociable.
- **Entonnoir a 0,57 %** : 167 521 FVG detectes pour 962 ordres. Le detecteur ne
  detecte rien d'utile, ce sont les filtres qui font tout.

**Contraintes courtier decouvertes, valables au-dela de cet EA :**
- **`SYMBOL_TRADE_STOPS_LEVEL` = 20 points sur EURUSD chez PU Prime.** Les stops
  structurels M1 de cet EA faisaient 9 a 18 points : **aucun ordre ne passait**.
  Tout EA a stop serre sur EURUSD chez eux se heurtera a ce mur. Sur XAUUSD.p le
  plancher ne mord presque pas.
  *Precision mesuree le 28/08/2026 au soir :* ce 20 est lu sur `EURUSD`, symbole
  **non cotable** (spread 0). Sur **`EURUSD.p`**, le symbole reellement negocie,
  `stops_level` vaut **0**. Le mur reste vrai pour des stops M1 de 9 a 18 points,
  mais **ce n'est pas un plancher a 20 points sur le symbole traite** : ne pas
  ecarter un EA sur ce seul motif sans avoir relu la valeur sur le `.p`.
  Voir [[reperes-m15-puprime]].
- **`XAUUSD.p` exige `XAUUSD.crp`** (symbole de conversion interne PU Prime) pour le
  calcul de marge. Sans son historique de ticks, le testeur meurt au premier ordre
  au marche avec `no prices for symbol XAUUSD.crp`. Prevoir ~950 Mo en plus.
- **Qualite des ticks PU Prime mediocre** : sur 2021-2025, **68 % des barres M1 de
  XAUUSD.p ont vu leurs ticks reels rejetes** (77 % pour XAUUSD.crp) faute de
  concordance avec leur propre historique M1. Une passe « ticks reels » n'y est
  reellement en ticks reels que sur un tiers de la periode.

**Piege d'outillage, a ne pas refaire :** `terminal64.exe` lance depuis l'outil Bash
ne survit pas a la fin de l'appel — trois passes longues tuees en silence, sans
erreur au journal. Il faut le detacher (`cmd start` ou `Start-Process`). **Signature
d'une passe tuee : absence des lignes `Test passed` et `final balance`**, alors qu'une
passe tronquee affiche quand meme des trades. J'ai d'abord impute ces coupures a la
contention entre sessions : c'etait faux.

Voir [[backtest-acceptance-criteria]], [[trading-friction-timeframe]],
[[sauvegarde-code]] et [[garde-fous-mesure]].
