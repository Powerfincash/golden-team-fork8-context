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

## 2. Son intention, et l'écart avec le code

**Ses mots du 22/09** : « Kestrel reprend les trades rentables non fidèles à UBS lors de sa
reconstruction par Eagle-owl, et retirés d'Eagle-owl pour atteindre la fidélité à UBS. » Les deux
sont donc **complémentaires par construction**. C'est la définition qui fait foi, et elle change la
mesure à faire : **un AJOUT, pas un remplacement.**

**Mais le code ne fait pas encore cela.** Débrancher une règle de fidélité n'isole pas les trades
retirés, elle les rajoute par-dessus les autres : **Kestrel est le sur-ensemble d'Eagle-owl, pas son
résidu.** Ordre de grandeur mesuré le 19/09 : règle en deçà débranchée, le livre or était à
**116,9 %** des positions d'UBS, contre 100,1 % avec la règle. Jouer les deux côte à côte
aujourd'hui **doublerait les trades communs** au lieu d'ajouter une jambe.

C'est la question à trancher en premier, et elle se tranche **sur les rapports existants**, sans
rien relancer.

## 3. Deux mesures à ne jamais confondre

| Mesure | Ce qu'elle compare | Où elle en est |
|---|---|---|
| **Fidélité à UBS** | un robot contre UBS | connue : 96,5 % pour Eagle-owl, livre or 98,5 % |
| **Recouvrement Kestrel / Eagle-owl** | les deux robots entre eux | **jamais mesuré** |

La seconde décide de la cohabitation. `fidelite_entrees.py` la donne en prenant **Eagle-owl comme
référence à la place d'UBS** : ses « communes » sont le doublon, ses « inventées » sont exactement
le résidu que Kestrel est censé reprendre.

## 4. Ce qui est DÉJÀ mesuré et qui ne change pas

Le chiffre acquis reste acquis, mais il est **daté de v1.35**. Le lendemain le moteur or est passé
en **v1.42 → v1.47** (fidélité du livre or 92,9 → 98,5 %, erreur 301 → 105). Un chiffre sans sa
version est périmé : **le 9,76 doit être rejoué en v1.47** avant toute décision d'exploitation.

## 5. La passe — dans cet ordre, et la première ne coûte rien

**Étape A, sur les rapports déjà là, aucune relance.** `fidelite_entrees.py` avec le rapport or
Kestrel du 19/09 contre le rapport or Eagle-owl de la même version. Trois nombres : communes,
manquées, inventées.
- Si les communes dominent, c'est confirmé : Kestrel est un sur-ensemble. **Le résidu seul devient
  l'objet à mesurer**, et il n'existe pas encore comme jambe jouable — il faudra un mode qui ne
  joue QUE les entrées rejetées par les règles de fidélité. À dire avant de coder quoi que ce soit.
- Le résidu se chiffre dès maintenant à partir des « inventées » : net, creux, rapport, et son net
  mensuel pour l'étape B.

**Étape B, la cohabitation.** `parjeu.py --csv` sur les deux jambes pour obtenir les séries **datées
par mois**, puis :
`python outils/correlation_jambes.py <csv_residu_ou_kestrel> <csv_or_fidele> "or Kestrel" "or fidèle"`.

**Étape C, une seule passe MT5, en v1.47.** Jambe or SetsB2 en Kestrel sur 2021-2024 **et** 2025,
puis le livre **avec les deux jambes or côte à côte** — ajout, pas substitution — rapport hors
tirage et réserve 2025, dosage au pire des deux moitiés.

## 6. Les seuils, fixés d'avance

| Question | Seuil | Conséquence si raté |
|---|---|---|
| Recouvrement Kestrel / Eagle-owl sur l'or | part de communes **faible** | fort : ce n'est pas une jambe de plus, c'est le même trade joué deux fois. Passer au mode résidu avant toute exploitation. |
| Redondance des nets mensuels | corrélation **≤ +0,50** | au-delà : redondance, disqualifiant du crible |
| Réserve 2025 de la jambe ajoutée | **positive** | négative : éliminée, comme les sept candidats précédents |
| Gain du livre avec la jambe ajoutée | **> +15 %** de rapport hors tirage à creux égal | en dessous : sous le seuil de bruit, on ne change rien |
| Dosage | au **pire des deux moitiés** | sinon la mesure ne compte pas |

