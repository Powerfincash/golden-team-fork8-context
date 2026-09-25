---
name: fgi-reconstruction
description: Forex GOLD Investor (FXAutomater) — 3 systèmes séparés le 25/09, sorties lisibles, entrées introuvables ; décision de Denis attendue
metadata:
  type: project
---

**25/09/2026.** Forex GOLD Investor = trois systèmes indépendants (magics 30001-30003, `UseSystem1/2/3`).
Testés un par un sur 2021-2024 (PU Prime, `fgi_s1/2/3.ini`) : S1 +506 $, S2 +753 $, S3 +1 031 $ ;
somme = original à 22 $ près. Corrélation mensuelle à la jambe or (n121/n132 v147) : S1 ≈ 0,04,
S2 ≈ 0,01-0,08, S3 0,41-0,45. S1 et S2 sont les diversifiants.

Lisible : S2 achète seulement, 0,01 puis 0,02 quand l'or est ~5 $ plus bas, panier fermé à ~+5 $ du
prix moyen, stop 17 $, entrées 15h-19h courtier. S3 : une position à la fois, H1, jamais le lundi,
objectif 15 $ / stop 22 $.

Illisible : le déclencheur d'entrée (≤ 31 % retrouvés pour S3, ≤ 20 % pour S2 même avec un modèle
souple). Seuil Q1 du 22/09 (`outils/RECONSTRUIRE-OU-NON.md`) : entrées opaques → on renonce au clone.

**Why:** reconstruire pour être jouable en algo chez Axi Select ; un clone infidèle ne se contrôle pas.
**How to apply:** ne pas relancer la rétro-ingénierie sans décision de Denis ; option recommandée =
robot maison inspiré de S2 jugé sur ses propres critères [[portefeuille-de-reserve]] [[ecarts-rentables-a-garder]].
Détail : `resultats/fgi_systemes/RESUME.md`. Constat annexe : ticks 2021-2024 PU Prime surtout générés
malgré « 99 % ticks réels » dans le rapport (même fichier, section 6).

**25/09 fin de matinée** : option 1 choisie ; simulée sur M1 2021-2024, la gestion de S2 avec des entrées simples
(15h30, quart d'heure, cassure M15) donne ≈ 0 moins frais, comme une entrée au hasard (+134 $). L'avantage est dans
l'entrée. Achat seul = flatté par la hausse 2025-2026 : réserve positive non probante.
