---
name: moteur-multi-jeux
description: "État 20/09 12 h 45 : v1.47, livre entier 96,5 % pondéré (or 98,5 %, argent 95,8 %, AdvSc 94,3 %) ; projet du 04/09/2026 - moteur maison Eagle-owl qui lit les jeux UBS ; validé sur or (08/09), volatilité EURUSD (12/09), Daytrade Pro devises (13/09), or B/B2/B3/B4 et argent Till (15/09) ; 16-17/09 v1.05-v1.22 une règle par version, mesurée sur bancs mono-jeu ; état v1.28 (18/09 15 h) : or 104 %, argent 114 %, USO 91 %, EUR 98 %, CHFJPY 164 %, JPY 90 %, AdvSc 90 % des positions ; sorties ea = fausse cassure à la cadence d'Exit_Timing ; réfutées : v1.10, v1.14, v1.15, v1.16b, v1.18, v1.20, v1.21b (horloge UBS), v1.22 (MinDist non scalé), v1.23, v1.24 ; cinquième portefeuille tout maison sans or 9,41"
metadata: 
  node_type: memory
  type: project
  originSessionId: d0e7cce4-cea8-47de-9dd2-1ae784bc5f8a
  modified: 2026-09-19T16:08:35.324Z
---

Ouvert le 04/09/2026 vers 10h05 sur son « Si cela a une chance d'aboutir on y va ! », apres que
CassureOr v2 a montre qu'un jeu seul de cassure est mince (PF 1,51, 16 transactions/an) et que le
rapport 4-7 de Reaper/UBS est celui d'un portefeuille de 9-14 jeux.

**Architecture** : `MoteurCassure_v3.mq5` (dossier `MQL5\Experts\CassureOr`, copie dans `outils`) lit les
`.set` UBS (UTF-16, `FILE_UNICODE`) du dossier `Common\Files\SetsB` et fait tourner chaque jeu avec son
magic. Implemente : S/R (niveaux force L/R, countback, UpDiff/DownDiff negatifs = entree avant le
niveau, MaxPending, expiration, cadence Entry_Timing), volatilite (DevFactor x ATR), valeurs variables
(distances x ATR_D1/DefaultValue ; ATRDefault en $ si DefaultValue=0, hypothese), trailing SL/TP,
break-even, trailing sur swings, filtre d'ecart, NFP (premier vendredi 13h30 GMT, +2/+3), bougies de
confirmation (entree au marche apres cloture au-dela du niveau). Stops reels. Lot force 0,01.

**Reference mesuree, pas supposee** : `n18_ubs_or_lot001` = UBS lui-meme, 14 jeux or, lot fixe 0,01
(`Risk=0`, `AdjustLotsizeToVariableValues=false`), depot 100 000, 2021-2024, ticks reels. Lance 10h03,
~2 h. Puis chaine automatique (`jour19_chaine.ps1`) : `n19_moteur_1` (DaytradePro seul) puis
`n20_moteur_14`. Comparaison jeu par jeu par `compare_jeux.py` (commentaire des deals).

**Criteres de validation fixes d'avance** (`outils/PROTOCOLE-MOTEUR-MULTI-JEUX.md`) : transactions
±25 % d'UBS, PF ±0,15, rapport >= 75 %, signe du net identique sur >= 10/14 jeux, transactions ±40 %
sur >= 10/14. Trois passages de correction max. Le moteur doit REPRODUIRE, pas ameliorer ; les leviers
sur le creux (positions simultanees, vendredi, dimensionnement) viennent APRES validation.

**Piege appris** : codes d'unite de temps MQL5 : 16385 = H1, 16388 = H4, 16408 = D1, 32769 = W1
(j'avais lu 16408 comme W1 : CassureOr v2 a tourne en hebdomadaire). Et `ArraySetAsSeries` est
interdit sur un tableau statique (warning 63) : c[0] devient le plus ancien.

Voir [[ea-maison-cassure-or]], [[deux-livrables-attendus]], [[mt5-pieges-outillage]], [[profalgo-un-seul-moteur]].

**Mecanismes UBS etablis par mesure jeu par jeu (04/09 apres-midi), a reutiliser tels quels :**
1. `DefaultValue` est un PRIX de reference : facteur = prix / DefaultValue (0,59 mesure pour 1800/2900 ;
   0,82 pour 2400/2900 ; Gold Reaper 6 : 0,76 et 1,03 pour 2400). `ATRDefault` (en $) = ATR de reference,
   facteur_atr = ATR(ATR_Period, ATR_Timeframe)/ATRDefault ; les deux se multiplient. Avec cette regle, cibles
   et stops du moteur = ceux d'UBS a 5 %.
2. `ST1_MaxPendingOrders` = plafond TOTAL par jeu (UBS : 1 ordre a la fois, 106 achats / 91 ventes).
3. UBS ne traite que le SWING LE PLUS RECENT confirme de chaque cote (rang 0 : 125/197 entrees, rang <= 1 :
   146/197), qui est aussi le plus proche du prix (170/197). Prendre « le plus proche » parmi tous les
   niveaux entre sur des swings perimes et perd.
4. Avec bougie de confirmation, une seule entree par niveau par fenetre d'expiration (goldtrade_E : 82
   entrees en 4 ans = une par niveau ; mon marche a chaque cloture M1 en faisait 2 326).
5. Reference lot fixe 0,01, 100 k, 2021-2024 : UBS or 14 jeux = 3 550 tr, PF 1,62, +6 024 $, creux 359/474 $,
   rapport 4,24 ; Gold Reaper 9 jeux = 2 207 tr, PF 1,95, +3 490 $, creux 205/264 $, rapport 4,22.
   **Meme pente** : la difference 83 vs 41 %/an etait du dimensionnement. Gold Phantom sur la meme fenetre : 5,2.
6. Sorties UBS : TP atteint en 6 min (mediane) ; 43 sorties « ea » a −1 $ en 8 min, non expliquees.
Versions : v3.04 echelle, v3.05 plafond total, v3.06 niveau consomme, v3.07 derniers swings (fichiers
separes `MoteurCassure_v3_06/07.mq5` pour ne pas ecraser un .ex5 en cours de test). Le tester laisse parfois
un terminal inactif apres « automatic testing finished » : `Stop-Process -Name terminal64 -Force`
(taskkill echoue) avant que la chaine reparte.

