# État de reprise

> **Ce fichier est le premier à lire, et le seul qui fait foi sur « où on en est ».**
> Les autres fichiers du dépôt sont des archives : ils disent ce qui a été mesuré,
> pas ce qui est vivant. Un chiffre dans une archive sans date est un chiffre périmé.

**À jour au : 22/09/2026**
**Dernier geste : rapatriement du PC outillé — `COMMANDE.md` (une commande à coller dans Git Bash),
`INVENTAIRE.md` (ce qui entre et ce qui reste dehors), `gabarits/` (la page Quatre Standards).
Geste précédent : trois démos Vantage MT5 mesurées en réserve 2025 — voir section 1.**

---

## 1. Décidé — ne pas rouvrir

- **Jambe or, règle du 17/09** : compte propre = UBS SetsB (rapport n121). Tout prop firm
  (classique ou Axi) = Eagle-owl SetsB2 (rapport n132), pour brouiller les pistes.
- **Portefeuille de réserve** : jugé sur ses critères propres (1,8, réserve 2025 positive,
  crible, creux, indépendance). **Jamais comparé au livre UBS** (consigne du 20/09).
- **Argent de Till** : retiré du live le 20/09 après −455 USC sur 12 trades, 0 gagnant.
  L'argent à 62 $ pèse ~2,5 fois son modèle 2021-2024 : problème de dosage et de régime.
- **M5_H retiré** : tient hors échantillon (6,78 contre 6,71 en réserve), seul jeu négatif
  sur les deux moitiés. C'est un **critère d'admission manqué**, pas un retrait pour faiblesse.
- **GoldDaily1 et goldtrade_H gardés** (mesuré le 21/09 au soir, `parjeu.py --csv` sur n121
  et n132, corrélation de Pearson mensuelle contre le reste de la jambe or) : GoldDaily1
  corr 0,199/0,297, net −113/−262 $ sur 4 ans ; goldtrade_H corr 0,067/0,301, net +91/+89 $.
  Toutes bien sous le seuil +0,5 — **aucune redondance, aucun retrait justifié**. GoldDaily1
  reste faible individuellement mais faiblesse n'est pas un disqualifiant du crible.
- **Viper** : aucun candidat réserve solide. Seuls GBPAUD et AUDCAD sont positifs sur les
  deux périodes, et leurs creux en échantillon (33,1 % / 39,9 %) dépassent la référence 25 %.
  EURAUD éliminé par sa réserve 2025 négative. GBPCHF et EURCHF éliminés (creux 76-83 %).
  **La grille n'est pas le moteur** : sans elle, l'écart est sous le seuil de bruit de 15 %.
- **R Factor : mort comme candidat** (chaîne D terminée le 21/09 à 12h20). Panier 1-ordre
  **−2 875 $** sur 8 croisées, NZDCHF à lui seul −2 269 $ pour 76,1 % de creux. Et surtout :
  **réserve 2025 négative sur les cinq paires mesurées** — EURGBP et USDCAD, les seuls positifs
  en échantillon, s'inversent. Aucune paire ne passe « positif sur les deux périodes ».
- **Le poste retour à la moyenne reste vacant** (Heron seul). Le portefeuille est 100 % cassure.
  Sixième échec d'affilée sur la réserve 2025 (Luna AI, Viper, R Factor, puis les trois démos
  Vantage du 21/09 au soir) : le motif est net, chaque candidat doit être mesuré sur 2025
  **avant** tout le reste — protocole confirmé, pas de raison de le revoir.
- **Trois démos Vantage MT5 mesurées le 21/09 au soir, toutes négatives sur 2025** :
  Daily HighLow Breakout EA (NAS100.r, 886 deals, −0,7 %/an, creux 0,72 %), Ichimoku
  Strategies EA MT5 (EURUSD, 258 deals, −0,0 %/an, creux 0,04 %), Ichimoku Cloud Pro
  (EURUSD, 270 deals, −0,0 %/an, creux 0,03 %). Les deux Ichimoku ont un profil quasi
  identique (probablement même moteur, comme UBS/Advanced Scalper) et un creux si faible
  que les réglages par défaut semblent sous-trader — **éliminés sur la règle 2025 négatif**.
  **Daily HighLow Breakout : exception levée après mesure** (21/09 21h15). Corrélation
  mensuelle 2025 avec la jambe or (n66) : −0,225, mais trompeuse — dans les deux mois où
  l'or perd (février, juillet), Daily HighLow perd aussi. Pas d'effet protecteur, juste un
  drain constant (11/12 mois négatifs). **Éliminé, comme les deux Ichimoku.**

**Les trois démos Vantage MT5 testées le 21/09 sont toutes éliminées.**
- **Mécanisme de reprise de session en place** (PR n°1 fusionnée le 21/09) : `ETAT.md`,
  ordre de lecture en tête de `CLAUDE.md`, et `./sauver.sh` comme unique commande de sauvegarde.
