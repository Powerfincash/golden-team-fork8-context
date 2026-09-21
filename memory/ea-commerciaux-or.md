---
name: ea-commerciaux-or
description: Verdict hors-echantillon sur The Gold Phantom, Smart Gold Hunter et The Gold Reaper
metadata:
  type: project
---

Trois EA commerciaux du MQL5 Market, en demo dans le terminal PU Prime, testes sur
XAUUSD.p M15. Le partage decisif : **2023.01-2026.06** (la fenetre que les vendeurs ont
presque certainement optimisee) contre **2019.01-2022.12**, quatre annees anterieures.
Barres M1 pour la comparaison, reglages d'origine stricts.

| | PF 2019-2022 | PF 2023-2026 | annees positives | DD fonds |
|---|---|---|---|---|
| **The Gold Phantom** | **1,58** | 2,47 | **8 / 8** | 11,7 % / 4,7 % |
| Smart Gold Hunter | 1,13 | 1,92 | 6 / 8 | 1,0 % / 0,6 % |
| The Gold Reaper | 1,50 | — | 4 / 4 | 18,6 % |

**Retenu : The Gold Phantom.** 6 387 trades, aucune annee perdante sur huit, lots 0,01 a
0,12 sur un compte passe de 10 k a 40 k. La degradation hors echantillon (2,47 -> 1,58)
est reelle mais il reste largement rentable sur des donnees qu'il n'a pas vues. **Prevoir
12 % de drawdown, pas 5 %.**

**Elimine : Smart Gold Hunter.** 2019 et 2020 negatifs, et surtout il est tres sensible
au modele de prix : sur 2023-2026 son PF tombe de 1,92 (barres M1) a 1,43 (ticks reels),
soit un quart. Applique au hors-echantillon, son 1,13 passe sous 1. Son commentaire de
trade est `@fundedtoday updatedV3` : c'est un reetiquetage.

**Ecarte : The Gold Reaper.** Meme base de code que Phantom (memes noms d'inputs). PF
comparable mais il **compose sans frein** : `StartLots=0.01` ne bride rien, il atteint le
plafond de 99 lots, 37 M$ simules, 44 % de drawdown flottant, et le testeur finit par
manquer de memoire. Pour le mesurer proprement il faut `ManualBalance=10000`, qui fige le
capital servant au calcul des lots.

**Why:** ces produits sont vendus sur des courbes 2023-2026 sans exception. Le seul test
qui separe un edge d'un surapprentissage est la fenetre anterieure.

**How to apply:** limite honnete a rappeler — PU Prime ne fournit des barres M1 que depuis
2018, donc **aucun de ces EA n'a ete teste en marche baissier de l'or**. Les deux fenetres
sont haussieres. Voir [[reperes-chiffres-or]] et [[backtest-acceptance-criteria]].

**Piege du testeur, rencontre trois fois.** Un passage peut tourner jusqu'au bout et sortir
un rapport HTML **vide** (`some error after pass finished`), typiquement par manque de
memoire. Le journal `Tester\logs\AAAAMMJJ.log` contient alors chaque deal avec son prix :
`scratchpad\rebuild.py` reconstruit PF, net, annee par annee et drawdown flottant a partir
de la. Verifie sur Phantom : reconstruction PF 2,33 contre 2,47 au rapport officiel.

## SON CHOIX DE PORTEFEUILLE — arrete le 30/08/2026 au soir

**Il retient DEUX briques : Wolf Scalper EURUSD a `AutoLot=3,5` et The Gold Phantom.**
Formulation exacte : *« A ce stade, mon choix est wolf eurusd autolot 3.5 et gold phantom.
A cela je voudrais ajouter d'autres EA actuellement en test. »*

**C'est un choix de portefeuille, pas un choix d'EA** : deux moteurs sans rapport (cassure
ZigZag sur devises H1 / gestion or M15), donc peu correles a priori — **la correlation reelle
n'est pas mesuree, c'est la premiere chose a produire.**

Comparaison qui a fonde le choix, rendement annuel divise par le creux :

| | %/an | creux | perf/risque |
|---|---|---|---|
| Wolf EURUSD `AutoLot` 4,5 | 52,5 % | 23,8 % | 2,20 -> 1,45 apres friction |
| **Wolf EURUSD `AutoLot` 3,5** | **39,5 %** | **18,8 %** | **2,10 -> 1,41** |
| Wolf EURUSD `AutoLot` 1,8 | 18,6 % | 9,8 % | 1,89 -> 1,30 |
| **The Gold Phantom** (barres M1) | 18,9 % | 11,7 % | **1,62** |
| Grille or / clone | 25,1 % | 45,0 % | 0,56 |
| Or, achat et conservation | 15,9 % | 24,4 % | 0,65 |
| son etalon | 10 % | 47 % | 0,21 |

**Il a choisi 3,5 et non 4,5** : la marche superieure ne gagne que 0,10 de rapport pour
5 points de creux en plus.

**RESERVES ATTACHEES A CE CHOIX, a lever avant tout engagement reel :**
1. **Phantom en ticks reels** — passe en cours au moment du choix. Smart Gold Hunter avait
   perdu un quart de son PF au passage (1,92 -> 1,43). Si Phantom fait de meme, son 1,58 hors
   echantillon tombe vers 1,19.
2. **Wolf est mesure hors commission**, sur prix Dukascopy, une seule paire, quatre ans.
3. **Correlation des deux briques jamais mesuree**, ni le creux du portefeuille combine.
4. **`AutoLot=3,5` n'a pas ete valide hors echantillon** au moment du choix (les moities
   tournaient a 1,8 et 4,5).

