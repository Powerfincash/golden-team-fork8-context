---
name: garde-fous-mesure
description: "Sa correction du 27/08/2026 — mes erreurs alterent mon raisonnement ; la verification doit sortir de ma discipline et passer dans l'outil ; 19/09 : un agregat qui tombe juste ne prouve rien, mesurer communes/manquees/inventees"
metadata:
  type: feedback
---

Le 27/08/2026, apres quatre fautes dans une matinee, il m'a dit : « Tes erreurs te
conduisent dans une alteration de ton raisonnement et tu te perds. Modifie reellement ton
comportement. » Le mot qui compte est **reellement** : il m'avait deja reproche, la veille,
de mettre des regles par ecrit et de ne pas les suivre.

Les quatre fautes avaient **une seule forme** : affirmer avant d'avoir verifie la
precondition. Un taux de 267,7 % annonce sans controle ; une comparaison entre deux passes
sans lire les parametres charges de l'une ; une piste declaree « jamais testee » alors que
le commentaire du fichier ouvert consignait son echec ; « l'original fait 649 paniers »
mesure sur un tiers de la fenetre, quand le critere 1 124 etait ecrit dans le meme document.

**Why :** le degat n'est pas le chiffre faux, c'est la branche. Chaque affirmation non
qualifiee ouvre un raisonnement ou je construis une heure avant que le chiffre ne craque.
C'est ca, « se perdre ». Et mes controles etaient REACTIFS — declenches par un resultat qui
choque — au lieu d'etre prealables.

**How to apply :** ne pas ecrire une regle de plus. Le seul endroit ou je n'ai pas faute ce
jour-la est celui qui avait deja un outil : `verifier_passe.py`. Donc mettre la verification
dans du code qui REFUSE. Fait le jour meme :
`MQL5/Experts/LazyAlgo/Tools/source_verifiee.py` — `flux_original()` leve si la couverture
est partielle et qu'on demande un compte ; `rapport_clone(nom, exige={...})` leve si un
parametre charge contredit ce que la mesure annonce mesurer ; `taux()` leve au-dela de
100 % ; `par_unite_de_temps()` interdit les frequences « par panier », confondues avec le
critere en echec ; `piste_neuve(terme)` leve et affiche les extraits si le terme existe deja
dans le code ou la spec.

**Regle qu'il peut me faire tenir :** tout nombre que je lui donne sur l'original ou sur une
passe doit etre passe par ce module, et la ligne `[source]` doit exister. Pas de ligne de
provenance, pas de chiffre.

**LE DEFAUT EXACT : J'ANNONCE DANS LE MEME MESSAGE QUE LA MESURE.** Sa colere du 27/08 au
soir, apres que je lui ai demande de verifier avant d'annoncer toute la journee et que je ne
l'ai pas fait. Les QUATRE retractations du jour ont la meme forme : l'affirmation est sortie
a la seconde ou le chiffre est apparu, avant tout contre-test.

**Pourquoi mes garde-fous n'ont rien arrete :** `source_verifiee.py` controle l'ENTREE d'une
mesure — source, couverture, parametres charges. **Rien ne controle la SORTIE**, le saut du
chiffre a l'affirmation. C'est la que ca casse a chaque fois.

**Ce qui marche, et la seule chose qui ait tenu : une marque VISIBLE qu'il peut verifier
sans me croire** — comme la ligne `[source]`. Donc toute affirmation sur le comportement de
l'original porte desormais :
- **`VERIFIE`** — avec l'effectif ET le contre-test nomme qui aurait pu la contredire ;
- **`NON VERIFIE`** — hypothese, traitee comme telle.

Une affirmation sans marque, ou marquee VERIFIE sans contre-test nomme, **ne vaut rien**.
Ne jamais ecrire une regle de plus a la place : j'en ai ecrit trois ce jour-la et enfreint
les trois dans l'heure. **Seul ce qui est visible par lui a de l'effet.**

**RENVERSER UNE FONDATION EXIGE AUTANT DE PREUVES QU'EN ETABLIR UNE.** Ajoute le
27/08/2026 au soir, apres m'etre plante dans l'autre sens. Le matin, remettre en cause un
acquis avait tout debloque. Le soir, j'ai annonce que la regle de pose du clone etait fausse
depuis des semaines — sur UNE seule mesure, portant sans que je le voie sur 31 % de la
population. La regle etait juste : 98 % des poses majoritaires la respectent au centieme.

