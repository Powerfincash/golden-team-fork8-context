---
name: wolf-scalper-projet
description: "Projet suivant apres Goldinghedge : retro-ingenierie de Wolf Scalper, et le piege d'execution propre aux scalpeurs de cassure"
metadata:
  type: project
---

Demande le 29/08/2026 au soir, **a traiter APRES l'or** ([[feuille-de-route-clone]]).

**Ce qu'il en dit** : *« j'aimais bien cet EA ! un breakout scalper sur EURUSD et USDJPY en H1
travaillant en pending order sur zones cles »*.

## Pourquoi c'est plus simple que Goldinghedge

Peu d'etats internes : ni martingale, ni couverture, ni portes de sortie multiples. **Il n'y a
que deux choses a reconstruire** : comment il definit ses zones cles, et ou il pose ses stops.
La methode du 26-29/08 s'applique telle quelle — **ce sont les RAPPORTS DE BACKTEST du vendeur
qui portent les parametres**, c'est ainsi que Goldinghedge a ete craque (et je les avais sous
les yeux un jour entier avant de les regarder).

## Pourquoi c'est plus traitre — LE piege a anticiper

**Un scalpeur de cassure est bien plus sensible a l'execution qu'une grille.** Au moment precis
ou le prix casse une zone, le spread s'ecarte et le glissement apparait — et c'est exactement
l'instant ou il entre. **Meme en `Model=4`, le testeur ne simule ni le glissement reel ni
l'elargissement du spread sur pic de volatilite.** Il flattera donc systematiquement ce type de
strategie, comme les ticks generes flattaient la grille.

Repere deja etabli : **friction mesuree a 0,36 pip** ([[trading-friction-timeframe]]). Sur un
scalpeur, c'est la friction qui decide, pas la logique d'entree. **Chiffrer la friction AVANT
de juger un resultat.**

## LA LICENCE ET LE FICHIER — regle le 29/08 au soir

**Achat MQL5 legitime du 20/04/2025, 200 USD, "Wolf Scalper MT4", 17 activations restantes
sur 20.** Le vendeur a quitte le Marche, donc la fiche produit a disparu — **mais pas le droit
d'usage** : les achats restent telechargeables depuis l'onglet **Marche > Achats** du terminal,
en etant connecte au compte MQL5 acheteur (Outils > Options > Communaute). Fait ce soir-la.

**IL Y A DEUX COPIES DANS LE TERMINAL VANTAGE `F1BBCAACDA8825381C125EAF07296C41` :**

| chemin | taille | date | statut |
|---|---|---|---|
| `MQL4/Experts/Market/Wolf Scalper MT4.ex4` | 30 066 o | 29/08/2026 | **v2.0, sous licence — LA SEULE A UTILISER** |
| `MQL4/Experts/Wolf Scalper MT4.ex4` | 33 364 o | 19/09/2022 | **v1.625**, version anterieure, a ignorer |

