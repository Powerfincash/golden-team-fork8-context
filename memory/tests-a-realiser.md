---
name: tests-a-realiser
description: "File d'attente des tests ouverte le 12/09 — Range Breakout, Volatility Breakout hors indices, Luna AI Pro, AOT ; le fichier de référence est outils/TESTS-A-REALISER.md"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-12T17:05:51.298Z
---

**Sa consigne du 12/09/2026 : consigner tout ce qui reste à mesurer dans `outils/TESTS-A-REALISER.md`** (commit 6f77915).

Quatre entrées, dans l'ordre : (1) UBS Range Breakout `RANGE_XAUUSD` / `RANGE_USDJPY` — seule logique
d'entrée d'UBS absente du livre ; (2) UBS Volatility Breakout sur or/EURUSD/BTC — famille mesurée seulement
sur indices ; (3) Luna AI Pro — retour à la moyenne, lire son signal réel (fonds vs solde) avant tout
backtest, tester avec stop dur et `MaxOpenTrades=1` ; (4) AOT — trois réserves à lever avant achat.

**Why :** les 44 jeux UBS du live sont déjà Reaper + Goldbot + Goldtrade + S/R + Vol indices ; les 320 autres
jeux du dossier sont surtout le même moteur sur les mêmes symboles. Ce qui manque au livre est le retour à la
moyenne, pas une cassure de plus.

**How to apply :** avant de proposer un nouveau test, lire ce fichier ; un test en sort quand il a un chiffre
`mesure.py` VERIFIE et un verdict à creux égal. Mettre le fichier à jour, pas la mémoire.

Voir [[portefeuille-sport-collectif]], [[a-completer-apres-ubs]], [[banc-mesure-ultima]].

**État au 12/09 soir** : 1 fait (Range or clos, Range USDJPY candidat ×5-×10, insensible au délai, glissement réel à
mesurer sur le banc Ultima) ; 2 retiré ; 7 clos (aucun stop Heron ne passe) ; 5 à moitié (7 jeux vol EURUSD
validés, Daytrade Pro devises sur-trade) ; 6 premier passage non validé (même cause). Restent 3 Luna AI, 4 AOT,
et **le diagnostic du modèle S/R d'Eagle-owl sur devises**, qui débloque 5 et 6 ensemble.
