---
name: levier-et-plafond
description: "Le rendement s'achete avec les lots, le creux ne s'achete pas — et plafonner Gold Phantom a 50 % ne coute que 9 % d'efficacite"
metadata: 
  node_type: memory
  type: project
  originSessionId: ad015105-f722-4c5f-9697-c4b1c268474a
  modified: 2026-09-02T21:33:00.952Z
---

Mesuré dans la nuit du 02 au 03/09/2026, avec `outils/plafond.py`.

**Sa question qui a tout débloqué** — « TOUT serait mis sur un seul cheval, alors ? »
Je n'avais **jamais** imposé de plafond de concentration à l'optimiseur : le
85 % de Gold Phantom n'était pas un résultat, c'était l'absence d'une contrainte.

**Le plafond coûte très peu.** Fenêtre 2022-2024, trois jambes :

| plafond | rendement | creux | rapport | répartition |
|---|---|---|---|---|
| aucun | 39,7 % | 4,0 % | 10,02 | Phantom 80 / Wolf 20 |
| 50 % | 28,7 % | 3,2 % | 9,10 | Phantom 50 / Wolf 20 / Revert 30 |

Diviser par deux la dépendance à un seul robot ne coûte que **9 % de rapport**.

**Le renversement de méthode** : le rendement se rachète avec les lots, le creux
ne se rachète pas. Il faut donc optimiser le RAPPORT sous plafond de concentration,
puis monter le levier — et non chercher du rendement.

Vérifié sur huit ans (2012-2020, Phantom + Revert seuls) : à ×3, **99,9 %/an pour
14,5 % de creux au solde**. Le creux à ×1 passe de 3,2 % (3 ans) à 5,0 % (8 ans) —
dégradation réelle mais modérée.

**Les deux corrections à toujours appliquer** :
- les données importées flattent Gold Phantom de **27 %**, pas 12 % (53,0 %/an
  importé contre 41,6 %/an en ticks réels, même fenêtre 2021-2026)
- son creux en **fonds** vaut 1,7 fois son creux en solde (19,75 % contre 11,6 %
  sur 17 ans) — c'est le creux en fonds qui sert à provisionner

Après corrections, le ×3 sous plafond 50 % vaut réalistement **75-80 %/an pour
22-25 % de creux vécu**.

**L'hypothèse encore non vérifiée** : que multiplier les variations quotidiennes
par k équivaille à faire tourner le robot à k fois les lots. Le levier réel est
`Risk` (solde par pas de lot) : 1234 → 617 → 411. Prédictions écrites d'avance
dans `outils/PREDICTION-LEVIER.md`, test dans `nuit3_levier.ps1`.
`MaxRiskPerStrategy_` est inerte, ce n'est PAS le bon paramètre.

Voir [[reperes-chiffres-or]], [[ea-commerciaux-or]], [[backtest-acceptance-criteria]].

---

**Correction du 03/09 à 1 h 40 :** la loi en √N évoquée à partir de ces chiffres a
été **RÉFUTÉE** dès qu'elle a été confrontée à un deuxième cas. Voir
[[pas-de-formule-de-portefeuille]]. Les chiffres de levier ci-dessus restent
valables ; c'est leur extrapolation à N jambes qui ne l'est pas.
