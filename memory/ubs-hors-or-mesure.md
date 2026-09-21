---
name: ubs-hors-or-mesure
description: Mesure du 06/09 — les 17 jeux hors or et hors indices d'UBS ajoutent +74 % de rendement à creux égal sur la jambe or, mieux que Wolf ; les 13 jeux sur indices détruisent l'apport
metadata:
  type: project
---

**Mesuré le 06/09/2026**, courbes journalières, 2021-2024, ticks réels, lot 0,01 fixe, 1 140 jours.
Rapports `n51` à `n56` (un test par symbole de graphique), outils `mesure.py` + `parjeu.py`.

## Le résultat

| groupe | net | creux | rapport | corr. or | apport à creux égal |
|---|---|---|---|---|---|
| or, 14 jeux (référence) | +5 882 $ | 340 $ | 17,3 | — | — |
| Bitcoin, 7 jeux | +1 357 $ | 133 $ | 10,2 | −0,09 | **+95 %** |
| GBPUSD + CHFJPY, 2 jeux | +788 $ | 175 $ | 4,5 | −0,05 | **+37 %** |
| EURUSD, 8 jeux | +862 $ | 123 $ | 7,0 | −0,03 | **+18 %** |
| DJ30 / NAS100 / SP500, 13 jeux | +1 979 $ | — | — | **+0,33 / +0,17 / 0,00** | **−31 / −23 / −21 %** |
| **les 30 ensemble** | +4 986 $ | 314 $ | 15,9 | +0,17 | **+7 %** |
| **les 17 hors indices** | +3 006 $ | 167 $ | 18,0 | | **+74 %** |

**Prendre les 30 ne donne que +7 %, prendre les 17 en donne +74 %** : les jeux sur indices sont les
seuls corrélés positivement à l'or et annulent l'apport des autres. Illustration chiffrée de
[[portefeuille-sport-collectif]]. Wolf, pour comparaison, donnait +41 %.

## Année par année (or + 17 jeux, ramené au creux de l'or seul)

| | 2021 | 2022 | 2023 | 2024 | total |
|---|---|---|---|---|---|
| or seul | +1 246 / creux 264 | +720 / 238 | +1 936 / 215 | +1 980 / 340 | +5 882 / 340 |
| or + 17 | +2 382 / 340 | +2 068 / **195** | +2 678 / 215 | +3 126 / **199** | **+10 254 / 340** |
| gain | +91 % | +187 % | +38 % | +58 % | **+74 %** |

**Sa remarque validée (06/09)** : la faiblesse des jeux forex en 2024 (EURUSD +255 → +84, les trois
DaytradePro de ~400 $/an à 25 $) ne nuit pas, puisque l'or et le Bitcoin couvrent l'année et que le
creux commun de 2024 tombe de 340 à 199 $. **Mais 87 % de l'apport 2024 vient du Bitcoin seul** : le
résultat repose donc sur sa fiabilité, alors qu'il gagne 24 centimes par transaction sur 5 696
transactions et que le glissement réel du BTC n'est pas dans le testeur. Réserve à lever.

**Indices non condamnés, non mesurables** : PU Prime n'a d'historique DJ30/NAS100/SP500 que depuis 2023,
soit 14 mois. Leur contribution négative est en partie un artefact de fenêtre courte.

## Conséquence pour l'achat

**Il ne possède PAS encore UBS** (version d'essai installée, testeur seulement). Cette mesure est le
premier argument chiffré pour l'offre à 101 $ : ce qu'il achète n'est pas un robot or de plus mais
**17 jeux décorrélés déjà mesurés**. Et elle corrige son choix des 5 EA gratuits : la bibliothèque UBS
contient déjà des dossiers `The_Gold_Reaper`, `Daytrade Pro`, `Advanced Scalper`, `Bitcoin Reaper` —
prendre ces robots-là en gratuit ne donne que des activations, pas une stratégie de plus.
Voir [[profalgo-un-seul-moteur]], [[ubs-or-ticks-reels]].