- **Rapatriement du PC outillé le 22/09** : `./rapatrier.sh`, lancé par la ligne unique de
  `COMMANDE.md`, ramène outils, `.set`, `.ini` sans identifiant, sources `.mq4`/`.mq5`, gabarits
  et index des rapports, puis vérifie le push. Ce qui entre et ce qui reste dehors : `INVENTAIRE.md`.
  **Le gabarit de la page « Quatre Standards » est dans `gabarits/` : on le reprend tel quel.**
- **Rapatriement automatique** (22/09, autorisé par Denis) : une seconde ligne de `COMMANDE.md`
  crée la tâche Windows « Rapatriement Golden Team », qui lance `auto.sh` chaque nuit à 3 h, avec
  rattrapage au démarrage suivant si le PC était éteint. Un commit par jour au maximum.
  **`AUTOMATIQUE.md` est le témoin de vie** : sa première ligne donne la date du dernier passage ;
  plus de deux jours = la tâche ne tourne plus.

## 2. En cours — ce qui tourne seul

- **Rien ne tourne.** La chaîne des trois démos Vantage (réserve 2025) est terminée depuis le
  21/09 20h58 ; ses résultats sont versés dans `RESULTATS_CORRIGES.md`. Terminal Vantage MT5
  local refermé après le test (le lanceur ne ferme jamais un terminal existant : c'est à
  l'utilisateur, il l'a fait deux fois ce soir — avant le premier essai refusé, puis confirmé).

> *Tenir cette section à jour est le point le plus important du fichier : une session
> qui reprend doit savoir en une ligne si une mesure est en vol.*

## 3. Bloqué — et sur quoi exactement

- **Dossier argent** : suspendu à la réserve 2025 des trois jeux Till. 94 % de leur net a été
  réalisé en 2023-2024 et la fenêtre d'optimisation de Till est inconnue. C'est le vrai risque,
  pas les 12 trades live.
- **Infrastructure** : une session cloud n'a aucun accès à MetaTrader ni au PC. Recommandation
  posée : un runner sur le VPS piloté par le dépôt (job commité, rapport et série de trades
  repoussés). Reste à dimensionner : quel VPS, quel OS, quel terminal, quels ticks déjà installés.
  **Correction du 21/09 au soir** : une session AVEC accès PC n'a aucun blocage pour ces mesures
  (`parjeu.py --csv` tourne en local en quelques secondes) — le blocage était propre aux sessions
  cloud, pas structurel.

## 3bis. Kestrel sur la jambe or — décidé le 22/09, protocole prêt

Sa décision du 22/09 : mesurer Kestrel jambe par jambe, en commençant par l'or SetsB2, plutôt que
comme profil global (le remplacement en bloc a été mesuré le 19/09 et recule, 19,20 → 18,29).

**L'essentiel est déjà acquis** (19/09, moteur v1.35) : réserve 2025 de l'or SetsB2 en Kestrel
3,74 → **9,76** (+3 460 $), et le livre bâti autour de cette jambe, c'est la rubrique 6 de la page
des standards. **Ne pas le refaire.**

**Sa définition du 22/09, qui fait foi** : « Kestrel reprend les trades rentables non fidèles à UBS
lors de sa reconstruction par Eagle-owl, et retirés d'Eagle-owl pour atteindre la fidélité. » Les
deux sont donc complémentaires par construction : la mesure à faire est un **AJOUT**, pas un
remplacement.

