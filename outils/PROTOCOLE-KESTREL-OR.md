# Kestrel sur la jambe or SetsB2 — ce qui est acquis, ce qui manque, et la passe à faire

Écrit le 22/09/2026, en réponse à « c'était acquis avec fork 7 ». Il avait raison pour l'essentiel.

## 1. Ce qui est DÉJÀ mesuré — ne pas le refaire

Tout date du **19/09/2026**, moteur en **v1.34-v1.35**.

| Mesure | Résultat | Source |
|---|---|---|
| Réserve 2025 de la jambe or SetsB2 en Kestrel | rapport **3,74 → 9,76**, **+3 460 $** | `outils/reserve2025.py`, [[moteur-multi-jeux]] 19/09 15 h |
| Le livre autour de cette jambe (portefeuilles autonomes A2) | Axi **17,01** / réserve **+6 058 $** · classique **16,59** / **+7 128 $** · compte propre **15,26** / **+6 202 $** | rubrique 6 de la page des standards |
| Remplacement EN BLOC des jambes fidèles par Kestrel | rubrique Axi **19,20 → 18,29** : négatif | 19/09 |

Lecture : Kestrel est meilleur jeu par jeu et moins bon en portefeuille. Signe classique de jambes
qui se ressemblent trop entre elles.

## 2. Ce qui MANQUE — et c'est ce qui décide

**La jambe or Kestrel n'a jamais été mise CÔTE À CÔTE avec la jambe or fidèle.** Dans la
rubrique 6, Kestrel **remplace** l'or fidèle, il ne s'y ajoute pas. Donc :

- corrélation or-Kestrel contre or-fidèle : **jamais mesurée** ;
- substitution de la **seule** jambe or (fidèle → Kestrel) dans le livre principal
  (rubriques 1, 2ter, 3) : **jamais mesurée**. Seul le remplacement en bloc l'a été.

**Le précédent qui pèse** : Eagle-owl contre UBS a été mesuré à **+0,77** le 08/09, avec le verdict
écrit « c'est un SUBSTITUT, pas une brique de plus ». Kestrel et Eagle-owl descendent tous deux de
la reproduction d'UBS et jouent **le même jeu** SetsB2. Attendre une corrélation encore plus haute
que +0,77 est le scénario de base, pas le scénario pessimiste.

**Et depuis v1.43, un seul des trois réglages mord encore sur l'or** (tranché le 22/09, voir
[[kestrel-profil-rendement]]) : `Fid_SwingMortAuDela` ne vaut que pour les 3/5 décimales, et
`Fid_ReposeMaxTrades` ne change rien là où `if(dig == 2) return false;` coupe déjà la fenêtre.
Reste `Fid_SwingMortEnDeca`. Sur l'or, Kestrel et Eagle-owl sont donc aujourd'hui presque le même
robot — raison de plus de s'attendre à un substitut.

## 3. Le chiffre acquis est DATÉ — et c'est le vrai motif de relance

Le 9,76 a été mesuré en **v1.35**. Le lendemain, le moteur or est passé en **v1.42 → v1.47** :
fidélité du livre or **92,9 → 98,5 %**, erreur 301 → 105. Un chiffre sans sa version est un chiffre
périmé. **Le 9,76 doit être rejoué en v1.47 avant toute décision.**

## 4. La passe — une seule, et ce qu'elle produit

Rejouer la **jambe or SetsB2 en Kestrel, en v1.47**, sur 2021-2024 **et** sur 2025, puis :

1. `outils/parjeu.py <rapport> --csv` sur le nouveau rapport **et** sur la jambe or fidèle (n121 ou
   n132 selon le compte), pour obtenir les deux séries **datées par mois** ;
2. `python outils/correlation_jambes.py <csv_kestrel> <csv_fidele> "or Kestrel" "or fidèle"` ;
3. le livre avec la seule jambe or substituée, rapport hors tirage et réserve 2025.

## 5. Les seuils, fixés d'avance

| Question | Seuil | Conséquence si raté |
|---|---|---|
| Redondance avec l'or fidèle | corrélation mensuelle **≤ +0,50** | au-delà : **substitut, pas une brique de plus**. On ne les met pas côte à côte. |
| Réserve 2025 | **positive** | négative : éliminé, comme les sept candidats précédents |
| Gain du livre, jambe or substituée | **> +15 %** de rapport hors tirage | en dessous : sous le seuil de bruit, donc non interprétable, donc on ne change rien |
| Dosage | au **pire des deux moitiés** | sinon la mesure ne compte pas |

Règles qui s'appliquent par-dessus : aucun chiffre hors `mesure.py` ; **un rapport unique fait foi,
jamais une recomposition de séries** ; un candidat se juge à creux égal sur sa contribution au
portefeuille, jamais sur son rendement propre.

## 6. Ce qui bloque aujourd'hui

Rien côté méthode. Côté matériel : une session infonuagique n'a accès ni à MetaTrader ni au PC.
La passe se lance sur le PC par le chemin unique de `CLAUDE.md` (`outils/lance_chaine.ps1 -Inis …`).
Le `.ini` exact reste à écrire à partir de celui de la jambe or existante, en changeant trois
paramètres d'entrée et le nom du rapport — il n'est pas encore au dépôt, `rapatrier.sh` n'ayant
jamais été lancé (aucun dossier `pc/`).