Par-dessus : aucun chiffre hors `mesure.py` ; **un rapport unique fait foi, jamais une recomposition
de séries** ; un candidat se juge à creux égal sur sa contribution au portefeuille.

**Le précédent à garder en tête** : Eagle-owl contre UBS = **+0,77** (08/09), verdict de l'époque
« substitut, pas une brique de plus ». Kestrel et Eagle-owl jouent le **même jeu** SetsB2, et depuis
v1.43 **un seul des trois réglages mord encore sur l'or**. Si le résidu est mince, il n'y a pas de
jambe à ajouter — et c'est l'étape A, gratuite, qui le dira.

## 7. Ce qui bloque aujourd'hui

Rien pour l'étape A ni l'étape B : elles tournent sur le PC en quelques secondes, sur des rapports
déjà écrits. Pour l'étape C, le `.ini` exact reste à écrire à partir de celui de la jambe or
existante (trois paramètres d'entrée et le nom du rapport) — il n'est pas encore au dépôt.

## 8. Le portefeuille maison — là, la question ne se pose pas

Sa remarque du 22/09, et elle est juste : **c'était l'objet de sa question de départ.** Dans le
portefeuille autonome bâti autour de Zebra (rubrique 6 de la page), il n'y a **aucune jambe UBS et
aucune jambe Eagle-owl fidèle**. Kestrel y entre donc de plein droit : rien à doubler, rien à
brouiller. Le problème de recouvrement des sections 2 et 5 ne concerne que le livre principal.

**Ce portefeuille existe déjà, mesuré le 19/09.** Ne pas le refaire.

Composition, dosage Axi (6a), dix jambes :

| Robot | Jambes | Dosage |
|---|---|---|
| **Kestrel** | or SetsB2 · EUR volatilité · CHFJPY · GBPUSD · argent Till · JPY D1 · EUR storyG | ×1 · hors or ×1 · argent ×1 · JPY D1 ×3 · storyG ×15 |
| **Zebra** | or | ×8 |
| **Heron** | AUDCAD · NZDCAD | ×4 · ×2 |
| **Eagle-owl fidèle** | *aucune* | — |

**Eagle-owl n'est pas dans ce portefeuille** : toutes ses jambes y sont jouées par Kestrel. Le
livre maison autonome est donc un **trois robots**, pas un quatre.

Réserve 2025, par variante de compte : Axi **+6 058 $** (rapport 17,01) · prop firm classique
**+7 128 $** (16,59) · compte propre **+6 202 $** (15,26) · sans or **+2 357 $** (10,56). Les dix
jambes sont toutes positives en 2025 ; quatre ont été retirées par cette même réserve (Advanced
Scalper, USO, Zebra GBP, Zebra EUR). Le détail jambe par jambe est en rubrique 6d de la page.

### Ce qui manque sur ce portefeuille

1. **Les corrélations croisées entre ses dix jambes n'ont jamais été mesurées.** Ce qui existe est
   antérieur et porte sur d'autres jambes : Eagle-owl **fidèle** contre les trois Zebra
   (**+0,13 / −0,02 / +0,02**, 08/09) et Heron contre Axi Select (**+0,01 à +0,07**, les plus
   basses mesurées ici). **Aucune corrélation impliquant une jambe Kestrel n'existe**, et sept des
   dix jambes sont des jambes Kestrel. C'est le trou réel.
2. **La rubrique 6 est restée en v1.34-v1.35.** Les rubriques 1 à 5 ont été rejouées en v1.47 le
   20/09, pas elle. Ses chiffres sont les seuls de la page à ne pas être au moteur courant.

Dans cet ordre : d'abord les corrélations croisées, qui tournent sur les rapports existants et ne
coûtent rien ; ensuite seulement le rejeu en v1.47, qui est une passe complète.