**La porte reste ouverte** : il veut y ajouter d'autres EA en cours de test — SafeScalperPro,
SafeScalperPro Prime, Smart Gold Impulse, Quant Valencia Gold, en file derriere Phantom
([[mt5-pieges-outillage]] : un seul terminal MT5 peut tester a la fois). AnaCristina est
multi-devises, reporte. `AlgosphereTerminal` et `Trade Manager AlgoSphereQuant` ne sont pas
des strategies.

## 31/08/2026, nuit — CE QUI EST TOMBE ET CE QUI RESTE BLOQUE

**RESERVE 4 LEVEE : le dimensionnement de Wolf EURUSD tient hors echantillon.**
`FixedLot=false`, trailing vendeur, deux moities independantes de 2 ans :

| `AutoLot` | 2022-2023 | 2024-2025 |
|---|---|---|
| 1,8 | +23,7 %/an, creux 9,83 %, PF 1,56 | +13,6 %/an, creux 6,43 %, PF 1,68 |
| 4,5 | +69,2 %/an, creux 23,82 %, PF 1,51 | +36,6 %/an, creux 15,93 %, PF 1,65 |

Positif sur les quatre, PF stable 1,51-1,68, **et le creux ne depasse jamais celui de la
fenetre complete**. Son choix de 3,5 est encadre des deux cotes.

**GOLD PHANTOM EN TICKS REELS — mesure, mais a ne pas surinterpreter.** XAUUSD.p M15,
2021.01.04 -> 2026.06.10, **307 346 046 ticks, qualite 99 %** : 10 000 -> **66 063**, soit
**41,6 %/an**, PF **2,12**, creux de fonds **5,23 %**, creux de solde 3,45 %, 4 625 trades.
Rapport perf/risque **7,95**.
**MAIS cette fenetre RECOUVRE celle que le vendeur a optimisee (2023-2026).** Le seul hors
echantillon connu reste 2019-2022 a PF 1,58. **La question posee — les ticks reels
degradent-ils Phantom ? — N'EST PAS TRANCHEE** : le 2,47 connu etait sur 2023-2026 en barres
M1, ce 2,12 est sur 2021-2026 en ticks reels. Fenetres differentes, l'ecart ne se lit pas.
**Il faut la passe temoin en barres M1 sur EXACTEMENT cette fenetre.**

