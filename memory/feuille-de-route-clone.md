---
name: feuille-de-route-clone
description: "Ce que l'utilisateur veut faire du clone APRES sa validation - diversification multi-actifs en sous-comptes compartimentes"
metadata: 
  node_type: memory
  type: project
  originSessionId: 82d3828f-2f80-4d36-bead-d03e08c7569e
  modified: 2026-08-26T15:23:28.039Z
---

Enonce par lui le 26/08/2026, spontanement, « je comptais t'en parler apres la validation
du clone ». **Rien de tout cela ne se deduit du code** : c'est son intention, et elle
explique des choix deja faits.

**STATUT DE CE DOCUMENT, dit par lui le meme jour et a respecter :**

> « Ce que j'ai mis ici n'est pas une verite mais une piste de reflexion pour savoir dans
> quelle direction aller. Tout ceci est revisable mais l'important est que la ligne de
> conduite soit connue et tentee d'etre appliquee. »

Donc : **un cap, pas une these a refuter.** Les reserves notees plus bas sont des choses a
mesurer en chemin, pas des objections a lui opposer. La bonne posture est de tenir le cap
et de le corriger sur des chiffres — pas de rouvrir le debat a chaque session ni, a
l'inverse, d'appliquer le plan sans le verifier.

## Pourquoi MT5 et pas MT4

**Le choix de coder le clone en MQL5 etait deja motive par cette suite.** Ce n'etait pas
une preference technique : MT5 permet le multi-actifs dans un seul compte, ce que MT4 ne
fait pas proprement. A ne pas remettre en cause sans le lui dire.

## Le montage cible : trois sous-comptes compartimentes

Au sein d'un compte global unique, trois poches etanches :

| sous-compte | actifs |
|---|---|
| 1 | **XAUUSD + AUDUSD** |
| 2 | **EURUSD + USDCHF** |
| 3 | **USDCAD + NZDUSD** |

**But recherche : diminuer le drawdown dangereux sur l'or par diversification.** La
gestion s'appuierait sur **les outils deja developpes pour MultiStrategyEA** — qui
possede deja un garde de correlation (`InpCorrelationThreshold = 0.6`,
`InpCorrelationLookbackDays = 20`) et une gestion d'exposition.

Et cela s'articule avec le montage deja decide : un compte pour Goldinghedge, un second
**alimente chaque vendredi** par ses gains et gere par **Gold Phantom**.

## Sa piste sur le clone, et ce que les mesures en disent

Il pense que **le clone sera plus performant que l'original parce qu'il fait plus de
trades** — « meilleure circulation du capital et moins de DD ».

**Les mesures du 26/08 pointent dans l'autre sens — a verser au dossier, pas a brandir :**
chaque fois qu'on a augmente la cadence du clone, le drawdown a **empire**, jamais
diminue. Le clone a fait 9 715 transactions pour un PF de 0,88 et 79 % de drawdown, la
ou l'original en fait autant pour un PF de 1,41 et 13 %. Sur une grille, plus de trades
signifie **une echelle qui s'empile plus vite**, ce qui a tue le compte quatre fois dans
la meme journee.

Nuance a garder : le clone fait aujourd'hui plus de trades **parce qu'il est faux**
(espacement 1,80 contre 2,26 mesures), pas parce qu'il serait meilleur. Une fois
conforme, sa cadence rejoindra celle de l'original. **En l'etat, sa piste confond un defaut avec une
fonctionnalite** — ce qui n'enleve rien a sa direction, seulement a l'argument qui la
soutient aujourd'hui. En revanche, la version legitime de son idee existe : une fois le clone
valide, on peut deliberement le regler ailleurs sur la courbe risque/rendement — mais
c'est un exercice d'optimisation, distinct du clonage, et il vient APRES.

## Un parametrage PAR ACTIF, decide le 26/08

**Confirme par lui : chaque actif aura ses propres parametres, comme cela avait ete fait
dans MultiStrategyEA.** Ce n'est pas une option, c'est la conception retenue.

La raison est mecanique et chiffree : les parametres de l'original sont en **points
absolus**, et un point ne vaut pas la meme chose d'un actif a l'autre.

| | `Step = 80 points` | rapporte au prix |
|---|---|---|
| XAUUSD a 4 700 | 0,80 | **0,017 %** |
| EURUSD a 1,08 | 0,0008 | **0,074 %** |

Le meme reglage est **quatre fois plus large en relatif** sur EURUSD : la grille y poserait
des niveaux tres espacies par rapport a l'amplitude du marche, donc peu de remplissages et
peu de paniers. Et le resserrer ramene le probleme inverse — l'echelle qui s'empile trop
vite, ce qui a tue le compte quatre fois le 26/08.

**Consequence : « ajouter le forex » n'est pas une etape, ce sont six calibrages**, chacun
avec sa propre validation contre des criteres poses d'avance. Une poche qui ne produit
rien ne compense rien.

**Et un chiffre a ne pas oublier : les 38 $/semaine, le pire flottant de −4 784 et les
1 124 paniers sont des mesures SUR L'OR.** La production d'une grille sur EURUSD n'a
jamais ete mesuree. Toute l'arithmetique de la diversification repose dessus. C'est
mesurable une paire a la fois avec le clone, en une passe de vingt secondes.

## Point a mesurer avant de batir les trois poches

**Les paires choisies ne sont pas independantes**, et c'est mesurable plutot que
supposable :
- **XAUUSD et AUDUSD** sont positivement correles (tous deux matieres premieres / appetit
  au risque) — les mettre ensemble concentre le risque au lieu de le diluer.
- **EURUSD et USDCHF** sont fortement NEGATIVEMENT correles, quasi en miroir — deux
  grilles opposees peuvent s'annuler, ce qui reduit le DD mais aussi le rendement.
- **USDCAD et NZDUSD** portent tous deux une exposition au dollar, de signes opposes.

**A faire avant de coder quoi que ce soit : mesurer les correlations reelles sur
l'historique disponible, et verifier que la compartimentation reduit vraiment le DD
agregat.** Ne pas prendre la diversification pour acquise du seul fait qu'il y a plusieurs
actifs.

**Why:** il a annonce cette suite de lui-meme, elle explique le choix de MQL5 et elle
mobilise MultiStrategyEA. La perdre reviendrait a lui refaire expliquer sa propre
strategie.

**How to apply:** ne rien lancer de tout cela **avant la validation du clone** — c'est sa
propre consigne. Voir [[lazyalgo-multistrategy-state]], [[backtest-acceptance-criteria]]
et [[goldinghedge-exploitation]].

## MULTI-ACTIF : ce que les mesures mono-actif ne disent PAS (sa question du 29/08)

**Tous les resultats du 28-29/08 sont MONO-ACTIF.** Ils ne se transportent pas tels quels.
Trois plans distincts :

