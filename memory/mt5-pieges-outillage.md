---
name: mt5-pieges-outillage
description: "Pieges MQL5 et Strategy Tester rencontres et verifies, avec la ligne de commande qui compile sans MetaEditor"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 0a08b05d-baec-41f7-85b6-be56c9dc701d
  modified: 2026-09-15T18:18:37.566Z
---

Constate et verifie le 28/08/2026 en revoyant un EA SMC. Tout ceci a ete confirme par le
compilateur ou par une passe, pas deduit.

## Compiler en ligne de commande — a faire AVANT de rendre du code

```
"C:\Program Files\PU Prime MT5 Terminal\metaeditor64.exe" /compile:"<chemin.mq5>" /log:"<chemin.log>"
```

Le journal est en **UTF-16LE** : `iconv -f UTF-16LE -t UTF-8 -c`. Sortie utile en fin de
fichier (`Result: N errors, M warnings`). Deux erreurs reelles ont ete trouvees ainsi, dont
une que j'avais introduite moi-meme en croyant corriger. Complete [[pine-sans-compilateur]] :
ici il existe un compilateur, donc il n'y a aucune excuse a envoyer du code non compile.

## `__TIME__` n'existe pas en MQL5 — et une erreur de compilation SUPPRIME le `.ex5`

Constate le 29/08. Seul `__DATETIME__` existe (avec `__DATE__`, `__FILE__`, `__LINE__`,
`__FUNCTION__`). Erreur 256 « undeclared identifier ». **Le compilateur efface le binaire
existant avant de compiler** : une erreur laisse le dossier SANS `.ex5`, et il n'y a pas de
copie de secours. Toujours recompiler et verifier `Result: 0 errors` AVANT de lancer une passe.

**Passer `/log` nu ne produit aucun journal** — il faut `/log:"<chemin>"` explicite, sinon on
croit a un echec silencieux.

## Le modele de ticks est un parametre de PREMIER ORDRE, pas un detail de configuration

Verifie le 29/08 sur `XAUUSD.p`, meme symbole, meme fenetre, seul `Model` differe :
`Model=0` (ticks generes) rend +170 % ; `Model=4` (ticks REELS) **liquide le compte a 72 %**
de la fenetre. Le testeur l'ecrit : `stop out occurred on 72% of testing interval`.

**Les ticks generes par MT5 sont des oscillations intra-barre FABRIQUEES par interpolation.**
Une strategie qui vit sur les extremes intra-barre (grille, cliquet, martingale) les recolte
alors qu'elles n'ont jamais existe. Pour ce genre d'EA, **seul `Model=4` a valeur de preuve**.

**Corollaire sur MT4 : MT4 n'a PAS de mode ticks reels.** Son « every tick » est toujours
genere depuis les barres M1. Donc le backtest fourni par le vendeur d'un tel EA est, par
construction, sur des ticks interpoles.

## Le RAPPORT du testeur imprime la configuration EFFECTIVE — c'est l'instrument d'audit

Decouvert le 29/08 en cherchant a appliquer la regle de la configuration heritee. Le fichier
`<Report>.htm` (UTF-16LE) liste **TOUS** les parametres reellement utilises, defauts compris.
Sur une passe du montage : **51 parametres effectifs pour 24 declares dans mon `.ini`** — 27
tournaient sur des defauts que je n'avais jamais choisis, dont `InpDelaiRenflouementH=24`
(la pause apres une mort, qui gouverne directement la frequence de ruine du montage) et
`InpPorte2SousPlafond=true`.

**Ne jamais auditer une passe depuis son `.ini` : l'auditer depuis son rapport.**

## Une valeur VIDE dans `[TesterInputs]` est IGNOREE — le defaut de l'EA s'applique