**A COMPRENDRE : Phantom fait generer les ticks de DEUX symboles**, `XAUUSD.p` ET
`XAUUSD.crp` (470 M de ticks au total). Il ne travaille donc pas que sur le symbole donne.
Nature de `XAUUSD.crp` inconnue — a elucider avant de retenir ses chiffres.

**HYGIENE : 86 Go de journaux de testeur accumules**, dont **31 Go pour le seul passage de
Phantom** (il journalise chaque modification de position). Disque passe de 88 % a 70 % apres
nettoyage. **A purger regulierement** : `<terminal>/Tester/logs/` et
`AppData/Roaming/MetaQuotes/Tester/<hash>/Agent-*/logs/`.

**BLOQUE : plus aucun test MT5 ne demarre depuis 22h40**, sur AUCUN des deux terminaux, y
compris celui qui venait de faire tourner Phantom. Le terminal demarre, lit la configuration
(`successfully initialized from start config`), se connecte, **puis rien** : aucun agent,
aucun rapport, aucune erreur. Ecartes par mesure : l'EA (un EA maison echoue pareil),
l'autorisation MQL5 (active), le port 3000 partage (plus aucun agent), le disque (85 Go
liberes, echoue toujours). **Cause inconnue.** Deux pistes non traitees : une boite de
dialogue en attente a l'ecran, ou la recreation des agents
(`rm -rf AppData/Roaming/MetaQuotes/Tester/<hash>/`, terminaux fermes).

## 31/08/2026 — GOLD PHANTOM VALIDE : il est INSENSIBLE AU MODELE DE PRIX

**La question qui bloquait est tranchee.** Meme EA, meme symbole, meme fenetre
(XAUUSD.p M15, 2021.01.04 -> 2026.06.10), memes reglages d'origine, meme levier **1:500**,
depot 10 000 — **seul le modele de prix change** :

| modele | ticks | net | PF | creux fonds | trades |
|---|---|---|---|---|---|
| barres M1 | 7 685 525 | 60 933 | **2,19** | 5,06 % | 4 622 |
| **ticks reels** | 307 346 046 | 56 063 | **2,12** | 5,23 % | 4 625 |

**Cout des ticks reels : -8,0 % de net, -3,2 % de PF, +0,17 point de creux.** Quarante fois
plus de points de prix, **trois transactions d'ecart sur 4 600**.

**A comparer a Smart Gold Hunter : -25,5 % (1,92 -> 1,43)** — c'est ce qui l'avait elimine.

**Consequence sur le seul chiffre qui compte, le hors echantillon.** 2019-2022 valait **1,58**
en barres M1 ; en appliquant le meme rapport (0,968), il vaut **~1,53 en ticks reels**.
**Il reste franchement rentable sur quatre annees que le vendeur n'a pas vues.**
=> **Il valide son choix du 30/08.** Reserve 1 levee.

**PIEGE DE COMPARAISON EVITE DE JUSTESSE** : sa capture initiale etait en levier **1:100**
alors que la passe en ticks reels tournait en **1:500**. Verifie dans le rapport AVANT de
lancer. Sinon on aurait mesure deux choses a la fois.

**CORRECTION** : le second symbole `XAUUSD.crp` que j'avais cru voir chez Phantom **n'est pas
a lui** — son rapport dit « Symboles : 1 ». C'etait un reliquat d'un autre passage dans le
journal partage. Oublier cette piste.

**RESERVES QUI DEMEURENT, inchangees :**
1. **Aucune des fenetres testees n'est baissiere pour l'or** — PU Prime ne fournit des barres
   M1 que depuis 2018. Il n'a jamais ete mesure en marche baissier.