**1. La marge.** `SYMBOL_MARGIN_HEDGED = 0` est une propriete DU SYMBOLE, pas du compte.
Deux instances tiennent donc deux carnets couverts independants, chacun gratuit tant qu'il
est equilibre — le multi-actif ne degrade rien sur ce point. **Mais au moment ou les
couvertures se rompent, les expositions NUES s'additionnent sur le meme compte.** C'est la
que le multi-actif concentre au lieu de diluer.

**2. La coupure.** Aujourd'hui elle porte sur le flottant d'UN panier. Avec N instances sur
un compte il faut choisir : couper chaque panier separement (le total derive) ou couper sur
le total du compte (on sacrifie un panier sain pour en sauver un malade). **Choix de
conception jamais pose dans nos tests.**

**3. LE POINT QUI DECIDE — les episodes dangereux coincident-ils ?** Le danger n'est pas
continu : mesure a ~2 fois l'an. Si les mauvais episodes de trois actifs tombent ensemble,
la diversification n'apporte RIEN au moment ou on en aurait besoin.

**PIEGE DE METHODE** : la correlation des RENDEMENTS ne repond pas a cette question. Deux
actifs faiblement correles au quotidien s'effondrent regulierement ensemble. Il faut mesurer
la coincidence des **EPISODES PROFONDS**, pas celle des variations.

**Consequence immediate** : le « 20 000 suffit » du 29/08 est mono-actif. Trois instances
demanderaient au minimum 3 x cela si leurs mauvais moments sont independants, davantage
sinon. Coherent avec l'invariance du cout annuel de ruine par instance (28/08).

**PROTOCOLE** : faire tourner le clone sur 2-3 actifs sur la MEME fenetre, enregistrer le
flottant agrege, compter les moments ou deux paniers profonds sont ouverts simultanement.
Mesurable avec l'outillage actuel.

**A FAIRE EN AMONT** de l'etude restreinte et de la coupure optimale : si les episodes
coincident, l'etude mono-actif ne dira pas grand-chose du montage vise.

## MULTI-ACTIF, PREMIERE MESURE (29/08) — aucun candidat ne ressort

Variante normalisee (geometrie calee sur le prix, lot fige par actif sur une reference
longue), meme fenetre 2025.06 -> 2026.06, meme capital. **Ce n'est PAS le clone** : ses
chiffres absolus ne se comparent pas a lui, seulement les actifs entre eux.

**Etat individuel** — part du temps ou le flottant est sous -10 % du capital :

| | XAUUSD.p | BTCUSD | NAS100.p | GER40.p |
|---|---|---|---|---|
| temps en etat profond | 20,6 % | **54,9 %** | **10,8 %** | 1,2 % |
| paniers fermes | 3 357 | **3** | 370 | 6 |
| morts | 41 | 3 | 11 | 3 |

**BTC est inutilisable seul** : 55 % du temps en difficulte, 3 paniers fermes dans l'annee,
il s'enfonce et ne revient pas. **GER40 est mort en huit jours.** Le NASDAQ est le seul
individuellement correct — deux fois moins souvent en difficulte que l'or.

**COINCIDENCE des episodes profonds** (ce qu'il faut mesurer, PAS la correlation des
rendements) :

| paire | observe | si independants | rapport |
|---|---|---|---|
| or / BTC | 39,2 j | 41,1 j | 0,95 |
| **or / NASDAQ** | 15,5 j | 8,0 j | **1,92** |
| BTC / NASDAQ | 19,6 j | 21,4 j | 0,92 |

**Or et NASDAQ decrochent ensemble deux fois plus souvent que le hasard.**

**PIEGE DE LECTURE QUI INVERSE LA CONCLUSION NAIVE** : le rapport mesure la DEPENDANCE, les
jours absolus mesurent le RISQUE. Or+BTC passe **39,2 jours/an** en difficulte simultanee
contre 15,5 pour or+NASDAQ. BTC parait « independant » seulement parce que sa base est si
haute (55 %) que le recouvrement est massif malgre l'independance. **Pour un compte partage,
or+BTC est 2,5 fois plus expose que or+NASDAQ.**

**CONCLUSION : aucun candidat ne ressort.** Le seul actif individuellement correct est
precisement celui qui coincide le plus avec l'or.

*Reserves : une fenetre d'un an ; GER40 mort trop tot pour que ses paires signifient quoi que
ce soit ; et la variante normalisee est une autre strategie que le clone.*

## LES DEVISES SONT LA REPONSE (29/08) — mesure sur huit actifs

Meme variante normalisee, meme fenetre 2025.06 -> 2026.06, meme capital.

**Part du temps en etat profond** (flottant sous -10 % du capital) :

| BTCUSD | XAUUSD.p | NAS100.p | GBPUSD.p | USDJPY.p | EURUSD.p | GER40.p | AUDUSD.p |
|---|---|---|---|---|---|---|---|
| 54,9 % | 20,6 % | 10,8 % | 7,9 % | **5,1 %** | **2,1 %** | 1,2 % | 0,8 % |

**COINCIDENCE AVEC L'OR** — jours ou les deux sont profonds simultanement :

| partenaire | jours communs | si independants | rapport |
|---|---|---|---|
| **EURUSD.p** | 0,2 j | 1,6 j | **0,11** |
| **USDJPY.p** | 0,8 j | 3,8 j | **0,21** |
| GBPUSD.p | 6,3 j | 5,9 j | 1,07 |
| BTCUSD | 39,2 j | 41,1 j | 0,95 |
| NAS100.p | 15,5 j | 8,0 j | **1,92** |

**LES DEVISES SONT LA REPONSE, PAS LES INDICES NI LES CRYPTOS.** EURUSD et USDJPY
decrochent cinq a neuf fois MOINS souvent que le hasard en meme temps que l'or, tout en
etant individuellement viables (192 et 2 107 paniers, 5 et 12 morts).

**En jours reels : or + USDJPY expose 0,8 jour/an en difficulte simultanee, contre 15,5
pour or + NASDAQ.** Presque vingt fois moins.

**Classement pratique** : USDJPY pour l'activite (2 107 paniers, 5,1 % du temps profond),
EURUSD pour la surete (2,1 %, mais seulement 192 paniers).

**RESERVE POSEE — ET CONFIRMEE PAR LA SECONDE FENETRE. VOIR CI-DESSOUS : le resultat
spectaculaire ne tient pas.**

## SECONDE FENETRE (2024.06 -> 2025.06) : L'ANTI-COINCIDENCE NE TIENT PAS

| coincidence avec l'or | 2025-2026 | 2024-2025 |
|---|---|---|
| EURUSD.p | **0,11** | **0,92** |
| USDJPY.p | **0,21** | **0,84** |
| GBPUSD.p | 1,07 | 0,33 |
| NAS100.p | 1,92 | 0,00 (aucun episode, non significatif) |

**Le 0,11 / 0,21 etait un artefact de la fenetre 2025-2026.** Sur l'annee precedente les
devises sont simplement INDEPENDANTES de l'or. Le « facteur vingt sur l'exposition
simultanee » n'existe pas. La reserve posee au moment de la premiere mesure — regularite
inexpliquee donc suspecte — etait justifiee.