**Je n'appliquais pas a la DEMOLITION le standard que j'applique a la CONSTRUCTION.** Un
acquis qui a tenu doit tomber sur deux chemins independants, comme pour le poser.

*Et sur « fallait-il demander a une IA tierce ? » :* non, pas sur cette faute. Il ne me
manquait pas d'hypothese — j'avais la bonne et je l'ai jetee. Une liste exterieure donne des
mecanismes, pas un controle d'echantillonnage. Seul un second calcul pouvait rattraper ca.
**Mais si j'avais decrit ma METHODE et pas seulement ma conclusion** — « je mesure sur les
poses survenant dans la meme seconde qu'un evenement » — n'importe quel regard exterieur
aurait pu demander « pourquoi ce sous-ensemble ? ». **L'effet yeux neufs vaut sur la methode
autant que sur le sujet.**

*Motif de la journee, quatre fois :* un filtre pose pour MA commodite a decide de la
conclusion — les flux excluant les ordres en attente, « marche connu a la seconde », les
intervalles de plus de 600 s, les evenements de sortie. **A chaque fois le filtre retirait
precisement la population qui portait la reponse.**

**ET C'EST AUSSI POURQUOI JE LUI EXPLIQUE CE QUE JE FAIS.** Il l'a rappele le meme jour :
« En le sachant, cela peut me permettre de reagir. » Il est le second controle, et il
detient la verite terrain — il connait l'EA, le courtier, l'historique des versions.

Mais la narration ne le sert QUE si j'enonce mes PRECONDITIONS, pas mes conclusions. Le
27/08 je lui ai annonce « l'original fait 649 paniers » : rien la-dedans ne lui permettait
de savoir que je lisais `flux.txt` seul. S'il avait lu « je mesure sur flux.txt, qui couvre
le 23/04 au 20/05 », il aurait repondu « et le reste de la fenetre ? » immediatement. Idem
pour la bascule de rang, annoncee comme piste neuve alors qu'il avait vecu les v4.09 et
v4.10 avec moi.

Une conclusion, il ne peut que la croire ou non. **Une precondition, il peut la dementir.**
Donc : avant un resultat, dire sur QUOI il repose — la source, sa couverture, le parametre
suppose actif, l'hypothese tenue pour acquise. La ligne `[source]` est autant pour lui que
pour moi.

Voir [[methode-de-travail]] — ce module est le bras arme des deux principes qui y sont :
revenir aux bases d'abord, chercher dehors ensuite.

## 30/08/2026 — les garde-fous MT4 existent enfin : `outils/lancer_mt4.sh`

Ecrit apres une soiree ou j'ai refait, sur MT4, toutes les erreurs contre lesquelles
`lancer.sh` protegeait deja sur MT5. Trois passes rendues **0 tick modelise / 0 trade** sur un
terminal Ultima neuf, parce que **les reglages TDS sont par installation** (`config/tds.config`)
et qu'un terminal neuf part desactive.

**Il REFUSE plutot que de lancer, ou plutot que de moissonner**, sur neuf controles :
modele de ticks != 0 · une instance de CETTE installation tourne deja (MT4 ignore alors l'ini
en silence) · prefixe de rapport deja pris · TDS non active pour l'installation ·
aucun tick reel pour le symbole (derogation `--sans-ticks`) · EA absent du chemin ·
temoin « Started with configuration file » jamais vu · attente depassee — **un depassement
REFUSE, il ne poursuit pas** · rapport annoncant 0 tick modelise.

**LE CHEMIN NOMINAL DOIT ETRE TESTE, PAS SEULEMENT LES REFUS.** Ma premiere version refusait un
passage parfaitement valide : je decodais le journal en UTF-16 alors qu'il est en ANSI, et je ne
regardais qu'un des deux dossiers de journaux. **Un garde-fou non teste sur un cas VALIDE est un
garde-fou qui bloquera le travail.** Corrige : trois encodages, `logs/` et `tester/logs/`, et le
temoin est considere acquis si le rapport est deja la.

