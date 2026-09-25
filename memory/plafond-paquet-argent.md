---
name: plafond-paquet-argent
description: Plafond de perte par paquet pour l'argent de Till — 450 $ par 0,01 lot au prix de 64 $ (7 × le prix), accepté par Denis le 24/09/2026
metadata:
  type: project
---

**Accepté par Denis le 24/09/2026 à 18h45 (Paris)** : fermer tout le paquet d'argent quand sa perte atteint
**450 $ par 0,01 lot à 64,44 $** (≈ 7 × le prix de l'argent ; 450 USC au réel cent à 0,01).

**Why:** le paquet réel du 16/09 (12 ventes) est descendu à −632 en cours avant de fermer à −475 ; le
risque est la perte en cours, pas la finale. Rejeu minute par minute de 597 paquets (2021-2024, 2025, 2026,
historique M1 PU Prime `.hcc`, ramené au prix actuel) : 450 est le seul seuil positif sur les trois périodes
(+17 / +54 / +122) avec de la marge ; 300 coupe deux paquets finis gagnants (−868 / −895).

**How to apply:** avant tout retour en réel de l'argent, poser le gardien `gardien/GardienPaquet.mq5` (écrit et
essayé le 24/09 : 6 coupes au testeur, +3/+51/+266 $) sur un second graphique XAGUSD.sc d'Ultima — accord écrit de
Denis exigé. Piège vu au test : à 01h00 serveur le marché est fermé, la fermeture est refusée ; le gardien réessaie
toutes les 2 s jusqu'à fermer. Outil : `outils/plafond_paquet.py` ; détail : `resultats/plafond_paquet_xag/PLAFOND.md`.
Lecteur `.hcc` MT5 inclus (en-tête 228 octets, table de blocs de 18 octets, blocs = 189 octets + barres de 60).
Lié : [[portefeuille-de-reserve]].

**25/09/2026 15h24 (Paris) : POSÉ** sur un second graphique XAGUSD.sc M15 du terminal Ultima de vps-london (accord écrit
de Denis 15h13), journal : plafond du jour 448,72 USC pour 0,01 lot. Les jeux argent restent retirés.