**CE QUI SURVIT, ET C'EST L'ESSENTIEL** : sur les DEUX fenetres, les devises ne sont jamais
POSITIVEMENT coincidentes avec l'or (tous rapports <= 1), alors que le NASDAQ etait a 1,92
sur la fenetre ou il avait de l'activite. **La diversification par les devises apporte de
l'INDEPENDANCE, pas de la compensation.** C'est moins spectaculaire mais c'est ce qu'il
faut : des poches independantes reduisent multiplicativement la probabilite d'ennuis
simultanes.

**AVERTISSEMENT IMPOSE PAR LES CHIFFRES — aucun actif n'a de profil stable :**

| part du temps en etat profond | 2025-2026 | 2024-2025 |
|---|---|---|
| XAUUSD.p | 20,6 % | 14,1 % |
| EURUSD.p | 2,1 % | **10,6 %** |
| USDJPY.p | 5,1 % | **14,1 %** |
| GBPUSD.p | 7,9 % | 2,7 % |
| NAS100.p | 10,8 % | **0,0 %** |

EURUSD passe de 2,1 % a 10,6 %, le NASDAQ de 10,8 % a zero. **Tout dimensionnement calibre
sur une seule annee est donc sans valeur.**

## VERDICT MULTI-ACTIF COMPLET (29/08) — dix actifs, deux fenetres

| symbole | profond 25-26 | profond 24-25 | coinc. 25-26 | coinc. 24-25 |
|---|---|---|---|---|
| XAUUSD.p | 20,6 % | 14,1 % | - | - |
| **EURUSD.p** | 2,1 % | 10,6 % | 0,11 | 0,92 |
| **USDJPY.p** | 5,1 % | 14,1 % | 0,21 | 0,84 |
| **GBPUSD.p** | 7,9 % | 2,7 % | 1,07 | 0,33 |
| NAS100.p | 10,8 % | 0,0 % | 1,92 | n.s. |
| **SP500.p** | 11,3 % | 13,1 % | **1,63** | **1,12** |
| DJ30.p | 0,9 % | 21,4 % | 0,12 | 1,14 |
| GER40.p | 1,2 % | 0,0 % | 0,03 | - |
| BTCUSD | 54,9 % | 0,0 % | 0,95 | - |

**SON INTUITION SUR LES INDICES ETAIT JUSTE, ET C'EST MESURE.** Les quatre indices
echouent sur au moins une fenetre : NAS100 ferme ZERO panier en 2024-2025 ; SP500 zero
avec 25 morts ; DJ30 zero avec 34 morts ; GER40 mort en huit jours.

**MAIS PAS POUR LA RAISON HABITUELLE.** Ce n'est pas la derive haussiere qui les tue —
c'est qu'ils alternent entre ne pas remplir la grille du tout et trender jusqu'a la mort.
Deux regimes, aucun exploitable. (Le raisonnement du 29/08 tient : la derive de long terme
n'est pas le discriminant, l'or a derive de 9,5 %/an et y prospere.)

**LE SEUL SIGNAL NEGATIF CONFIRME SUR LES DEUX FENETRES : le S&P 500**, coincidence 1,63
puis 1,12, au-dessus de 1 les deux fois. C'est le seul actif dont on puisse dire avec
confiance qu'il AGGRAVE l'or. Tous les autres resultats spectaculaires se retournent d'une
fenetre a l'autre.

**VERDICT : les devises, et elles seules.** Elles fonctionnent sur les deux fenetres
(EURUSD 192 puis 2 698 paniers, USDJPY 2 107 puis 4 583, GBPUSD 2 170 puis 474) et ne sont
jamais positivement coincidentes avec l'or. L'apport est de l'INDEPENDANCE, pas de la
compensation — ce qui suffit pour compartimenter.

## LA PROPOSITION DE GEMINI (3 compartiments) — principe bon, forme fausse

Proposes : XAUUSD+AUDUSD, EURUSD+USDCHF, USDCAD+NZDUSD. Mesures sur deux fenetres :

| compartiment | coinc. 25-26 | coinc. 24-25 |
|---|---|---|
| XAUUSD + AUDUSD | 0,01 (AUDUSD inactif) | 1,12 |
| **EURUSD + USDCHF** | n.s. | **2,41** |
| USDCAD + NZDUSD | n.s. | 0,27 |

**LE DEFAUT EST STRUCTUREL : les majeures partagent toutes la JAMBE DOLLAR.** Quand le
dollar part en tendance elles trendent ensemble — et une grille couverte ne souffre que des
tendances, pas du sens. Diversifier entre majeures, c'est empiler six copies du meme pari.

**Compagnons possibles pour EURUSD, mesure sur deux fenetres :**

| candidat | 25-26 | 24-25 | |
|---|---|---|---|
| **XAUUSD.p** | 0,11 | 0,92 | **le seul bon compagnon exploitable** |
| SP500.p / DJ30.p | 0,03 / 0,26 | 0,99 / 0,80 | bons mais inexploitables par la grille |
| USDJPY.p | 0,31 | 1,49 | mixte |
| USDCHF / GBPUSD / NZDUSD / USDCAD / AUDUSD | | 2,41 a 3,07 (AUDUSD 6,83) | **AGGRAVENT** |

**DEUX ENONCES QUI TIENNENT ENSEMBLE, a ne pas confondre :**
- Les devises diversifient **l'OR** (jamais positivement coincidentes avec lui).
- Les devises **ne se diversifient PAS entre elles** (jambe dollar commune).

Donc : l'or + une paire de devises se completent ; deux paires de devises se dupliquent.
**Le schema a trois compartiments ne tient pas avec les actifs testes.**

**LE CRITERE A RETENIR pour construire la bonne forme** — applicable a tout candidat futur :
1. episodes profonds non coincidents, **verifie sur au moins DEUX fenetres** ;
2. se mefier de tout MOTEUR COMMUN (ici la jambe dollar) — le chiffre d'une seule fenetre
   ne le revele pas, le mecanisme si ;
3. l'actif doit etre individuellement exploitable par la grille : les indices qualifient sur
   la coincidence mais meurent ou ne tradent pas.

**A EXPLORER** : matieres premieres hors metaux (petrole, cacao) — moteur different de la
jambe dollar, mais aucun ATR rendu faute d'historique charge. Charger les donnees avant de
conclure.

## LE MONTAGE MESURE (29/08) — 3 poches, et c'est le maximum disponible

**Montage : 20 000 par poche, coupure a 40 %, or + euro-dollar + dollar-yen.**
Courbes d'equite horaires agregees, comparees au meme capital entierement sur l'or.

| | 2025-2026 | | 2024-2025 | |
|---|---|---|---|---|
| | gain | DD max | gain | DD max |
| or | 470 % | 35,4 % | 107 % | 49,7 % |
| euro-dollar | 23 % | 15,7 % | 34 % | 9,0 % |
| dollar-yen | 33 % | 18,7 % | 183 % | 15,6 % |
| **LES 3 POCHES** | **175 %** | **25,5 %** | **108 %** | **21,1 %** |
| TOUT SUR L'OR | 470 % | 35,4 % | 107 % | 49,7 % |
| gain / DD | 6,87 | (or 13,27) | 5,12 | (or 2,16) |