**Etat 04/09 17h00** : v3.11 (`MoteurCassure_v3_11.mq5`) = 2 852 transactions (UBS 3 550), PF 1,10 (1,62),
+1 065 $ (+6 024), signe identique 11/14. Reproduits : volatilite M5, goldtrade D/E/H, GoldDaily3, GoldbotOne,
DaytradePro en partie. NON reproduits : Gold Reaper 4-7 (niveaux H1/H4, confirmation M1+M15, 2-5 ordres) : moitie
des entrees, cibles atteintes 2x moins, nets ~0 contre +300 a +990 — la moitie du net d'UBS. Mecanismes ajoutes
en plus des 5 deja notes : (6) l'ordre en attente SUIT le dernier swing (age median du swing a l'entree 11 j chez
UBS) ; (7) confirmation = pose d'un ordre STOP au-dela de la bougie qui confirme (13 % des entrees UBS a la seconde
0, pas 100 %) ; (8) sortie sur fausse cassure a la PREMIERE cloture apres l'entree sur chaque unite de
confirmation, seuil entree − |decalage| (UBS : 50 % a une cloture M15, durees < 18 min). Outil : `compare_jeux2.py`
(attribution des sorties par le prix ; l'ancien melangeait les jeux). Reste mesurable : nombre d'entrees Reaper
(moitie) et instant d'entree (cibles UBS en 6 min). Decision a lui : continuer les diagnostics Reaper 5-7 ou
ecrire « non reproductible » pour ces quatre jeux et garder le moteur pour les dix autres.

**Etat 04/09 19h15 — v3.14 (`MoteurCassure_v3_14.mq5`)** : 3 503 tr (UBS 3 550), PF 1,33 (1,62), +3 360 $ (+6 024),
rapport 2,53 (4,24), signe 14/14, ±40 % 9/14 : trois criteres sur cinq. Mecanismes ajoutes depuis 17h : (9) la
confirmation n'est PAS un filtre d'entree (entree UBS = niveau + UpDiff a 0,02 $ pres) ; (10) l'ordre est toujours au
candidat le plus PROCHE du prix (155/197 fois mon ordre etait de l'autre cote) ; (11) un niveau est CONSOMME des
qu'une position en sort autrement que par la fausse cassure (UBS : 117/150 niveaux entres une fois, re-entrees a
1,9 h). Echelle d'ordres : refutee (97 % d'entrees isolees). Outil `vie_ordres.py` (vie des ordres depuis le journal
du testeur, contre les entrees UBS). Restent : Reaper 4 (43 entrees / 225), Reaper 6 et 7 en net, GoldbotOne, les
deux jeux de volatilite (+50 % d'entrees).

**Etat 04/09 19h45 — v3.16 (`MoteurCassure_v3_16.mq5`)** : 3 582 tr (UBS 3 550), PF 1,46 (seuil 1,47), +3 975 $
(+6 024), rapport 3,80 (seuil 3,18 ✓), signe 14/14, ±40 % 12/14 : quatre criteres sur cinq. Ajouts : (12) volatilite =
CORPS de la bougie M5 (P10 corps/ATR_H1 = 1,54 pour DevFactor 1,5) ; (13) seuil de fausse cassure = niveau − 2 decalages ;
(14) la distance minimale au niveau est une condition de POSE, pas de maintien (Reaper 4 : 2 833 suppressions sur
2 939 ordres avant). Reste : les entrees gagnantes manquantes des Reaper 5-7 (cibles 168 vs 305 sur Reaper 6 avec
stops et fausses cassures identiques).
**19h50** : Reaper 6 trace en v3.16 : 395/660 entrees UBS avec mon ordre au meme prix ; 240 fois mon ordre sur un swing
voisin (1-2 $) ; consommation alignee (re-entree apres fausse cassure 60 % UBS / 52 % moi, ~0 apres cible ou stop).
Prochain cycle si on continue : choix entre swings voisins (le plus PROCHE strictement ? le plus recent parmi ceux a
moins de X $ ?) et seuil M15 de la fausse cassure (56 cibles UBS fermees par moi, 36 l'inverse).


**Etat 08/09/2026 -- v3.19 (`MoteurCassure_v3_19.mq5`) : 91 % du net d'UBS, quatre criteres sur cinq.**
n55 (14 jeux, memes conditions que n18) : **+5 337 $** (UBS +5 882), rapport **4,14** (4,24), PF **1,54**
(1,60), creux **332 $** (359, donc plus bas qu'UBS), signe 14/14, +-40 % 10/14. Seul echec : transactions
totales 4 694 contre 3 550 (**+32 %**, seuil +-25 %).

**Fausse piste ecartee** : le « 240 swings voisins sur 660 » du 04/09 venait de `vie_ordres.py` (suivi des
ordres dans le journal, sensible aux cycles de vie). Mesure directe en v3.17 (instrumentation seule, dump
des candidats) : **la selection de niveau est juste a 96,7 %** (177/183 sur deux semestres independants).

**Vraie cause, mecanisme (15)** : `TropProche` appliquait `MinDist_orders` (55 pts = 0,55 $) aussi aux
POSITIONS deja remplies. Toute re-entree au meme niveau etait donc refusee tant que la position y restait
ouverte. Trace du 18/09/2023 : mon moteur ouvre UNE position a 08:38 et la garde 24 h, pendant qu'UBS fait
six allers-retours sur ce meme niveau (grappes identiques les 05/09, 26/09). Ce n'etait ni MaxTrades (5
autorisees, 1 utilisee) ni la consommation de niveau (aucune sortie encore survenue). v3.18 : la distance
minimale ne vaut qu'entre ordres EN ATTENTE.

**Mecanisme (16)** : la levee de v3.18 faisait reessayer un ordre refuse a CHAQUE tick ; pendant les marches
fermes cela inondait le journal du testeur (**1 Go en 6 min**, chaine coupee par le garde-fou). v3.19 ne
reessaie que sur refus transitoire (requote, prix change, timeout, connexion).

**Reste a mesurer avant de coder** : le sur-trading de 32 % est concentre sur quatre jeux -- Reaper 6
(1 002 contre 660), Reaper 7 (824/541), GoldDaily1 (249/139), GoldDaily2 (169/75), exactement ceux qui
echouent au +-40 %. Question a mesurer : ces quatre-la ont-ils chez UBS une cadence minimale entre deux
re-entrees au meme niveau que les dix autres n'ont pas ? Mesure = ecart de temps entre re-entrees
consecutives au meme niveau, jeu par jeu, UBS contre moteur.


## 08/09/2026 (suite) : le moteur s'appelle EAGLE-OWL

**Renommage, sa decision** : `MQL5\Experts\EagleOwl\EagleOwl_v1.mq5` (copie dans `outils`). Les
`MoteurCassure_v3_*` restent intacts comme trace des mesures -- meme convention que Wolf -> [[clone-wolf-or-gbpusd]].

**Mecanisme (17), le plus net de la journee** : la re-entree au meme niveau est gouvernee par `MaxTrades`.
Mesure sur 4 ans, ecarts entre re-entrees consecutives au meme niveau : les **6 jeux a MaxTrades=1**
(GoldDaily1/2/3, GoldbotOne_8, M5_C, M5_H) totalisent **UNE** re-entree chez UBS ; les **8 jeux a
MaxTrades>1** en totalisent **702**. L'exemption « re-entree permise dans les 30 min apres une fausse
cassure », mesuree en v3.14 sur Reaper 6 puis generalisee, ne vaut que pour les jeux MULTI-positions.

**Refutee par la mesure (a ne pas refaire)** : v3.20 supprimait les ordres en attente des que le plafond
de positions etait atteint -- aucun effet (9 400 transactions contre 9 388), l'ordre est deja rempli quand
le plafond est constate.

**EagleOwl_v1 (n57)** : net **+5 270 $** (91 % d'UBS), rapport **4,09**, creux **332 $** (contre 359 chez
UBS), signe 14/14, +-40 % 10/14. **Dernier critere a 2 % de passer** : 4 539 transactions contre un
plafond de 4 438. Reaper 6 (1 008 / 660) et Reaper 7 (826 / 541), les deux jeux a MaxTrades=5, portent
tout l'excedent (+633). Prochaine mesure : la fenetre de 30 min et le seuil de 10 points qui definissent
« meme niveau » sont-ils bons pour ces deux jeux, ou UBS impose-t-il en plus une cadence minimale ?

**Portefeuille 100 % maison mesure le 08/09** (Eagle-owl x1 + Zebra or x12 + GBPUSD x40 + EURUSD x20) :
rapport **10,37**, moities 10,85 / 10,11, **37 %/an corrige du reel** a la marge 50 %, creux 4,90 %,
6 mois negatifs sur 48. Contre 27,1 % pour Zebra seul et 46,8 % avec UBS (interdit en algo chez Axi
Select, voir [[propfirm-choix-maison]]). Eagle-owl seul : rapport 4,31 contre 4,33 pour UBS, correlation
+0,77 avec UBS (c'est un SUBSTITUT, pas une brique de plus) et +0,12 / -0,01 / +0,01 avec les trois
jambes Zebra. **Eagle-owl ne trade que l'or** : les 14 jeux de `SetsB` sont tous des jeux or.

**Devises, sa question du 08/09** : `SetsC` (30 jeux hors or, dont SetsC_EUR 8 et SetsC_FX2 2) est deja
sur le disque et Eagle-owl les lit tels quels -- une instance par symbole (le moteur travaille sur
`_Symbol`). Voir [[ubs-hors-or-mesure]] : les 17 jeux hors indices ajoutent **+74 % a creux egal** malgre
une rentabilite individuelle quasi nulle. Les 13 jeux indices restent exclus.


## 08/09/2026, fin de journee : EAGLE-OWL EST VALIDE (5 criteres sur 5)

**Mecanisme (18), le dernier** : un niveau ne peut pas etre entre plus de `MaxTrades` fois dans la fenetre
`max(expiration, 24 h)`. Mesure decisive : la taille des grappes de re-entrees au meme niveau, sur quatre
fenetres de regroupement (2 h a 24 h) -- **Gold Reaper 7 ne depasse JAMAIS 5 entrees au meme niveau chez
UBS** (= son MaxTrades), zero grappe au-dela, insensible a la tolerance de prix (0,05 a 0,50 $) ; le moteur
y montait a 11. Compteur par niveau (`EntreesAuNiveau` / `CompteEntree`), incremente a l'APPARITION d'une
position.

**Rapport n58 -- les cinq criteres du protocole sont atteints** : transactions **4 416** (cible
2 663-4 438), PF **1,52** (UBS 1,60, cible 1,47-1,77), rapport **4,09** (seuil 3,18), signe **14/14**,
+-40 % **11/14**. Net **+4 981 $** (85 % d'UBS) pour un creux de **313 $ contre 359 $** : il gagne moins,
il risque moins. Reaper 6 rentre dans la cible (922 contre 660).

**Ce qui commence maintenant**, prevu par le protocole apres validation : mesurer les leviers sur le creux
(plafond de positions simultanees, coupure du vendredi, dimensionnement par jeu a creux egal), un test par
levier, contre le critere « baisse le creux sans detruire le rapport » (-15 % / >= 90 %).

**Portefeuille 100 % maison avec le moteur valide** (Eagle-owl x1 + Zebra or x12 + GBPUSD x40 + EURUSD x20) :
rapport **10,17** en prop firm (moities 10,32 / 10,24), **36 %/an corrige du reel** pour **4,86 % de creux**
a la marge 50 %, 6 mois negatifs sur 48 ; rapport **10,61** en compte propre (77 %/an corrige pour 10 % de
creux). Correlations d'Eagle-owl avec les trois jambes Zebra : **+0,13 / -0,02 / +0,02**.

Contre 27,1 %/an pour Zebra seul et 46,8 % avec UBS (interdit en algo chez Axi Select) : le portefeuille
maison recupere les deux tiers de l'ecart et il est entierement utilisable. Voir
[[propfirm-choix-maison]] et `outils/PORTEFEUILLE-ZEBRA-AXISELECT.md`.


## 08/09 (fin) : reserve 2025 tenue, dosage par jeu REFUTE

**Le moteur tient hors echantillon** : n66, Eagle-owl sur 2025 (annee jamais utilisee pour regler),
+2 506 $, creux 430 $, **rapport 5,95** contre 3,98 sur 2021-2024.

**Le dosage par jeu est une correction de resultat, refutee -- a ne pas refaire.** Optimisation au sens
du pire des deux moities (poids dans {0 ; 0,5 ; 1 ; 1,5 ; 2}) : rapport 3,98 -> **6,58** en echantillon,
mais **6,54 en reserve contre 6,71 pour l'uniforme**, et le creux passe de 373 a 571 $. Le +65 % etait
entierement de l'ajustement a l'histoire. Illustration directe de [[backtest-refute-ne-confirme-pas]].

**Seul le retrait de M5_H tient** (meilleur sur les DEUX periodes : 4,40 contre 3,98 en echantillon,
6,78 contre 6,71 en reserve). C'est le seul jeu negatif sur les deux moities independamment (-0,32 et
-0,32) : un fait, pas un reglage.

**Fermes le meme jour** : croisees or (XAUEUR -0,5 %/an avec un creux de 3 045 $ contre 313 ; XAUJPY
hors d'echelle car DefaultValue est un prix de l'or EN DOLLARS et le facteur explose a x151 ; XAUAUD.p
et XPTUSD.p n'existent pas chez PU Prime) et jeux hors or d'UBS dans Eagle-owl (EURUSD -21 $ contre
+862 chez UBS, CHFJPY -8 $) : les ENTREES sont reproduites (1 694 contre 1 664) mais la reussite tombe
de 65 a 47 %, l'ecart est dans l'instant d'entree du modele de volatilite. Le gain de diversification
chiffre a 42 %/an reposait sur la courbe d'UBS et **n'est pas atteignable avec Eagle-owl**.

**Le rapport ne s'ameliore donc pas par la selection des jeux.** Leviers restants (protocole §3), tous
sur le creux : plafond de positions simultanees, coupure du vendredi. Chacun devra passer la reserve.

**Luna AI PRO** (retour a la moyenne, le poste vacant) : le produit est sur le disque en MT4
(terminal Vantage F1BBCAAC) mais **jamais backteste** -- le `v_LunaAIPRO.htm` est un export de
parametres, pas un rapport. Ses parametres livres : `MaxOpenTrades=99`, `SetSLTP_AfterEntry=0`, aucun
`StopLoss=`, `maxdrawdown_enable=0` (seuil 70 %), `consecloss_enable=0`. Donc **pas de stop dur, 99
positions concurrentes, protections eteintes** -- signature grille/moyennage. Sa question du 08/09
(« c'est sans SL, non ? ») etait juste. Voir [[crible-signaux-mql5]] et `CRIBLE-RETOUR-MOYENNE-TIERS.md`.

## 12/09/2026 : les distances UBS sont en PIPS sur 3 et 5 décimales — Eagle-owl corrigé

**Le piège** : la mesure du 04/09 « aucun facteur pips→points chez cet éditeur » (`Exit_stop=220` → 2,20 $) était
faite sur l'or à 2 décimales, où pip = point. Sur EURUSD/GBPUSD (5 déc.) et CHFJPY/USDJPY (3 déc.), UBS lit
`Exit_stop=85` comme **85 pips** ; Eagle-owl lisait 85 points → sorties 10× trop courtes, trois tests devises
négatifs (n117-n119 premier passage : 0,04 $ par transaction contre 1,06 chez UBS, même nombre d'entrées).
Corrigé dans `EagleOwl_v1.mq5` : `pip = _Point × (10 si 3 ou 5 décimales)`, utilisé par `D()` et le filtre
d'écart ; sans effet sur l'or par construction. Cohérent avec le jeu Advanced Scalper converti du 10/09
(`Exit_stop=22` = 22 pips sur USDJPY, validé avec UBS).

**Après correction** : les 7 jeux Volatility Breakout EURUSD (`EURUSD_e…o`) reproduisent UBS à ±10 % de net et
±5 % de transactions — **modèle 2 validé sur devises**. Les 3 Daytrade Pro (modèle 1, S/R) **sur-tradent sur
devises** (EURUSD 294 tr contre 187, CHFJPY 364/159, GBPUSD 596/110) alors que le modèle passait sur l'or :
à diagnostiquer avec la méthode du 08/09 (listes d'entrées niveau par niveau). Réserve : chez UBS les deux jeux
FX2 tournaient sur un seul graphique GBPUSD, la référence CHFJPY est elle-même discutable.

**Outillage** : le journal du testeur prend ~300 Mo par test devises (`position modified` à chaque tick, trailing
sans pas) ; le lanceur coupe à +1 Go par test. À corriger dans le moteur (pas de résultat en jeu).

Détail et tableau jeu par jeu : `outils/TESTS-A-REALISER.md`, test 5. Voir [[tests-a-realiser]].

## 12/09 soir : trois règles du modèle S/R corrigées, mesurées sur Advanced Scalper USDJPY (`outils/diag_sr.py`)

1. **`UseEveryTick=false`** : trailing et break-even une fois par bougie de `Exit_Timing`, pas à chaque tick (le jeu
   AdvSc a `Exit_Timing=0` = H1 ; à chaque tick, un trailing à 1 pip verrouillait +4 $ au lieu de +13).
2. **Fausse cassure seulement avec bougie de confirmation** : sans confirmation UBS ne ferme rien (364 fermetures
   fautives sur H1 ; sur l'or `Exit_Timing=1` = M1 rendait le repli invisible).
3. **`ST1_MaxPendingOrders` par sens** (UBS : 5 achats + 5 ventes, vie médiane d'un ordre 69 h) et remplacement du
   plus éloigné seulement si le sens est plein — avec 1 ordre, c'est la règle de l'or validée le 08/09.

Résultat : sorties identiques à UBS sur USDJPY (net 100 % à l'étape 2, 89 % à l'étape 3), or à **97 % d'UBS** (n121)
contre 85 % avant. **Reste un seul écart, commun : `Niveaux()` accepte des swings jumeaux à 3-6 pips** (1 218 niveaux
contre 1 019 ; +24 % de transactions sur USDJPY, +35 % sur l'or). À mesurer niveau par niveau (commentaire `|niveau`
des ordres EO contre prix − UpDiff chez UBS), puis revérifier or + USDJPY + Daytrade Pro devises.

## 12/09, 22 h : swings jumeaux résolus — règle « swing le plus récent » ; état final du moteur

Les niveaux en trop étaient des swings **valides** servis trop tard. UBS : pose à la confirmation si le prix est à
≥ `ST1_MinDist_to_HL` du niveau, sinon attend que le prix s'éloigne (délai médian 4 h) **tant que le swing est le plus
récent de son côté**, puis l'abandonne ; repose permise sur un niveau ayant déjà porté un ordre. Implémenté
(`DejaPose`/`MemoPose`, candidat = rang 0 ou déjà posé). Outils : `diag_niveaux.py`, `diag_tardifs.py` ; barres H1
exportées par le pont Python `MetaTrader5` (qui laisse le terminal ouvert : le fermer avant `lance_chaine`).

**État** : or **90 % d'UBS, 4 années sur 4 dans ±40 %** (n121) ; Advanced Scalper USDJPY **105 %**, 96 % d'ordres
communs (n120) ; 7 jeux volatilité EURUSD ±10 % (n117). **Reste** : Daytrade Pro sur devises, 2-3× trop d'entrées —
mêmes niveaux mais cycle de vie différent (UBS pose à 00:05 et annule 80 % de ses ordres au rafraîchissement du lundi,
Eagle-owl laisse expirer). Voir `TESTS-A-REALISER.md`, tests 5 et 6.

## 13/09 : Daytrade Pro devises reproduit — règle « niveau dépassé » limitée aux symboles 3/5 décimales

Diagnostic complet dans `TESTS-A-REALISER.md` (test 5). Ce qui sépare tous les cas mesurés : **UBS n'abandonne un niveau
dépassé que pour un ordre d'anticipation (UpDiff < 0) sur un symbole à 3/5 décimales** (Daytrade Pro GBPUSD : 1 % de
poses sur niveau dépassé) ; sur l'or il repose massivement (Reaper 75 %, goldtrade 16-84 %) ; AdvSc (UpDiff > 0) n'est
pas concerné. Règle finale : 3/5 déc. + diff < 0 + dépassement > 0,5 pip. Résultat : GBPUSD 140 / +352 (UBS 110 / +341),
CHFJPY 194 / +586 (159 / +447), EURUSD 8 jeux 818 / +775 (832 / +862), or et AdvSc inchangés. Un critère « L ≥ 15 » avait
réparé GBPUSD seul ; une règle inconditionnelle cassait l'or (78 %). **État du moteur** : or 90 % (SetsB) / 89 % (SetsB2),
AdvSc 105 %, hors or 90 % (corr +0,83). Les Daytrade Pro devises n'améliorent pas le livre maison hors tirage (creux) :
reproduits, pas dosés. Outils : `diag_sr.py`, `diag_niveaux.py`, `diag_tardifs.py`, barres H1 or/GBP/JPY dans le scratchpad
(à régénérer : pont `MetaTrader5` ou M1 → H1).

## 15/09 soir : v1.01 (distances en double) — ce qui passe, ce qui ne passe pas

**Le chantier `EntryModel=1` s'est fermé sans code** : n134 (UBS, jeux Till) ne contient aucun ordre limite — le paramètre est inerte
dans ce build v7.0. Le vrai défaut était la lecture des distances **décimales** des jeux clients (`DownDiff=-0,6` → 0). Après correction :
**argent Till 107 % (93 % d'ordres communs), or SetsB3 96 %, SetsB4 96 %** (les 4 jeux or Till reproduits). **Ratent** : JPY D1 65 %,
EUR storyG 28 %, USO H4 223 % — les jeux hangsan/storyG à **offset positif** (ordre au-delà du niveau) : UBS repose le niveau D1
**chaque jour à 00 h** et annule (P3516 : 657 poses pour 43 remplissages), Eagle-owl pose une fois (12). Pistes : repose quotidienne
non modélisée pour UpDiff > 0 ; Eagle-owl pose à 01 h contre 00 h ; `BE_extra > BE_start`. Détail : `TESTS-A-REALISER.md` (n150-n155),
outil `compare_eo_ubs.py`. Chantier d'une demi-journée, méthode du 13/09.

**Suite le même soir (22 h-22 h 30), deux itérations mesurées.** v1.02 (« tous les swings, plafond levé ») **réfutée** : 166 % de deals,
net 10 % — la prémisse « 4-5 niveaux simultanés » était un artefact : au moment de 41 remplissages sur 43, UBS n'a qu'UN autre ordre
vivant ; il a **un ticket par côté qu'il déplace**. **v1.03 adoptée** (au-delà du niveau, 3/5 déc. : consommation permanente après
remplissage si MaxTrades=1, ordre gardé jusqu'à expiration, ordre opposé gardé pendant la position) : cadence reproduite (EUR 95 %,
JPY 105 %) mais net 51 % / 69 % — mêmes niveaux, moins bon moment. Reste : « quel swing, quand » (barres + `diag_tardifs`), P3516
(entrée D1, 12 deals) à instrumenter, R3 (offsets négatifs, 6 niveaux), XTW07 (MaxTrades 3, +40 % de deals). Leçon de méthode :
**un comptage par intervalles de tickets modifiés surestime la concurrence** — vérifier avec « combien d'ordres vivants à l'instant d'un
remplissage ».

## 16/09 matin (en son absence) : v1.05 → v1.08, une règle par version, chacune mesurée sur ce qu'elle touche + or en contrôle

- **v1.04 (récence) réfutée**, revert. **v1.05** : pas de fausse cassure pour un ordre sur/au-delà du niveau (offset ≥ 0, 3/5 déc.).
- **v1.06** : `TRADE_RETCODE_MARKET_CLOSED` à 00:00 serveur (pose D1) → réessai 60 s ; P3516 12 → 88 deals ; EUR storyG 84 %.
- **v1.07** : candidat d'anticipation (offset < 0, 3/5 déc.) = premier swing **vivant** (ni dépassé, ni consommé, ni plein), 8 swings ;
  JPY D1 72 → **79 %** (≥ 75 atteint), G347 70 → 110 deals (UBS 132), GBPUSD identique, CHFJPY niveaux 70 → 80 (UBS 76).
- **v1.08** (en test 08:00) : sur un ordre au-delà, **UBS n'entre jamais deux fois sur un même niveau** (BOJPY1 29/29, D343 33/33 malgré
  `MaxTrades 99`) ; le moteur ré-entrait parce que `Consomme()` recyclait l'emplacement après 168 h et que seul `MaxTrades=1` était
  permanent. Permanence portée par le niveau (`consoPerm`), fixée à la sortie selon le sens.
- **Second filtre de fausse cassure trouvé sur barres M15 (argent Till, `fc_m15_xag*.py`)** : UBS ne ferme **jamais** si la bougie de
  confirmation clôt avec un corps favorable (0/2 617) ; 60 % si corps contre, taux plat en âge/taille/distance ; résidu propre au jeu
  (75/61/40 %, ordre du countback, hypothèse « swing sorti de la fenêtre » non confirmée). → **v1.09 = corps contre exigé**.
- **v1.08b/c** : la frontière est **offset ≥ 0** (pas > 5 pips) et le niveau est consommé dès le **remplissage** (CHFJPY ventes 27/27 ré-entrées
  pendant la position, UBS 1/29). Résultat : **USO H4 reproduit** (100 % / 102 % / PF +0,05), EUR 101 % de deals, CHFJPY ventes = UBS.
- **v1.09 adoptée 10:12** : argent 192 sorties rapides contre 196 (419 avant), or **104 % d'UBS** (deals 122 %, PF −0,02 : trois critères
  tenus pour la première fois), USO 84 %, JPY 65 %. Or : 100 % identique de v1.05 à v1.08c (8 940 / +5 365), bouge seulement avec v1.09.
- **BOJPY (JPY, ordres au-delà) : les sorties sont reproduites** (`diag_sorties.py`, 23 entrées communes : +62,6 / +54,6 $, SL/TP à 0,003) ;
  l'écart vient de 9 niveaux qu'UBS ne prend jamais. `diag_swings_jeu` : **UBS garde son niveau** (1 720 reposes / 90 déplacements en 4 ans,
  735 pips du prix), le moteur re-choisit le plus proche à chaque expiration (105 pips). → v1.10 = niveau collant au-delà, sinon le plus récent.
- **v1.10 réfutée** (collant seul : JPY 89 %, banc 14 communes) ; **v1.11 adoptée** = collant + déplacement vers un NOUVEAU swing de rang 0
  posable, mesuré sur 1 811 poses UBS (`regle_audela.py` : 95 % même niveau, 65 des 90 déplacements vers le nouveau rang 0). Banc BOJPY4
  24 communes / 31 (UBS 30) ; JPY 92 % de deals (BOJPY 62-64 contre 58-60), EUR 85 %, **USO 98 %**, or et CHFJPY inchangés.
- **G347 (anticipation, `MaxTrades 99`)** : poses reproduites mais 17 entrées manquées — après un remplissage le premier swing vivant est le
  swing rempli (prix d'ordre sous le marché, imposable) ; UBS pose à **H+1 sharp** sur le swing d'au-dessus. → **v1.12** (en test 18:42) :
  premier swing vivant ET posable, réévaluation à l'heure ronde après un remplissage. **v1.12 adoptée 19:20, effet faible** (banc 51/66,
  tout le reste neutre). **État du soir contre UBS** : or 104 %, argent 115 %, USO 98 %, EUR 85 %, CHFJPY 166 %, JPY 67 % (deals 92 %).
  Reste : sorties G347 (fausse cassure M30 dans les deux sens, trailing différent) — banc n160, pas de règle sans mesure.

## 16/09 soir : chantier sorties G347 — v1.13 adoptée, v1.14 et v1.15 réfutées

- **Banc propre des deux côtés** : `n161` = UBS avec G347 seul (+137 $ ; l'attribution dans le rapport à 14 jeux lui prêtait +187), `n160` =
  moteur G347 seul. Leçon : les sorties UBS d'un jeu ne se lisent QUE sur un rapport mono-jeu (`Sets_Folder` dédié) ; `diag_sorties.py`.
- **v1.13 adoptée** : `Exit_TrailSL_Stop` (manuel V7 p. 30 : « profit beyond which the stop stops being adjusted ») — le moteur l'ignorait
  depuis le 04/09. G347 = 35 pips (UBS sort à +35,7), D343 32, or Daytrade Pro / goldtrade E-D 200. Communes G347 +48 → +50 $ (UBS +74),
  or +19 $, reste identique.
- **v1.14/v1.14b réfutées** (rafraîchir un ordre qui expirerait avant la bougie suivante) : inerte puis EUR 85 → 72 %. Le vrai mécanisme
  est l'**horloge d'UBS** : pose à 00:05 (396 ordres sur 648), vendredi annulation 14:40 → repose 16:00 ; le moteur pose/annule à toute heure.
  Chantier de demain, avec la sonde `n159` (Journal) sur le lundi 01/03/21 00:00-01:00 où le candidat d'achat manque.
- **v1.15 réfutée** (fausse cassure sans seuil) : juste sur G347 (UBS seul : 6/6 à corps contre, 0/58 favorable, seuil jamais vrai) mais
  JPY 68 → 63 % (hangsan_4, décalages −130) et argent 367 fermetures contre 286. Le seuil niveau − 2|décalage| dépend du décalage ; piste :
  seuil = min(niveau − 2|décalage|, entrée − X) ou proportionnel à l'ATR, à mesurer sur hangsan_4 seul et G347 seul.
- Barres USDJPY M30/M1 exportées (`outils/barres/`), `fc_bars.py` généralise `fc_m15_xag.py` (tf, offsets, DefaultValue, jeu).

## 17/09 matin : sonde n159 lue — v1.16a adoptée, v1.16b réfutée

- **Sonde (Journal CAND/POSE)** : le trou G347 de mars 2021 est une cascade partie du 04/02 : après un remplissage, le premier swing vivant
  était « trop près » (25 pips < MinDist 50) et le moteur n'examinait aucun autre ; UBS a posé un ordre au-delà d'un swing trop proche (cas
  2/197), rempli le 16/02, qui a décalé son cycle d'expiration (lundi/vendredi) — irréductible.
- **v1.16a adoptée** : MinDist dans la recherche du premier swing vivant posable. Banc G347 53 communes / 66 (51), JPY 70 % (seul G347 bouge),
  argent, CHFJPY, or identiques.
- **v1.16b réfutée** (collant pour l'anticipation) : argent −1 856 $, banc −30 $. Le collant vaut pour les ordres au-delà (95 % des poses UBS),
  pas pour l'anticipation où UBS suit le swing le plus récent vivant posable (192/195 confondu avec le plus proche).
- Mesure `regle_anticip.py` (swings D1 vivants = non dépassés après confirmation, posables = ≥ MinDist de la clôture D1) ; UBS respecte MinDist
  à la repose (5 exceptions sur 497, artefacts H+1).
- **v1.17 adoptée** (validée par lui 07:48) : sur 3/5 déc., seuil de fausse cassure = prix d'entrée (bancs UBS seuls G347 6/6, hangsan_4 87 %
  à corps contre sous l'entrée ; jamais sous niveau − 2|décalage|). Bancs : 38 paires ea→ea à ~0 $. JPY 70 → 64 % assumé (le moteur ne gagne
  plus à la place d'UBS sur hangsan_4 : +137 → +95 contre +77). Or garde sa règle (v1.15 sans seuil : −834 $).
- **(3) résidu argent : n'existait pas.** Banc AGA04 seul des deux côtés : UBS 58 % de fermetures à corps contre — mais le moteur v1.17 sans règle
  a la même empreinte (36 % / 100 % selon « jumelle plus ancienne ouverte », UBS 31 % / 98 %) → **artefact d'attribution des positions jumelles**
  (même niveau, même prix, `MaxTrades 5`). v1.18 (règle « pas de contrôle si jumelle ouverte ») sur-corrigeait (130 fermetures contre 286) :
  réfutée, revert. L'excédent argent (350 contre 286) vient des 140 entrées en trop (771 contre 697). Hypothèse « 5 swings » réfutée aussi.
- **État = v1.17** (MQL5 0a62132). Reste : 13 entrées G347 manquées (4 swing lointain, 5 aucun ordre à H+1), 140 entrées argent en trop.
- Leçon de mesure : avec `MaxTrades > 1`, toute statistique par position est suspecte (jumeaux) — comparer d'abord le moteur SANS règle à UBS.
- **(4) entrées G347 manquées** : sonde 4 ans n166. v1.19 (ordre existant reste candidat sous MinDist) : inerte, gardée. v1.20 (pas de
  consommation hors fausse cassure pour l'anticipation 3/5 déc.) : G347 57 communes / 66 (+136 $ = UBS), mais sur-entrée partout ailleurs
  (argent 128 % de deals, HJP 172 contre 132, « 4 » 388 contre 282) → **réfutée**. Mesuré : UBS ré-entre bien après TP/SL (repose dans l'heure),
  et sur AGA04 tout l'excédent du moteur est « pendant une position du même niveau » (328 contre 263, à 1-2 ouvertes) — la variable qui
  borne UBS n'est pas trouvée (ni horloge, ni MaxTrades, ni prix). **État = v1.19** (MQL5 revert de v1.20).
- **(a) 09:28-09:48, banc AGA04** : réfutés un à un — plafond de positions (niveau ou jeu : ≤ 4 des deux côtés), moment de la repose (mêmes
  délais, médiane 0,22 h), ordre pré-existant (266/269 sont des reposes après remplissage), MinDist non scalé (manuel p. 20 : les pips sont
  scalés). Fait restant : le moteur pose/annule 2× plus (4 266 ordres contre 2 068) et son excédent se concentre à ATR bas (range) → le
  **rythme de réévaluation** (horaire chez le moteur, 01:01 + H+1 chez UBS) est le suspect ; à modéliser comme horloge, chantier à part.
- Rapports sauvés `_v10x.htm` / `_v11x.htm` dans le dossier du terminal ; banc mono-jeu : `Seulement=<fichier.set>` (nom exact) ou dossier
  dédié ; outils : `diag_sorties.py` (sorties à entrées communes), `reentrees_niveau.py`, `regle_audela.py`, `fc_m15_xag*.py`. Leçon d'outil : `compare_eo_ubs.py` par jeu vaut pour les DEALS ; le net par jeu dépend de l'attribution quand plusieurs
  jeux partagent un symbole (seul l'ENSEMBLE est fiable) ; `reentrees_niveau.py` compte niveaux distincts / entrées par niveau.

## 17/09, 10 h : chantier horloge (sa voie (1)) — v1.21b en jugement, v1.22 réfutée

- **Horloge UBS mesurée sur les journaux** (G347, AGA04) : repose à la SECONDE d'expiration (même niveau), vendredi 14:40 annulation → 16:00
  repose, purge du week-end → lundi 00:05, H+1 après remplissage/sortie, 01:01 sur l'argent (ouverture de session) ; la SÉLECTION du swing ne
  change qu'à ces instants (`g_deplacement`), le reste du temps le moteur ne fait que reposer ce qui a disparu.
- **v1.21b** (`jourHorloge`, `jourVen16`, `nOrdresVus`, fenêtre 14:40-16:00 le vendredi) : rythme d'ordres reproduit (AGA04 2 131 ordres contre
  2 068 chez UBS, contre 4 266 avant ; heures identiques), **entrées inchangées** sur tous les bancs (G347 53/66, AGA04 759 / 620 communes).
  Le rythme n'était donc PAS la variable des 139 re-poses « pendant une position » de l'argent. **Chaîne complète : RÉFUTÉE** — JPY 62 %
  (v1.19 64), argent 111 % (114), EUR 77 % (85), USO 81 % (98) : 4/4 en recul. Sélectionner le candidat aux seuls instants d'horloge est
  moins bon que le réévaluer à chaque heure ; UBS compense par une variable non trouvée. Retour à **v1.19** (MQL5 4e703c0, étiquette `v1.21b`).
- **Contre-signal CHFJPY** : v1.21b y est FIDÈLE (322 deals / 123 % contre 372 / 166 % en v1.19 — le sur-trading Daytrade Pro devises du 12/09 est
  un effet de la bride des déplacements). Séparé en deux : **v1.21c** (calendrier seul) = v1.19 partout → le calendrier est inerte ; **v1.21d**
  (bride limitée à l'anticipation) garde CHFJPY 123 % mais USO 86 % (98) et EUR 77 % (85) → réfutée. La bride est juste pour UN ordre
  d'anticipation lointain sur D1 (Daytrade Pro), fausse pour trois ordres collés sur H4 (XTW07) : deux cas, pas de mécanisme — ne pas conditionner.
  **Chantier horloge clos 17/09 12:56, état v1.19** (étiquettes MQL5 `v1.21b/c/d`).

## 17/09 13 h : TER MAISON (`outils/ter_maison.py`) — le hors or maison remplace UBS, l'or coûte, l'AdvSc MT4 n'est pas au protocole

- Compte propre du 10/09 (hors tirage **13,80**) rejoué à l'identique. **UBS hors or → Eagle-owl hors or (EUR 8 + GBPUSD + CHFJPY) : 14,01** — substitut
  complet ; le JPY à 64 % ne pèse pas, les jeux hangsan ne sont pas dans le livre. **UBS or → Eagle-owl or v1.19 : 12,22** (−11 %) ; avec n58 du 08/09 :
  13,29. Tout maison ré-optimisé : **10,69** ; Axi Select tout maison : **11,57** (10,32 le 10/09).
- **Cause datée : v1.09** (fausse cassure or si corps M15 contre) — or +5 365 / creux 372 / 3,61 → +6 112 / **471** / 3,24 (UBS 340 / 4,33). Adoptée le
  16/09 sur le net seul. Prochain chantier utile : fausse cassure OR, mesurée d'abord sur UBS or seul ; cible creux ≤ 372 à net ≥ 100 %.
- **Soir (17:45-19:25), chantier « creux or »** : sur bancs mono-jeu Reaper 5/6 (UBS et moteur), sorties reproduites ; le creux vient des ré-entrées
  (R5 863 positions contre 570, R6 943 contre 660). Table des ordres UBS : `MaxPendingOrders` plafonne ordres + positions du sens (jamais dépassé) →
  **v1.23 réfutée** (R5 771, creux inchangé ; G347 et hangsan_4 dégradés ; or 3,25). Réfutées aussi : traversée du niveau, MinDist depuis l'ordre,
  état de la position précédente. UBS repose sur un niveau rempli dans 27 % des cas (moteur 40 %), 69 % à une fermeture de position — non expliqué.
  **Puis sa règle (19:05) a changé la question : tout prop firm = Eagle-owl SetsB2** (Reaper 5 et 6 absents). Eagle-owl SetsB2 v1.19 (n132) : 3,95
  (UBS 4,79). Livre turbo tout maison : Axi 12,95, classique 11,88 hors tirage (l'optimiseur écarte l'or ; à dosage fixe 14-15, SetsB2 = SetsB = sans or
  dans le bruit) contre ~20 avec UBS : **l'écart du substitut vient des jambes clients (JPY D1 1,12, EUR 0,61, USO 0,71), pas de l'or**. Outils :
  `ter_maison_b2.py`, `turbo_maison.py`.
## 18/09 matin : v1.25 adoptée — frontière « au-delà » à offset ≥ 0 ; JPY 64 → 72 % (deals 100 %) ; la fidélité par jambe vaut peu au livre

- **Retrait d'une jambe à la fois** (livres prop firm tout maison, dosage fixe) : remplacer une jambe Eagle-owl par sa version UBS rapporte au plus
  +1 de hors tirage (JPY +0,5) ; à dosage UBS, le livre maison a le même net (+35 332 / +35 372) et 50 % de creux en plus (creux joint des jambes).
  Et le turbo UBS de la page (19,98 / 20,68) tenait à la jambe AdvSc du backtest MT4, hors protocole : au protocole (n113) il vaut **17,52 / 17,86** —
  maison 14,72 / 14,87 = 84 % / 83 %. Page republiée (version 15) avec l'alternative au protocole, MT4 en « hors protocole, info ».
- **Bancs mono-jeu JPY (UBS et moteur, n172-n183)** : hangsan_1 = LA cause (143 positions contre 228 : UBS tient 2 ordres par sens 72-99 % du temps,
  moteur 6-14 %) ; B −44 $ (cible mal scalée ?), R3 −50 $ (sorties H4), BOJPY1/3 −45 $ (niveaux propres), A341 quasi fidèle. v1.24 (bloc au-delà à
  plafond 1 seulement) INERTE. **Sonde n184** : le moteur ne voyait que 2 swings — `AuDela()` exigeait un offset > 5 pips, or `DefaultValue 4000`
  ramène les offsets 0/10 de hangsan_1 à 0/0,4 pip → classé anticipation à tort. **v1.25 : `AuDela` = offset ≥ 0** (`SurOuAuDela`). Résultats :
  hangsan_1 176 communes / 228 (132), A341 79/84, JPY complet **2 196 deals = 100 %, +822 $ = 72 %** (64), USO 105 % (98), CHFJPY 149 % (166), EUR
  **77 % (85)**, or/argent/G347/hangsan_4/GBPUSD inchangés. État contre UBS : fidélité de net ~90 %. Résidu JPY = choix du second niveau (hangsan_1 :
  41 niveaux UBS jamais posés). Outils : `sonde_cand.py` (CAND par sens/heure), `standards_variantes.py`, `turbo_maison.py`.
- **v1.26 adoptée (11:42)** — sonde v1.25 contre la table des ordres UBS heure par heure (`second_niveau.py`) : 74 % des ordres UBS étaient dans les
  candidats du moteur, **22 % sur des swings plus anciens que son pool de 5** (jusqu'au rang 29, quand les récents sont du mauvais côté du prix), et
  UBS choisit par **récence** (rang 0 : 39 %, 1 : 23 %, 2 : 9 %). v1.26 : au-delà, pool de 30 swings et clé de pose nouveau rang 0 > collant > récence >
  distance. Résultat : hangsan_1 **203 communes / 228** (net 74 %), A341 82/84, **JPY complet 2 264 deals = 103 %, +924 $ = 81 %** (critère atteint),
  EUR 74 % (−3), reste inchangé. Fidélité de net **89 %**. Restes : EUR storyG (G357 177 % de deals), R3 (sorties H4), BOJPY (niveaux propres).
- Leçons : les « baselines » doivent être datées et versionnées (mes `_v119` d'hier soir étaient des v1.21c) ; le JPY complet prend 9 min, pas 1 h 23
  (le journal du testeur bloqué par `tail -f` ralentissait tout) ; hangsan_b : écart de TP initial 2,6 pips à vérifier.
- **Réserve sur le compte propre lui-même** : la jambe AdvSc JPY ×25 vient d'un backtest MT4 Vantage H1 2003-2024 (creux 8 $ en 4 ans au lot 0,01),
  corr +0,33 avec Eagle-owl + le même jeu en ticks réels (n120, lot 0,10 dans le rapport : ×0,1). Aucune référence AdvSc au protocole ; à mesurer
  (UBS + `AdvScalp_USDJPY.set`, 2 min) avant de doser. Voir [[quatre-standards-corriges-10-09]].
- **v1.22 réfutée** (MinDist en pips nominaux) : `MetAJourFacteur` = (bid/DefaultValue) × (ATR/ATRDefault) ; retirer le facteur ATR sur AGA04
  ne change RIEN (identique à v1.21b : MinDist ne borne pas ces re-poses), et hangsan_4 s'effondre (99 998 $ : 250 pips nominaux au lieu de
  ~17 scalés par prix/2000 → UBS scale bien MinDist par le facteur prix). L'écart « ~1 pip » vu sur la clôture M15 précédente était un
  artefact du proxy. Revert (MQL5 d28e8be = v1.21b).
- **Reste ouvert** : la variable qui borne les re-poses UBS pendant une position (AGA04 : moteur 328 contre 263) — ni plafond, ni délai, ni
  MinDist, ni rythme. Et : 5 entrées G347 « aucun ordre à H+1 », TER maison si JPY ≥ 75 %.

## 18/09 soir : A1 (re-poses or) — l'excédent est LOCALISÉ, la variable pas encore trouvée

Sonde Reaper 6 seul 2023-2024 (`repose_or.py`, n189 contre UBS n168) : une position ouverte n'empêche pas UBS de reposer (67 % des instants),
`MinDist_orders` ne s'applique pas aux positions (repose à 0,01 $), délais identiques (4-5 min, cadence M5). **La différence : après un
remplissage dont le niveau reste candidat, UBS ne repose pas dans 26 % des cas (55/208), le moteur dans 0,7 % ; dans 52 de ces 55 cas le
moteur se fait remplir 1 à 3 fois dans les 24 h = l'essentiel des 166 entrées en trop.** Réfutés comme séparateurs : nombre de positions
(niveau/sens/total), ordres vivants, remplissages déjà faits, rang du swing, distance du prix, heure, vendredi. À tester demain sur barres M1 :
position en perte / dernière bougie de confirmation contre au moment de l'évaluation M5. Luna : ticks Dukascopy présents pour AUDCAD et
EURGBP, mais deux lancements ratés (rapport vide non lu, puis instance inactive lancée pendant l'arrêt de la précédente).

## 18/09 18:25 : v1.29 adoptée — NFP à 8 h 30 New York (heure d'été américaine)

UBS ferme à 14:40 serveur le premier vendredi, été comme hiver (n140 JPY 17 + 12, n18 or 9 + 18, USO 1 + 3) ; le moteur, à 13:30 GMT toute
l'année, fermait à 15:40 l'été. `HeureEteUS` + NFP = 13:30 GMT − 1 h en été américain. Juges : hangsan_b ea → ea 15 → 16, USO 39 → 40, or B2
245 → 251 (communes 2 841 → 2 849), JPY complet 91 %, rien ne régresse. MQL5 becef69. Ce qui restait comme « purge du vendredi 14:40 » était ce
filtre. Filtre de taux : 6 jeux US30 seulement ; CPI : aucun ; paramètres prop firm des jeux : tous à zéro (rien à reproduire).
**Luna AI Pro (test 3, son « go aussi »)** : banc MT4 lancé le soir (`luna_prep.py`, `mt4_luna_chaine.ps1`, M1 exporté du MT5 → `.hst`, 8 paires,
paramètres livrés à lot fixe, `MaxOpenTrades` 99 pour voir s'il empile) ; à lire : positions simultanées et progression des lots d'abord.

## 19/09 matin : v1.30 jugée, v1.30b adoptée comme v1.31 — fenêtre de repose adaptée à la cadence d'entrée

**A1 : re-poses or/argent pendant une position (sa demande 19/09 matin)** — recherche sur barres M1 (`repose_or_m1.py`, `repose_or_arbre.py`) : UBS
re-pose un niveau rempli, position ouverte, **que dans les 30 minutes qui suivent le remplissage** (0 % après 30 min sur 917 évaluations). Fenêtre
décroît 66 % → 3 % par unité d'Entry_Timing, puis zéro. Cible : adapter la fenêtre à la cadence d'entrée de chaque jeu (Reaper 6 M5 → 30 min,
hangsan_4 H1 → 6 h).

**v1.30 (compilé 08:01 chaîne 09:07 v1.30b 09:07)** : `ReposeFermee` fenêtre fixe 30 min. Résultats v1.30 : R6 1712, R5 1538, AGA04 1464, G347 110,
H4 238, JPY1 424, EUR 304, USO 774, AdvSc 1360, CHFJPY 162, GBPUSD 106, JPY 2054, or B2 7850, or SetsB 7854 deals.

**v1.30b → v1.31 (compilé 10:13)** : fenêtre = `6 × PeriodSeconds(j.tfEntree)` — M5 30 min, H1 6 h, H4 24 h, D1 144 h. Résultats v1.30b : R6 1712 (=),
R5 1696 (+10,3 %), AGA04 1464 (=), G347 110 (=), H4 286 (+20,2 %), JPY1 424 (=), EUR 304 (=), USO 810 (+4,7 %), AdvSc 1360 (=), CHFJPY 206 (+27,2 %),
GBPUSD 266 (+151,5 %), JPY 2114 (+2,9 %), or B2 7666 (−2,3 %), or SetsB 8298 (+5,7 %). **Adopté sur le compte de deals** ; réserve : ces écarts ne sont
pas une mesure de fidélité (communes/manquées/inventées) — à repasser avec `fidelite_entrees.py`.

## 19/09 11 h : v1.32 adoptée — « swing dépassé = mort » s'applique AUSSI à l'or ; le livre or passe à 100,1 % des positions d'UBS

- **Une croyance inscrite dans le code était fausse.** Le commentaire du moteur disait « sur l'or (2 déc.) il repose massivement sur des niveaux
  dépassés (Reaper 75 %) : non concernés », d'où la restriction `dig == 3 || dig == 5`. **Mesure du 19/09 : UBS ne pose sur un niveau déjà dépassé
  que dans 3,5 à 3,9 % des cas (2 943 poses de R6) ; 96,7 % visent un pivot jamais atteint.**
- **Leçon de méthode, la plus utile du jour** : la reconstruction d'un niveau UBS EXIGE le facteur de valeurs variables (`prix/DefaultValue` ;
  R6 `DefaultValue=2400`, l'offset de 115 points vaut 0,91 $ à 1 900 et 1,24 $ à 2 600). Contrôle contre les pivots réels : **100 % avec le facteur,
  25 % sans**. Le « 75 % » d'origine est très probablement ce taux d'échec de reconstruction pris pour un comportement d'UBS. Tout outil qui
  reconstruit un niveau doit porter ce contrôle de cohérence en interne (`fc_or_swing.py` le fait).
- **v1.32** : restriction décimale levée pour les ordres EN DEÇÀ (`upDiff/downDiff < 0`) aux quatre endroits (lignes 449/453 choix du premier swing
  vivant, 490/508 filtre des candidats). Ordres AU-DELÀ non touchés (autre règle, autre version). MQL5 b5b7915.
- **Témoins strictement identiques** : argent AGA04, USO, CHFJPY, EUR — l'argent et l'USO sont à **3 décimales**, la règle y était déjà active.
- **Fidélité** (`fidelite_entrees.py`, neuf) : R6 inventées **286 → 156**, communes 86,4 → 90,6 % ; R5 inventées **293 → 92**, net **117 → 98,4 %**
  d'UBS. **Livre or complet (n18, 14 jeux) : 4 149 → 3 554 positions, soit 116,9 % → 100,1 % d'UBS**, net 93,6 %.
- **Retenir** : le compte de deals ne mesure pas la fidélité ; un moteur peut avoir le bon nombre d'entrées en ratant autant qu'il en invente.
  Trois nombres obligatoires : communes, manquées, inventées.
- **King Robot (Myfxbook 11742235, leapfx, Blaze Markets)** : écarté sur la fiche — Sharpe 0,05, **pips −3 978 pour +2 783 % de gain**,
  commissions 35 806 $, Z-Score −15,52. Gains en dollars sans gain en pips : ce n'est pas de la direction. Jamais vu par `dejavu.py` avant.
- **v1.33 adoptée (11:49)** : même règle pour les ordres AU-DELÀ sur l'or (six jeux, 28 % du livre or). Mesuré d'abord : 94 à 97,5 % des poses
  visent un pivot jamais atteint ; **c'est le pivot qui gouverne, pas le prix d'ordre** (GoldDaily3 : prix d'ordre déjà traversé dans 79 % des
  poses, pivot dans 4 %). Implémenté par un test `OffsetAuDela` **séparé** de `SurOuAuDela`, qui gouverne aussi la consommation permanente des
  niveaux (v1.08b, non mesurée sur l'or) : sans cette séparation, deux règles changeaient d'un coup. Inventées du livre or **518 → 418**,
  erreur totale 1 032 → 959, précision 85,4 → 87,8 % ; coût assumé **27 entrées communes** (GoldDaily3, GoldbotOne_8). Huit jeux en deçà et
  tous les témoins rigoureusement identiques. MQL5 eb0e767.
- **J'avais écrit la réserve AVANT le verdict** (ces six jeux manquent 262 entrées et n'en inventent que 105, donc une règle qui retire des
  poses devait coûter) : elle s'est vérifiée à moitié, et l'avoir écrite d'avance a permis de juger l'échange au lieu de le découvrir après.
  À refaire systématiquement.
- **Reste sur l'or** : l'écart dominant est maintenant le DÉFICIT (541 entrées manquées), pas l'excès. `AuDela()` renvoie toujours faux sur
  l'or, donc les six jeux au-delà sont traités comme des jeux d'anticipation dans tout le reste du moteur. M5_C et M5_H (100 manquées,
  0 inventée, `ST1_Timeframe=0` = TF courant) sont une piste à part.

## 19/09 21:15 : v1.41 — plafond d'ordres en attente d'au moins DEUX pour les ordres en deçà ; BILAN DU JOUR sur l'or

**Sonde DaytradePro or** + **banc UBS mono-jeu neuf** (`s_dtpor_ubs`, dossier `SetsB_DTPor`) : dans 26-28 % des évaluations le moteur a
deux niveaux posables et n'en sert qu'un (`MaxPendingOrders=1`) ; UBS tient 2 ordres du même sens 9 % du temps, **toujours sur deux
niveaux différents** (77 paires, zéro au même prix, écart minimum = `MinDist_orders` à l'échelle). **Le paramètre borne PAR NIVEAU.**
Seuls les jeux à plafond 1 le dépassent (DaytradePro or, CHFJPY : 2) ; ceux à 3 ou 5 le respectent exactement.
- **v1.40 REJETÉE** : minimum de deux pour TOUS → les trois jeux or au-delà à plafond 1 inventaient 104 entrées (erreur 325 → 412).
  Leur unicité vient de la consommation permanente. **La distinction en deçà / au-delà inscrite à 16 h a été enfreinte à 19 h** :
  toute règle sur les ordres se pose d'abord la question « en deçà ou au-delà ? ».
- **v1.41** : `Cap = SurOuAuDela ? maxPending : MathMax(2, maxPending)`. DaytradePro or 72,6 → 76,1 %, goldtrade_H 85,4 → 92,7 %,
  CHFJPY 159 positions pour 159 chez UBS, JPY D1 erreur 178 → 116, **livre or 92,9 %, erreur 301**. MQL5 2ff3f00.
- **Piège d'étiquetage** : un rapport copié en `_v139` ne contient v1.39 que si le jeu était dans la chaîne v1.39. GBPUSD et JPY D1 n'y
  étaient pas ; leur gain « v1.40 » venait de v1.39. Nommer les sauvegardes par la version RÉELLEMENT jouée.

**BILAN DU 19/09 SUR L'OR** (v1.30 → v1.41, onze versions dont deux rejetées) : **erreur 952 → 301 (÷3), inventées 407 → 48, communes
85,0 → 92,9 %** ; argent Till erreur 572 → 257 ; M5_C et M5_H à 100 %. Six fausses règles remplacées par des règles mesurées.
**Ce qui reste** : un DÉFICIT concentré sur trois jeux D1 à plafond 1 et gros offsets négatifs (DaytradePro 76,1 %, goldtrade_E
76,8 %, goldtrade_D 73,0 % — 109 manquées à eux trois). Prochaine sonde : goldtrade_D.

## 19/09 18:45 : v1.39 — un niveau TOUCHÉ par la bougie en cours ne se repose plus ; erreur du livre or DIVISÉE PAR DEUX

**Trouvé par SONDE** (`s_r6_sonde.ini`, Reaper 6 seul, `Journal=true`, 2023-2024 : 140 791 lignes CAND en 1 min de test, journal grossi
de 20 Mo seulement), analysée par `repose_or_arbre.py`. Sur 636 instants où une position UBS est ouverte au niveau et le niveau
posable, la variable dominante (gain 0,28 contre 0,09) est : **la bougie EN COURS de l'unité des NIVEAUX a-t-elle touché le swing ?**
**H1 (= tfNiv) : 92,9 % d'ordre si non touché, 3,2 % si touché — écart de 90 points** (M15 : 76, M5 : 61). C'est l'unité des NIVEAUX
qui commande, ni la cadence d'entrée ni une unité intermédiaire.
- **Deux différences avec la règle existante** : condition **instantanée** (bougie en cours) et non historique (`hautsExces` depuis la
  formation du swing) ; seuil = **TOUCHER** (extrême ≥ swing), pas dépassement de 0,5 pip. v1.27 l'appliquait déjà aux ordres
  AU-DELÀ ; v1.39 l'étend aux ordres EN DEÇÀ (les trois Reaper).
- **Juges** : **Reaper 6 inventées 159 → 12 SANS perdre une commune** (erreur 216 → 69), Reaper 5 92 → 3 (101 → 12), Reaper 7 108 → 9,
  argent Till 346 → 39 (erreur 544 → 257, coût 20 communes), CHFJPY 35 → 15. **LIVRE OR : inventées 428 → 54, erreur 696 → 325.**
  M5_C, M5_H, GoldDaily1/2/3, GoldbotOne_8 inchangés. MQL5 234614a.
- **La nature de l'écart a changé** : il ne reste que 54 inventées sur 3 279 positions. **L'écart est maintenant un DÉFICIT**,
  concentré sur DaytradePro or (72,6 %), goldtrade_D (72,3 %), goldtrade_E (75,6 %). Chantier suivant.
- **Coût à garder** ([[ecarts-rentables-a-garder]]) : **CHFJPY passe de 2,80 à 2,41** de rapport (net 730 → 628, creux inchangé) —
  **sa version v1.38 devient une candidate autonome.**
- **Méthode** : la sonde coûte 1 min de test et répond là où trois heures de mesures indirectes n'avaient rien donné. À lancer
  PLUS TÔT la prochaine fois qu'un écart résiste à deux mesures.

## 19/09 18:05 : v1.38 — `MaxTrades` plafonne les positions SIMULTANÉES au niveau, pas le cumul

Mesuré sur trois bancs UBS : le cumul d'entrées par niveau monte à **11** (Reaper 6) et **13** (AGA04) pour un `MaxTrades` de 5,
mais les positions OUVERTES EN MÊME TEMPS sur un niveau n'excèdent **jamais** MaxTrades (zéro dépassement sur 979 niveaux).
Le moteur comptait le cumul et condamnait le niveau définitivement. **À ne pas confondre avec la consommation permanente**
(v1.08b, offset ≥ 0) : c'est elle qui explique l'unicité des six jeux or au-delà, pas MaxTrades.
- **Gain réel mais inégal** : **argent Till 88,8 → 90,9 %** (communes +45, erreur 572 → 544), Reaper 6 90,6 → 91,4 %,
  GoldDaily2 94,7 → 96,0 %, **livre or 92,3 → 92,5 %**. R5 et R7 (MaxTrades 99), jeux au-delà et volatilité : identiques.
  Le plafond ne mord que là où il est atteint. MQL5 0277868.
- **Comment elle a été trouvée** : le chantier argent venait d'être suspendu sur « pas de mécanisme manquant ». La
  contradiction était DANS cette sortie (« UBS jusqu'à 8 entrées pour MaxTrades=5 ») et je l'avais prise pour une curiosité.
  Elle est devenue une question en réapparaissant sur Reaper 6. Voir [[garde-fous-mesure]] (19/09, seconde leçon).

## 19/09 17:30 : v1.37 — M5_C et M5_H reproduits à 100 % ; livre or 92,3 %

**Le plafond de la stratégie VOLATILITÉ est `VolMaxTrades` et il est TOTAL.** Le moteur testait aussi `Positions(j) < MaxTrades`, or
`MaxTrades` est le plafond par NIVEAU de la stratégie S/R et vaut **1** pour M5_C et M5_H : il n'y tenait qu'UNE position quand UBS en
tient 4. **83 des 100 entrées manquées venaient de là.**
- **Mesure décisive** : le maximum simultané d'UBS égale VolMaxTrades en TOTAL (M5_C 4/4, EURUSD_i 2/2, EURUSD_k 1/1) et lui est
  inférieur par sens. **EURUSD_m tranche : 3 au total dont 2 d'un seul sens.** Le test par sens était donc faux aussi.
- **Pourquoi invisible deux ans** : M5_C et M5_H sont les SEULS jeux volatilité du livre où `MaxTrades` (1) est inférieur à
  `VolMaxTrades` (4 et 5) ; les 47 autres ont MaxTrades à 5 ou 10, donc le mauvais plafond n'y mordait jamais.
- **Résultat** : M5_C 75,6 → **100,0 %**, M5_H 77,7 → **100,0 %** — **première fois qu'un jeu du livre est reproduit exactement**
  (420 positions UBS, 420 retrouvées). Livre or 89,5 → **92,3 %**, manquées 374 → 274, erreur 798 → 699. MQL5 44d8f90.
  Coût assumé : EUR volatilité 815 → 812 communes (erreur 36 → 40).
- **La piste notée le matin était FAUSSE** : j'avais retenu `ST1_Timeframe=0` (niveaux sur le TF courant). Ce sont des jeux de
  volatilité, qui n'utilisent pas de niveaux du tout. **Une piste plausible notée dans un journal n'est pas une mesure.**
- **Reste sur l'or** : les trois Reaper inventent **356 entrées** à eux seuls pour 90-98 % de couverture. C'est LE chantier suivant,
  et c'est un excès, pas un déficit.

## 19/09 16:45 : v1.36 — les six jeux or AU-DELÀ ; livre or 85,0 → 89,5 %

`SurOuAuDela` était limité aux 3/5 décimales, donc `AuDela()` renvoyait toujours faux sur l'or : les six jeux à offset positif
(Gold_a/b/c, M5_C, M5_H, dailyK) étaient traités comme des jeux d'anticipation partout dans le moteur et portaient **289 des 532
entrées manquées** du livre or pour 28 % de ses positions. La restriction datait du 15/09, justifiée par « ils sont reproduits à
60-100 % » — un ordre de grandeur, pas une mesure de fidélité.
- **Risque écarté AVANT de coder** : la même fonction commande la consommation permanente d'un niveau (v1.08b), jamais vérifiée sur
  l'or. Mesuré : ces six jeux n'entrent qu'une fois par niveau dans **98 à 100 %** des cas. C'est ce contrôle qui a permis de faire
  en une version ce que j'avais reporté le matin par prudence.
- **Juges** : GoldbotOne_8 **49,2 → 95,2 %**, GoldDaily3 **65,7 → 95,3 %**, GoldDaily2 78,7 → 94,7 %, GoldDaily1 86,3 → 92,8 %.
  **M5_C et M5_H intacts** : seuls jeux à `ST1_Timeframe=0` (niveaux sur le TF courant), 100 entrées manquées, autre cause.
  Livre or : manquées 532 → 374, erreur 952 → 798. Huit autres jeux or et sept témoins hors or identiques. MQL5 8cf3ee1.
- **Reste sur l'or** : les Reaper INVENTENT (356 entrées en trop à eux trois pour 90-98 % de couverture) ; M5_C/M5_H MANQUENT sans
  jamais inventer. Deux familles, deux chantiers.

## 19/09 15 h : RÉSERVE 2025 — elle élimine Advanced Scalper et l'USO, et sauve les portefeuilles autonomes

Neuf jambes rejouées sur 2025 en profil Kestrel, jugées au RAPPORT net/creux (`outils/reserve2025.py`, neuf).
- **Éliminatoires** : **AdvSc JPY** 2,53 → **−0,98** (−421 $, creux 158 → 430) et **USO H4** 1,89 → **−0,95** (−89 $).
- **Effondré sans être négatif** : JPY D1 2,57 → 0,04.
- **Meilleurs qu'en échantillon** : **or SetsB2 3,74 → 9,76** (+3 460 $), EUR volatilité 1,68 → 3,86, GBPUSD 0,54 → 6,33.
- Tiennent : CHFJPY 2,80 → 1,96, argent Till 2,78 → 1,86, EUR storyG 1,00 → 1,60.
- **Portefeuilles (partie moteur, dosage Axi, 2025)** : A **+786 $** de justesse (l'or seul le sauve), B **−2 897 $ ÉCHEC**.
  **Sans AdvSc : A +4 998, B +1 316.** Sans AdvSc ni USO : A +5 087, B +1 493. Retirer JPY D1 en plus ne change rien :
  le problème est **concentré sur deux jambes**.
- **AdvSc était gardé à sa demande** et méritant sur l'échantillon ; à ×10 il fait basculer les deux portefeuilles à lui
  seul. **L'USO était la jambe la plus éloignée d'UBS** (35,7 % d'entrées inventées) et la plus brillante en
  échantillon : négative en réserve. Même motif que [[luna-ai-pro-banc]]. **Ce que rien ne valide hors backtest ne
  survit pas.**
- **Manque pour une réserve complète** : Zebra (×3) et Heron (×2) sur 2025. Aucune décision d'exploitation avant.

## 19/09 12 h : DETTE v1.31 sur CHFJPY, et page des standards en v1.33

- **La règle de la fenêtre de repose (v1.30/v1.31) fait perdre 58 entrées communes sur 155 à CHFJPY** (communes 155 → 97, erreur 39 → 68).
  Elle avait été adoptée le matin sur des transactions EN HAUSSE (162 → 206 deals) : la hausse venait d'un changement de composition.
  Trouvée seulement en rafraîchissant la page. **Sur les quatre jeux mesurés la règle reste positive** (R6 454 → 376, AGA04 206 → 191,
  GBPUSD 38 → 33, CHFJPY 39 → 68 ; gain net 69) donc conservée, mais c'est une dette.
- **Cause probable** : `ReposeFermee` bloque un niveau de PRIX alors que la fenêtre mesurée appartient au PIVOT ; sur un couloir comme
  CHFJPY un nouveau pivot naît au même prix et se trouve bloqué. Reposes d'UBS en unités d'Entry_Timing : CHFJPY médiane 1,2 mais
  **P95 = 117**, GBPUSD P95 = 3, EUR P95 = 51,6. **v1.34 à tester : expirer la fenêtre quand un nouveau pivot naît au même niveau.**
- **La règle A1 avait été mesurée sur Reaper 6 seul puis généralisée à tous les jeux** alors que le tableau du matin montrait 1 à 18 unités
  d'Entry_Timing selon les jeux. Une fenêtre unique de 6 unités était une moyenne, pas une loi. **Mesurer sur un jeu n'autorise pas à
  généraliser à tous : le moteur applique la règle partout, donc la mesure doit couvrir plusieurs familles avant l'adoption.**
- **v1.34 adoptée (13:20) — la fenêtre de repose ne vaut que pour un budget d'entrées FINI** (`if(j.maxTrades > 20) return false;`).
  Deux explications réfutées avant de coder (`repose_pivot.py`) : nouveau pivot au même niveau (0/12) et retour à `MaxPendingOrders`
  (CHFJPY et GBPUSD posent avec 1 à 3 ordres vivants pour un plafond de 1). Le discriminant est `MaxTrades` : avec 99, UBS repose tant
  que le niveau vit (347 h mesurées) ; avec 5, les reposes se concentrent après le remplissage. 87 jeux à ≤ 20, 25 à 99.
  Juges : **CHFJPY 68 → 39**, **EUR volatilité 101 → 36**, JPY D1 187 → 178, R5 105 → 101, livre or 959 → 952, GBPUSD 33 → 38 (seule
  perte) ; six bancs strictement identiques. **CHFJPY retrouve +730 $ / creux 65 / rapport 2,80** (v1.33 0,90 ; UBS 0,94) : ici la
  version la plus fidèle est aussi la plus rentable. MQL5 f2ac46a.
- **Page des standards en v1.33** (`standards_v133.py`, rubrique 5d incluse), rapports HORS TIRAGE : 2ter-a **18,03 → 18,70**,
  2ter-b 19,68 → 18,81, 3a 18,04 → **17,08**, 3b 15,90 → 16,36, 5a 10,04 → **8,30**, 5b 9,26 → 8,87, 5c 8,15 → 8,63, 5d 5,53 → 5,08.
  **Le recul de plusieurs rubriques est le PRIX DE LA FIDÉLITÉ** : le moteur perd des trades inventés qui rapportaient. Livre UBS de
  référence 17,5 / 17,9 — les rubriques prop firm restent à son niveau. Une partie du recul de 5a vient de la dette CHFJPY ci-dessus.

## 18/09 18 h : FEUILLE DE ROUTE UNIQUE dans `outils/TESTS-A-REALISER.md` (section « FEUILLE DE ROUTE EAGLE-OWL »), sa demande « compile tout »

19 points en six blocs : **A fidélité** (1 re-poses or/argent pendant une position = le seul écart du livre prop firm ; 2 fausse cassure or à
tester avec la règle 3/5 déc. ; 3 Daytrade Pro devises 164 % ; 4 JPY G347/hangsan_4 ; 5 AdvSc 107 manquées, USO ; 6 dérive or SetsB depuis v1.19 ;
7 résidus), **B calendrier** (8 v1.29 NFP 8 h 30 New York — UBS ferme à 14:40 serveur été comme hiver, 86 jeux ; 9 taux = 6 jeux US30 seulement,
CPI aucun ; 10 horaires inertes), **C sécurité** (11 EA de garde séparé, spec `Prop_*` du 15/09 ; 12 arrêt par variable globale `GARDE_BLOQUE`
+ battement `GARDE_VIVANT`, UBS neutralisé par fermeture à chaque tick ; paramètres prop firm des jeux tous à zéro), **D exploitation** (13 GMT
serveur, TrailingStep, plafond d'exposition ; 14 anonymisation ; 15 premier passage réel Eagle-owl SetsB2 sur le compte cent ; 16 leviers creux
avec réserve 2025), **E page** (17), **F composition de jeux** (18 protocole : hypothèse, grille grossière, contribution à creux égal, corr < 0,5,
réserve 2025 ; candidats GBPJPY, EURJPY, AUDUSD, Brent ; 19 « complètement validé » = A1 + C11-12 + D15). Relire cette section avant tout chantier.

## 18/09 midi : v1.27 adoptée — « swing dépassé = mort » étendu aux ordres AU-DELÀ (3/5 déc.) ; EUR 85 %, JPY 88 %, AdvSc 90 % des positions

- **Mécanisme (G357 seul, `UpDiff 5 / DownDiff 20`, 46 deals contre 26)** : les 10 entrées en trop du moteur étaient toutes des reposes après
  expiration d'un niveau dont le **swing venait d'être franchi par le prix** sans que l'ordre soit servi (UBS laisse l'ordre vivre jusqu'à
  l'expiration, puis ne le repose JAMAIS : 0 cas sur 380 ordres). Vérifié sur barres D1 PU Prime : 9/10 par une bougie close, 1/10 par la
  **bougie en cours** (Sep 2024). F356 3/3. Les ventes G357 sont 20 pips SOUS le creux (swing = ordre + DownDiff).
- **v1.27** : la règle du 13/09 (`Exces > 0,5 pip`, limitée à `UpDiff < 0`) s'applique aussi à `AuDela(j, ±1)` sur 3/5 déc., bougie en cours
  comprise (`iHigh/iLow(tfNiv, 0)`) ; tableaux `hautsRang/Casse/Exces` 16 → 32 (pool 30). L'ordre déjà posé reste vivant jusqu'à expiration.
  **La note du 13/09 « AdvSc USDJPY : 81 % des poses UBS sur niveau dépassé » était fausse** : n120 passe de 1 013 à 690 positions (UBS 769),
  entrées seules 332 → 28, net +1 779 $ (UBS +1 622).
- **Juges** : G357 26 deals = UBS (13/13 communes), EUR complet **85 %** (74), JPY complet **2 164 deals, +1 005 $ = 88 %** (81 ; BOJPY1/3/4
  +83/+88/+88 contre +98/+104/+85), hangsan_1 203/228 communes et seules 35 → 10, USO 100 % (105), CHFJPY 164 % (149, s'éloigne vers le haut),
  or/argent/G347/GBPUSD/hangsan_4/AGA04 inchangés. MQL5 3d096ea, étiquette `v1.27`. **Restes** : sorties `ea` d'UBS dans l'heure (G357/F356 :
  UBS ferme par l'EA à 0-0,4 h, le moteur va au stop/cible), R3 (H4, −27 contre +30), hangsan_4 (+34 contre +92), CHFJPY au-dessus d'UBS.
- **v1.28 adoptée (15:20) — sorties « ea » d'UBS = fausse cassure rétablie pour les ordres AU-DELÀ, évaluée à la cadence d'Exit_Timing.**
  Mesure (`fc_audela.py`, barres M1 EURUSD/USDJPY exportées, bancs mono-jeu UBS) : à la première clôture de chaque bougie de confirmation après
  l'entrée, corps contre ET clôture au-delà du prix d'entrée → UBS ferme : G357 1/1, F356 6/6, A341 11/11, hangsan_b 13/13, zéro fausse alerte.
  Exceptions hangsan_1 (Exit_Timing H1) et R3 en M1 (Exit_Timing M5) résolues par la cadence : avec `UseEveryTick=false` UBS n'évalue qu'aux bornes
  d'Exit_Timing, une première clôture hors borne est perdue (sur borne 6/6 et 25/26, hors borne 0/29 et 0/14). v1.05 (exclusion au-delà) datait
  d'avant les règles corps contre (v1.09) et seuil = entrée (v1.17) : la levée est sans risque. Juges : G357/F356 47 paires identiques (ea → ea
  7/7, 0,00 $), **EUR complet 98 %** (85), **JPY complet 90 %** (88), hangsan_b +128 (UBS +129), R3 +81 (+49), USO 91 % (100, XTW07 non mesuré :
  pas de M1 USO), le reste identique ; or Till B3/B4 105-107 % de net avec creux +60 % (hors livre, baseline v1.01 seulement). MQL5 82cd07a.
  Leçon : les sorties UBS d'un jeu ne se lisent que sur un rapport MONO-JEU (n142 multi-jeux : jumelles O3515/P3516 à la même seconde, attribution
  fausse) ; et une sous-chaîne de commentaire (« USDJPY B ») attrape d'autres jeux (BOJPY).
- **Cinquième portefeuille (sa demande 12:06, `outils/cinquieme_maison.py`)** : tout maison SANS or (Zebra ×3 + Heron ×2 + Eagle-owl hors or v1.26 +
  AdvSc JPY n120 ×0,1) : compte propre **9,41** hors tirage (13,80 avec or), Axi 7,49 (14,72), classique 7,81 (14,87) ; l'optimiseur écarte Heron
  NZDCAD partout et l'AdvSc sauf en classique (×10). Zebra + Heron seuls 7,20. Page des standards rubrique 5 (artefact v17).
- **Page des standards en v1.28 (16 h, artefact v20, `standards_v128.py`)** : les livres tout maison de la règle rejoignent UBS — **2ter-a Axi
  18,03** (v1.19 : 14,72 ; UBS 17,52), **3a classique 18,04** (14,87 ; UBS 17,86), 5a compte propre sans or 10,04 (9,41). L'or SetsB2 imposé ×1
  rapporte (libre : 15,18, l'optimiseur écarte or et hors or). USO XTW07 : `fc_audela` 37/38, v1.28 plus fidèle (ea → ea 16 → 39). Or SetsB2
  identique au 17/09 ; or SetsB (info) dérive en creux depuis v1.19 (500 contre 450, UBS 340), cause non datée, hors livre — reste.


## 20/09 08:50 : v1.42 — sur l'or, les ordres en deçà cherchent le premier swing VIVANT dans 32 swings (plus 2)

Sonde goldtrade_D (D1, countback 240, MaxPendingOrders 1) + banc UBS mono neuf `s_gtpd_ubs` (159/159 = n18, jeu indépendant).
`outils/rang_swings_d1.py` (niveau reconstruit avec ATR(47,D1)/ATRDefault, cherché parmi les swings D1 calculés comme
`Niveaux()`) : 40 des 43 manquées visent le swing vivant le plus récent du bon côté du prix, de rang 2 à 20 par ancienneté ;
les 116 communes sont de rang 0 ou 1. Le moteur ne gardait que 2 swings (`NB_SWINGS = MathMax(2, maxPending)`) sur l'or —
règle v1.07 des devises (8) jamais portée sur l'or. v1.42 : 32 sur `dig == 2` en deçà, bornes 15/16 → 31/32.
Juges : goldtrade_D 73,0 → 92,5 %, DaytradePro 76,1 → 90,4 %, goldtrade_E 76,8 → 89,0 %, Reaper 4 90,2 → 96,9 % ;
**livre or 92,9 → 95,2 %, erreur 301 → 225** ; Reaper 5-7, M5, GoldDaily, goldtrade_H identiques. MQL5 ee14a31, outils e8ab70a.
Piège : pour une vente en deçà, niveau = prix + DownDiff·f (DownDiff négatif) ; le mauvais signe rendait 88 communes « introuvables ».
Reste sur l'or : Reaper 6 (57 manquées), re-poses au même niveau après sortie en stop (goldtrade_D, 6 cas).


## 20/09 09:20 : v1.43 — pas de fenêtre de repose sur l'or ; la sonde CAND imprime les swings REJETÉS et le motif

Ajout au moteur (Journal seulement) : `REJ [S0 1934.42 repose] …` — sans lui, la sonde était muette sur un MANQUE. Sonde R6 :
16 des 35 manquées 2023-24 refusées par la fenêtre v1.31/v1.34 ; UBS repose sur position ouverte HORS fenêtre dans R5 63/118,
R6 71/223, R7 62/116 des cas (n18). Essai direct `Fid_ReposeMaxTrades=4` avant de coder : communes 308 → 317, inventées 5 → 5
(la règle du toucher v1.39 a pris le rôle de la fenêtre). v1.43 : `if(dig == 2) return false;` dans ReposeFermee.
Juges : R6 603 → 613 (mono), R7 +4, R5 identique ; **livre or 95,5 %, erreur 214, inventées 55**. MQL5 a1318e6, outils 111a8ce.
Outil : `livre_or_versions.py <avant> <après>` (tableau jeu par jeu). Reste : R6 « ordre non servi » quand le moteur tient
4-5 positions et UBS 1-3 (côté sorties), et `consomme` après stop (R6 5 cas, goldtrade_D 6) — à sonder avant de coder.


## 20/09 10:40 : v1.44 — fausse cassure sur l'or au seuil du PRIX D'ENTRÉE (ordres en deçà), comme les devises (v1.17)

Sonde des sorties R6 (`diag_sorties.py n168 n170`) : 79 sorties ea d'UBS tenues par le moteur jusqu'au TP/SL — première clôture
M1 ou M15, corps contre, au-delà du prix d'entrée mais pas de « niveau − 2|décalage| » (règle v3.16 gardée sur l'or parce que
v1.15 « ravageait l'or » : v1.15 était corps contre SANS seuil, une autre règle). `fc_or_seuil.py` (n18, M1) : seuil entrée
explique R6 131/236, R5 81/110, R7 64/79, R4 23/35, goldtrade_D 15/40, goldtrade_H 13/27 (niveau : 62/61/44/16/1/3).
Juges : R6 ea→ea 90 → 158, communes 613 → 639 ; **livre or 96,6 %, erreur 176**, inventées 55 ; net 5 499 (UBS 5 882),
creux 350, rapport 15,5 → 15,7. MQL5 d224b11, outils commit du 20/09 10:45.
**Bilan 20/09 matin : erreur du livre or 301 → 176 en trois versions (v1.42 32 swings, v1.43 sans fenêtre, v1.44 seuil entrée),
chacune mesurée avant d'être codée ; sonde REJ (motifs de rejet) = ce qui a rendu les sondes rapides.**
Reste (176) : DaytradePro 19 + 9, R6 21 + 12, R7 13 + 9, GoldDaily1 10 + 2.


## 20/09 11:30 : v1.45 — fenêtre de repose retirée PARTOUT (profil fidèle) ; page des standards v1.44 ; sonde argent

Page des standards (artefact v25) : 2ter-a 19,20 → **21,14**, 3a 18,31 → **21,31** hors tirage ; `maj_standards_html.py`. Les scripts
des standards lisent les rapports COURANTS : les figures d'une page ne se reproduisent qu'avec les copies `_vXXX`.
Sonde argent : UBS repose sur position ouverte hors fenêtre dans 24 % des cas ; rang des swings ≤ 6 (les 8 suffisent, pas de règle 32).
Fenêtre mesurée nulle sur JPY D1, storyG, USO, AdvSc (même binaire, avec/sans : identiques) → v1.45 `if(Fid_ReposeMaxTrades < 999) return false;`
(Kestrel 999 = toujours active). Argent 89,9 → **92,1 %**, erreur 257 → 238 (170 manquées, 68 inventées). MQL5 d79663f.
USO en v1.44 : 2 inventées (33 avant v1.38-39) ; n155/n120/n154 rejoués en v1.44. Reste argent : 62 niveaux jamais posés → sonde REJ AGA04.


## 20/09 12:05 : v1.46 — une sortie à swing INTACT ne consomme pas le niveau (or, argent, en deçà) ; fidélité globale

`fidelite_globale.py` (pondérée par les entrées UBS) : livre entier **93,8 %** avant v1.46 ; AdvSc USDJPY 85,8 % est la jambe la plus
basse (le « 90 % » cité avant était un rapport de nombres de positions, pas une fidélité). Sonde REJ AGA04 : 20/25 manquées = `consomme`.
`consomme_swing_intact.py` : sortie sans dépassement du swing + prix revenu dans 72 h → UBS ré-entre 70-80 % (argent), 45-80 % (or) ;
swing dépassé → ~0. Les « tp » de l'argent sont des pertes (stops virtuels) : le discriminant est le swing, pas le type de sortie.
v1.46 (drapeau `vuCasse`) : **livre or 98,1 %, erreur 122, inventées 55 inchangées ; argent 95,8 %, erreur 180**. MQL5 9e3358f.
Net or 5 667 (UBS 5 882). **Erreur du livre or 301 → 122 depuis hier soir, cinq versions.** Reste : argent 90 inventées, GoldDaily1, R6 11.


## 20/09 12:45 : v1.47 — consommation permanente portée par le SWING (au-delà) ; fidélité globale 96,5 %

UBS reproduit Advanced Scalper (même moteur, jeu traduit le 10/09) : n113 est la référence. Sonde REJ AS : 51/71 manquées `consomme` ;
`sonde_as.py` : 43/109 manquées visent un swing formé APRÈS la position qui avait consommé ce prix → v1.47 `NiveauConsomme(j, niv, tSwing)`.
Juges : AdvSc 85,8 → **94,3 %**, USO 91,4 → 96,6 %, JPY D1 93,0 %, livre or **98,5 %** (erreur 105). **Livre entier pondéré 96,5 %**
(erreur 545 / 9 257). MQL5 5f23151. Réserve 2025 AS : UBS −233 / 299, Eagle-owl −376 / 385 (fidélité 95 %), Kestrel −421 / 430 —
année perdante pour tous, l'avantage de creux d'Eagle-owl sur 4 ans ne tient pas hors échantillon.
Six démos FXAutomater (Krastev) téléchargées par lui le 20/09 10 h : WallStreet Recovery PRO éliminé (récupération = moteur) ;
les cinq autres (GOLD Scalper PRO, Forex GOLD Investor, WallStreet GOLD Trader, Forex Diamond, Infinity Trader) à mesurer en ticks réels.
