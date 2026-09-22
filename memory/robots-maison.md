---
name: robots-maison
description: "Les quatre robots maison et leur origine — sa nomenclature du 22/09/2026 : Eagle-owl et Kestrel proviennent de la reproduction d'UBS, Zebra et Heron sont indépendants"
metadata:
  type: project
---

**Quatre robots maison**, et deux origines distinctes. Nomenclature posée par lui le 22/09/2026,
elle fait foi.

**Issus de la reproduction d'UBS :**
- **Eagle-owl** (le grand-duc) — profil de FIDÉLITÉ : il reproduit UBS le plus exactement possible.
  Fidélité globale pondérée par les entrées : 96,5 % au 20/09 (v1.45-v1.47).
- **Kestrel** (la crécerelle) — profil de RENDEMENT : les règles de fidélité à UBS sont
  débranchées, sur l'or comme sur les devises. Créé le 19/09/2026.
  Voir [[kestrel-profil-rendement]] pour la portée exacte des trois réglages, tranchée le 22/09.

**Kestrel n'est PAS hors or — c'est l'inverse** (question posée le 22/09, vérifiée) : l'or est
précisément là où il sert. Son gain le mieux mesuré est l'or SetsB2, rapport 3,74 en échantillon
contre **9,76 en réserve 2025** (+3 460 $), et c'est cette jambe qui porte plus de la moitié du
résultat 2025 du portefeuille autonome A2. Il a été rejoué sur NEUF jambes pour la réserve 2025
(or, argent, CHFJPY, GBPUSD, EUR volatilité, EUR storyG, JPY D1, AdvSc, USO), pas sur l'or seul.

Ce qui est hors or chez Kestrel, et qui explique sans doute la confusion : **sa route vers
l'autonomie**. Aujourd'hui il lit encore les jeux d'UBS (seules 13,4 % de ses entrées en sont
absentes). L'autonomie passe par des jeux composés par nous sur des symboles où UBS n'existe pas
— GBPJPY, EURJPY, AUDUSD, Brent — point 25 de la feuille de route. Ce chantier-là est hors or ;
le robot ne l'est pas.

**Ils sont complémentaires par intention** (ses mots du 22/09) : Eagle-owl garde ce qui est fidèle
à UBS, Kestrel reprend les trades rentables que la reconstruction a dû retirer pour atteindre cette
fidélité. Réserve à lever : le code fait aujourd'hui de Kestrel un SUR-ENSEMBLE d'Eagle-owl et non
son résidu — voir [[kestrel-profil-rendement]].

Techniquement les deux partagent le binaire `EagleOwl_v1.ex5` : Kestrel s'active par trois
paramètres d'entrée, pas par une copie du code. D'où la règle de maintenance — un seul code à
corriger, ce qui est vrai pour l'un l'est pour l'autre. **C'est une précision d'implémentation,
pas la définition** : ce sont bien deux robots.

**Décidé le 22/09, pas encore construit :**
- **Merlin** (l'émerillon) — le **résidu** : uniquement les entrées que les règles de fidélité
  rejettent. Nom choisi par lui. La relation s'écrit **Kestrel = Eagle-owl + Merlin**, aux effets
  d'interaction près. Kestrel n'est ni renommé ni remplacé. Plan : `outils/MERLIN-CHANTIER.md`.
  **Rien n'est codé, et le moteur ne sera pas touché sans son accord.**

**Indépendants — aucun lien avec UBS :**
- **Zebra** — cassure sur pivots, joué sur l'or, GBPUSD et EURUSD.
- **Heron** — sur les croisées AUDCAD et NZDCAD.

Conséquence à garder en tête pour le portefeuille : Eagle-owl et Kestrel partagent la généalogie
d'UBS, donc leur indépendance l'un par rapport à l'autre ne se présume pas — elle se mesure. Zebra
et Heron sont les seules jambes dont l'origine est étrangère à UBS.

Voir [[moteur-multi-jeux]], [[portefeuille-sport-collectif]], [[zebra-couplage-pivots]].