**LE RESULTAT SOLIDE : le drawdown du montage est STABLE** — 25,5 % puis 21,1 % — la ou
l'or seul passe de 35,4 % a 49,7 %. **Et dans l'annee difficile, le montage rend le MEME
gain avec moitie moins de risque** (108 % contre 107 %, 21,1 % contre 49,7 %). C'est ce
qu'on achete : pas de la performance dans les bonnes annees — on en perd beaucoup — mais
de la survie dans les mauvaises.

**Contre l'etalon (10 %/an pour -47 %)** : le montage fait 108-175 %/an pour 21-25 %, soit
un rapport de 5,1 a 6,9 contre 0,21. **Facteur 25 a 33.** Les frais sont DEJA comptes
(swaps -0,1 a -8,4 % du brut ; et les devises paient des COMMISSIONS que l'or ne paie pas —
17,5 % du brut sur le dollar-yen, 26 % de frais totaux).

**PAS D'OPTIMISATION DES POIDS POSSIBLE** : le meilleur actif change de fenetre (l'or en
2025-2026, le dollar-yen en 2024-2025 avec +183 % contre +107 %). Pondérer d'apres l'une
serait a contresens sur l'autre. **Parts egales**, faute de base fiable.

**RECHERCHE D'UN 4e PILIER : ECHEC, et c'est une limite de l'univers d'actifs.**
Sur ONZE actifs testes, seuls QUATRE survivent aux deux fenetres : or, euro-dollar,
dollar-yen, livre-dollar. Et la livre est coincidente avec l'euro (2,90 puis 2,28), donc
elle n'ajoute rien.

| elimines | pourquoi |
|---|---|
| NAS100, SP500, DJ30, GER40 | zero panier ou mort sur une fenetre |
| BTCUSD | 3 paniers en un an, 55 % du temps profond |
| argent, platine | comptes detruits (20 000 -> 1 470 et 282) |
| **petrole** | **+189 % sur une fenetre, DETRUIT sur l'autre** (20 000 -> 229 en 7 mois) |

**Descendre le drawdown sous 21 % demanderait des actifs independants supplementaires. Il
n'y en a pas chez ce courtier parmi ceux qui survivent a deux regimes.**

**RESERVE GENERALE** : deux fenetres, toutes deux recentes, dans un regime etabli comme
exceptionnel. 6 a 9 %/mois soutenus est une pretention enorme — a ne pas traiter comme
acquis avant d'avoir ajoute des fenetres.

## LE MONTAGE SUR QUATRE ANNEES (29/08) — resultat consolide

20 000 par poche, coupure a 40 %, parts egales. **Quatre fenetres d'un an, 2022 a 2026.**

| fenetre | 3 poches gain / DD | 5 poches gain / DD | or seul gain / DD |
|---|---|---|---|
**AVERTISSEMENT DU 29/08 — CE TABLEAU A TOURNE EN `Model=1` (une minute).** Le modele de
ticks est un parametre de PREMIER ORDRE pour cet EA (son cliquet avance d'un pas par tick) :
sur la fenetre de reference il donne **13 paniers contre 96** en `Model=0`. Le `Model=1` etait
herite d'un fichier de configuration cree le 28/08 et n'a JAMAIS ete verifie pendant deux
jours de mesures. Voir [[methode-de-travail]], regle de la configuration heritee en silence.

**Refait en `Model=0` sur 2025-2026, meme depot, meme coupure 40 %** (seuls `Model`, `Report`
et les fichiers de sortie different, diff verifie) :

| | Model=1 (ci-dessous) | **Model=0 (ticks)** |
|---|---|---|
| 5 poches | 122 % / 19,4 % | **300 % / 14,5 %** |
| 3 poches | 175 % / 25,5 % | **502 % / 18,3 %** |
| or seul | 470 % / 35,4 % | **1478 % / 26,9 %** |

**Le sens est constant : en ticks, PLUS de rendement ET MOINS de creux.** Le `Model=1`
n'exagerait pas le resultat, il **affamait la strategie** — sept fois moins d'occasions de
recolter, alors que les creux, eux, restaient. La hierarchie etablie tient : chaque poche
ajoutee baisse le creux (18,3 % a trois, 14,5 % a cinq).

Detail par poche en ticks : or +1478 % / 26,9 % (13 morts, 7 846 paniers) · EURUSD +15 % /
10,4 % · USDJPY **-22 % / 43,0 %** (passe du profit a la perte, 1 mort) · EURJPY +13 % /
10,1 % · AUDJPY +17 % / 11,8 %. **Le modele ne deplace pas tout dans le meme sens** : l'or
gagne et meurt MOINS (13 contre 17), les quatre devises perdent.

## SA DISTINCTION DU 29/08 : RECONSTRUCTION *contre* OPTIMISATION — a tenir separees

Sa remarque : *« les developpements suivants realises dans le cadre du clone MT5 ne relevent
pas de la reconstruction pure et dure mais plutot de l'optimalisation ! NON ? »*. **Il a
raison, et j'avais melange deux comparaisons.**

- **Impossible pour toujours** : comparer quoi que ce soit a l'ORIGINAL sur ticks reels (il ne
  tourne que sous MT4, qui n'en a pas).
- **Possible et deja fait** : clone MT4 contre clone MT5, 96 paniers contre 93. C'est une
  verification de STRUCTURE, elle n'a pas besoin de ticks reels et reste valide.
- **Le piege qu'il pointe** : le clone MT5 a derive au-dela de la reconstruction (coupure,
  renflouement, normalisation ATR, recyclage, multiplicateur de lot — **rien de tout ca
  n'existe dans l'original**). Mesurer avec ces ajouts actifs et conclure sur « le mecanisme »,
  c'est attribuer a l'original ce qui vient de nous. **C'est exactement l'erreur payee avec la
  coupure.**

**ETAT « RECONSTRUCTION PURE » — verifie ligne a ligne le 29/08.** Il suffit de :
`InpMaxFlottantPct=0` · `InpNormaliserATR=false` · `InpRecyclage=false` · `InpOrdreUnique=false`
· `InpPoseMarche=false` · `InpArmerSurEvenement=false` · `InpMultLot=1.0` · `InpMaxNiveaux=0` ·
`InpSuivreGagnant=false`. Les quatre qui SEMBLENT encore actifs sont alors inertes, prouve par
lecture du code : `InpCapitalNotionnel` et `InpDelaiRenflouementH` ne servent qu'a la mort, qui
ne se declenche pas ; `InpEtalon` est derriere le `if(!InpNormaliserATR) return` de
`MajEffectifs()` ; `InpPorte2SousPlafond` ne mord que si `g_plafondVu`, qui exige
`InpMaxNiveaux > 0`.

