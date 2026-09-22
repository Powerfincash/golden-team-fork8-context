# Merlin — le chantier du mode résidu

**Nom choisi par lui le 22/09/2026 : Merlin**, l'émerillon, le plus petit faucon d'Europe, même
famille que la crécerelle. La relation s'écrit :

> **Kestrel = Eagle-owl + Merlin**, aux effets d'interaction près.

Ce n'est pas une addition exacte : les trades en plus consomment des niveaux et changent ce qui
suit. Mesuré le 22/09 — six jeux gardent le même nombre de trades entre v1.31 et v1.32 et changent
quand même de net. **Merlin produira une jambe nouvelle, pas un extrait de Kestrel.**

Kestrel n'est ni renommé ni remplacé : il reste le fidèle + le résidu, et il peut servir.

**Rien n'est codé. Ce fichier est un plan, présenté avant tout changement, et le moteur ne sera pas
touché sans son accord explicite.** Le source `EagleOwl_v1.mq5` n'est d'ailleurs pas encore au
dépôt : à lire avant d'écrire une ligne, pour vérifier chaque point ci-dessous.

## 1. Ce que les trois robots font, en une ligne chacun

Une entrée candidate est examinée ; chaque règle de fidélité dit « je la rejette » ou « je la laisse
passer ».

| Robot | Ce qu'il prend |
|---|---|
| **Eagle-owl** | les entrées qu'**aucune** règle ne rejette |
| **Kestrel** | **toutes** les entrées (règles débranchées) |
| **Merlin** | **seulement** les entrées qu'au moins une règle rejette |

## 2. Le changement dans le code : un seul endroit, pas trois

La tentation serait d'inverser les trois règles là où elles sont. **C'est la mauvaise route** :
elles agissent à des endroits différents, dont des fonctions appelées ailleurs, et trois inversions
font trois occasions de se tromper.

La bonne route, en deux temps :

1. **Rendre les trois règles muettes** : chacune ne décide plus, elle *rapporte*. Elle renvoie
   « rejeté » ou « accepté », sans effet de bord.
   - « swing dépassé = mort » **en deçà** — quatre points (choix du premier swing vivant, filtre
     des candidats). Restriction décimale levée en v1.32 : vaut partout, **or compris**.
   - « swing dépassé = mort » **au-delà** — `AuDela(j, ±1)`, restreint aux **3 et 5 décimales**.
     **Sans effet sur l'or.**
   - **fenêtre de repose** — `ReposeFermee`, avec `if(dig == 2) return false;` (v1.43) puis
     `if(Fid_ReposeMaxTrades < 999) return false;` (v1.45). **Sans effet sur l'or non plus.**
2. **Un seul point de décision**, là où l'ordre est posé : `rejete = regle1 || regle2 || regle3`,
   puis selon le profil — Eagle-owl saute si `rejete`, Kestrel ne saute jamais, **Merlin saute si
   `!rejete`**.

Un seul paramètre d'entrée, un choix à trois valeurs (`FIDELE` / `KESTREL` / `MERLIN`), qui remplace
l'usage actuel des trois `Fid_*` comme interrupteurs. Les trois `Fid_*` restent pour le réglage fin.

**Conséquence pour l'or, à savoir d'avance** : deux règles sur trois n'y mordent pas. **Merlin sur
l'or ne joue donc que les rejets de la règle en deçà.** Sur les devises, les trois contribuent.

## 3. Les pièges, à vérifier dans le source avant d'écrire

1. **Effets de bord.** Si `ReposeFermee` ou la comptabilité des niveaux *modifie* un état au lieu de
   seulement le lire, la transformer en simple rapporteur change le comportement. À vérifier ligne
   par ligne.
2. **L'état diverge, et c'est voulu.** En Merlin, les trades fidèles n'existent pas : les niveaux ne
   sont pas consommés par eux, les places de position ne sont pas prises. Le jeu de candidats
   lui-même change. **Merlin ≠ Kestrel moins Eagle-owl.** C'est pour cela qu'il se mesure comme une
   jambe à part entière.