**Cause unique des erreurs de la soiree, et elle est toujours la meme** : j'ai remplace par une
inference plausible une mesure que je pouvais lancer. Annonce « glissement verifie » (faux),
puis « glissement impossible sur ce build » (faux aussi), puis 0,36 pip traite comme un cout
par cote alors que c'est un aller-retour. **Trois affirmations, zero verification prealable,
alors que chaque passage coute six minutes.**

## Le 30/08 : une erreur qui n'est pas de raisonnement mais de LECTURE

J'ai traite les 0,36 pip de [[trading-friction-timeframe]] comme un cout **par cote**, et bati
sur cette base un tableau annoncant l'EA a -569. **Sa fiche dit, en toutes lettres et en
premiere ligne : « Cout aller-retour mesure sur EURUSD.p chez PU Prime : 0,36 pip (spread +
commission) ».** Rien a deduire, rien a interpreter : a lire.

Sa remarque : *« tu ne sais meme pas lire »*. Elle est juste.

**How to apply : avant d'employer un chiffre venu d'une fiche memoire, ROUVRIR LA FICHE.**
Un chiffre rappele de memoire perd ses unites et son perimetre — et c'est exactement ce qui
transforme un resultat correct en verdict alarmiste. Les fiches sont dans
`.claude/projects/C--Users-User--claude/memory/`, elles se lisent en une seconde.

## 31/08/2026 — UN EA QUI NE TRADE JAMAIS N'A PAS DE SIGNAL NUL : IL LUI MANQUE UNE PIECE

**Market Reversal Alerts EA a occupe le terminal MT4 pendant 1 h 40 sans rien produire.**
J'ai classe ca en « echec silencieux » et je suis passe a autre chose. **La cause etait
simple : son INDICATEUR n'etait pas installe.** Lui ajoute, l'EA repart.

**Le signe qui le disait, et que j'avais sous les yeux : le journal du testeur etait VIDE.**
Un test qui tourne mal ecrit quand meme des lignes. Un journal vide veut dire qu'aucun test
n'a demarre — donc que le probleme est en amont de la strategie.

**How to apply — reflexe a avoir AVANT toute interpretation d'un resultat nul :**
1. `<terminal>/tester/logs/` (MT4) ou `<terminal>/Tester/logs/` (MT5) est-il vide ? Si oui,
   rien n'a tourne : ne rien conclure sur l'EA.
2. L'EA depend-il d'un INDICATEUR du meme vendeur ? C'est frequent chez les EA batis autour
   d'un indicateur vendu a part (Market Reversal Alerts, et les produits de Reza Aghajanpour
   qui dependent de « Swing Scanner », « 123 Pattern Scanner », « Market Structure »).
   **Telecharger l'indicateur EN MEME TEMPS que l'EA.**
3. Verifier le chemin exact : `MQL4/Indicators/Market/` pour un produit du Marche.

**Meme racine que la panne MT5 de la nuit** : chercher pourquoi rien ne demarre, au lieu de
conclure sur ce qui n'a pas tourne. Voir [[methode-de-travail]].

## 31/08/2026 — POURQUOI SON EXIGENCE DE TOUT VERIFIER N'EST PAS DE LA PARANOIA

Sa phrase : *« Depuis le temps que je te demande de tout verifier, ce n'est pas par
paranoia. »* Elle est fondee, et la raison est STRUCTURELLE, propre a cet outillage.

**Dans ce domaine, les defaillances sont SILENCIEUSES : elles ne produisent pas d'erreur,
elles produisent un CHIFFRE PLAUSIBLE.**

Les six du 30-31/08, toutes du meme moule — j'ai pris un INDICE pour LA CHOSE :

| l'indice que j'ai cru | la chose qu'il fallait verifier | ce que ca a coute |
|---|---|---|
| fichiers `.hcc` dates de 2007 | les BARRES sont-elles la ? | 14 ans testes a **18 % de qualite**, creux aberrant a 81 % |
| aucune erreur dans le journal TDS | `SlippageEnabled` dans tds.config | « glissement verifie » annonce a tort |
| 92 erreurs « slippage unavailable » | reessayer une fois | « glissement impossible » annonce a tort |
| « 0,36 pip » de memoire | rouvrir la fiche : « cout ALLER-RETOUR » | tableau annoncant l'EA a -569 |
| le `.ex4` est dans `Experts/Market` | son INDICATEUR est-il installe ? | 1 h 40 de terminal vide |
| l'EA est charge | quels PARAMETRES effectifs ? | 21 ans testes = **12 mois** avec les defauts, compte detruit |
| un symbole existe chez le courtier | des ticks reels existent-ils ? | 3 passes Ultima a **0 tick** |

