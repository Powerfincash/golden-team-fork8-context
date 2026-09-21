---
name: quatre-standards
description: Les quatre configurations du livre arrêtées le 07/09 — compte propre (16,73), sans UBS (10,61), prop firm (65 %/an), prop firm avec AUDCAD (70 %/an)
metadata:
  type: project
---

**Arrêtés le 07/09/2026.** Détail complet et tableaux : `forex/outils/QUATRE-STANDARDS.md`,
recalculable par `outils/quatre_standards.py`. Protocole unique (ticks réels, délai d'exécution,
2021-2024, lot 0,01, dosage au pire des deux moitiés).

| standard | composition | rapport | à retenir |
|---|---|---|---|
| **1. compte propre** ★ | UBS or ×1, UBS fx ×1, Zebra or ×15, Zebra GBP ×30, Zebra EUR ×30, AdvSc ×10 | **16,73** | 1 352 $ pour 18 % de creux → 220 %/an corrigé |
| 2. compte propre SANS UBS | Zebra or ×15, GBP ×10, EUR ×30, AdvSc ×30 | 10,61 | **les deux tiers du rapport sans licence tierce** — configuration de repli |
| 3. prop firm | idem 1 mais AdvSc ×20 | 16,43 | ×15,0 → 65 %/an, challenge 2,4 mois, funded 3,50 % médian corrigé |
| **4. prop firm + AUDCAD ×3** ★ | idem 3 mais Zebra or ×12 + AUDCAD ×3 | 16,01 | ×15,6 → **70 %/an**, challenge **2,3 mois**, funded **3,97 %** → ~3 400 $/mois sur 100k |

**Le fait à retenir** : AUDCAD (retour à la moyenne, sans stop) **nuit en compte propre et aide en prop
firm**. Le compte propre est limité par le creux, où il dilue (son rapport propre est 1,64 contre 16,7
pour le livre). Le prop firm est limité par la **pire journée**, et il la réduit de 166,9 à 160,4 $ tout
en ajoutant du rendement. **La contrainte détermine la composition** — voir
[[portefeuille-sport-collectif]].

**Recommandation : standard 1 en compte propre, standard 4 en compte financé.**


## 08/09/2026 : outil `etat_portefeuilles.py` — l'etat de situation ne se refait plus a la main

`python outils/etat_portefeuilles.py [propre|axi|propfirm|zebra]` sort les quatre configurations avec
dosage optimise au pire des deux moities, rapport, **capital minimum impose par le lot plancher de
0,01**, duree de challenge et performance en funded. A relancer apres chaque nouvelle brique mesuree.

**Regles encodees** (corrigees sur son signalement du 08/09) :
- **Axi Select : +7 % objectif / -7 % perte maximale, UNE phase, CODE MAISON UNIQUEMENT** (les EA
  commerciaux y sont interdits en algo -- voir [[propfirm-choix-maison]]).
- Prop firm classique : 5 % journalier / 10 % total, phase 1 +8 % puis phase 2 +5 %.
- Compte propre : aucun seuil, le capital fixe le creux accepte.

**Etat au 08/09, marge de securite 50 %** :

| | rapport | rendement corrige | capital minimum | instances |
|---|---|---|---|---|
| Compte propre (livre complet) | **17,23** | 126 %/an a 10 % de creux | 3 066 $ | 28 |
| Prop firm classique (livre complet) | 16,16 | funded **+3,94 %/mois**, 2 phases en 2,8 mois corriges | 8 130 $ | 28 |
| **Axi Select (Eagle-owl + Zebra x3)** | **11,21** | funded **+2,25 %/mois**, challenge +7 % en 2,1 mois | **11 465 $** | 16 |
| Zebra seul | 7,57 | 28 %/an | **360 $** | 3 |

**Le capital minimum vient du lot plancher de 0,01** : la brique la MOINS dosee le fixe. C'est pour ca
que Zebra seul demarre a 360 $ (sa plus petite brique est a x25) alors qu'Axi Select exige 11 465 $
(Eagle-owl y est a x1). **Zebra seul reste le seul point d'entree pour un premier compte reel.**

Le classique paie 75 % de plus par mois que Axi Select ; c'est le prix du risque de refus de paiement
pour strategie partagee, qui n'existe pas avec du code maison.