3. **Les plafonds.** `MaxTrades` par niveau, plafond de positions simultanées : ils comptent des
   entrées que Merlin ne prend plus. À décider explicitement, pas par accident.
4. **Le magic. Piège opérationnel majeur.** Merlin et Eagle-owl tourneront **sur le même symbole**.
   Deux EA au même magic sur un même compte s'annulent mutuellement leurs ordres — règle apprise le
   17/09. **Merlin doit avoir sa propre plage de magics**, dès le backtest.
5. **Contrôle d'acceptation du code**, avant toute mesure de portefeuille : le nombre d'entrées de
   Merlin doit correspondre aux « inventées » que donne `fidelite_entrees.py` en prenant Eagle-owl
   comme référence, à l'écart d'interaction près. Si l'écart est grand, c'est le code qui est faux,
   pas le marché.

## 4. Ce qu'on attend de Merlin — et pourquoi il se juge sur sa décorrélation

Le résidu est **dilutif en rendement** : rapport marginal **5,0 à 5,7** contre 13,5 à 15,0 pour la
jambe fidèle (mesure du 22/09, v1.31 → v1.32). Il ne sera donc jamais retenu pour ce qu'il rapporte.

Son seul argument est la **décorrélation**, et il est sérieux : Merlin prend précisément les moments
où le moteur fidèle **refuse** d'entrer — niveau déjà consommé, swing déjà franchi, fenêtre de
repose. Ce sont des états de marché structurellement différents. C'est mesurable, et c'est la seule
chose à mesurer.

**Le risque, à dire d'avance** : même symbole, mêmes jeux, mêmes niveaux. La corrélation peut très
bien dépasser +0,50, et alors le crible interdit de les mettre côte à côte, quel que soit le gain.
Précédent : Eagle-owl contre UBS, **+0,77**, « substitut, pas une brique de plus ».

## 5. Le plan de mesure, du gratuit au coûteux

| Étape | Ce qu'on fait | Coût | Ce qu'elle décide |
|---|---|---|---|
| **1** | Export **mensuel** (`parjeu.py --csv`) du rapport règle débranchée, puis `correlation_jambes.py` contre `parjeu_n121_..._v147_mensuel.csv` | gratuit, quelques secondes | **si le chantier vaut la peine.** Au-dessus de +0,50 sur ce substitut, on s'arrête là. |
| **2** | Écrire le mode Merlin, contrôle d'acceptation du point 3.5 | chantier de code | rien — c'est un contrôle, pas une mesure |
| **3** | Une passe MT5 **en v1.47** : jambe or SetsB2 en Merlin, 2021-2024 **et** 2025, rapport unique | une passe | le rapport propre de Merlin et sa réserve 2025 |
| **4** | Corrélations de Merlin contre **chaque** jambe maison : or fidèle, Zebra or, Heron ×2, et les jambes hors or | gratuit une fois 3 faite | la place de Merlin dans le portefeuille |
| **5** | Le livre maison complet à quatre robots, dosage au pire des deux moitiés, rapport hors tirage et réserve 2025 | une passe | **la décision.** Seul ce rapport unique décide. |

## 6. Les seuils, fixés d'avance

| Question | Seuil | Si raté |
|---|---|---|
| Corrélation de Merlin à la jambe or fidèle | **≤ +0,50** | doublon : disqualifiant, on n'ajoute pas |
| Corrélation aux autres jambes maison | **≤ +0,50** | idem, jambe par jambe |
| Réserve 2025 de Merlin | **positive** | éliminé, comme les sept candidats précédents |
| Taille | **≥ 300** transactions | déjà acquis : ~590 sur l'or |
| Apport au livre maison | **> +15 %** de rapport hors tirage **à creux égal** | sous le seuil de bruit : on ne change rien |
| Dosage | au **pire des deux moitiés** | la mesure ne compte pas |

Par-dessus : aucun chiffre hors `mesure.py` ; **un rapport unique fait foi, jamais une recomposition
de séries** ; un candidat se juge à creux égal sur sa contribution, jamais sur son rendement propre.