**Consequence : le balayage sans coupure du 29/08 EST la reconstruction pure sur ticks reels** —
la seule mesure du jour qui soit les deux a la fois. Son resultat tient : **le mecanisme nu,
sans aucune protection, liquide n'importe quel capital (10 k a 160 k) en 8,5 mois.** Coherent
avec ce qu'on sait de l'original : ni filtre de news, ni filtre de session, ni coupure — d'ou
la protection MANUELLE de son montage reel.

**DONC LE TERRAIN DU COMBAT EST LA COUCHE DE PROTECTION, QUI EST ENTIEREMENT LA NOTRE.** On ne
repare pas un EA commercial qu'on ne maitrise pas : on construit la piece qui lui manque.

## DECISIONS ARRETEES AVEC LUI LE 29/08 (soir)

**1. DIVERSIFICATION ABANDONNEE. OR SEUL.** Ses mots : *« ne garder que XAUUSD et oublier la
diversification »*. Fonde : les seules mesures FX en ticks reels n'etablissent aucune esperance
positive et changent de signe selon le modele. Diluer 25 % dans des poches a zero donne 5 %.
**La diversification ne paie QUE si chaque poche a une esperance positive.**

**2. MT4 ECARTE COMME OUTIL DE VALIDATION.** Il a compris et valide le raisonnement : *« MT4 ne
semble pas etre une solution si le backtest enjolive la situation reelle »*. **MT4 n'a pas de
ticks reels — il les FABRIQUE par interpolation, donc son backtest est plus flatteur. Mais en
REEL il recoit le meme marche que MT5 rejoue.** MT4 ne protege pas la strategie, il CACHE ce
qui lui arrive.

**=> LE CLONE MQL4 EST GELE, PIECE D'ARCHIVE.** Il a servi a reconstruire l'original et a
valider le portage (96 paniers contre 93). **Une seule base evolue desormais : le MQL5.** Ne
porter vers MQL4 que si le compte reel l'exige, une seule fois, a la fin — jamais des
corrections encore en cours de mesure (cf. les deux MultiStrategyEA divergents,
[[sauvegarde-code]]).

**3. FILTRE DE NEWS : codable mais NON VALIDABLE.** Le calendrier economique est **vide dans le
Strategy Tester** : le filtre y compte zero blocage, ce qui ne prouve rien. L'implementer sera
un acte de foi, pas une amelioration mesuree — le lui redire s'il y revient.
**A PROPOSER A LA PLACE : le filtre de SEANCE**, qui est rejouable puisque ce sont des heures.
Ses consignes manuelles (arret vendredi 17h, cloture de secours 21h, reprise lundi 2h) sont
donc CHIFFRABLES. C'est la seule part de sa protection manuelle qu'un backtest peut mesurer.

**7. COUPURE INDEXEE SUR LA VOLATILITE : ECARTEE.** Son idee du 30/08, la plus defendable
sur le papier — adapter a une VARIABLE D'ETAT plutot qu'a la performance passee, donc sans
rien optimiser sur le passe. Implementee v5.26 (`InpCoupureSurAtr`, facteur = ATR lisse /
12,93, borne 0,50-2,00).

| | reference | indexee ATR |
|---|---|---|
| solde | **134 830** | 118 754 |
| rendement | **25,1 %/an** | 22,2 %/an |
| pire flottant | **-17 785** | **-33 140** |
| marge minimum | **395 %** | **210 %** |

`Facteur ATR coupure : min 0,50 moyenne 0,95 max 2,00` — l'indexation a bien mordu.
**Elle degrade les DEUX axes.** Mecanisme : en marche agite le facteur monte a 2,00, le seuil
passe a **80 % du capital**, et on laisse le flottant s'enfoncer deux fois plus loin au moment
le plus dangereux. **Le raisonnement etait juste en physique et faux en consequence : ce qu'il
faut proteger n'est pas la proportionnalite, c'est le CAPITAL.**
Resserrer les bornes reviendrait a les ajuster jusqu'a ce que le resultat plaise — et plus on
resserre, plus on revient a la coupure fixe.

**DEUX PIEGES D'INERTIE SILENCIEUSE RENCONTRES SUR CETTE SEULE MESURE**, tous deux revelés par
le compteur et non par les resultats :
1. l'ATR n'etait calcule que si `InpNormaliserATR` etait vrai ;
2. **le HANDLE de l'ATR n'etait cree que dans ce meme cas** — corrige une couche plus bas.
Sans la ligne « Facteur ATR coupure » au bilan, les deux passages auraient rendu des chiffres
identiques et on aurait conclu « l'indexation n'apporte rien ». **Un non-effet se serait
deguise en effet nul.** => **Instrumenter le MECANISME, pas seulement lire les resultats.**

**6. FERMETURE PARTIELLE DE LA PORTE 2 : ECARTEE.** Proposition de l'IA collaboratrice, la
plus prometteuse sur le papier — elle visait le mecanisme de mort mesure. Implementee dans le
clone (v5.25, `InpPorte2Fraction`, defaut 1.0). Ticks reels, 40 000, 5,4 ans.

| fraction fermee | solde | rendement | morts | marge min | creux | declenchements |
|---|---|---|---|---|---|---|
| **1,00 (ref)** | **134 830** | **25,1 %/an** | 24 | **395 %** | **40,2 %** | 10 381 |
| 0,90 | 50 176 | 4,3 %/an | 28 | 144 % | 86,9 % | 24 065 |
| 0,80 | 1 266 | **RUINE** | 24 | 142 % | 92,6 % | 24 350 |
| 0,70 | 97 123 | 17,8 %/an | 26 | 509 % | 56,2 % | 38 381 |

**NON-REGRESSION VERIFIEE** : la fraction 1,00 rend 134 829,79 / 15 699 paniers / 24 morts /
395,2 % / porte 2 a 10 381 pour 344 939,13 — **identique chiffre pour chiffre a la reference**.
La modification est donc neutre et les trois points sont interpretables.

**MECANISME D'ECHEC, compris** : en rognant le cote gagnant au lieu de le solder, on ne le
sort jamais vraiment. Il repasse le seuil, on le rogne encore — **24 000 a 38 000
declenchements contre 10 381**. Le panier ne se denoue plus, la structure s'enfonce.

