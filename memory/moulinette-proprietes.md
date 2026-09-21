---
name: moulinette-proprietes
description: Le processus de generation de strategies maison, modelise le 04/09/2026 - une propriete par heure, mesuree en Python, verdict par regles fixees ; etat du catalogue
metadata:
  type: project
---

Son mot : « le processus de moulinette ». Reponse a « comment generer nous-memes des strategies plutot
que reconstruire celles des tiers » : on genere des PROPRIETES (une phrase mesurable), on les mesure en
Python sur les barres (`forex/outils/moulinette.py`), en unites d'ATR, en echantillon 2010-2023 (ou
2021-2023 pour M5/M30) et en reserve 2024, sur or + EURUSD + USDJPY, avec l'inconditionnel a cote.
Verdict par regles ecrites AVANT : GARDEE (or : t >= 3, >= 70 % des annees, reserve de meme signe, ajoute
a l'inconditionnel), CANDIDATE (t >= 2, reserve de meme signe), TUEE. Ce qui survit devient un module
d'entree du moteur multi-jeux, qui fournit sorties, echelle ATR, filtres, lots.

**Etat du catalogue** (`CATALOGUE-PROPRIETES.md`) : P1 continuation apres cassure D1 (tuee), P2 contact
d'un niveau prononce H1 (tuee : reserve inversee), P3 bougie M5 de volatilite (tuee), P4 volume tick
(non mesurable, a reformuler), P6 heure 01 h (tuee : artefact d'ecart a la cloture), **P7 l'or le vendredi
(CANDIDATE : +0,37 ATR, t 2,5, 12/14 annees, reserve 2024 +0,61)**, P7b lundi (candidate faible).
Autocorrelation horaire : nulle. Enseignement : l'avantage de la cassure Profalgo n'est pas dans la
direction du prix a 24 h ; il est dans l'execution (entree avant le niveau, gestion) → P8, P9 a mesurer.

**How to apply:** une propriete par seance, formulee avant d'etre mesuree ; ne jamais ajuster une
definition jusqu'a ce qu'elle passe ; verifier le profil minute par minute pour toute case horaire.
Voir [[moteur-multi-jeux]], [[backtest-acceptance-criteria]], [[garde-fous-mesure]].

**Decision du 04/09 ~14h10 : agent autonome pour alimenter la moulinette — « on met cela en route
quand possible », c'est-a-dire APRES la validation du moteur multi-jeux.** Montage convenu : tache
planifiee la nuit ; l'agent FORMULE seulement (jamais n'ajuste, jamais ne juge) ; lot de 10 proprietes
pre-enregistrees et figees avant la mesure, seuil t >= 3,5 pour un lot de 10, reserve 2024 intouchable,
verdict par les regles de `moulinette.py`, rien ne passe a l'etape EA sans lui ; resume de 3 lignes le
matin. File de sources, dans l'ordre : CodeBase MQL5 (code source ouvert → regle exacte) filtre par
mots-cles (breakout, session, range, volume, fix, week) ; fiches du Marche avec signal reel (mecanisme
nomme seulement, jamais les chiffres annonces) ; litterature academique. Il approuve la file d'abord.