2. **Ses filtres de news ne s'appliquent pas dans le testeur** : ses parametres portent
   `UseMQL5Calendar=true` et `EnableNFP_Filter=true` (fermeture 100 min avant, reprise 60 min
   apres), or **le calendrier economique est VIDE dans le Strategy Tester**. En reel il
   s'abstiendra a des moments ou le backtest l'a fait trader. Sens de l'effet inconnu.
3. **Creux : prevoir 11,7 % (le hors echantillon), pas 5 %** (la fenetre du vendeur).

## 31/08/2026 — CRIBLE SUR FICHES : sa liste de candidats, et ce qu'elle revele

**Il veut construire un portefeuille diversifie en paires, strategies et unites de temps,
alimente par une recherche sur mql5.com.** Le scrapping automatique est impossible (les demos
passent obligatoirement par l'onglet Marche du terminal, aucune interface programmable), mais
la lecture des fiches donne des faits STRUCTURELS exploitables — jamais leurs performances.

**ELIMINES SUR PIECE (grille / moyennage) :**
- **Perceptrader AI** (EURUSD, GBPUSD, EURGBP M5) : multiplicateurs de grille
  `1,2,4,8,14,24,41,69` ecrits dans la fiche. Famille Goldinghedge.
- **Quantum Queen** (XAUUSD) : « grid strategy » ET « no averaging in » dans la meme page.
- **Luna AI Pro** (EURAUD, GBPCHF, GBPAUD M5) : « moyennage avec progression non geometrique
  de construction d'une grille », puis dementi dans la phrase suivante. **Scalpeur de NUIT** —
  la categorie la plus flattee par le testeur (ecart double vers minuit). Et TDS n'a aucune de
  ses paires principales.
- **SentinelAI** : produit **171982** (nouveaute 2026) annoncant « aucun mois perdant depuis
  aout 2019 » — donc un BACKTEST presente comme un palmares. Symbole contradictoire selon les
  passages (BTCUSD / EURUSD-GBPUSD).

**RETENUS, par ordre d'interet :**
1. **Artemis NAS100 ORB Edge EA — MT4** : cassure de plage d'ouverture Londres/New York,
   straddle OCO, plage de 15 min. **MT4 => TDS donne le Nasdaq 2011-2025, 527 M de ticks.**
   Seul candidat validable sur ~14 ans hors echantillon, et **vraie troisieme classe d'actif**.
   (Frere : **Artemis US30 Opening Bell MT4**, Dow 2011-2025, 365 M de ticks — equivalent,
   mais **ne pas prendre les deux** : meme seance, memes nouvelles, courbes quasi identiques.)
2. **Advanced Scalper (Profalgo) — MT4, produit 24254** : entrees sur cassure plus-haut/plus-bas,
   **H1/H4** (donc friction faible), **EURUSD et USDJPY** — 22 ans de ticks TDS. Produit ANCIEN,
   donc ayant survecu a la vente reelle. **Mais meme mecanisme et memes paires que Wolf
   Scalper : candidat pour le REMPLACER, pas pour s'y ajouter.** Meme vendeur que Luna AI Pro,
   donc verifier la progression des lots dans le test.
3. **MoonDog EA — MT5, XAUUSD** : stop et objectif sur chaque trade, martingale/grille/moyennage
   explicitement exclus. Bon sur le papier mais **produit 183924 = nouveaute sans historique**.
4. **XGen Scalper — MT4/MT5** : fiche qui ne s'engage sur rien (« tous les marches, tous les
   styles »), aucune mention de stop franc. Peu couteux a trancher, faible priorite.

**LE CONSTAT QUI COMPTE POUR SA DIVERSIFICATION : sept des onze de sa premiere liste tradent
l'OR** (MoonDog, Adaptive Gold Scalper, Gold-pip Miner, Quantum Queen, AI Gen XII, Fantastic 4,
Leto Apex Scalper). Avec Gold Phantom deja retenu, ils epaississent le meme risque au lieu de
le diviser — et **aucune fenetre de test disponible ne contient de marche baissier sur l'or**.