**META-CONSTAT — LA REPONSE AUX PARAMETRES EST EN DENTS DE SCIE.** Troisieme balayage dans ce
cas (coefficient d'echelle, fermeture partielle) : 0,90 donne 4 %, 0,80 ruine, 0,70 remonte a
18 %. Sur un systeme a martingale, **une poignee d'excursions profondes decide de l'annee**,
donc **optimiser un parametre sur une seule fenetre revient largement a ajuster du bruit.**
Seuls les effets massifs sont interpretables (K=1,40 detruit, plafond 20 etouffe, partiel
degrade). **=> La priorite n'est plus un levier de plus, c'est la validation HORS ECHANTILLON.**

**5. PLAFOND DE RANG : ECARTE.** Balayage nuit du 29 au 30/08, ticks reels, `XAUUSD.p`,
40 000, coupure 40 %, 2021-2026.

| plafond | solde | rendement | morts | survie | marge min | pos/panier | rang max |
|---|---|---|---|---|---|---|---|
| 20 | 40 162 | **0,1 %/an** | 3 | 38,6 sem | 2 011 % | 40 | 19 |
| 25 | 103 593 | 19,2 %/an | 17 | 12,6 sem | 226 % | 50 | 24 |
| 30 | 85 577 | 14,9 %/an | 21 | 12,0 sem | **110 %** | 60 | 29 |
| **aucun** | **134 830** | **25,1 %/an** | 24 | 10,7 sem | **395 %** | 84 | 78 |

**SANS PLAFOND DOMINE SUR LES DEUX AXES** — meilleur rendement ET meilleure marge minimale que
les plafonds 25 et 30. Brider a 30 tombe a 110 % de marge, **deux fois plus pres de la
liquidation que sans plafond du tout**. Mecanisme : quand l'echelle ne peut plus s'approfondir,
la grille empile des jambes au lot de base qui ne se denouent plus. Le seul plafond sur (20) ne
rapporte **rien** (+162 en 5,4 ans).

**CECI CORRIGE LA NOTE ANTERIEURE** qui annoncait le plafond a 20 « quasi gratuit, -0,2 % de
gain, pire panier -21 % » : c'etait mesure en **ticks generes sur sept semaines**.

**Irregularite signalee, non lissee** : 25 fait mieux que 30 (19,2 % contre 14,9 %), ce qui n'a
pas de sens dans une progression. Une seule fenetre, 17 morts contre 21 : **c'est du bruit, ne
rien en tirer.**

**CONCLUSION DES DEUX BALAYAGES : l'echelle profonde n'est pas un defaut a corriger, C'EST LE
MOTEUR.** La seule protection qui fonctionne sans detruire le rendement est **la coupure**,
dont le sommet est a 40 %.

**4. BALAYAGE DE COUPURE COMPLET (ticks reels, `XAUUSD.p`, 40 000, 2021-2026, 5,4 ans)** :

| coupure | solde final | rendement | morts | cout/mort | survie | pire flottant | marge min |
|---|---|---|---|---|---|---|---|
| 15 % | 103 573 | 19,2 %/an | 60 (11,0/an) | 6 201 | 4,2 sem | -8 392 | 1 155 % |
| 25 % | 104 500 | 19,3 %/an | 39 (7,2/an) | 10 164 | 6,5 sem | -10 773 | 977 % |
| **40 %** | **134 830** | **25,1 %/an** | 24 (4,4/an) | 16 282 | 10,7 sem | -17 785 | 395 % |
| 60 % | 95 788 | 17,5 %/an | 18 (3,3/an) | 24 209 | 14,4 sem | -24 983 | **184 %** |

**40 % EST UN VRAI SOMMET, PAS UN CURSEUR.** Desserrer a 60 % perd du rendement ET de la
securite — domine sur les deux axes, et la marge y tombe a 184 % quand la liquidation est a
50 %. **Cout TOTAL des morts invariant entre 15 et 40 %** (372 060 / 396 396 / 390 768) puis
**435 762 a 60 %** : trop attendre coute plus cher que les coupures evitees ne rapportent.

**L'arbitrage reel est entre 25 % et 40 %** : 6 points de rendement contre une securite deux
fois moindre (marge min 977 % contre 395 %, pire flottant -10 773 contre -17 785).

**LIMITE** : le creux d'equite n'est connu QUE pour 40 % (40,2 % horaire, sous-estime). Pour
les trois autres on n'a que le pire flottant. **A rejouer pour avoir quatre creux comparables.**

*(ancien texte du premier point remplace)*

## A FAIRE EN PRIORITE — deux mecanismes de tendance, prets, NON ENCORE MESURES (30/08)

**Son idee, en deux volets. Le premier est code (v5.27), le second est ECRIT ET EN ATTENTE.**

**Volet 1 — INACTION : bloquer l'ouverture d'un panier NEUF en tendance forte.** Code v5.27
(`InpFiltreTendance`, `InpTendanceHeures=24`, `InpTendanceSeuil`). Ne bloque QUE `nTot == 0`,
donc jamais la gestion d'un panier ouvert — bloquer la gestion est ce qui a tue le plafond de
rang et la fermeture partielle. Mesure = `|close(0) - close(N)| / ATR lisse`.

**Volet 2 — COUPURE RESSERREE : patch pret dans `scratchpad/patch_v528.py`, A APPLIQUER.**
`InpCoupureTendance` : en tendance forte le seuil de mort passe de 40 % a X % (15 % par
exemple). **Pourquoi c'est le plus prometteur des deux** : meme si le NOMBRE de morts ne baisse
pas, leur PRIX passe de 16 000 a 6 000. Or les morts avalent **71 % des gains bruts** — c'est
le poste qui decide du resultat.
**Sens INVERSE de l'indexation ATR (v5.26, ecartee) qui DESSERRAIT au pire moment.** Ici le
declencheur est DIRECTIONNEL, pas l'amplitude, et il RESSERRE.

**Mesure prealable deja faite, signal faible mais reel** : les 24 morts suivent un deplacement
directionnel **38 % plus marque** que la normale sur 24 a 72 h (16 sur 24 au-dessus de la
mediane, p ~ 0,08). **Sur 6 h, aucun signal** — le filtre doit regarder l'echelle du jour.

**Arithmetique du compromis** : un seuil a la mediane bloquerait la moitie du temps pour eviter
deux tiers des morts — match nul. **L'espoir est dans un seuil HAUT** (10-15 % des periodes les
plus directionnelles). C'est cette courbe qu'il faut tracer.

**PROTOCOLE** : passage de CALIBRATION d'abord (`InpTendanceSeuil=999`, rien n'est bloque) —
il sert de non-regression (doit rendre 134 829,79) ET donne la distribution reelle de la mesure,
pour choisir les seuils au lieu de les inventer. **Trois pieges d'inertie silencieuse deja
rencontres sur ce chantier : ne jamais lancer un seuil devine.**

## FILE DE TRAVAIL ARRETEE LE 29/08 — tout en `Model=4`, voir [[methode-de-travail]]

