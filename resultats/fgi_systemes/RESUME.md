# Forex GOLD Investor : les trois systèmes séparés (25/09/2026)

Chantier 2 de `ETAT.md`. Reconstruire, pas acheter (consigne du 22/09). Plan validé par Denis le 25/09
à 08h11 (Paris) : S3, puis S2, puis S1, seuil de fidélité 90 % de trades identiques.

## 1. Réglages lus (démo PU Prime MT5, `reglages_vendeur.set.txt`)

Trois systèmes indépendants, activables séparément (`UseSystem1/2/3`), magics 30001/30002/30003.

| | Stop | Objectif | Particularités |
|---|---|---|---|
| S1 | 1 500 pts (15 $) | 1 300 pts | TurboMode, SecureProfit −250 dès +300 |
| S2 | 1 700 pts (17 $) | 0 (objectif mobile) | 2 ordres au plus, `Add_Lot_Multiplier` 1,0 |
| S3 | 2 200 pts (22 $) | 1 490 pts | aucun autre réglage |

Communs : lot fixe 0,01, LastTradeHour 19 / ExitHour 20 (heure GMT du robot), MaxSpread 40, GMT auto.
**Aucun réglage ne décrit la règle d'entrée.** La notice du vendeur dit : S1 scalping, S2 « selon l'heure »,
S3 cassure.

## 2. Tests de l'original, un système à la fois

`fgi_s1/s2/s3.ini`, XAUUSD.p M15, 2021-01-04 → 2024-12-31, 10 000 $, lot 0,01, modèle 4, par
`lance_chaine.ps1` (journal `chaine_fgi_systemes.log`, 25/09 08h35-08h45 Paris). `mesure.py` : VERIFIE.

| | Deals | Solde final | Net | Creux solde |
|---|---|---|---|---|
| S1 | 2 056 | 10 506 | +506 $ | 0,80 % |
| S2 | 2 108 | 10 753 | +753 $ | 4,13 % |
| S3 | 990 | 11 031 | +1 031 $ | 1,19 % |
| Somme | | | +2 290 $ | |
| Original complet (d02, 20/09) | 5 158 | 12 312 | +2 312 $ | 3,13 % |

Les trois s'additionnent à 22 $ près : les systèmes sont indépendants.

Historique chargé par le testeur (journal de l'agent) : S1 = M5, M15, M30 ; S2 = H1 (+M5) ; S3 = H1.
D1 et M1 sont chargés par les trois (modules communs).

## 3. Corrélation mensuelle avec la jambe or (48 mois, 2021-2024)

| | n121 Eagle-owl v147 | n132 Eagle-owl B2 v147 |
|---|---|---|
| S1 | +0,04 | +0,03 |
| S2 | +0,01 | +0,08 |
| S3 | **+0,41** | **+0,45** |

Entre eux : S1/S2 −0,06, S1/S3 +0,06, S2/S3 −0,03. **S1 et S2 sont les vrais diversifiants ; S3 passe
sous +0,5 mais de peu.**

## 4. Ce qui se lit dans les trades

**S3** (495 trades, 341 achats / 154 ventes) : une seule position à la fois ; entrées à l'heure pile
(321 sur 495), les autres juste après une sortie ; **jamais le lundi** ; sorties : 214 objectif (~15 $),
110 stop (~22 $), 171 par le robot (dont des retournements). Durée médiane 23 h.

**S2** (1 054 trades, **achats seulement**) : premier ordre 0,01 lot (610) ; second ordre toujours
0,02 lot (444), ouvert quand l'or est **~5 $ sous le premier** (médiane 5,11 $) ; sortie du panier
à **~+5 $ au-dessus du prix moyen** ; stop 17 $ par ordre. Entrées concentrées 15h-19h (heure du
courtier), à la seconde 00 (décision à l'ouverture d'une bougie M1).

**S1** : pas encore étudié (dernier dans l'ordre validé).

## 5. La règle d'entrée ne se retrouve pas

| Essai | Résultat |
|---|---|
| S3, cassure d'un canal horaire (N = 3 à 96, marges 0-6 $), cassure du plus haut/bas de la veille (décalages horaires −6 à +6), cassure « fraîche », Bollinger, filtres de tendance | **≤ 31 %** des entrées retrouvées (même heure, même sens) |
| S3, arbre de décision entraîné sur 2021-2022 | 29 % en échantillon, 25 % hors échantillon |
| S2, remontée depuis le plus bas des 30-120 dernières minutes, fenêtres horaires | ≤ 13 % à la minute près |
| S2, modèle statistique souple (gradient boosting) hors échantillon | précision 18 %, rappel 24 % |

Le seuil fixé le 22/09 (`outils/RECONSTRUIRE-OU-NON.md`, Q1) prévoyait ce cas : entrées opaques,
rétro-ingénierie à l'aveugle, on renonce. **Décision demandée à Denis le 25/09 vers 10h30 (Paris)** :
(1) robot maison inspiré de S2 (structure lue, entrée à nous, jugé sur la réserve 2025 et la
corrélation) — recommandé ; (2) continuer la rétro-ingénierie ; (3) arrêter.

## 6. Constat hors chantier : ticks « réels » 2021-2024 sur PU Prime

Le journal de l'agent de test (`Tester\E62C…\Agent-127.0.0.1-3000\logs\20260924.log` et `20260925.log`)
écrit, pour tout test qui couvre 2021-2024 : « real ticks discarded for ~1,2-1,38 M minutes of
~1,41-1,49 M total minute bars, every tick generation used » (XAUUSD.p 1 209 879 / 1 414 401 ;
GBPUSD.p, USDJPY.p, CHFJPY.p, AUDCAD.p… 85-92 %). Pour 2025-2026 : quelques centaines à 2 700 minutes.
**L'en-tête du rapport affiche pourtant « 99 % ticks réels ».** Les mesures 2021-2024 dites en ticks
réels sur PU Prime tournent donc surtout sur des ticks générés depuis les barres M1. Vérifié sur les
journaux des 24 et 25/09 seulement (les plus anciens sont purgés). Signalé au coordinateur.

## Fichiers

- `s1_trades.csv`, `s2_trades.csv`, `s3_trades.csv` : trades appariés (entrée/sortie FIFO, type de sortie).
- `s2_first.csv` : premiers ordres de S2 (hors ordre d'ajout).
- `fgi_s*.ini.txt` : configurations de test (copie UTF-8 des .ini).
- `scripts/` : extraction, appariement, caractéristiques et évaluations.