**CORRECTION D'UNE DE SES CROYANCES** : il pensait qu'AI Gen XII tradait aussi EURUSD et
GBPUSD. **Faux : XAUUSD uniquement, M30, MT4.**

**DEUX REGLES DE CRIBLAGE nees de ce passage :**
- **Comparer le NUMERO DE PRODUIT a l'historique revendique.** < 100 000 = ancien, a survecu a
  la vente reelle. > 160 000 = nouveaute 2025-2026, donc tout palmares anterieur est simule.
- **Un vendeur honnete RESTREINT son perimetre.** Le vendeur de Wolf ne livre que deux jeux, et
  on a mesure que les cinq autres paires perdaient. « Fonctionne sur tous les marches » est un
  aveu d'absence de mesure.

**LA CONTRAINTE DE DONNEES QUI COMMANDE TOUT LE CRIBLE — et il avait raison contre moi :**
j'ai dit que le hors echantillon etait impossible hors de l'or ; **c'est faux, TDS le fournit**.
Ticks Dukascopy disponibles (MT4 uniquement) :

| symbole | du | au | ticks |
|---|---|---|---|
| EURUSD, GBPUSD, USDCHF, USDJPY | **2003** | 2025-01-01 | 249 a 421 M |
| XAUUSD | **2003** | 2025-01-01 | 588 M |
| EURGBP, NZDUSD, USDCAD | 2003 | 2025-01-01 | 227 a 302 M |
| AUDCAD, AUDNZD, EURNZD, NZDCAD, NZDCHF | 2006 | 2025-01-01 | 269 a 393 M |
| DAX, S&P 500, Dow, Nasdaq | 2011 | 2025-01-01 | 151 a 527 M |
| Bitcoin | 2017 | 2025-01-01 | 398 M |

**=> Pour un EA existant dans les deux versions, la MT4 est PREFERABLE a la MT5** : 22 ans
d'historique contre 44 mois cote MT5 devises (68 mois sur XAUUSD.p). C'est l'inverse de ce que
je supposais. Reserve permanente : prix **Dukascopy**, pas ceux du courtier — depistage oui,
validation finale non, surtout sur indices. Donnees arretees au **01/01/2025**, les 8 derniers
mois sont a telecharger dans le gestionnaire TDS. Les indices exigent un **mappage manuel**
du symbole dans TDS (`USATECHIDXUSD` -> `NAS100`, `USA30IDXUSD` -> `US30`).

## 01/09/2026 — LE LEVIER QUI COMMANDE TOUT : abaisser le creux pour monter la taille

**Son raisonnement, et il est juste** : le plafond de creux est un BUDGET. Toute baisse du
creux a rendement constant rend de la place, qu'on reconvertit en taille.

**Le facteur de conversion est MESURE sur Wolf** (AutoLot 1,8 -> 4,5) :
taille x2,50 -> **creux x2,42, rendement x2,82**. Le rapport rendement/creux est donc
**invariant a la taille** — propriete d'un EA sans martingale.
Consequence chiffree : diviser le creux par 1,5 permet de multiplier le rendement par 1,65.

**MAIS le facteur d'echelle applicable AUJOURD'HUI est 1**, et il faut le dire a chaque fois :
- la loi d'echelle est mesuree sur Wolf, **jamais sur Phantom**, qui pese 75-80 % du couple ;
- la marge n'est pas verifiee a taille x8 ;
- le creux du couple repose sur 36 mois **sans marche baissier de l'or**.
J'ai produit deux fois des extrapolations absurdes (333 %/an, puis 547 %/an) en appliquant
un facteur 8 a un creux mesure sur la periode la plus favorable de Phantom. **Toute erreur
d'estimation du creux est multipliee par le facteur d'echelle.**

**=> PROCHAINE MESURE, LA PLUS RENTABLE DU DOSSIER : le dimensionnement de Gold Phantom**,
comme on l'a fait pour Wolf. Ses parametres de taille, releves dans son profil de testeur :