**Son objectif, qu'il a du me rappeler** : *« on sait que cela arrivera. L'objectif a toujours
ete de la RETARDER au plus possible pour que la performance puisse l'absorber et rester
neanmoins rentable »*. Juger au **rapport par cycle** (gain accumule pendant la survie moyenne
contre cout moyen d'une mort), jamais a la survie.

**Son mot d'ordre** : *« Bats-toi nom de dieu. Il faut arriver. Jamais se rendre sans combattre
jusqu'au bout. »*

1. **Balayage capital x coupure sur ticks reels** (en cours) — depots 10 k a 160 k, 5,4 ans.
2. **LIRE LES COMPTEURS DE VOLUME NU** — `Volume nu maximal`, `Ruptures sous 200/100/50 %`.
   **Ils tournent depuis des jours et n'ont jamais ete lus.** C'est le mode de mort identifie :
   la couverture se rompt, un cote reste a decouvert, appel de marge. Si le volume nu est borne,
   on le plafonne (refuser la porte 2, ou recouvrir aussitot) — **on supprime le mode de mort
   lui-meme, pas ses consequences.** Cout : zero passage, les chiffres sont deja dans les logs.
3. **Le coefficient d'echelle `InpKLot = 1,30`** — jamais teste, releve sur l'original et repris
   tel quel. C'est LE parametre martingale (rang 28 = 11,93 lots). 1,20 divise la profondeur au
   prix d'une recuperation plus lente. Arbitrage central jamais pose.
4. **L'ecretage du rang** — `InpMaxNiveaux = 0` (aucun plafond) alors que **l'original ecrete
   des le rang 36**. Borner le rang borne directement le pire flottant.
5. **Le delai de renflouement (24 h)** — jamais choisi. Seul levier qui augmente le gain par
   cycle SANS augmenter le cout d'une mort.
6. **Refaire la selection des actifs sur ticks reels** — obligatoire AVANT toute composition :
   USDJPY et EURJPY changent de SIGNE entre les deux modeles.
7. **Compositions de 1 a 5 poches** — *demande explicitement le 29/08 : « une analyse 2 poches
   et 4 poches pour completer l'approche »*. **Cout zero en backtests** : se calcule en
   combinant les courbes d'equite horaires deja produites. Reserve a ecrire a chaque fois : le
   creux de portefeuille ainsi calcule est SOUS-ESTIME d'environ un quart (echantillonnage
   horaire contre mesure au tick).

**Contrainte materielle** : un passage 5,4 ans d'or en ticks reels = ~500 M de ticks. Fini les
balayages de dizaines de combinaisons. **Il faut choisir les questions.**

**CE VERDICT EST PERIME — il reposait sur une coupure qui ne coupait pas** (elle laissait le
carnet arme, voir plus haut). **MESURE DE REFERENCE, code corrige v5.21, ticks reels :**
`XAUUSD.p` seul, depot 40 000, coupure 40 %, 2021.01.04 -> 2026.06.10, **307 346 046 ticks
reels**, qualite d'historique confirmee :

| | |
|---|---|
| 40 000 -> **134 832** | **25,1 % par an** sur 5,4 ans |
| creux horaire | 40,2 % (sous-estime, compter 45-50 % au tick) |
| morts | 24, soit 4,41/an — survie moyenne 10,7 semaines |
| cout moyen d'une mort | 16 282 = **41 % du capital** (= le niveau de coupure) |
| niveau de marge minimum | **395 %** — jamais approche de la liquidation |
| commissions / swaps | -55 363 (35 % du brut) / -6 436 |
| plus gros ordre | 57,56 lots (rang 33) — plafond du symbole jamais atteint |

**L'etalon etait 10 %/an pour -47 %. Ce point fait 2,5 fois le rendement a risque comparable.**

**OU PART L'ARGENT** : les 24 morts coutent **390 768** au total contre 94 830 de net — elles
avalent ~71 % des gains bruts. Les frais coutent 12 points de rendement annuel. **Le cout d'une
mort EST le niveau de coupure**, donc ce parametre gouverne le rendement ET le creux ensemble.

**LEVIERS, corriges le 29/08 apres sa relecture :**
1. **Niveau de coupure** — en cours de mesure sur ticks reels (15/25/40/60 %).
2. **Plafond de rang a 20** — **deja valide** : cout 0,2 % de gain, reduit le pire panier de
   21 %. A refaire sur ticks reels.
3. **Coefficient d'echelle 1,30** — jamais teste.
4. **Commissions** — 12 points/an.
**Le RECYCLAGE n'est PAS un levier** : ecarte sous ses trois formes, 3 refus convertis sur
12 145. Quand l'echelle est enfoncee il n'existe aucune jambe gagnante a solder. *Je l'avais
reproposé le 29/08 ; c'est lui qui m'a corrige.*

**DIVERSIFICATION — son objection du 29/08, juste** : elle ne paie QUE si chaque poche a une
esperance positive, sinon elle dilue le seul moteur qui gagne (or 25 % + quatre poches a zero
= 5 %). Les seules mesures FX en ticks reels ne l'etablissent pas. **Regler la coupure d'abord**
(elle baisse le creux SANS diluer), mesurer ensuite chaque actif candidat, ne garder que les
esperances positives.

**VERDICT DU 29/08 — LE MONTAGE NE SURVIT PAS AUX TICKS REELS. CONCEPT CLOS.**

`Model=4`, qualite d'historique **100 % ticks reels**, 2025.06.12 -> 2026.06.10, 20 000 par
poche, coupure 40 %. Creux lus dans le RAPPORT (mesures au tick), pas dans mon fichier horaire :

| poche | rendement | creux fonds | morts | couverture |
|---|---|---|---|---|
| XAUUSD.p | **-69 %** | **95,84 %** | 28 | **LIQUIDE a 72 %** |
| EURUSD.p | +16 % | 14,97 % | 0 | complete |
| USDJPY.p | +20 % | 31,70 % | 0 | complete |
| EURJPY.p | **-17 %** | **48,18 %** | 1 | complete |

**Portefeuille 3 devises : +6,1 %/an. Portefeuille 4 poches avec l'or : -0,6 % pour 65 % de
creux.** L'etalon a battre etait **10 %/an pour -47 %** : le montage sans l'or rend **moins
de la moitie** de l'etalon, et EURJPY seul creuse a 48 %.

**LES SIGNES S'INVERSENT ENTRE LES DEUX MODELES** : USDJPY -22 % en ticks generes, **+20 %**
en ticks reels ; EURJPY +13 % genere, **-17 %** reel. Un avantage qui change de signe selon
la facon de simuler les prix n'est pas un avantage, c'est du bruit. **Les poches devises ne
sont pas un resultat faible : elles ne sont pas un resultat.**

**Criteres d'acceptation du 21/08 : ECHEC.** Esperance apres couts non atteinte, pas de
plateau, pas de tenue hors echantillon, signe instable selon le modele. **La regle d'arret
s'applique : c'est tue, pas garde.**

**CE QUE CA DIT DU COMPTE REEL — le vrai produit de ce travail.** Le mecanisme (grille +
martingale + un cote a decouvert apres denouement partiel) liquide 20 000 en 8,7 mois sur l'or
en conditions reelles, avec 28 coupures. Le backtest du vendeur ne peut pas le montrer :
**MT4 est incapable de tester sur ticks reels**. Reserve honnete : la fidelite clone/original
n'est etablie qu'en ticks generes (a 3 %), aucun original ne peut servir de reference en ticks
reels. C'est le MECANISME qui est condamne, pas une transcription particuliere.

**RESERVE LEVEE LE 29/08 — ET ELLE TOMBE DU MAUVAIS COTE. LE GAIN ETAIT DE L'INTERPOLATION.**

Test decisif, fait sur le MEME symbole pour eliminer tout autre facteur — `XAUUSD.p`,
2025.06.12 -> 2026.06.10, depot 20 000, coupure 40 %, seul `Model` differe (diff verifie) :

