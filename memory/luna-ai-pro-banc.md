---
name: luna-ai-pro-banc
description: "Luna AI Pro mesuré sur vrais ticks Dukascopy les 18-19/09/2026 (7 paires MT4) — pas une grille (2 positions max, lot constant), jambe faible et décorrélée en échantillon (0,91 seul), mais RÉSERVE 2025 NÉGATIVE (−40 $/an contre +72 en échantillon, 5 paires sur 7) — CLOS, non admis"
metadata: 
  node_type: memory
  type: project
  originSessionId: d0e7cce4-cea8-47de-9dd2-1ae784bc5f8a
  modified: 2026-09-18T23:31:08.809Z
---

**Produit** : Profalgo, livré avec UBS, MT4 seul (terminal Vantage MT4 F1BBCAAC), scalpeur de NUIT sur bandes de Bollinger, fenêtre 23:00-01:00
(GMT+2/DST), ordres limites, écart max 1,8 pip, `MaxOpenTrades=99`, 8 paires livrées (EURAUD, EURCAD, EURCHF, GBPCHF, AUDUSD, AUDCAD, EURGBP,
GBPAUD). Manuel lu (6 pages images, PyMuPDF), paramètres livrés lus dans `tester/Luna AI PRO.ini`.

**Banc (18/09 23:12 → 19/09 01:30)** : `lancer_mt4.sh` (un seul chemin), TDS + ticks Dukascopy 2021-2025 téléchargés par lui (Tick Data Manager),
symboles `.s` de sa Market Watch, M5 chaque tick écart variable, qualité 99,90 %, paramètres livrés sauf lot fixe et filtre d'annonces coupé
(pas de calendrier en testeur). Lot exécuté 0,10 (minimum du `.s`) : `_mt4` ramène à 0,01. Outils : `luna_prep.py`, `luna_lire.py`,
`luna_livre.py`. Détail : `TESTS-A-REALISER.md` (18/09 23:12).

**Crible** : jamais plus de 2 positions simultanées, lot constant → PAS une grille, l'éliminatoire ne s'applique pas (la fiche vendeur disait
« moyennage avec progression non géométrique » : faux sur le comportement mesuré).

**Échantillon 2021-2024 (0,01 lot)** : EURAUD +99 $ / creux 14 (1,78), GBPAUD +97 / 65, EURGBP +58 / 35, EURCHF +30 / 7, EURCAD +21 / 25,
AUDCAD −4, GBPCHF −12. Sept paires : +288 $, creux 79 $, rapport 0,91, années +206 / +85 / +49 / **−53** ; 82-97 % gagnants, perte moyenne
5 à 20 fois le gain moyen. Corrélations |r| < 0,07 avec toutes les jambes. Contribution à creux égal : compte propre 13,80 → 14,94, classique
18,17 → 19,58, sans or 10,04 → 10,25, Axi 18,81 → 18,09.

**RÉSERVE 2025 (jamais regardée avant, vrais ticks)** : AUDCAD −1, EURAUD +17 (creux 34, triplé), EURCAD −39, EURCHF −2, EURGBP −20, GBPAUD +26,
GBPCHF −21 → **−40 $ sur l'année, 5 paires sur 7 négatives.** VERDICT : **clos, non admis** — même signature que le dosage réfuté le 08/09
(échantillon brillant, réserve nulle). L'avantage de nuit 2021-2023 n'existe plus en 2024-2025 ; ce n'est pas le mécanisme, c'est le marché.
Le poste « retour à la moyenne à plus gros avantage » reste vacant ; Heron AUDCAD (maison) est ce qui existe.

Voir [[crible-signaux-mql5]], [[retour-moyenne-croisees]] (Heron), [[mt4-lancement-un-seul-chemin]], [[backtest-refute-ne-confirme-pas]].