| parametre | valeur | role |
|---|---|---|
| **`MaxRiskPerStrategy_`** | **1.0** | **le levier a balayer** (plage 0,1 a 10) |
| `Risk` | 1234 | sentinelle, comme le 9999 d'Advanced Scalper |
| `StartLots` | 0.01 | lot de base |
| `ManualBalance` | 0.0 | 0 = le lot suit le solde ; le figer isole la strategie |
| `AdjustLotsizeToVariableValues` | true | |
| `PropFirmMaxDailyDD` | 0.0 | plafond de perte journaliere, desactive |

Balayage a faire : **0,5 / 1,0 / 2,0 / 3,0**, XAUUSD.p M15 ticks reels 2021-2026, et lire le
rapport rendement/creux a chaque niveau. Reference actuelle a 1,0 : **41,6 %/an, 5,23 % de
creux, ratio 7,95**.

## COMMENT IMPOSER DES PARAMETRES AU TESTEUR MT5 SANS L'INTERFACE

Le lancement par `/config:` **reste casse** sur cette machine (cause inconnue apres une dizaine
d'hypotheses eliminees). Mais on peut ecrire directement le fichier que le testeur relit :

`<terminal>/MQL5/Profiles/Tester/<nom EA>.set`, en **UTF-16**, avec l'en-tete
`; saved automatically on ...`.

**IMPERATIF : le terminal doit etre FERME pendant l'ecriture** — sinon MT5 le reecrit avec ses
propres valeurs a la fermeture. Constate le 01/09 : un preset charge par l'interface n'avait
pas pris, et le passage a tourne sur les valeurs d'usine sans que rien ne le signale.
Sequence : fermer le terminal -> ecrire le .set -> rouvrir -> verifier une valeur temoin dans
le fichier -> lancer.

Le format `.set` accepte `valeur||debut||pas||fin||drapeau` ; seule la valeur avant `||` compte.


**Correction du 04/09/2026** : « son choix Wolf EURUSD + Gold Phantom » est un choix, PAS une mise en route. Il m a repris : « Qui a dit que Wolf tournait ? ». Au 04/09, aucun relevé reel de Wolf n existe : tout ce qu on sait de Wolf vient de backtests MT4 en ticks modelises. Ne jamais ecrire qu un EA « tourne » sans l avoir vu dans un journal ou un releve.


**Correction du 05/09/2026** : il ne POSSEDE PAS Gold Phantom, seulement la demo Marche (testeur). « son choix Wolf + Gold Phantom » etait un choix envisage, pas un achat. Au 05/09 il ne possede aucun des robots or Profalgo ; UBS = version d essai v7.0 recue du vendeur.

**Prix et offre releves le 05/09/2026 (fiches MQL5)** : The Gold Phantom (produit 161561) **649 $**, location 349/399/499 $
(3/6/12 mois), v1.4 du 19/05/2026, 10 activations, **« 1 EA au choix offert (sauf UBS), limite a 2 comptes » a l'achat** ;
The Gold Reaper MT5 (111357) **949 $**, location 399/499/699 $, v4.6 du 19/05/2026, meme offre (1 EA offert, 3 comptes) ;
UBS (133653) 1 699 $, location 399/599/799/999 $, v7.5 du 28/08/2026. Donc **Phantom + Reaper offert = 649 $**.
**Signal reel Gold Phantom** (2355953, CapitalPointTrading, depuis le 27/01/2026, 33 semaines) : +25,5 % (788 € sur 3 091 €),
creux 8,56 % solde / 6,89 % fonds, 459 tr, PF 1,32, 64,5 % de reussite, 3 h de tenue moyenne → ~43 %/an pour 8,6 %,
rapport ~5, coherent avec le backtest ticks reels (5,2). Reaper reel : 111 %/an pour 16,9 % (rapport 6,6).