| | solde final | morts | couverture |
|---|---|---|---|
| `Model=0` ticks generes | **53 968 (+170 %)** | 26 | annee complete |
| `Model=4` ticks REELS | **6 215 (-69 %)** | 28 | **LIQUIDE a 72 %** |

Meme spread, meme marge, meme code, memes parametres. **Seul le flux de prix change.** Le
testeur l'ecrit lui-meme : `stop out occurred on 72% of testing interval`, apres 96 797 378
ticks reels. Les oscillations intra-barre que MT5 FABRIQUE sont assez regulieres pour qu'une
grille les recolte ; les vrais ticks ne le sont pas. **La poche or du montage tombe** — et
c'etait la poche dominante, celle qui portait le rendement.

**UNE CONCLUSION ANTERIEURE EST FAUSSE : le stop-out EXISTE.** J'avais etabli que la marge
couverte etant nulle, aucun appel de marge n'etait possible et le testeur MT5 ne l'appliquait
pas. Le journal montre `position stop out triggered at 49.32%` sur 11,93 lots. **Apres un
denouement partiel un cote reste a decouvert et consomme de la marge REELLE.** La protection
que je croyais structurelle n'existe pas.

**A REFAIRE EN `Model=4`** : les quatre poches devises (jamais testees en ticks reels non
plus), le montage, et l'etude de ruine. Les donnees existent : 68 mois de ticks reels sur
`XAUUSD.p`, 01/2021 a 08/2026, tous les mois pleins (20 a 79 Mo).

**Piege d'outillage** : la banniere de bilan imprimait « GoldingClone v4.14 » — chaine figee
jamais mise a jour, qui m'a fait croire deux minutes a un binaire perime. Corrigee le 29/08
pour imprimer `__DATETIME__` (horodatage de compilation, non falsifiable). **`__TIME__`
n'existe pas en MQL5**, seul `__DATETIME__` — l'avoir utilise a casse la compilation ET
SUPPRIME le `.ex5`. Voir [[mt5-pieges-outillage]].

**RESERVE NON LEVEE : `XAUUSD_22` est un symbole PERSONNALISE construit sur des barres M1.**
En `Model=0`, MT5 n'y lit pas des ticks reels, il les **fabrique** par interpolation dans la
barre. Un EA qui vit sur les extremes intra-barre peut recolter des oscillations qui n'ont
jamais existe. **Le +1478 % n'est pas acquis tant que ce point n'est pas tranche.** Ce qui
tranche : `XAUUSD.p` en `Model=0` contre `Model=4` (ticks reels), meme fenetre, meme symbole.
**`XAUUSD.p` dispose de 68 mois de ticks reels, 01/2021 a 08/2026** — verifie le 29/08, donc
toute l'etude est refaisable sur ticks reels si le test passe.

| 2025-2026 | 175 % / 25,5 % | 122 % / **19,4 %** | 470 % / 35,4 % |
| 2024-2025 | 108 % / 21,1 % | 85 % / 14,2 % | 107 % / **49,7 %** |
| 2023-2024 | 300 % / 11,5 % | 206 % / 6,7 % | 224 % / 13,5 % |
| 2022-2023 | 62 % / 21,6 % | 47 % / 16,1 % | 157 % / 24,0 % |
| **moyenne / pire** | 161 % / 25,5 % | **115 % / 19,4 %** | 240 % / 49,7 % |

3 poches = or + EURUSD + USDJPY. 5 poches = plus EURJPY + AUDJPY.

**LE RESULTAT ROBUSTE — chaque poche ajoutee baisse le creux ET le rendement, dans les
QUATRE fenetres sans exception.** Le montage a cinq bat celui a trois sur le drawdown a
chaque fois (19,4/25,5 · 14,2/21,1 · 6,7/11,5 · 16,1/21,6) et perd sur le rendement a chaque
fois. C'est le resultat le plus solide de l'etude.

**LE CHIFFRE QUI VALIDE LA DEMARCHE** : l'or seul a un pire creux de **49,7 %**, quasiment
celui de l'alternative passive (**-47 %**). Il gagne beaucoup plus mais avec le meme creux :
**il ne resout pas le probleme pose. C'est la diversification qui apporte le risque contenu,
pas la strategie.**

**RETRACTATION** : j'avais annonce le rapport gain/DD « stable » a 6,02 / 6,28 sur deux
fenetres. **Sur quatre il va de 2,89 a 30,72.** C'etait un artefact de deux echantillons.
Ce qui tient, c'est le PLAFONNEMENT DU CREUX, pas le rendement ajuste du risque. Les deux
montages sont d'ailleurs indiscernables sur ce rapport (2,88-26,03 contre 2,89-30,72) : le
choix entre eux est une PREFERENCE, pas une optimisation.

**LE LEVIER EST REFUTE** : doubler le lot des croisements les detruit sur une fenetre
(EURJPY +33 % a lot simple, solde negatif a lot double). La coupure est fixee en % du
CAPITAL, donc un lot double suffit a la declencher avec la moitie du mouvement : les morts
ne doublent pas, elles se multiplient, et chacune coute toujours 40 %.

## CORRECTION IMPORTANTE — les POINTS normalisent deja l'or et les devises

Ma conclusion du 29/08 matin — « les parametres absolus ne transposent a aucun autre
actif » — est **FAUSSE POUR LES DEVISES**. Les parametres sont en POINTS, et le point
s'ajuste au nombre de decimales :

```
or      2 decimales   point 0,01      Step 80 = 0,80
EURUSD  5 decimales   point 0,00001   Step 80 = 8 pips
USDJPY  3 decimales   point 0,001     Step 80 = 8 pips
```

La convention des points normalise donc or et devises entre eux, a un facteur ~4 pres.
Elle ne normalise PAS les indices ni les cryptos (taille de contrat et valeur de tick hors
cadre) — c'est pour EUX que la normalisation ATR/prix etait necessaire.

**CONSEQUENCE A TRAITER** : le MONTAGE a tourne avec les parametres ABSOLUS (normalisation
eteinte) ; l'ETUDE DE COINCIDENCE avec la normalisation active. **La selection des actifs et
la mesure de performance viennent de deux configurations differentes.** A reconcilier.

## CE QUE « EPROUVE » DEMANDERAIT — par cout croissant

1. **Reconcilier les deux configurations** : rejouer l'etude de coincidence avec les
   parametres absolus du montage. Si le classement tient, la selection est validee.
   Une heure de testeur, aucun developpement.
2. **Verifier le trou de liquidation sur les 5 poches et les 4 fenetres.** Deja instrumente
   (temps passe sous 50 % de niveau de marge), il suffit de lire.
3. **Remonter avant 2022.** Les quatre fenetres sont du meme regime recent.
4. **LE PLUS LOURD : la fidelite du moteur.** Le montage tourne avec le clone MQL5, qui n'a
   JAMAIS ete confronte a l'original — seul le MQL4 l'a ete, sur trois jours. La fidelite de
   ce qui produit ces chiffres n'est pas etablie. Seul point qui demande du travail.