**Consequence : quand rien ne signale l'erreur, la verification n'est pas une precaution
supplementaire — c'est la SEULE SOURCE D'INFORMATION disponible.**

**How to apply :** avant chaque passage, verifier la chose elle-meme, jamais son indice.
Apres chaque passage, lire dans le RAPPORT : qualite de l'historique, ticks modelises,
configuration effective, dates de la premiere et de la DERNIERE transaction. Les quatre
sont desormais des refus automatiques dans `fiche_ea.py`, `lire_rapport.py` et les deux
lanceurs — onze controles, tous nes d'une erreur reelle.

## 01/09/2026 — LE SYMBOLE TEMOIN : 100 secondes qui auraient evite un redemarrage

**Ce que j'ai fait.** Les passages sur `NAS100.s` rendaient 0 tick et TDS affichait deux
erreurs (`unable to open database file`, puis `KeyNotFoundException`). J'en ai conclu que
**TDS etait casse**, et j'ai fait faire a l'utilisateur, dans l'ordre : fermer/rouvrir MT4,
redemarrer le service `TDSService.exe` en administrateur, puis **redemarrer la machine** —
ce qui a tue un backtest Gold Phantom en cours et l'a oblige a **reinstaller Claude**.

**Ce qu'il fallait faire : lancer une sonde sur EURUSD.** Resultat, en 100 secondes :
**182 ordres, zero erreur, VERDICT=OK. TDS n'etait pas casse du tout.** Le probleme etait
circonscrit a un seul symbole.

**LA REGLE : avant de declarer un OUTIL en panne, le tester sur un cas CONNU QUI MARCHAIT.**
Un symbole temoin, un EA temoin, une fenetre temoin. Sans ce controle, on ne distingue pas
« l'outil est casse » de « ce cas particulier est mal configure » — et on repare ce qui n'est
pas casse, en cassant autre chose au passage.

**Les deux messages d'erreur mentaient sur leur portee** : ils parlaient de la base et du
dictionnaire, donc de TDS en general, alors que la cause etait un mappage de symbole. Un
message d'erreur decrit ce que le programme a ressenti, pas ou est le probleme.

Meme racine que le reste de la semaine ([[methode-de-travail]]) : j'infere au lieu de tester,
et ici l'inference a coute un redemarrage machine et une reinstallation.

## 01/09/2026 — VERIFIER QUE L'EXPERIENCE A EU LIEU, pas seulement son resultat

Deux erreurs du meme jour, meme racine : je crois avoir change quelque chose, et je ne
le verifie pas.

**1. Les reglages qui n'ont jamais ete appliques.** J'ai lance une « variante session »
d'un EA en mettant les parametres dans un bloc `[TesterInputs]` du fichier de lancement.
**MT4 ignore ce bloc.** Le passage a rendu exactement les memes chiffres que le precedent
— PF 0,68, meme profit au centime, memes 2 607 trades — et je ne l'ai vu qu'en comparant
a l'oeil. Les entrees MT4 vivent dans `<terminal>/tester/<NomEA>.ini`, bloc `<inputs>`,
et chaque cle doit etre ecrite DEUX fois : `Cle=` et `Cle,1=`.

**La garde** : `outils/regler_tester.py`. Il ecrit les deux formes, **refuse une cle
inexistante** (une faute de frappe donnerait un reglage silencieusement ignore), et
surtout `--controle Cle=valeur` se lance APRES le passage : MT4 reecrit ce fichier en
quittant avec les valeurs REELLEMENT utilisees, donc le fichier est la preuve. Teste
dans les deux sens : il valide le bon passage et refuse celui qui m'avait trompe.
Second controle gratuit : **compter les trades contre la conception** (un straddle « un
par jour » sur 6 mois doit en faire ~125 ; 2 607 ou 13 signalent un montage faux).

