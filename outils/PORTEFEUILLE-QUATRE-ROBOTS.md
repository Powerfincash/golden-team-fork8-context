# Le portefeuille maison à quatre robots — ce qu'il a demandé, et comment le mesurer

Écrit le 22/09/2026. **Sa demande, telle qu'il l'a redite** : un portefeuille maison où les quatre
robots coexistent — **Eagle-owl sur ses jambes fidèles ET Kestrel sur le résidu rentable**, plus
Zebra et Heron. Ce n'est pas ce qui a été fait : la rubrique 6 a **substitué** Kestrel à Eagle-owl
partout au lieu de les faire cohabiter. C'est écrit ici pour ne plus se perdre.

Sa définition de Kestrel, du 22/09 : « Kestrel reprend les trades rentables non fidèles à UBS lors
de sa reconstruction par Eagle-owl, et retirés d'Eagle-owl pour atteindre la fidélité à UBS. »

## 1. La composition demandée

| Robot | Rôle | Jambes |
|---|---|---|
| **Eagle-owl** | le fidèle | or SetsB2 · EUR volatilité · CHFJPY · GBPUSD · argent Till · JPY D1 · EUR storyG |
| **Kestrel** | **le résidu seul** | les mêmes symboles, mais uniquement les entrées que les règles de fidélité rejettent |
| **Zebra** | indépendant | or |
| **Heron** | indépendant | AUDCAD · NZDCAD |

Dosage au pire des deux moitiés, comme partout. Aucune jambe UBS : le portefeuille reste utilisable
en algo chez Axi Select et ne brouille rien.

## 2. Le point bloquant : le résidu n'est pas isolable en l'état

Kestrel ne joue pas le résidu, il joue **le fidèle + le résidu**. Débrancher une règle de fidélité
ne met pas de côté les entrées retirées, elle les remet dans le flux. Mesure du 19/09 : règle en
deçà débranchée, le livre or était à **116,9 %** des positions d'UBS, contre 100,1 % règle posée.

**Donc, tel quel, Eagle-owl et Kestrel ne peuvent PAS cohabiter sur la même jambe** : ils joueraient
deux fois les trades communs, sur le même symbole, aux mêmes niveaux.

### Trois routes, et une seule décide

| Route | Ce que c'est | Verdict |
|---|---|---|
| **Paramètre** | un mode « résidu » dans `EagleOwl_v1.mq5` : là où une règle de fidélité rejette une entrée, la prendre ; là où elle accepte, la laisser à Eagle-owl | **la bonne.** Petit chantier : les règles sont localisées (`ReposeFermee`, `NiveauConsomme`, les quatre points de la règle en deçà). C'est la seule version **jouable en réel**. |
| **Post-traitement** | apparier les transactions de Kestrel et d'Eagle-owl sur (jeu, heure, sens, prix) et garder les non-appariées | **pour dégrossir seulement.** Gratuit et immédiat, mais c'est une série réassemblée : sa propre règle interdit d'y juger un dosage — seul un rapport unique compte. |
| **Cohabitation sans isoler** | lancer les deux tels quels | **exclue.** Doublon des trades communs, et collision opérationnelle sur les mêmes niveaux. |

**Réserve honnête sur la notion même de résidu** : les trades interagissent. Une entrée en plus
consomme un niveau, occupe une position, et change ce qui suit. Le résidu n'est donc pas exactement
la soustraction de deux listes, et un mode « résidu » ne produira pas exactement les entrées
manquantes d'aujourd'hui. **C'est une jambe nouvelle, à mesurer comme telle**, pas un extrait.

## 3. Ce que ses mesures disent déjà du résidu — et ce n'est pas encourageant

Sur le livre or SetsB, entre v1.38 (428 entrées inventées) et v1.44 (toutes retirées) :
net **5 789 → 5 499 $**, creux **465 → 350 $**, rapport **12,4 → 15,7** (UBS 16,4). Sa conclusion
écrite ce jour-là : **« les entrées inventées étaient du rendement acheté avec du creux. »**

Ordre de grandeur, et rien de plus : les 428 entrées retirées valaient **+290 $ pour environ +115 $
de creux**, soit un rapport voisin de **2,5** contre 15,7 pour la jambe fidèle. Les creux ne
s'additionnent pas, donc ce n'est pas une mesure : c'est une indication, et elle va dans le sens
d'un résidu faible en rapport.

Ce qui ne l'élimine pas : **la faiblesse n'est pas un disqualifiant du crible, la redondance l'est.**
Une jambe faible mais décorrélée mérite sa place. C'est exactement la question à mesurer.

## 4. L'ordre des mesures, du gratuit au coûteux

**Étape 0 — gratuite, sur les rapports du 19/09.** `fidelite_entrees.py` en prenant **Eagle-owl
comme référence à la place d'UBS** : communes, manquées, inventées entre Kestrel et Eagle-owl sur
l'or. Les inventées sont le résidu. On en tire son net, son nombre de transactions, et son net
mensuel. **Ce que cette étape décide** : si le résidu vaut le chantier de code. Rien d'autre.

**Étape 1 — gratuite.** Corrélation mensuelle du résidu contre la jambe or fidèle :
`python outils/correlation_jambes.py <csv_residu> <csv_or_fidele> "résidu Kestrel" "or fidèle"`.
Au-dessus de +0,50, c'est un doublon et le chantier s'arrête là.

**Étape 2 — le chantier de code**, seulement si 0 et 1 passent : le mode résidu dans le moteur.

**Étape 3 — une passe MT5 en v1.47** : les quatre robots ensemble, réserve 2025, dosage au pire des
deux moitiés, rapport hors tirage. **C'est ce rapport unique qui décide**, pas les étapes 0 et 1.

## 5. Les seuils, fixés d'avance

| Question | Seuil | Si raté |
|---|---|---|
| Taille du résidu (étape 0) | assez de transactions pour être mesurable, **≥ 300** sur 2021-2024, le seuil déjà retenu pour valider un EA maison | en dessous : rien à ajouter, on clôt |
| Redondance résidu / jambe fidèle | corrélation mensuelle **≤ +0,50** | au-delà : doublon, disqualifiant |
| Réserve 2025 du résidu | **positive** | négative : éliminé, comme les sept candidats précédents |
| Apport au portefeuille | **> +15 %** de rapport hors tirage **à creux égal** | en dessous : bruit, on ne change rien |
| Dosage | au **pire des deux moitiés** | sinon la mesure ne compte pas |

## 6. Les deux trous qui restent sur le portefeuille maison actuel

1. **Aucune corrélation croisée impliquant une jambe Kestrel n'existe**, alors que sept des dix
   jambes de la rubrique 6 en sont. Ce qui existe est antérieur : Eagle-owl fidèle contre les trois
   Zebra (+0,13 / −0,02 / +0,02, 08/09), Heron contre Axi Select (+0,01 à +0,07).
2. **La rubrique 6 est restée en v1.34-v1.35.** Les rubriques 1 à 5 ont été rejouées en v1.47.