**Écart à lever d'abord** : le code fait de Kestrel le SUR-ENSEMBLE d'Eagle-owl, pas son résidu.
Débrancher une règle rajoute les trades par-dessus au lieu de les isoler (livre or à 116,9 % des
positions d'UBS règle débranchée, 100,1 % règle posée). Les jouer côte à côte doublerait les trades
communs. **Le recouvrement Kestrel / Eagle-owl n'a jamais été mesuré** — à ne pas confondre avec la
fidélité à UBS, qui elle est connue. `fidelite_entrees.py` le donne en prenant Eagle-owl comme
référence : ses « inventées » sont exactement le résidu. Cette étape ne coûte rien, elle tourne sur
des rapports déjà écrits.

Précédent qui pèse : Eagle-owl contre UBS = **+0,77**, « substitut, pas une brique de plus ». Et
depuis v1.43 un seul des trois réglages mord encore sur l'or.

**Motif de relance** : le 9,76 date de v1.35 ; le moteur or est passé en v1.47 le lendemain
(fidélité 92,9 → 98,5 %). Un chiffre sans sa version est périmé.

**Le portefeuille maison est un cas à part, et c'était sa question de départ** : dans la rubrique 6
(autour de Zebra) il n'y a aucune jambe UBS ni Eagle-owl fidèle, donc Kestrel y entre de plein droit
et le problème de recouvrement ne se pose pas. Ce portefeuille existe depuis le 19/09 : dix jambes,
sept en Kestrel, une Zebra, deux Heron ; réserve 2025 +6 058 $ (Axi), +7 128 $ (classique),
+6 202 $ (compte propre), +2 357 $ (sans or). Manquent, dans cet ordre : les **corrélations croisées
entre ses dix jambes** (aucune corrélation impliquant Kestrel n'existe à ce jour) puis son **rejeu en
v1.47** — c'est la seule rubrique de la page restée en v1.34-v1.35.

**Sa demande d'origine, jamais faite, à ne plus perdre** : un portefeuille maison où les QUATRE
robots coexistent — Eagle-owl sur ses jambes fidèles ET Kestrel sur le résidu rentable, plus Zebra
et Heron. La rubrique 6 a substitué Kestrel à Eagle-owl partout au lieu de les faire cohabiter.
Spécification, point bloquant, ordre des mesures et seuils : `outils/PORTEFEUILLE-QUATRE-ROBOTS.md`.

**Merlin, décidé le 22/09** : le robot du résidu s'appellera Merlin (son choix), et la relation
s'écrit **Kestrel = Eagle-owl + Merlin**. Kestrel reste tel quel. Le résidu est chiffré sur l'or :
**~590 trades, +400 $ de net pour +70 à +80 $ de creux**, rapport marginal **5,0 à 5,7** contre
13,5 à 15,0 pour la jambe fidèle (mesure du 22/09, diff v1.31/v1.32, `outils/residu_par_versions.py`).
Assez gros pour justifier le chantier, mais **Merlin se jugera sur sa décorrélation, pas sur son
rendement**. Plan de code et plan de mesure : `outils/MERLIN-CHANTIER.md`. **Rien n'est codé ; le
moteur ne sera pas touché sans son accord explicite.**
Prochaine mesure gratuite : l'export mensuel du rapport règle débranchée, pour lancer
`correlation_jambes.py` contre `mesures/parjeu_n121_..._v147_mensuel.csv`.

Protocole complet, seuils fixés d'avance : `outils/PROTOCOLE-KESTREL-OR.md`.
Outil prêt : `outils/correlation_jambes.py` (deux sorties datées de `parjeu.py --csv`, Pearson
mensuel, seuil +0,50).

## 4. Prochain geste — le poste retour à la moyenne reste vacant

Plus aucun candidat en cours d'évaluation. Sept échecs d'affilée sur la réserve 2025 (Luna AI,
Viper, R Factor, trois démos Vantage). Aucune piste ouverte au 21/09 22h — **le prochain geste
est d'en chercher une nouvelle**, pas de retester ce qui vient d'échouer.

Dans cet ordre, sans urgence :

1. Relancer les **réserves 2025 de Sakura et Happy Pound**. Les deux passes du 21/09 ont été
   lancées sans produire de rapport (le log dit à 02:31 : « REFUS : aucun rapport après
   l'attente — ne rien conclure de ce passage »). Leurs verdicts d'origine PASS et *validé*
   n'ont jamais été revus alors que leur facteur de profit est 1,08 et leurs creux 42,2 % et 48,8 %.
2. Corriger le symbole **AUDUSD** — 4 blocs à 0 trade, seul test lancé sur le symbole nu alors
   que tous les autres tournent sur les suffixes `.s`.

## 5. Ne pas refaire

- **Ne pas réutiliser `FORK8_FINAL.md`** : trois lignes y sont mal attribuées (décalage entre
  « LANCE X » et le rapport lu juste après). `RESULTATS_CORRIGES.md` fait foi.
- **Ne pas comparer deux mesures faites sous des hypothèses d'exécution différentes** (fenêtre,
  lot, modèle de ticks, délai). Erreur commise Zebra avec délai contre Wolf sans délai.
- **Ne pas retirer un jeu sur son résultat en échantillon** : le dosage par jeu a été mesuré
  et réfuté, le rapport ne s'améliore pas par sélection.
- **Aucun écart sous 15 % n'est interprétable** entre deux variantes.
- **Ne pas publier avant d'avoir fini de lire ce qui est déjà sur le disque** (critique du 06/09).

---

## Comment tenir ce fichier

- Il se met à jour **pendant** le travail, pas à la fin : une décision prise s'écrit en section 1
  dans la foulée, une mesure lancée s'écrit en section 2 avant de quitter le clavier.
- Il reste **court** — une page. Ce qui déborde part dans `memory/` et n'est plus qu'un lien d'ici.
- Il ne contient **aucun chiffre qui ne vienne pas de `mesure.py`**.
- Il n'est à jour que **s'il est poussé** : `./sauver.sh "ce qui a changé"`.