**2. La detection d'encodage, faite DEUX FOIS en trois heures.** Le matin j'ai lu un
journal MT4 en utf-16 alors qu'il etait en ANSI. Une heure plus tard j'ai ecrit
`regler_tester.py` avec la meme detection fautive et je me suis plante pareil. Le test
« peu de \x00 donc c'est de l'utf-16 » **ne marche pas** : decoder de l'ANSI en utf-16
ne leve aucune erreur et ne produit aucun zero, seulement des ideogrammes. **Toujours
tester la marque d'ordre d'octets d'abord** (`\xff\xfe`, `\xfe\xff`, `\xef\xbb\xbf`).

**Why:** entre les deux occurrences j'avais « appris » la lecon. Elle n'a servi a rien
parce qu'elle etait restee une regle et non un garde-fou. C'est sa correction du 27/08,
verifiee une fois de plus : **une lecon qui n'est pas dans un outil qui refuse ne tient
pas d'un contexte a l'autre.** Son mot du jour : ce n'est pas l'erreur qui est
reprochable, c'est de ne pas en tirer d'enseignement et de la refaire.

**How to apply:** ne jamais annoncer qu'un passage repond a une question sans avoir
verifie (a) que les reglages demandes ont ete utilises, (b) que le nombre de trades est
compatible avec la conception annoncee. Voir [[methode-de-travail]].


---

**03/09/2026, 14 h — « tu n'es encore vraiment pas en forme, comme les jours
précédents ». Quatrième instance, et une forme NOUVELLE et pire.**