**Ce sont deux VERSIONS differentes, pas deux compilations.** **v1.625 contre v2.0** : les reglages et le comportement de celle de 2022 ne disent
rien de la 2.0. **C'est la 2.0 qu'il faut reconstruire**, puisque
c'est elle qu'il ferait tourner. **Verifier le chemin `Market\` dans CHAQUE configuration de
test** — deux EA du meme nom dans le meme terminal, c'est le piege qui fait mesurer l'un en
croyant mesurer l'autre.

**Il possede aussi des copies crackees (MT4 et MT5) : ne pas travailler dessus.** La version MT5
n'existe donc pas legitimement pour lui — d'ou la necessite du clone MQL5.

## LES 23 PARAMETRES SONT DEJA EN NOTRE POSSESSION (29/08, dans `Downloads/Telegram Desktop`)

Deux rapports : `Wolf scalper live set risk 20 raw.html` et `... standard.html`.
**CE SONT DES RAPPORTS MT5, PAS MT4** — build 3446, « History Quality: **100% real ticks** »,
« Equity Drawdown Maximal », « OnTester result ». **Donc une version MT5 existe.**

```
Commentary=Wolf Scalper EA   MagicNumber=12345
Spread=12       Slippage=12      Depth=12
BuyShift=0      SellShift=0      UseBarsControl=true   DeletePending=false
FixedLot=false  Lot=0.1          DepoLoad=20
StopLoss=200    TakeProfit=200   TrailingStop=5        Expire=72
TimeControl=false  StartHour=1  StartMinute=50  EndHour=21  EndMinute=50
FridayClose=false  FridayTimeGMT=21:50
```

**Toute la mecanique tient dans quatre parametres** : `Depth` (profondeur de la zone cle),
`BuyShift`/`SellShift` (decalage de pose), `Expire` (peremption de l'ordre en attente), plus
SL/TP/Trailing. C'est bien plus simple que la grille couverte de Goldinghedge.

**Resultats annonces** — USDJPY H1, 01/09/2021 -> 31/08/2022, depot **200**, levier 1:500,
25 103 805 ticks reels :

| | |
|---|---|
| profit net | **3 490** (x18,4 en un an) |
| facteur de profit | 2,50 |
| trades | 424, dont **78,3 % gagnants** |
| creux d'equite | **32,68 %** (relatif 54,78 %) |
| **niveau de marge minimum** | **58,78 %** |

**LE POINT QUI ALERTE : marge minimale 58,78 %, quand la liquidation est a 50 %.** Il est passe
a un cheveu. `DepoLoad=20` en est la cause — le lot suit 20 % du depot, donc l'exposition grandit
avec le compte. C'est ce qui produit le x18 ET ce qui frole le stop-out.

**PROVENANCE : Telegram, pas lui.** Un seul an, un seul symbole, fenetre choisie par un tiers qui
voulait convaincre. **A traiter comme une piste, jamais comme un resultat** — le verifier
nous-memes sur les 44 mois de ticks reels disponibles (EURUSD.p et USDJPY.p, 01/2023 -> 08/2026).

## OUTILLAGE RESOLU LE 30/08 — TDS 2.3.17 FONCTIONNE

**Tick Data Suite 2.3.11 (12/2023) PLANTE sur MT4 build 1470** — `exception c0000005 address
0x00C99D9B`, reproductible, precede de « Unable to find the open/close order pattern ».
**La 2.3.17 (27/05/2026, compatible builds 940-1474) fonctionne.** Verifie : « TDS: Every tick
backtest using tick data from Dukascopy USDJPY », « TestGenerator: using variable spread »,
qualite **99,90 %**, 15,9 M de ticks sur six mois.

**Donnees deja presentes** (~4,5 Go) : USDJPY, EURUSD, XAUUSD **2003-2025**, plus DAX
(DEUIDXEUR), S&P 500, Dow, Nasdaq. Reserve permanente : ce sont les prix **Dukascopy**, pas
ceux du courtier reel — bon pour depister, insuffisant pour valider un scalpeur en dernier
ressort (le spread a la cassure est propre a chaque courtier).

**PIEGE MT4 : `TestExpertParameters` dans l'ini reste SANS EFFET.** MT4 lit les parametres dans
son propre fichier **`tester/<nom EA>.ini`**, bloc `<inputs>` au format etendu
(`Param=valeur` + `,F=` `,1=` `,2=` `,3=`). **C'est ce fichier qu'il faut modifier**, sinon
l'EA tourne sur ses defauts sans que rien ne le signale.

**Consequence mesuree** : avec les defauts (`FixedLot=false`, `AutoLot=5`), l'EA ouvre
**2,50 lots sur un depot de 10 000**. C'est ce dimensionnement qui produit les resultats
spectaculaires — pas la strategie. **Le vendeur, lui, recommande 0,25 lot FIXE**, dix fois
moins.

**Premiere mesure honnete** (defauts, USDJPY, 6 mois de 2024, ticks reels, spread variable) :
87 trades, profit net +245,88 sur 10 000, **facteur de profit 1,06**, creux 12,83 %. Tiede.

**Ses jeux USDJPY et EURUSD sont IDENTIQUES** (Depth=12, SL/TP=200, Trailing=20, Expire=100,
Lot=0.25 fixe) — seuls le commentaire et le magique changent. Changer de paire ne demande donc
que de changer le symbole : comparaison parfaitement propre.
**Son retour d'experience : EURUSD donnait les meilleurs resultats, GBPUSD pas terrible.**

## PREMIERE EVALUATION SERIEUSE — 30/08, ticks reels, spread variable, GLISSEMENT emule

Reglages du VENDEUR (`FixedLot=true`, `Lot=0.25`, `Depth=12`, SL/TP 200, Trailing 20,
Expire 100), depot 10 000, TDS 2.3.17, qualite **99,90 %**.

| | USDJPY (4 ans, 2021-2025) | EURUSD (5 ans, 2021-2025) |
|---|---|---|
| transactions | 673 | **817** |
| facteur de profit | 1,31 | **1,55** |
| profit net | 770,55 | **1 941,81** |
| rendement | 1,9 %/an | **3,6 %/an** |
| chute maximale | 2,54 % | **2,10 %** |
| **rapport rendement/creux** | 0,74 | **1,72** |
| ticks reels | 128 119 694 | 101 258 047 |

**Comparaison : le clone de l'or fait 25,1 %/an pour ~45 % de creux, soit un rapport de 0,56.**
EURUSD est **trois fois meilleur en risque ajuste**. Son retour d'experience est confirme :
EURUSD > USDJPY.

**LE POINT STRUCTUREL, plus important que les chiffres : Wolf Scalper est LINEAIREMENT
EXTENSIBLE.** Pas de martingale, pas d'echelle geometrique. Avec 2,10 % de creux, le risque est
fixe par la TAILLE DU LOT, pas par le mecanisme : x10 sur le lot donnerait ~36 %/an pour ~21 %
de creux. **La grille martingale, elle, ne se regle pas** — ses 45 % sont structurels et son
exposition s'emballe seule.

**GLISSEMENT : AFFIRMATION FAUSSE, CORRIGEE LE 30/08 AU SOIR.** J'avais ecrit « glissement
verifie, ma reserve principale est levee », en interpretant 817 ajustements de prix comme du
glissement emule. **C'EST FAUX.** Deux preuves concordantes :
- `config/tds.config` du terminal Vantage : `SlippageEnabled = False` ;
- journal TDS `AppData/Local/Tick Data Suite/log/` : **92 occurrences** de
  `ERROR Slippage during backtesting is not currently available for this MT4 build`,
  la derniere le 30/08 a 10:10. **MT4 est en build 1470 ; TDS 2.3.17 n'y sait pas emuler le
  glissement.**

**=> AUCUNE mesure Wolf Scalper n'inclut de glissement. La reserve principale est INTACTE.**
Les 392 ajustements etaient autre chose (modifications d'ordres par l'EA, remplissages au
spread variable) — j'ai nomme une cause sans la verifier, exactement l'erreur du GBPUSD.

**MAIS IL REDEVIENT MESURABLE — verifie le 30/08 au soir.** En remettant
`SlippageEnabled=True`, la passe tourne **sans aucune erreur** et le resultat change :
net **1 496,97** contre 1 621,11, PF **1,55** contre 1,62, creux 2,35 % contre 2,16 %.
**Cout du glissement : 124,14 $ sur 617 transactions = 0,080 pip aller-retour.**
Les 92 erreurs dataient toutes d'avant 10:10 le 30/08, avant la reinstallation de TDS.

**RESERVE SUR CE CHIFFRE** : le glissement de TDS est **symetrique**
(`FavorableSlippageChance=50`, `MaxFavorable=MaxUnfavorable=10`), donc favorable une fois sur
deux. **Un scalpeur de cassure entre et sort sur ordres STOP : le glissement reel y est
unidirectionnel, contre lui.** Les 0,08 pip sont donc un plancher, pas une estimation.

**COMMISSION : jamais appliquee non plus.** `OverrideCommissionSettings = False`,
`BaseCommission = 0`. Les resultats sont donc **bruts de commission**. Sur un compte brut type
(~7 $/lot aller-retour), a 0,25 lot, cela fait 1,75 $ par transaction — a comparer aux
**2,63 $ de gain moyen par transaction** d'EURUSD.

**RESERVES QUI DEMEURENT** : (1) prix **Dukascopy**, pas ceux du courtier reel — le spread et le
glissement a la cassure sont propres a chaque maison ; (2) ce sont les reglages du VENDEUR,
choisis par lui, possiblement sur cette periode — meme risque de selection dans l'echantillon
que notre coupure a 40 % ; (3) fenetres inegales (USDJPY s'arrete en 01/2025 faute de donnees).

**A FAIRE ENSUITE** : hors echantillon sur EURUSD (decouper 2021-2025), verifier si le trailing
de 20 points est applicable (`SYMBOL_TRADE_STOPS_LEVEL=30` chez ce courtier — l'avertissement
tombe a CHAQUE ouverture, 1 029 fois sur USDJPY), et tester les indices dont les donnees sont
la (DAX, S&P 500, Dow, Nasdaq).

## ZIGZAG CONFIRME + PROFIL DE GAIN + DEPENDANCE AU COURTIER (30/08, soir)

**TEST DECISIF DU ZIGZAG — CONCLUANT.** EURUSD 2022-2025, seul `Depth` varie :

| Depth | trades | PF | net | creux | net/creux |
|---|---|---|---|---|---|
| 6 | **1 127** | 1,20 | 1 219 | 3,40 % | 3,34 |
| **12 (vendeur)** | **617** | **1,62** | 1 621 | 2,16 % | **6,86** |
| 24 | **226** | 1,77 | 651 | 1,65 % | 3,82 |

**Le nombre de transactions varie a l'INVERSE de `Depth`** — signature exacte d'un ZigZag.
**Le 12 du vendeur est le meilleur en rapport gain/creux.** Son reglage est bien choisi.

**PROFIL DE GAIN — et le chiffre qui compte n'est pas le taux de reussite :**

| | trades | gagnants | gain moyen | perte moyenne | esperance | **reussite d'EQUILIBRE** |
|---|---|---|---|---|---|---|
| EURUSD | 617 | **87,2 %** | +7,85 | -34,72 | +2,63 | **81,6 % (marge 5,6 pts)** |
| USDJPY | 501 | 82,8 % | +5,64 | -24,72 | +0,82 | **81,4 % (marge 1,4 pt)** |

**Les pertes sont 4,6 fois plus grosses que les gains.** Tout repose sur le maintien du taux de
reussite. **USDJPY n'a qu'un point et demi de marge** — trois points de reussite en moins et il
passe sous zero. C'est l'explication chiffree de sa fragilite, bien plus parlante que le PF.

**DEPENDANCE AU COURTIER, MESUREE.** `TrailingStop=10` et `=20` donnent un resultat **identique
au centime** (1 621,11 / 236,40 / 617 trades), parametres verifies dans les rapports.
**Cause : `SYMBOL_TRADE_STOPS_LEVEL = 30` chez ce courtier — tout trailing plus serre est
refuse.** Le trailing du vendeur est donc **INOPERANT ici** et vaut en realite 30.
=> **Chez un courtier a ecart minimal plus faible, le comportement serait different de TOUT ce
qu'on a mesure.** A 40 (au-dessus du seuil) : net 1 805 contre 1 621, mais PF 1,55 et creux
2,50 % — meilleur en absolu, moins bon en rapport.

**L'OR EST REFUTE.** Parametres transposes par volatilite depuis les deux rapports du vendeur
(ATR H1 : EURUSD 131 pts, USDJPY 185, XAUUSD 667) :
- version EURUSD (stop 1 020, trailing 102) : **PF 0,45**, -2 973, creux 30,1 %
- version USDJPY (stop 720, trailing 72) : **PF 0,35**, -3 297, creux 33,1 %
**560 transactions dans les deux cas** — les entrees ne dependent que du ZigZag, pas du stop.

**=> PERIMETRE DEFINITIF : EURUSD et USDJPY, rien d'autre.** Sept paires et l'or testes.

## LA MECANIQUE EST CRAQUEE : WOLF SCALPER EST BATI SUR LE ZIGZAG STANDARD (30/08)

Revele par une ligne du journal du testeur :
`2021.01.04 01:00:00  ZigZag.ex4 GBPUSD,H1: array out of range in 'ZigZag.mq4' (161,32)`

**Les « zones cles » sont les pivots du ZigZag** — ses sommets et ses creux. Tout ce qui avait
ete mesure s'explique alors :
- **largeur d'encadrement variable** (42,5 pips medians, 10 a 183) = distance entre le dernier
  sommet et le dernier creux, qui varie naturellement ;
- **pas un cliquet** (196 descentes / 172 montees) = le pivot se deplace quand un nouvel
  extreme se forme ;
- **`Depth=12` est `ExtDepth` du ZigZag**, dont la valeur par defaut est justement 12.

**MODELE DE RECONSTRUCTION :**
```
buy stop  = dernier SOMMET du ZigZag(Depth, Deviation, Backstep)
sell stop = dernier CREUX  du ZigZag
SL / TP   = 200 points      trailing = 20 points      peremption = 100 HEURES
```
**`Expire=100` est en HEURES — etabli** : sur 58 expirations, duree de vie mediane 100,0 h et
**minimum exactement 100,00 h**. Les 734 `delete` (mediane 29 h, max 100 h) sont des annulations
decidees par l'EA lui-meme.

**DEFAUT MAJEUR DE L'EA, ET IL EST EXPLOITABLE CONTRE LUI** : le ZigZag plante des la deuxieme
barre quand l'historique est trop court au demarrage. **Apres cette erreur l'indicateur ne rend
plus rien et l'EA ne trade PLUS JAMAIS** — zero transaction sur 4 ans. En reel, cela signifie un
robot silencieusement mort apres un redemarrage de VPS. **Un `.ex4` interdit de le corriger ;
une reconstruction le corrige.**

**CONSEQUENCE SUR LES MESURES** : tout passage demarrant en 01/2021 est invalide pour les paires
touchees (GBPUSD, EURGBP, USDCAD, USDCHF, NZDUSD). **A refaire en demarrant en 2022.**
**EURUSD et USDJPY ne sont PAS touches** — verification : 498 + 319 = **817**, exactement le
total du passage de 5 ans.

**=> LA RECONSTRUCTION EN MQL5 DEVIENT REALISTE** : 200-300 lignes, le ZigZag existant nativement
en MT5. Elle permettrait de tout mettre sur une plateforme (marge partagee, donc le benefice de
diversification EURUSD/USDJPY joue au niveau du COMPTE), de s'affranchir d'un vendeur disparu, et
de corriger le plantage du ZigZag. **Reserve : le ZigZag MT5 n'est pas identique a celui de MT4 —
validation transaction par transaction obligatoire.**

## MECANIQUE RECONSTRUITE PAR MESURE — 30/08, depuis les rapports MT4

**L'EA n'a que 10 parametres** (la v1.625 en avait 23) : `Commentary`, `FixedLot`, `Lot`,
`AutoLot`, `StopLoss`, `TakeProfit`, `TrailingStop`, `Expire`, `Depth`, `MagicNumber`.
La 2.0 a supprime `Spread`, `Slippage`, `BuyShift`, `SellShift`, `UseBarsControl`,
`DeletePending`, `DepoLoad` et **tout le controle horaire**.

**POSE DES ORDRES — mesure sur 1 610 poses EURUSD (806 achat / 804 vente, parfaitement
equilibre : il encadre systematiquement).**

- **Ecart entre les deux ordres VARIABLE** : mediane **42,5 pips**, q1 30, q3 63, extremes 10
  et 183. Ce n'est donc PAS une distance fixe — la largeur suit un extreme recent.
- **L'ordre est reajuste en permanence** : mediane **10 modifications** par ordre (q3 20, max 88),
  pas median **0,2 pip**.
- **Ce n'est PAS un cliquet** : 196 buy stops descendent, 172 montent. Il suit un niveau qui
  bouge dans les DEUX sens — signature d'un **extreme glissant**.
- **Coherence avec `Depth=12` = 12 barres H1** : une demi-journee d'EURUSD, dont l'amplitude
  journaliere est de 60-70 pips, donne bien ~42 pips.
- **Heures de pose non uniformes** : creux la nuit (6 poses a 1h), pics a **11h et 16h serveur**
  — ouvertures de Londres et de New York.

**MODELE A TESTER :**
```
buy stop  = plus-haut des Depth dernieres barres H1
sell stop = plus-bas  des Depth dernieres barres H1
SL / TP   = 200 points depuis l'entree      trailing = 20 points      Expire = 100
```
**TEST DECISIF, sans donnee exterieure** : relancer avec `Depth=6` puis `Depth=24`. Si la
largeur mediane de l'encadrement se divise puis se multiplie, la regle est etablie.

**COMMENT L'EA GAGNE REELLEMENT — et ca change tout pour l'optimisation.**

| sortie | EURUSD | USDJPY |
|---|---|---|
| `s/l` | 800 sorties, +1 432,65, **87 % GAGNANTES** | 660, +459,29, 83 % |
| `t/p` | 17 sorties, +509,14 (**26 % du profit**) | 13, +311,23, 100 % |
| expiration | 58 | 85 |

**87 % des sorties « stop loss » sont GAGNANTES : c'est le TRAILING qui verrouille, pas le stop
de protection.** Le SL initial a 200 points ne sert presque jamais. Le take-profit ne tombe que
17 fois sur 800 mais vaut **17 fois plus par evenement**.

**LE CHIFFRE QUI COMMANDE TOUT : 1 432,65 pour 800 sorties a 0,20 lot = 1,79 par transaction,
soit MOINS D'UN PIP NET.** Marge de rasoir. Glissement median mesure 0,2 pip, plus le spread
variable. **Un courtier un demi-pip plus cher effacerait la moitie de l'avantage.**
=> **Le choix du courtier n'est pas un critere parmi d'autres, c'est LE critere.** Criteres
mesurables : spread AU MOMENT DE LA CASSURE (pas le spread moyen), glissement sur ordres stop,
et `SYMBOL_TRADE_STOPS_LEVEL` (30 points chez PU Prime, alors que le trailing recommande vaut
20 — l'EA emet lui-meme un avertissement a CHAQUE ordre).

**PISTES D'OPTIMISATION, par ordre d'interet :**
1. **Le trailing (20 points = 2 pips)** — il coupe tres tot, d'ou 87 % de gagnantes minuscules.
   L'elargir donnerait moins de gagnantes mais plus grosses. **Arbitrage central, un parametre.**
2. **Le take-profit** — rarement atteint, tres rentable quand il l'est.
3. **AMELIORATION HORS PERIMETRE DU VENDEUR** : il n'existe **aucun seuil d'activation du
   trailing**. Il suit des l'entree, ce qui explique qu'il coupe si tot. Ajouter « ne suivre
   qu'apres X points de gain » est simple, et c'est exactement ce qu'une reconstruction permet
   et qu'un `.ex4` interdit.
4. **Filtre de seance** — les poses se concentrent deja sur Londres et New York.
5. **`Depth` par instrument** — le vendeur met 12 partout.

## EURUSD PASSE LE HORS ECHANTILLON — 30/08. PREMIER RESULTAT VALIDE DES DEUX JOURS.

Decoupage en deux moities independantes, reglages du vendeur inchanges entre les deux :

| | facteur de profit | profit net | creux | trades |
|---|---|---|---|---|
| **EURUSD 2021 - 06/2023** | **1,59** | +1 238 | 1,19 % | 498 |
| **EURUSD 07/2023 - 2025** | **1,49** | +704 | 2,35 % | 319 |
| USDJPY 2021 - 06/2023 | 1,42 | +637 | 2,32 % | 421 |
| USDJPY 07/2023 - 2025 | **1,13** | +132 | 2,02 % | 252 |

**EURUSD tient sur les deux periodes sans rien regler entre elles.** C'est exactement ce que
Gold Stuff n'a pas fourni (t 0,55 puis 2,51) et ce qui a failli renverser la coupure de l'or.
**USDJPY se degrade nettement** (1,42 -> 1,13) : la paire principale est EURUSD.

**CORRECTION D'UNE CONCLUSION FAUSSE.** J'avais annonce que GBPUSD et EURGBP « ne tradent pas
du tout » et attribue ca a `SYMBOL_TRADE_STOPS_LEVEL`. **FAUX** : un diagnostic sur janvier 2024
donne **20 transactions**, soit ~240/an. Le passage de 5 ans annoncant zero etait un artefact
des ratés de lancement MT4 de l'apres-midi (instance unique). **Les resultats des cinq paires
autres que EURUSD/USDJPY sont donc SUSPECTS et refaits.**

**Lecon** : quand un resultat est structurellement bizarre (zero trade sur 114 M de ticks), le
verifier sur une fenetre courte AVANT d'en tirer une explication. J'ai fabrique une explication
plausible — l'ecart minimal de stop — pour un chiffre qui n'existait pas.

## SEPT PAIRES MESUREES — 30/08. LE POINT QUI DOIT ALERTER

Reglages du vendeur, 2021-2025, ticks reels, spread variable, glissement emule, 99,90 %.
**Symboles verifies un a un dans les rapports** (les 786 de USDCHF et NZDUSD sont une
coincidence, pas un doublon).

| paire | trades | facteur de profit | profit net | creux |
|---|---|---|---|---|
| **EURUSD** | 817 | **1,55** | **+1 942** | 2,10 % |
| **USDJPY** | 673 | **1,31** | **+771** | 2,54 % |
| USDCAD | 821 | 0,81 | -1 080 | 13,14 % |
| NZDUSD | 786 | 0,62 | -3 385 | 34,66 % |
| USDCHF | 786 | 0,62 | -3 555 | 37,30 % |
| GBPUSD | **0** | — | 0 | — |
| EURGBP | **0** | — | 0 | — |

**LES DEUX SEULES PAIRES RENTABLES SONT EXACTEMENT LES DEUX POUR LESQUELLES LE VENDEUR LIVRE
UN `.set`.** Trois autres perdent avec les memes parametres, deux ne tradent pas.

**Deux lectures, non tranchees :**
1. les parametres sont SPECIFIQUES a chaque paire (`Depth=12`, `SL=200` conviennent a ces deux
   la) — il faudrait regler par instrument avant de conclure ;
2. **le vendeur a retenu les deux paires qui marchaient sur l'historique** — selection sur le
   passe, sans raison de tenir demain.

**=> PRIORITE ABSOLUE : DECOUPER EURUSD HORS ECHANTILLON** (2021-2023 puis 2024-2025). Si
l'avantage tient sur les deux moities, lecture 1. S'il se concentre sur une periode, lecture 2.
**A faire AVANT d'ajouter d'autres actifs.**

**Les deux paires en LIVRE ne tradent pas du tout** — 0 ordre sur 114 M et 74 M de ticks.
Systematique, donc une condition de specification empeche la pose. Suspect le plus probable :
`SYMBOL_TRADE_STOPS_LEVEL` (30 points ici, l'EA emet un avertissement a chaque ordre).
**A verifier dans le journal du testeur** — ca eclairerait aussi pourquoi le vendeur ne livre
que deux jeux.

## A recuperer avant de commencer

- **ses rapports de backtest** (porteurs des parametres)
- **ses fichiers `.set`** s'il en a
- la version exacte de l'EA

Ne pas decompiler le `.ex4` — contrainte permanente. La reconstruction se fait par la mesure.

## 30/08 AU SOIR — LE SEUIL DE RUPTURE, ET LE TRAILING SERRE EST UNE FAUSSE PISTE

**Outil decouvert : `config/tds.config` dans le dossier de donnees du terminal.** TDS peut
forcer, symbole par symbole, `OverrideStopsLevel`, la commission, le levier, les swaps, le
spread. **On peut donc simuler un AUTRE courtier sans changer de terminal ni de donnees** —
experience a un seul facteur, ce qu'un changement de courtier ne permet jamais (il change le
spread, les specs et l'historique en meme temps). Sauvegarder le fichier avant, le restaurer
apres.

**Detour Ultima Markets inutile et instructif** : niveau de stops mesure par lui a **0 sur
EURUSD et USDJPY** (20 chez Ultima sur d'autres paires, 30 chez PU Prime). Mais le terminal
Ultima n'a **aucun historique de prix** : trois passes rendues a **0 tick modelise, 0 trade**.
Les reglages TDS sont **par installation MT4** (`config/tds.config`), un terminal neuf part
desactive. **Toujours verifier « Ticks modelises » avant de lire un resultat.**

**TEMOIN REPRODUIT A L'IDENTIQUE** (EURUSD, 2022-2025, Depth 12, SL/TP 200, Trailing 20,
Lot 0,25 fixe, 84 573 964 ticks, qualite 99,90 %) : net **1 621,11**, PF **1,62**, creux
**236,40 (2,16 %)**, **617** transactions, brut +4 224,96 / -2 603,85.

**LE CHIFFRE QUI COMMANDE TOUT LE PROJET : l'avantage entier vaut 1,05 pip par transaction,
aller-retour.** Soit 2,63 $ sur 0,25 lot. Sensibilite calculee depuis le brut/net du temoin :

| cout ajoute par transaction | net | PF |
|---|---|---|
| aucun (toutes nos mesures) | 1 621 | 1,62 |
| friction mesuree 0,36 pip/cote | 1 066 | 1,34 |
| commission 7 $/lot a/r | 541 | 1,15 |
| glissement 0,36 pip/cote | 511 | 1,14 |
| **les deux ensemble** | **-569** | **0,88** |

**Seuil de rupture : 10,51 $/lot aller-retour, ou 1,05 pip de friction totale.**
Les deux cotes sont defavorables : l'entree est un ordre stop, la sortie aussi (le trailing
ferme 87 % des positions). Le glissement joue contre, jamais pour.

**LE TRAILING SERRE DEGRADE — mesure, contre mon estimation.** Meme donnees, meme courtier,
seul `StopsLevel` force a 0 :

| | bride a 30 (trailing reel 3 pips) | **stops level 0 (trailing reel 2 pips)** |
|---|---|---|
| net | 1 621 | **1 111 (-31 %)** |
| PF | 1,62 | 1,56 |
| creux | 2,16 % | 1,67 % |
| gain par transaction | 1,05 pip | **0,72 pip** |
| **commission de rupture** | 10,51 $/lot | **7,19 $/lot** |

**=> CHERCHER UN COURTIER A ECART MINIMAL FAIBLE EST UNE FAUSSE PISTE.** Le bridage a 30 points
de PU Prime *aide* l'EA en l'empechant de couper trop tot. A 2 pips de trailing, le seuil de
rupture (7,19 $/lot) est **exactement le tarif d'un compte brut ordinaire** : l'EA y
travaillerait a zero, glissement non compte.

**Mon estimation prealable annoncait une marge residuelle de 1,5 point de taux de reussite. La
direction etait bonne, l'ampleur fausse : le trailing serre coute un tiers du resultat.**

## L'AMELIORATION A MESURER EN PREMIER : UN SEUIL D'ACTIVATION DU TRAILING

**Ce que la mesure du 30/08 designe.** Forcer `StopsLevel=0` fait tomber le net de 1 621 a
1 111 (-31 %) : **le trailing serre coupe trop tot**. Or l'EA du vendeur n'a
**aucun seuil d'activation** — il suit des l'entree. C'est la cause directe, et elle se corrige
en une ligne dans un clone, jamais dans un `.ex4`.

**La regle a ajouter :**
```
si (gain courant en points >= InpSeuilTrailing)  alors suivre a InpTrailing
sinon                                            laisser le stop initial a 200 points
```
Un seul parametre neuf. `InpSeuilTrailing = 0` reproduit exactement le vendeur : **le clone
reste donc validable transaction par transaction contre l'original** avant d'activer quoi que
ce soit. Balayage a mesurer : 0 (temoin) / 20 / 40 / 80 / 150 points.

**Ce qu'on attend, et comment le juger.** Moins de gagnantes, mais plus grosses. Le vrai
critere n'est ni le PF ni le net : c'est le **gain net par transaction rapporte au seuil de
rupture de 1,051 pip aller-retour**. Une variante qui gagne moins au total mais plus PAR
TRANSACTION est meilleure, parce qu'elle achete de la marge contre la friction.
Repere existant qui va dans ce sens : `TrailingStop=40` (au-dessus du bridage, donc reellement
applique) donne 2,93 $/transaction contre 2,63 au temoin.

**Deuxieme piste, meme logique** : le take-profit. 17 sorties sur 800 mais **26 % du profit**.
Laisser courir plus souvent, c'est exactement ce qu'un seuil d'activation permet.

**Voir [[garde-fous-mesure]]** : ne pas annoncer l'effet avant de l'avoir mesure. J'ai deja
qualifie une piste de « decouverte la plus utile de la journee » avant simulation, et elle
valait 7,2 %/an contre 15,9 pour ne rien faire.

## BALAYAGE COMPLET DU TRAILING — 30/08 au soir. EURUSD, 2022-2025, 84 573 964 ticks

**A RETENIR EN UNE PHRASE : le 20 du vendeur devient 30 chez PU Prime, et 30 est le bon.
Il n'y a RIEN a changer au jeu de parametres.**

Le parametre demande n'est pas celui qui s'applique : `SYMBOL_TRADE_STOPS_LEVEL = 30` chez ce
courtier ecrase toute valeur inferieure. **Le seul geste a retenir : chez un courtier SANS
distance minimale (Ultima Markets : 0 sur EURUSD et USDJPY), il faudrait ecrire 30 ou 40
EXPLICITEMENT**, sinon le 20 s'appliquerait vraiment et couterait un tiers du resultat.

| TrailingStop | trades | net | PF | creux | par transaction |
|---|---|---|---|---|---|
| 20 reellement applique | 618 | 1 111 | 1,56 | 1,67 % | 0,72 pip |
| **20 -> bride a 30 (vendeur)** | 617 | 1 621 | **1,62** | **2,16 %** | 1,05 pip |
| 40 | 617 | 1 805 | 1,55 | 2,50 % | 1,17 pip |
| 50 | 617 | 1 497 | 1,36 | 2,99 % | 0,97 pip |
| 60 | 617 | 1 379 | 1,28 | 5,10 % | 0,89 pip |
| 80 | 617 | 1 562 | 1,25 | 3,76 % | 1,01 pip |
| 120 | 617 | 1 658 | 1,20 | 5,06 % | 1,07 pip |
| **200 (= le stop : pas de trailing)** | 617 | **2 051** | 1,18 | **6,55 %** | **1,33 pip** |

**Le nombre de transactions ne bouge pas** (617) : les entrees ne dependent que du ZigZag.

**REPONSE NON MONOTONE** — 1,17 a 40, retombe a 0,89 a 60, remonte a 1,33 a 200. Meme signature
que le coefficient K de la grille or. **Optimiser sur cette fenetre serait choisir du bruit :
seuls les deux bouts s'interpretent.**

**ET LES DEUX BOUTS DISENT LA MEME CHOSE : le trailing ne CREE pas de gain, il ACHETE du creux.**
Sans trailing du tout : meilleur net (2 051) et meilleure resistance a la friction (1,33 pip
contre un seuil de rupture a 1,05), mais creux triple. Rendement rapporte au creux :
**750 pour le vendeur contre 313 sans trailing**. Le reglage du vendeur est le meilleur en
risque ajuste, 40 est son egal.

**=> C'EST LA JUSTIFICATION MESUREE DU SEUIL D'ACTIVATION** (section precedente) : laisser
courir comme a 200 tant que le gain n'est pas acquis, puis proteger comme a 30. C'etait une
intuition ; c'est desormais la seule facon d'avoir les deux bouts a la fois.

## RECONSTRUCTION MQL5 — SA CORRECTION DU 30/08 : LA FIDELITE N'EST PAS L'OBJECTIF

J'avais pose comme condition que le clone reproduise l'original transaction par transaction, et
presente la difference entre le ZigZag de MT4 et celui de MT5 comme un RISQUE. **Il a corrige :
*« si le zigzag de MQL5 est mieux pour cet EA, il vaut mieux le garder »*.** Il a raison.

**La reproduction transaction par transaction est un OUTIL DE DIAGNOSTIC, pas un objectif.**
Elle sert a savoir si un ecart vient d'un bug de ma part ou d'une vraie difference entre les
deux indicateurs. Une fois qu'on le sait : **on garde le meilleur, pas le plus conforme.**

**Consequence sur la conception du clone** : il porte LES DEUX, et le choix devient un
parametre — le ZigZag natif de MT5, ou un portage fidele de celui de MT4. L'algorithme du
ZigZag standard est public : le porter n'est PAS du decompilage, la contrainte permanente est
respectee. Une passe chacun, memes ticks, meme fenetre.

**LA PRECAUTION QUI DECIDE** : gagner sur la fenetre complete ne suffit pas. **Il faut gagner
sur les DEUX MOITIES**, sinon on aura choisi du bruit — exactement le piege qu'on est en train
de verifier sur le trailing, dont la reponse s'est revelee non monotone.

Voir [[methode-de-travail]] : c'est la deuxieme fois dans la soiree qu'une de ses questions
corrige un cadrage que j'avais pose seul.

## 01/09/2026 — ADVANCED SCALPER MESURE SUR 21 ANS : valide mais tres inferieur a Wolf

Huit jeux du vendeur (4 EURUSD H1, 2 USDJPY H1, 2 USDJPY H4), **lot fixe 0,01**,
2003-2024, ticks reels Dukascopy, qualite 99,90 %. **Les huit sont positifs.**

| jeu | net | PF | creux |
|---|---|---|---|
| **USDJPY H1 SL22** | 4 901 | **1,40** | **6,23 %** |
| USDJPY H4 SL17 | 4 348 | 1,24 | 17,77 % |
| USDJPY H4 SL14 | 4 037 | 1,22 | 16,27 % |
| EURUSD H1 SL22 | 3 248 | 1,30 | 7,81 % |
| EURUSD H1 SL18 | 2 948 | 1,22 | 12,91 % |
| USDJPY H1 SL30 | 2 661 | 1,28 | 11,48 % |
| EURUSD H1 SL14 | 1 364 | 1,11 | 17,35 % |
| EURUSD H1 SL17 | 1 081 | 1,08 | 24,49 % |

**MAIS la combinaison decoit : 1,3 %/an pour 11,81 % de creux, ratio 0,11.**
**Correlation moyenne entre les huit : +0,382** — huit variantes de la MEME strategie sur deux
paires perdent largement ensemble. Le creux du groupe DEPASSE celui de plusieurs jeux seuls.
A comparer : Wolf EURUSD sous friction **1,09**, Gold Phantom **7,95**.
**=> Ecarte comme jambe principale.** Seul `USDJPY H1 SL22` merite un examen, non pour sa
performance mais pour sa correlation eventuelle avec les deux jambes existantes.
Chiffres **hors commission** : sur un avantage aussi mince, elle serait fatale.

**TROIS PIEGES DE MESURE RENCONTRES SUR CET EA, tous silencieux :**
1. **Valeurs d'usine** : sans conversion du .set, MT4 tourne sur ses defauts — compte detruit
   en un an, puis 20 ans sans une transaction, le rapport affichant toujours 21 ans.
2. **.set MT5 donne a un EA MT4** : `Entry_Timing=16385` (PERIOD_H1 en MQL5) la ou MQL4 attend
   60 minutes. **Zero transaction, aucune erreur.**
3. **Dimensionnement du vendeur** (`LotPerBalance_step` 120 ou 200) : le lot suit le solde, donc
   sur 21 ans il enfle jusqu'a ce qu'un mauvais passage emporte tout — 86 a 99 % de creux.
   **Mesurer d'abord a LOT FIXE MINIMAL pour isoler l'avantage, dimensionner ensuite.**
   C'est la methode etablie sur Wolf, appliquee ici avec six heures de retard.

**ASQ Safe Scalping (= version libre de SafeScalperPro, source MQL5 disponible)** : XAUUSD M5,
307 M de ticks reels. Valeurs d'usine **9 763,71**, preset Phase1 **9 271,18** — **perdant dans
les deux cas** sur 5,4 ans. Reste a mesurer son preset `XAUUSD_M5_v2`, produit de 500 passages
Monte Carlo : s'il est gagnant sur cette meme fenetre, l'ecart mesure l'ajustement, pas un
avantage. Les fichiers `Phase1` a `Phase4` du vendeur sont un **mode d'emploi de
surapprentissage** : optimisation sequentielle sur le meme jeu d'entrainement.

## AdvScalp USDJPY H1 SL22 — GARDE EN OPTION comme 3e jambe (01/09/2026)

**Retenu pour sa DECORRELATION, pas pour sa performance.** Correlation **+0,017 avec Gold
Phantom, +0,057 avec Wolf** — la meilleure du dossier, tres loin des +0,19 entre les deux
jambes principales.

**Hors echantillon, lot fixe 0,01, ticks reels :**

| fenetre | net | PF | creux | trades |
|---|---|---|---|---|
| complete 2003-2024 | 4 901 | 1,40 | 6,23 % | 3 449 |
| moitie A 2003-2013 | 1 004 | **1,12** | 6,23 % | 1 624 |
| moitie B 2014-2024 | 3 945 | **2,13** | 0,82 % | 1 825 |

Positif sur les deux moities — il passe. **Mais le produit date de 2018** : dix des onze
annees de la moitie B lui etaient connues. Le chiffre honnete est donc **1,12 sur dix ans
qu'il n'a jamais vus**, pas 1,40.

**Apport mesure au portefeuille**, a risque egalise (chaque jambe ramenee a 1 % de creux
mensuel avant melange, fenetre commune 2022-2024) :

| melange | %/an | creux | ratio |
|---|---|---|---|
| sans lui : 44 % Wolf / 56 % Phantom | 7,4 % | 0,48 % | 15,49 |
| **avec lui : 50 % / 40 % / 10 %** | 6,2 % | **0,37 %** | **16,87** |

**Creux -23 %, ratio +9 %.** En budget de risque : taille x1,3 donc rendement x1,35.
**=> A retenir a 10-15 % du portefeuille, pas plus.** Les 10 % exacts sont un optimum trouve
apres coup sur une fenetre de 36 mois — un poids rond est plus honnete.


**05/09/2026 — il possede Wolf Scalper MT4 (preuve d achat MQL5 montree ; je l avais oublie et j ai mis en doute la provenance du .ex4 : « Tu es grave ! »). Ne plus jamais remettre en question cet achat. Le .ex4 est dans MQL4xperts (pas Market), c est normal pour sa copie.**

**05/09/2026 — premier chiffre de Wolf hors testeur** : Myfxbook 9888801 « Wforex Wolf MT5 », demo World Forex, 11/12/2022
→ 16/01/2023, 56 transactions, +18,9 %, creux 5,2 %, PF 3,04, reussite 80 %, gain +5,8 pips / perte −15 pips,
**+1,7 pip par transaction contre +0,9 en backtest**, tenue 12 min, ~0,21 lot sur 3 000 $. Cadence 3,5x le backtest.
Signe attendu, t ≈ 1,9, demo (pas de glissement reel). Essai PU Prime en cours depuis le 05/09 19h21 (0,01 lot).
Page privee : lisible seulement via son Chrome connecte a Myfxbook (compte « cashinvestclub »).

**Precision de l utilisateur (05/09)** : World Forex est le courtier utilise par le CONCEPTEUR de Wolf ; le compte Myfxbook 9888801 est donc vraisemblablement la vitrine demo du vendeur (5 semaines, conditions choisies par lui) : a lire comme une borne haute, pas comme un test independant. Le test independant est notre demo PU Prime.

**05/09** : Wolf Scalper N EST PLUS VENDU nulle part (« Tu deconnes ? »). Ne jamais parler de location ni d achat pour Wolf : il le possede (17 activations), l etape reelle = activer sa licence sur un compte reel au lot minimal.

**05/09** : il possede Wolf en MT4 SEULEMENT (licence). Sa copie MT5 « n est pas frequentable » (origine non sure) : ne jamais la lancer. L essai demo tourne en MT4 sur la copie Market sous licence. La vitrine Myfxbook du concepteur etait en MT5 : deux versions et deux courtiers d ecart avec notre essai.

**05/09 — compte REEL tiers (Myfxbook 7964017, dauub, Hugo s Way MT4, 10/2020-09/2021)** : 28 384 tr, +170 % (abs +33,6 %), creux 24,5 %, PF 1,77, reussite 66-68 %, +5,0/−11,9 pips, esperance −0,5 pip mais +2,62 $, pire trade −125 pips, 7 mois positifs puis −21,9 % et arret. Geometrie de Wolf mais pas notre reglage (2 800 tr/mois, stop bien au-dela de 20 pips). Borne reelle : ~0 pip d avantage par trade chez un courtier ordinaire.

**05/09 — courtiers recommandes par le concepteur de Wolf (Dmitry Kondrashov, capture)** : Tickmill Raw, Fusion Markets Zero, RoboForex Prime = comptes a ecart brut + commission. Coherent avec un avantage de ~1 pip. Notre demo PU Prime (ecart standard) est le test le plus dur. Proposition faite : demo Fusion Markets Zero en parallele (il a deja un compte reel Fusion 2036866 — mot de passe a changer, ancien terminal Fusion = celui de la DLL suspecte, ne pas le reutiliser).


## CORRECTION MAJEURE DU 06/09/2026 — LE COURTIER VAUT 40 % DU RESULTAT

**Ce qui etait ecrit ici est FAUX et doit etre lu a l'envers.** La section « CHERCHER UN COURTIER A
ECART MINIMAL FAIBLE EST UNE FAUSSE PISTE » concluait que le bridage a 30 points de PU Prime *aidait*
l'EA en l'empechant de couper trop tot. **Le clone MQL5 prouve le contraire.**

**Comment la correction a ete obtenue.** Le clone (`CloneWolf_v2`, retard de pivot 14) reproduit deja
la structure de l'original — 1 617 ordres contre 1 610, memes distances au marche, memes proportions de
sorties (97,7 % au stop contre 97,9 %). Restait un ecart de rentabilite. Balayage du suivi de stop,
EURUSD 2021-2025 ticks reels, tout ramene a 0,01 lot :

| configuration | entrees | sorties au stop | gain moyen par sortie au stop | net |
|---|---|---|---|---|
| **ORIGINAL** | 817 | 800 | **+7,2 pt** | **+77,7 $** |
| clone, **suivi 10, minimum 0** | 788 | 776 | **+6,8 pt** | **+76,5 $** |
| clone, suivi 20, minimum 30 | 785 | 767 | +1,3 pt | +45,3 $ |

**Le net est reproduit a 1,5 % pres avec un suivi de 10 points SANS bridage.** Le bridage a 30 divise
le gain par sortie par cinq et coute **40 % du resultat**.

**Consequence operationnelle, qui inverse la precedente :** le choix du courtier n'est pas neutre, il
vaut 40 % du resultat de Wolf. **Il faut un courtier a distance minimale NULLE ou tres faible sur
EURUSD** — Ultima Markets etait mesure a 0 sur EURUSD et USDJPY, PU Prime a 30. Verifier
`SYMBOL_TRADE_STOPS_LEVEL` avant de choisir ou porter la jambe EURUSD.

**Ce qui reste vrai** de l'ancienne section : le nombre de transactions ne depend que du ZigZag, jamais
du stop ; et `TrailingStop=10` et `=20` donnaient un resultat identique **chez PU Prime**, ce qui etait
la trace du bridage, pas une propriete de l'EA.

**Etat du clone au 06/09 :** entrees resolues (retard de confirmation du pivot = 14 barres ; la valeur
12, egale a la profondeur du ZigZag, donne 1 741 ordres et une distance mediane de 318 pt contre 320).
Sorties resolues (suivi 10, minimum 0). **Hypothese des 72 heures REFUTEE** : 182 ordres au lieu de
1 610, poses a 666 pt du marche.

**Piste ouverte par lui le 06/09** : le concepteur affirme que Wolf se configure sur DAX, SP500 et l'or
avec un jeu adapte. **L'or a deja ete refute le 30/08** avec des stops transposes par volatilite
(PF 0,45 et 0,35) — mais le stop ne change PAS les entrees. Le seul parametre qui les change est
`Depth`, que le vendeur laisse a 12 partout et que nous n'avons jamais fait varier par instrument.
**Le clone le permet** : balayage de profondeur sur XAUUSD, DAX et SP500 en ticks reels, a faire.