Verifie le 29/08 : `InpFichierEpisodes=` (vide) dans l'ini, `InpFichierEpisodes=episodes.csv`
dans le rapport. **Desactiver une option en la vidant ne desactive rien.** Il faut passer une
valeur explicite (ou un sentinelle que l'EA reconnait).

## MT4 : UNE SEULE INSTANCE — le piege m'a coute 3 h le 30/08 alors qu'il etait DEJA note

Lancer `terminal.exe <config.ini>` pendant qu'une instance tourne : le terminal demarre,
**ignore la configuration EN SILENCE** et reste ouvert sans rien faire. Signature dans
`logs/AAAAMMJJ.log` :

```
11:24:19  Vantage International MT4 build 1470 started     <- PAS de ligne de configuration
13:47:52  Vantage International MT4 build 1470 started
13:47:52  Started with configuration file '...'            <- lue, instance unique
```

**=> La ligne « Started with configuration file » est le SEUL temoin qu'un passage MT4 a
vraiment demarre.** Sans elle, le terminal tourne a vide et toute boucle qui l'attend se bloque.

**Ma faute de conception** : la boucle d'attente faisait `for k in $(seq 1 60) ... break` puis
lancait **quand meme** apres expiration. Un delai qui expire doit REFUSER, pas continuer.
**Bon schema** : fermer d'office tout terminal residuel, verifier que le compte est a zero,
et refuser de lancer sinon.

**Attendre la fin d'un passage MT4** : guetter l'apparition du fichier `<Report>.htm`, pas la
disparition du processus — un terminal sans configuration ne se ferme jamais.

## SONDER UN INDICATEUR COMMERCIAL : le mode « prix d'ouverture » ne suffit PAS

Methode (30/08) : un EA de sonde appelle l'indicateur par `iCustom`, lit ses tampons **sur la
barre 1** — la derniere CLOTUREE, jamais celle en cours, seule facon de mesurer un signal
utilisable en reel — et les ecrit dans un CSV. Aucun ordre. Tourne dans le testeur, donc sans
interface. `SondeIndicateur.mq5` dans le terminal MT5 standard (`D0E8209F...`).

**J'AI AFFIRME QUE LE MODELE DE TICKS ETAIT SANS EFFET POUR LIRE UN INDICATEUR. C'EST FAUX** des
qu'il consulte d'autres unites de temps. Le journal :

```
XAUUSD.p,M15: wrong timeframe request in Open Prices testing mode
XAUUSD.p: rates base receive error
XAUUSD.p,H1: 0 ticks, 0 bars generated
```

**Gold Stuff lit du M15 et du H4.** En `Model=2` ces requetes sont interdites, l'indicateur ne
calcule rien, et le test se termine en 71 ms sans une seule barre. **=> Toujours `Model=4`**,
qui reconstruit toutes les unites de temps depuis les ticks reels.

**Deuxieme piege du meme passage** : ce terminal n'avait que **5 929 barres H1**, de 2020.01.02
au 2020.12.31, alors qu'il possede 68 mois de TICKS. Barres et ticks sont deux stocks distincts —
`history synchronized from 2020.01.02 to 2026.06.10` ne dit RIEN de ce que le cache contient.
Verifier la ligne `history cache ... contains N bars from ... to ...`. `Model=4` regle aussi ce
probleme, les barres etant reconstruites depuis les ticks.

## Trois pieges d'API MQL5

- **`OrderGetSymbol()` n'existe pas.** Asymetrie de l'API : `PositionGetSymbol(i)` existe,
  son equivalent ordre non. Il faut `OrderGetTicket(i)` puis `OrderGetString(ORDER_SYMBOL)`.
- **`MqlCalendarEvent` n'a pas de champ `currency`.** La devise est portee par le pays :
  `CalendarCountryById(ev.country_id, ctry)` puis `ctry.currency`.
- **Le calendrier economique est VIDE dans le Strategy Tester.** Un filtre de news y compte
  zero blocage : ca ne veut pas dire qu'il laisse passer, ca veut dire qu'il ne mesure rien.

## `TimeGMT()` est inerte dans le Strategy Tester

En backtest, `TimeGMT() == TimeTradeServer()` : toute auto-detection du decalage horaire
rend **0**. Un EA qui compare des heures de bougies a une heure « GMT » lit en realite de
l'heure serveur — chez PU Prime, un decalage de 2 a 3 h. Il faut un input explicite de
decalage, renseigne pour chaque backtest. Le meme code fonctionne correctement en reel,
ce qui rend le piege invisible si l'on ne teste qu'en direct.
Corollaire : PU Prime passe a GMT+3 de fin mars a fin octobre ; sans gestion de l'heure
d'ete, l'erreur residuelle est d'une heure sur ~7 mois.

## Lire un rapport et un journal sans se tromper de format

- Rapport `.htm` du testeur : **UTF-16 avec BOM**, et **en francais** (`Nb trades`,
  `Facteur de profit`, `Remboursement attendu` = gain espere, `Fond Drawdown Maximal`).
- Rapport d'optimisation `.xml` : **UTF-8**, SpreadsheetML. Les colonnes `Trades` et les
  parametres balayes s'en extraient directement.
- Journaux `Tester\logs\*.log` : **UTF-16LE**. Un `grep` ASCII dessus ne trouve RIEN et
  ressemble a une passe tuee. Je suis tombe dans ce piege : toujours decoder avant de
  chercher `Test passed` et `final balance`.

## Panier multi-actifs et symboles courtier

Chez PU Prime les symboles sont suffixes `.p`. Un EA qui code `"EURUSD"` en dur obtient
`INVALID_HANDLE` et sort en `INIT_FAILED` **sans dire lequel**. Deriver le suffixe de
`_Symbol`, essayer avec puis sans, et **journaliser le nom exact** de chaque symbole non
resolu.

**`XAUUSD.crp` a un historique lacunaire sur ses deux premieres semaines** (avertissements
`no prices for symbol XAUUSD.crp` du 05 au 13/10/2021, 28 occurrences). Les ticks
commencent en 2021.10 alors que ceux de `XAUUSD.p` remontent a 2021.01 : demarrer une
passe en **2021.11** pour etre tranquille.

Voir [[sauvegarde-code]] pour la contention du testeur entre sessions, et
[[garde-fous-mesure]].

## 30/08/2026 — DEUX TERMINAUX MT5 NE PEUVENT PAS TESTER EN MEME TEMPS

Symptome : un terminal lance avec `/config:` demarre, ecrit
`Startup successfully initialized from start config`, puis **rien**. Aucun test, aucune erreur.
Le journal `Tester/logs/` s'arrete a `Cloud servers switched off`. Deux heures perdues a
chercher du cote de l'EA, du BOM, de l'autorisation MQL5 — **tout etait bon.**

**CAUSE, VERIFIEE PAR `netstat -ano` :** les agents de test locaux se lient a
**`127.0.0.1:3000`**, port **PARTAGE entre installations MT5**. Constate : port 3000 tenu par
le PID de l'agent du terminal PU Prime (Gold Phantom en cours), connecte a ce terminal. Le
second terminal ne peut donc pas demarrer le sien, **et ne le signale pas.**

**Signature d'un demarrage REUSSI dans `Tester/logs/` :**
```
Tester   Cloud servers switched off
Tester   "Dossier\MonEA.ex5" X64            <- si cette ligne manque, rien ne tournera
Core 01  agent process started on 127.0.0.1:3000
Tester   XAUUSD.p,H1 (PUPrime-Demo): testing of Experts\... from ... to ...
```

**Consequences :** les passages MT5 sont **strictement sequentiels**, quel que soit le nombre de
coeurs (12 ici). `outils/lancer.sh` REFUSE desormais si un agent tourne — refus **non
derogeable**, `--parallele` ne dispense que de l'exigence d'aucun TERMINAL ouvert.

**Le journal a lire est `<terminal>/Tester/logs/`**, pas seulement
`AppData/Roaming/MetaQuotes/Tester/<hash>/Agent-*/logs/`. Je n'avais jamais ouvert le premier.

## 31/08/2026 — LE TESTEUR QUI NE DEMARRE PAS : CAUSE NON TROUVEE

**Symptome** : le terminal demarre, ecrit `Startup successfully initialized from start config`,
se connecte au compte, **puis rien**. Aucun agent, aucun rapport, aucune erreur, sur AUCUN des
deux terminaux MT5. Dure depuis le 30/08 22h40, juste apres la fin du passage Gold Phantom.

**PISTES ELIMINEES PAR MESURE** (~3 h) :
- l'EA du Marche : un EA maison (`Sonde\SondeIndicateur`) echoue exactement pareil ;
- l'autorisation MQL5 : `activated for 'powerfin'` presente ;
- le BOM de l'ini : verifie octet par octet, `ef bb bf` correct ;
- le port 3000 partage entre installations : **reel** (verifie par `netstat`, l'agent du
  terminal PU Prime le tenait pendant Gold Phantom) **mais pas LA cause** — il echoue aussi
  quand plus aucun agent ne tourne ;
- le disque : etait a 88 %, **85 Go de journaux supprimes**, a 70 %, echec identique ;
- les dossiers d'agents : renommes en `.ancien_20260831` pour forcer leur recreation, non
  recrees, echec identique ;
- **les agents locaux desactives : FAUX.** J'avais conclu ca de la ligne
  `Tester Local network farm switched off`. **Sa capture d'ecran montre `Local: 12 cores`,
  Core 01 a 12 presents.** Cette ligne parle de la *Local Network Farm* (agents sur le
  reseau), pas des coeurs locaux. **Elle est normale.** Erreur de lecture de ma part.

**SIGNATURE D'UN DEMARRAGE REUSSI, a controler EN PREMIER** (le journal
`<terminal>/Tester/logs/AAAAMMJJ.log` n'en contient que les deux premieres quand ca echoue) :
```
Tester   Cloud servers switched off
Tester   "Dossier\MonEA.ex5" X64
Core 01  agent process started on 127.0.0.1:3000
Tester   SYMBOLE,PERIODE (SERVEUR): testing of Experts\... from ... to ...
```

**PROCHAINE BISSECTION, elle demande la souris** : lancer un passage depuis l'INTERFACE du
testeur. S'il tourne, le probleme est le lancement par `/config:` ; s'il ne tourne pas non
plus, c'est le testeur lui-meme et un redemarrage de Windows devient l'hypothese raisonnable.

## 31/08/2026 — UN `.set` MT5 DONNE A UN EA MT4 : ZERO TRANSACTION, AUCUNE ERREUR

**Symptome** : Advanced Scalper charge, tourne 21 ans, journal normal (`loaded successfully`,
`DAYSWITCH` une fois par jour, `Weekend starting`), et ouvre **0 transaction sur EURUSD**,
2 sur USDJPY. Aucun message d'erreur.

**CAUSE : le fichier `.set` venait de la version MT5 de l'EA.** Son parametre `Entry_Timing`
y vaut **16385** (= `PERIOD_H1` dans l'enumeration MQL5) ou **16388** (= H4), la ou MQL4
attend **60** et **240** — des MINUTES. L'EA cherche des barres d'une periode inexistante,
ne calcule aucun pivot, n'entre jamais.

**Signes qui identifient un .set MT5 :**
- valeurs d'unite de temps >= 16385 (H1=16385, H2=16386, H3=16387, H4=16388, D1=16408) ;
- parametres qui n'existent qu'en MQL5 (ici `Entry_Timing_Tick`, `UseEveryTick`) ;
- encodage **UTF-16** (MT5) contre cp1252 (MT4) ;
- format d'optimisation `valeur||debut||pas||fin||drapeau`.

**How to apply : avant tout passage avec un .set fourni, comparer `Entry_Timing` et tout
parametre d'unite de temps a la plateforme cible.** Et lire dans le rapport le nombre de
transactions AVANT d'interpreter quoi que ce soit — zero transaction n'est jamais un
resultat, c'est un defaut de montage ([[garde-fous-mesure]]).

**Piege connexe, meme EA, meme jour** : sans conversion du .set, MT4 tourne sur ses valeurs
d'USINE. Advanced Scalper y a detruit 10 000 en un an, puis n'a plus trade pendant 20 ans,
le rapport affichant toujours la fenetre complete. D'ou `outils/set_vers_tester.py`, qui
convertit un .set en bloc `<inputs>`, et le controle des dates de premiere et derniere
transaction dans `fiche_ea.py`.

## 01/09/2026 — TDS et les INDICES : mappage de symbole, et ce qu'il ne faut pas faire

**TDS fonctionne symbole par symbole.** Pour les devises, le nom du courtier et celui de
Dukascopy coincident (`EURUSD` -> `EURUSD`), donc rien a regler. **Pour les indices, non** :
`NAS100.s` doit etre associe a `USATECHIDXUSD`, `DJ30.s` a `USA30IDXUSD`, `GER40.s` a
`DEUIDXEUR`, `SP500.s` a `USA500IDXUSD`.

**Le mappage se declare dans `<terminal>/config/tds.config`**, une section par symbole avec
`SymbolPath-Dukascopy`. `outils/duka_symbole.py` le lit, et `lancer_mt4.sh` s'en sert pour
verifier la presence des ticks (sans lui il cherchait un dossier `NAS100` inexistant et
refusait a tort).

**CE QU'IL NE FAUT PAS FAIRE — appris cher le 01/09 :**
1. **Ne pas ajouter de section pour un symbole ABSENT du courtier.** J'en ai ajoute six d'un
   coup « pour etre complet » ; `NAS100`, `US30.s` et `US500` n'existent pas chez PU Prime.
   **Verifier dans `history/<serveur>/symbols.raw` avant.**
2. **Ne pas ouvrir le Tick Data Manager pendant qu'un backtest tourne** — il prend la base et
   le backtest se retrouve sans ticks, sans erreur visible dans le rapport.
3. **Un seul terminal MT4 avec TDS a la fois.** Deux instances se disputent la base.
4. **Restaurer `tds.config` depuis une sauvegarde efface les mappages** ajoutes depuis. Mettre
   la sauvegarde de reference a jour apres toute modification durable.

**Symptomes d'un mappage manquant, tous silencieux** : boite « No tick data symbol selected »
qui BLOQUE le terminal en attente d'un clic (donc le passage ne demarre jamais), rapport a
**0 tick modelise / qualite n/a**, et `KeyNotFoundException` quand TDS construit son dialogue.

**Etat au 01/09 : `NAS100.s` reste non fonctionnel.** EURUSD tourne parfaitement (182 ordres,
0 erreur). Le mappage est dans tds.config et `duka_symbole.py` le resout, mais TDS continue de
reclamer une selection. Un passage de 13 ans avait pourtant fonctionne a 08h19 avec ce meme
mappage — la seule difference introduite ensuite etait `OverrideStopsLevel`, remis a False.
Piste non tranchee.


## `PropFirmMaxDailyDD` rend le testeur 6 fois plus lent — 03/09/2026

Même expert, même symbole, même fenêtre, mêmes ticks réels, même dépôt. Seul
changement : `PropFirmMaxDailyDD` passé de 0 à 4.

| | durée | couverture |
|---|---|---|
| sans plafond quotidien | 1 h 01 | 24 mois, rapport produit |
| avec plafond quotidien à 4 % | 3 h 00 | **11 mois**, butée atteinte, **aucun rapport** |

Le nombre de transactions est proportionnel, ce n'est donc pas un surcroît de
trades : le contrôle quotidien coûte du temps à chaque tick.

**Deux leçons.** Prévoir six fois la durée si ce paramètre est actif. Et une
butée MT5 atteinte ne produit **rien** — pas de rapport partiel, le travail est
perdu en entier. Découper la fenêtre plutôt que d'allonger la butée.

**Et le test valait peu** : la configuration live du concepteur met ce paramètre
à zéro. Je testais quelque chose qu'il n'utilise pas. Voir
[[maxalloweddd-est-un-lot]] et [[inventorier-avant-de-lancer]].


**04/09 — la table des deals d un rapport MT5 n est PAS chronologique** : les ordres en attente y figurent a leur date de pose (1 755 lignes sur 9 250 hors ordre dans `gp_ticks.htm`). Tout script qui rejoue les deals doit trier par heure d abord, sinon il garde des positions fantomes ouvertes (j ai mesure 15 % de creux au lieu de 8 %). Et le « Fond Drawdown Maximal » du rapport est le plus grand creux EN ARGENT rapporte a son pic — pas le plus grand creux relatif, qui est en debut de periode quand le compte est petit.


**04/09 — codes d unite de temps** : 16385 = H1, 16388 = H4, 16408 = D1, 32769 = W1 (pas D1/W1 comme je l avais lu). `ArraySetAsSeries` sur un tableau statique = warning 63 et indices inverses.

## Deux pièges de chaîne, découverts la nuit du 05 au 06/09/2026

- **Disque plein tue le test en silence** : n50 (30 jeux UBS, 7 symboles, `PrintLogs=true`) a écrit 3 Go de journal en 8 minutes à cause des erreurs 4805 (« cannot load indicator Average True Range ») sur les symboles qui ne sont PAS celui du graphique (SP500.p, DJ30.p), puis « no disk space in ticks generating function » après 7h54 ; rapport écrit mais VIDE (0 transaction, « Symboles: 0 »). Remède appliqué : un test par symbole de graphique, `PrintLogs=false`, garde-fou disque dans la chaîne (`jour51.ps1`), et `Tester\cache\*.tst` (15,8 Go, régénérable) vidé.
- **La mise à jour automatique de MT5 bloque une chaîne sans surveillance** : au démarrage, le terminal lance `liveupdate\terminal64.exe /update` puis se ferme ; l'updater attend le consentement UAC (`consent.exe` présent, `terminal64` sans fenêtre, 0 % CPU). La chaîne croit le test en cours. Contrôle : `Get-Process consent,terminal64` + `logs\<date>.log` contenant « LiveUpdate start ». Seul l'utilisateur peut cliquer ; la chaîne reprend seule ensuite.

## Quatre pièges de lancement, payés le soir du 15/09/2026 (une heure perdue, aucun dégât)

- **Les `.ini` du testeur doivent être en UTF-16** — `prelance.py` le refuse sinon (« le testeur l'ignore en silence »). Mon outil d'écriture crée un fichier NEUF en UTF-8, mais **conserve l'encodage d'un fichier existant** : « convertir en UTF-16 » un fichier déjà UTF-16 le double-encode (taille ×2, caractères espacés, prelance : « champ manquant : Expert »). Écrire d'un bloc avec `Set-Content -Encoding Unicode` depuis une here-string, puis valider à blanc : `python outils\prelance.py --exe "<terminal64>" --data "<dossier terminal>" <ini>` (code 0 = OK) AVANT de lancer.
- **`Start-Process powershell -File lance_chaine.ps1 -Inis a,b` passe UN élément « a,b »** → prelance cherche `a,b.ini`. Le lanceur redécoupe désormais lui-même (15/09) ; pour tout autre script à `[string[]]`, lancer par `-Command "& '<script>' -Inis a,b"` (ce que fait `enchaine_apres.ps1`).
- **Les guetteurs `enchaine_apres.ps1` survivent à leur session** et se déclenchent dès que leur journal affiche `FIN de chaine` ou `INTERROMPUE` — y compris quand c'est MOI qui interromps la chaîne (le terminal « fantôme » de 19:59 sans test était un guetteur de 08:20 qui venait de lancer la sonde Onyx). Avant d'arrêter une chaîne ou d'en armer une : `Get-CimInstance Win32_Process | ? CommandLine -match 'enchaine_apres|lance_chaine'`, et tuer ce qui ne doit pas tirer. Trois guetteurs tournaient en même temps ce soir-là.
- **`metaeditor64 /compile` rend le code 1 même quand la compilation réussit** : seule la ligne `Result: 0 errors, 0 warnings` du journal `/log:` fait foi (v1.01 d'Eagle-owl compilée ainsi).
- Corollaire produit : **Onyx MT5 n'a pas de paramètre « lot fixe »** (`lot_selection`, `lot_method`, `MinLot`, `Maximum_Lot`, `Multiplicity_For_Lot`, `Risk_percent`) ; ses défauts sont un lot au risque 50 % — un rapport à 4,8 M$ sur 100 k$ en 4 ans est la signature. Auditer les volumes de la table des deals, pas le solde.

## 16/09 : tuer le lanceur d'une chaîne ne ferme PAS le testeur

Constaté le 16/09 : `Stop-Process` sur le `lance_chaine.ps1` en cours n'arrête que l'enchaînement ; le test MT5 en cours va
jusqu'au bout, puis le terminal se ferme seul (ini) ou reste inactif. Pendant ce temps `prelance.py` **refuse** la chaîne suivante
(« terminal64/metatester64 déjà en cours »). Deux issues propres : attendre la fin du test en cours (rapport écrit), ou fermer le
testeur avec le filtre exact du lanceur (`Testeur` : `Get-Process terminal64 | Where Path -eq <exe PU Prime>` — jamais par nom,
un compte réel tourne sur un autre `terminal64.exe`). Corollaire : ne lancer une nouvelle chaîne qu'après `FIN de chaine` ou
après avoir vérifié `Get-Process terminal64` avec ce filtre. Les veilleurs `enchaine_apres` orphelins restent à tuer avant.
Autre piège du même jour : `Seulement=` du moteur exige le **nom exact du fichier .set** (sinon « 0 jeux chargés », rapport vide,
chaîne interrompue) ; pour un sous-ensemble de jeux, un dossier dédié dans `Common\Files` (`SetsClient_JPY_BOJPY`).

**17/09 — ne jamais `tail -f` le journal du lanceur (`chaine_*.log`) depuis bash** : le `tail` MSYS tient le fichier ouvert et
l'`Add-Content` PowerShell du lanceur échoue (« en cours d'utilisation par un autre processus »), en silence : la chaîne continue, mais
plus aucune ligne « terminé / VERIFIE » n'est écrite (perdu de 10:21 à 11:52 sur la chaîne v1.21b). Reproduit sur un fichier de brouillon.
Surveiller par sondage (`tail -n 3` toutes les 30 s, ou apparition des rapports `.htm` dans le dossier du terminal), jamais par `tail -f`.
Et l'expiration d'un guetteur `Monitor` ne tue PAS son `tail` enfant : trois `tail.exe` orphelins (10:21, 10:51, 11:21) tenaient encore le
journal à 12:01. Après tout guetteur : `Get-Process tail | Stop-Process`.

**17/09 soir — deux terminaux sur un même compte réel s'annulent l'un l'autre.** Vantage réel 34803874 chargé sur le VPS de Londres pendant que
le Vantage de NY4 y était encore connecté : au déchargement des UBS de NY4 (20:06), ceux-ci ont ANNULÉ les ordres EURUSD posés depuis Londres
(mêmes magics, même compte — un EA annule au serveur tout ordre portant son magic). Zebra et Heron sont restés attachés sur NY4, inertes seulement
parce que l'auto-trading y est coupé (`10027`). Règle : arrêter complètement le second terminal (experts retirés, terminal fermé) AVANT de charger
le premier ; ne jamais laisser deux terminaux connectés au même compte avec des experts attachés.

**19/09 — une chaîne se lance avec l'outil prévu, jamais enveloppée dans autre chose.** Pour enchaîner automatiquement une
chaîne derrière un test en cours, j'ai appelé `lance_chaine.ps1` depuis un guetteur en ligne de commande (`powershell
-Command` lancé par bash). Les arguments ont mal passé : **un terminal64 s'est ouvert sans jamais recevoir de
configuration de test** et y est resté inactif (7 s de processeur en 8 minutes, aucun `metatester64`, aucun journal de
chaîne créé). C'est la panne du 18/09 sur MT4 (`/config:` ignoré, terminal ouvert sans test) reproduite sur MT5 par un
autre chemin : **l'erreur n'était pas la syntaxe, c'était de ne pas passer par l'outil normal.** Lui l'a vu avant moi
(« pas de tests en cours »).

Deux garde-fous ont tenu : `prelance.py` REFUSE de démarrer tant qu'un `terminal64` du même chemin tourne (« un test
tourne ou un terminal inactif bloque ») ; et le lanceur ne tue **jamais par nom de processus** mais en filtrant par
CHEMIN (`CheminDe $_ -eq $exe`), précisément parce qu'un compte réel tourne sur un autre `terminal64` (banc Ultima).
Pour débloquer un orphelin : vérifier d'abord qu'aucun `metatester64` ne tourne, puis fermer le seul processus dont le
chemin correspond au terminal visé — même méthode que le lanceur, jamais `Stop-Process -Name terminal64`.