Trois fautes dans la journée : recommander Revert Edge sur un backtest seul
(rattrapé par les avis d'acheteurs) ; brûler 1 h 24 de testeur sur `MaxAllowedDD`
de Gold Phantom, l'étalon, alors que la décision porte sur UBS, le produit ;
et surtout écrire **« la config or d'UBS, c'est Gold Phantom à 1,5× l'exposition »**
alors que **le tableau d'attribution que je venais de produire dans le MÊME
message donnait Gold Reaper à 47,9 % et Gold Phantom à 20,3 %.**

**Ce n'est plus « affirmer avant de vérifier ». C'est affirmer CONTRE ma propre
mesure, affichée deux paragraphes plus haut.** La donnée n'était ni absente ni à
chercher sur le disque : je l'avais calculée, imprimée, et j'ai écrit un titre qui
la contredit. Le résumé est parti d'une ressemblance d'agrégats (1 805 positions
contre 1 816, rapport 3,51 contre 3,34) au lieu de la composition que j'avais
sous les yeux.

**Why :** c'est lui qui a corrigé, comme les trois fois précédentes. Il paie mes
erreurs en attention, sur un projet qui lui coûte déjà du temps et de l'argent.
Et une identité fausse contamine tout ce qui s'appuie dessus.

**How to apply :** ne pas écrire une règle de plus — cette fiche dit déjà que
c'est inefficace. Deux gestes concrets, vérifiables par lui :
- **une identité (« A, c'est B ») se prouve sur les fichiers, jamais sur des
  totaux qui se ressemblent.** Outil fait : `outils/cmp_sets.py`, identité
  paramètre par paramètre.
- **avant d'envoyer un résumé, relire mon propre tableau de détail et vérifier
  que le titre ne le contredit pas.** Les trois erreurs du jour sont des
  résumés qui trahissent leur propre détail.

Corollaire de priorité : **mesurer le PRODUIT en jeu, pas l'étalon.** L'heure et
demie perdue sur Gold Phantom venait de là.

Voir [[controle-premier-resultat]], [[inventorier-avant-de-lancer]],
[[ubs-or-ticks-reels]], [[backtest-refute-ne-confirme-pas]].

**04/09 — piege des barres au bid** : une analyse par heure de la journee sur un `.hst` MT4 montre une case 01 h fortement positive sur l or (t 11) et 23 h negative : c est l ecart qui s elargit a la cloture quotidienne puis se resserre (0,36 $ des 0,52 $ dans la premiere minute, saut 23:59 -> 01:00 de -0,15 $). Toujours verifier le profil minute par minute avant de croire une case horaire. Le champ spread du `.hst` est vide.

## 13/09 : une recomposition se juge sur un rapport MT5 unique

Recomposer la jambe or à partir de séries par jeu réassemblées (attribution `parjeu.py` sur deux rapports) annonçait
hors tirage 13,80 → 16,98 ; le rapport MT5 unique des 15 jeux (`n130`) a donné **13,76**. Les jeux ne font pas la même
chose seuls et ensemble, et l'attribution des sorties entre jeux voisins n'est pas assez sûre. **Règle : aucun dosage,
aucune recomposition ne se juge sur des séries réassemblées ; seul un rapport unique compte.** `recompose_or.py` propose,
le testeur juge. Voir [[tests-a-realiser]] (test 10).

## 19/09 : un agrégat qui tombe juste ne prouve rien — mesurer communes / manquées / inventées

Deux fois le même jour, un chiffre global a failli valider une version du moteur : v1.31 affichait **100,3 % du net**
d'UBS sur l'or avec **17 % de positions en trop** ; v1.32 affichait **100,1 % des positions** du livre or alors qu'elle
**manque 514 entrées et en invente 518** (85,5 % de communes seulement, jeu par jeu). Dans les deux cas l'agrégat était
une COMPENSATION entre deux erreurs de sens opposé.

**Why :** un moteur qui rate autant d'entrées qu'il en invente produit exactement le bon total. Le compte de deals, le
net et le rendement sont tous des agrégats : aucun ne distingue « fidèle » de « faux deux fois ». Et l'erreur est
attirante parce que le chiffre rond donne envie de conclure.

**How to apply :** toute comparaison moteur/référence passe par `outils/fidelite_entrees.py` (appariement des entrées par
sens et heure à ±3 min), qui sort les TROIS nombres ensemble : communes, manquées (UBS seules), inventées (moteur seules),
avec leur net. Un verdict d'adoption cite les trois, par jeu. Corollaire mesuré le même jour : quand on reconstruit une
grandeur de la référence (un niveau UBS), l'outil doit porter son propre contrôle de cohérence — sans le facteur de
valeurs variables la reconstruction d'un niveau tombait juste dans 25 % des cas, et ce taux d'échec avait été inscrit
dans le code comme un comportement d'UBS pendant des jours. Voir [[moteur-multi-jeux]], [[backtest-refute-ne-confirme-pas]].

## 19/09 : une anomalie notée n'est pas une anomalie vue — et changer d'objet débloque un diagnostic

Sur l'argent Till, j'ai écrit dans le diagnostic que « UBS entre jusqu'à 8 fois sur un niveau, au-delà de son propre
`MaxTrades=5` », puis j'ai conclu **« écart diffus, pas de mécanisme manquant, chantier suspendu »**. La contradiction
était écrite noir sur blanc dans ma propre sortie et je l'avais traitée comme une curiosité de comptage.

Quarante minutes plus tard, en diagnostiquant un jeu SANS RAPPORT (Reaper 6, l'or), la même anomalie est réapparue —
cumul 11 pour un plafond de 5 — et cette fois la question s'est posée : et si `MaxTrades` plafonnait les positions
SIMULTANÉES ? Mesuré sur trois bancs : aucun niveau ne dépasse jamais MaxTrades en simultané, alors que les cumuls
montent à 11 et 13. Le moteur comptait les entrées cumulées et condamnait le niveau définitivement. **La correction a
fait gagner 45 entrées à l'argent** (88,8 → 90,9 %), le chantier que je venais de déclarer sans issue.

**Why :** un chiffre qui contredit un paramètre déclaré est une PISTE, jamais un détail. Je l'avais imprimé sans
l'interroger parce que je cherchais autre chose (l'échelle, les niveaux, la cadence). Et sa remarque est juste —
« reculer pour mieux sauter » : le diagnostic direct butait, l'angle d'un autre jeu a rendu la même anomalie lisible.

**How to apply :** (1) quand une sortie de mesure montre une valeur qui dépasse un plafond déclaré dans le `.set`,
s'arrêter et tester l'interprétation du paramètre AVANT de conclure quoi que ce soit ; (2) avant de suspendre un
chantier, relire sa propre sortie à la recherche de ce genre de contradiction ; (3) un chantier suspendu n'est pas clos
— le rouvrir dès qu'une règle trouvée ailleurs touche le même mécanisme. Voir [[moteur-multi-jeux]].
