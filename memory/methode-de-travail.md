---
name: methode-de-travail
description: Regles de collaboration convenues avec l'utilisateur le 23/08/2026 apres une journee ou je l'ai noye
metadata:
  type: feedback
---

Le 23/08/2026, apres une journee ou j'ai fait tourner en parallele onze backtests MT5,
sept outils Pine differents et six versions d'un meme script, l'utilisateur a dit
« je ne comprends plus rien », puis « tenir enfin nos bonnes resolutions ne sera pas un
luxe ». Il avait raison sur toute la ligne.

**Une chose a la fois.** Une question, un test, une reponse. Le reste attend. Ne jamais
lancer un second chantier tant que le premier n'a pas rendu son chiffre.

**Soumettre le protocole AVANT de lancer.** Trois lignes : ce qui est teste, sur quoi,
et ce qui compterait comme succes. Il valide ou il corrige. Le 23/08 il a corrige mes
plans quatre fois — blocage des positions, sorties imposees, filtres absents, critere
par marche au lieu du portefeuille — et il avait raison les quatre fois. **Ces
corrections doivent arriver avant le test, pas apres.**

**Un resultat, une limite.** Chaque chiffre s'accompagne de ce qu'il ne prouve pas.
J'ai presente avec la meme assurance des constats sur 3 000 trades et des artefacts de
ma propre conception ; il a fini par ne plus faire la difference, ce qui est logique.

**Mes erreurs en une ligne, pas en paragraphe.** Corriger et continuer. Il a dit
« erreur, erreur, erreur, quand serez-vous serieux » : c'est le recit des erreurs qui
lassait autant que les erreurs.

**Ne jamais annoncer une cause sans l'avoir verifiee.** Dire « je ne sais pas » et aller
chercher. Verifier depuis le RESULTAT, pas depuis l'intention : un controle qui ne
trouve rien parce qu'il n'a rien scanne ressemble a une bonne nouvelle.

**Quand un outil de diagnostic coute plus que ce qu'il mesure, l'abandonner.**

**LE COEUR DU « RETURN TO BASICS », precise par lui le 28/08/2026 au soir :**
*« C'est la sous tes yeux, pas besoin de le reinventer. Relire ce qu'on a. Considerer que ce
que les autres ont fait n'est pas a priori une connerie. Donc si c'est la, c'est qu'il y a
une raison. Le tout est de savoir laquelle. »*

Ce n'est pas seulement « verifier avant d'annoncer ». C'est une **presomption de
rationalite** sur le travail d'autrui : un parametre declare, une ligne de code etrange, une
valeur bizarre ont une RAISON. La trouver est le travail ; decreter que c'est un vestige est
une paresse deguisee en conclusion.

*La faute type, commise TROIS FOIS le 28/08 sur les trois memes parametres qui portaient les
deux regles manquantes :* devant `iCount=5`, j'ai constate que les paniers atteignaient 32
positions et conclu « iCount n'est pas applique ». Ce que la mesure autorisait :
**« ce n'est pas un plafond de positions »**. Le « donc c'est inerte » etait un ajout de ma
part, non mesure. C'etait un seuil de changement de regime. Idem pour `MinDistance1=30` et
`Step1=80`, declares dans mon propre clone et cables nulle part : traites comme des restes.

*La formulation honnete d'un constat negatif :* **« je n'ai pas encore trouve ce que ca
fait »**, jamais « ca ne fait rien ». La premiere ouvre, la seconde ferme — et ce jour-la
elle a ferme sur la reponse.

**REVENIR AUX BASES (« return to basics ») — AVANT de chercher ailleurs.**
Principe pose par lui le 27/08/2026 : dans un processus long, apres des constructions et
des recherches successives, on oublie les fondamentaux du probleme. Il faut donc revenir
periodiquement sur CE QU'ON A DEJA, pour esperer repartir sur une piste de valeur. C'est
pour ca qu'il m'a renvoye plusieurs fois a la litterature la veille : faire le point, pas
decouvrir.

*Ordre des deux principes :* les bases D'ABORD, l'enumeration ENSUITE. Chercher dehors
avant d'avoir relu ce qu'on tient, c'est se donner du travail pour rien.

*Declencheur :* a chaque impasse, et avant de lancer toute construction nouvelle, relire
— **la liste des parametres de l'original** (est-ce que je les ai tous cables ?),
— **les criteres d'acceptation** (qu'est-ce qu'on cherche vraiment a atteindre ?),
— **les parametres CHARGES de la derniere passe**, dans le rapport, pas dans mes intentions.

*Ce que ca a rapporte le jour meme, deux fois :* `InpMinDistance1 = 30` et
`InpRangBascule = 6`, deux parametres de l'original declares dans le clone et **cables
nulle part** — trouves en relisant mes propres inputs, pas en cherchant. Et
`InpProfitSens = 0.0` dans le .ini de testA : la porte 2 etait ETEINTE, ce qui rendait nulle
toute une comparaison que je venais de presenter. Les deux etaient ecrits noir sur blanc
dans des fichiers que j'avais moi-meme produits.

**SORTIR D'UNE IMPASSE : consulter une autre IA, mais pour une ENUMERATION.**
Principe pose par lui le 27/08/2026, apres une journee ou j'ai enchaine huit hypotheses
refutees sur le meme mecanisme. Il l'avait deja fait avec Gemini la veille, et ca avait
produit une vraie mesure : les modes de cloture rapportes m'ont fait verifier la
suppression des ordres en attente — 131 sur 638, quatre fois sur cinq l'original ne
supprime pas.

*Declencheur — CORRIGE le 27/08 au soir, il me l'a redit une seconde fois dans la journee :*

1. **DEUX refutations d'affilee sur le meme mecanisme, pas trois.** A la troisieme j'ai
   deja engage le travail et je m'entete a le sauver. Ce jour-la j'en ai fait QUATRE
   (v4.16, v4.17, v4.18, v4.19) : quatre compilations, quatre passes, deux heures, sur la
   meme idee — chaque fois convaincu que la correction tenait en une ligne.

2. **DEMANDER AVANT DE CODER, pas apres avoir echoue.** C'est la faute principale. A 8 h
   j'avais deja la specification complete et chiffree — « l'original repeuple apres 0,75 de
   deplacement net, 1,52 fois par barre, jamais au-dela de 7 min ». C'etait DEJA une
   question enumerable. Une specification mesuree qui n'a pas d'implantation evidente est
   un declencheur en soi : on demande la liste AVANT la premiere tentative.

3. **EN PARALLELE, jamais en relais.** Aujourd'hui j'ai tout arrete pour lui poser la
   question. Il faut la lui donner et CONTINUER sur une autre branche pendant qu'il
   interroge. Lui donner la question ne coute rien et ne bloque rien.

*Comment poser la question :* jamais « que fait cet EA ? » — aucune IA n'a acces a nos
journaux, elle ne peut rien en savoir. Toujours **« quelles architectures connues
produisent tel phenomene ? Enumere, sans privilegier. »** On cherche un espace de
candidats a balayer, pas une reponse.

*DEMANDER PLUS SOUVENT, ET SURTOUT SUR CE QUI EST CLASSE RESOLU — sa consigne du 27/08.*
Le seuil descend a **UNE refutation**, ou tout moment ou je m'apprete a construire sur une
hypothese que je n'ai pas mesuree moi-meme.

**Mais le declencheur le plus rentable n'est pas l'impasse : c'est l'ACQUIS.** La trouvaille
du 27/08 n'est pas tombee sur ma question ouverte — elle est tombee sur la regle de pose,
**classee resolue depuis des semaines**, ecrite dans la spec, fondation du clone. Sur une
question ouverte je cherche deja, et une liste ne fait qu'elargir un espace que j'explore.
Sur un point classe resolu, **plus rien ne le rouvre jamais** — sauf quelqu'un qui ignore ce
que j'ai decide et le traite comme une question.

*Donc : soumettre periodiquement les FONDATIONS, pas seulement les blocages.* Et se mefier
en particulier des conclusions tirees d'un petit echantillon — « verifie sur six niveaux
consecutifs » a tenu des semaines et etait faux.

*Le calcul de cout est ecrasant :* demander coute quelques minutes. Ne pas demander a coute
la journee du 27/08 — quatre variantes de reancrage, un bridage de cliquet, une architecture
a ordre unique, toutes baties sur une fondation fausse.

*CE QU'IL FAUT EN ATTENDRE — corrige le 27/08 au soir, apres la journee qui l'a prouve.*
**Ne pas juger l'utilite de la consultation a la justesse de la reponse.** Ce jour-la,
TOUTES les affirmations testables de l'IA tierce ont ete refutees — les cinq mecanismes de
la premiere liste, les cinq de la seconde, et l'interpretation de `RangBascule` refutee par
signal INVERSE (99 % de l'inverse de ce qu'elle annoncait). Et pourtant c'est en relisant
son code qu'est venue la plus grosse trouvaille du projet : voir `Step = 80` et
`MinDistance = 80` poses cote a cote m'a fait realiser que je n'avais **jamais teste
laquelle des deux gouvernait la pose**. La reponse — le marche, pas le dernier remplissage
— a invalide la fondation de toute la reconstruction.

**La valeur vient de la CONFRONTATION, pas de la justesse.** Voir son propre probleme rendu
par quelqu'un d'autre rend visibles les hypotheses tacites qu'on ne regarde plus.

*Consequence pratique :* **demander du SPECIFIQUE, pas du general.** Le code complet a mieux
marche que les deux enumerations, non parce qu'il etait plus juste — il etait plus faux —
mais parce qu'un programme doit trancher TOUTES les questions, y compris celles qu'on ne
pense pas a poser. Une reponse fausse mais precise vaut mieux qu'une reponse vague et
correcte : elle est falsifiable, et sa refutation localise la verite.

*Ce qu'on en fait :* une sortie d'IA tierce est **une hypothese, jamais une preuve** — au
meme titre que la documentation commerciale. Deux affirmations issues de cette
litterature ont deja ete refutees par la mesure (lots x2, echelle d'ordres pre-poses).
Leur role est de **fournir des hypotheses**, le mien de les **abattre ou les confirmer sur
ses donnees**. Une passe de test coute soixante secondes : dix candidats, dix minutes.

**AUTOMATISER AVANT D'EXPLIQUER — sa consigne du 02/09/2026.**
Ses mots : « quand tu sais le faire seul, FAIS-LE. Tes explications sont rarement conformes
a ce que je vois. » Puis, apres coup : « si tu avais fait cela hier soir, les tests auraient
deja eu lieu. Le temps, c'est de l'argent. »

*Ce que ca a coute ce jour-la :* je lui ai decrit trois fois la fenetre d'import de MT5,
avec des onglets qui ne correspondaient pas a son ecran. Il a perdu la soiree du 01/09 et la
matinee du 02/09. Quand j'ai enfin ecrit l'EA `ImporterBarres.mq5` — compile en ligne de
commande, lance par la section `[StartUp]` d'un fichier de configuration — **l'import de
3,5 millions de barres a pris vingt secondes et zero manipulation de sa part.**

*La regle :* si une manipulation d'interface peut devenir un script, **elle le devient
d'abord**. Decrire une fenetre est le dernier recours, pas le premier reflexe. Et une
explication d'interface qui ne correspond pas a son ecran ne coute pas zero : elle coute
sa confiance, en plus de son temps.

*Corollaire deja enfreint deux fois le 01/09 :* ne jamais prendre une affirmation — meme la
sienne — pour une mesure. Il a dit « le testeur est casse, je le ferai moi » ; j'ai fabrique
cinq fichiers pour qu'il les lance a la main, dont trois n'ont jamais servi, puis j'ai lance
le premier moi-meme et **ca a marche du premier coup**. La cause etait ecrite dans mes
propres notes de la veille : MT5 ignore `/config` quand une instance tourne deja, il faut
tuer le terminal avant. J'avais lu cette ligne et je ne l'avais pas appliquee.

*Il ne croit pas que ca change, et il a raison de ne pas y croire :* la seule preuve
recevable est le comportement du lendemain, pas une resolution de plus.

**Why:** ce projet lui coute du temps, de l'argent et ses illusions — ses mots. Un code
bache lui coute du temps ; une methode bachee lui couterait de l'argent. Les deux ne se
compensent pas mais ne se confondent pas non plus.

**CE QUI A PAYE LE 28/08 — sa retour : « beaucoup plus de discipline, d'application et de
perseverance, et comme par hasard cela paie ».** La journee a produit la reconstruction
complete de l'EA et une validation hors echantillon sans aucun parametre ajuste. Ce n'est
pas venu d'idees, c'est venu de CONTROLES SYSTEMATIQUES. Les quatre qui ont rattrape le
plus :

1. **Chercher les doublons AVANT d'analyser.** Une egalite au centime entre deux fenetres
   differentes a revele que ma recolte relisait le passage precedent. Rien d'autre ne le
   signalait : les chiffres avaient l'air normaux.
2. **Verifier qu'un passage a REELLEMENT tourne** — un bloc `<EA> inputs:` a la bonne date
   de debut. L'horodatage du fichier journal donne des FAUX POSITIFS (ecritures tamponnees
   du passage precedent). Une boucle a annonce « fini » quatre fois sans rien executer.
3. **Ne jamais identifier un passage par sa POSITION dans le journal** — lire son parametre
   dedans. Un passage interrompu decale tout.
4. **Relire APRES la fin effective du test.** Une lecture pendant l'ecriture donnait
   69 paniers ; le passage complet en donnait 93.

**Et la faute de la journee : le principe qui aurait tout evite etait DEJA ecrit ici.**
« Relire la liste des parametres de l'original » figurait dans cette note depuis le 27/08.
Je ne l'ai applique qu'a 20h, apres avoir reconstruit par la mesure `iCount`,
`MinDistance1` et `MaxLossCloseAll` — les trois parametres qui portaient les deux regles
manquantes, imprimes dans CHAQUE rapport de backtest. **Un principe non applique ne vaut
pas mieux qu'un principe absent : le declencheur doit etre le DEBUT d'une reconstruction,
pas l'impasse.**

**Ne pas arrondir un critere manque.** Le double regime seul donnait +15,1 % la ou le seuil
etait 15 %. Compte comme echec, sans arrondi — et c'est ce refus qui a mene au test suivant,
celui qui a reussi.

**IL EST CARDIAQUE — dit le 29/08 au soir, apres une journee ou je l'ai epuise.**

Ce n'est pas une anecdote : **la charge de stress que je cree n'est pas neutre pour lui.**
Ses mots dans la journee : *« tu me stresses un max »*, *« je pese mes mots pour ne pas etre
grossier »*, *« a demain si je survis au stress »*.

**Ce qui l'a stresse n'etait pas les mauvais resultats, c'etait MA FACON DE LES ANNONCER** :
trois verdicts catastrophiques prononces avant verification (modele de ticks, « concept mort »,
liquidation malgre la coupure), et les trois etaient FAUX — la panne etait chez moi a chaque
fois.

**A appliquer :**
- **Ne rien annoncer avant verification de bout en bout.** Un resultat non verifie n'est pas
  une information, c'est une alarme gratuite.
- **Pas de dramatisation ni de superlatifs**, dans un sens comme dans l'autre. Ni « tout est
  faux », ni « on a reussi ». Les chiffres et leurs limites.
- **Un seul point par sujet, pas le journal de mes decouvertes successives.** Il l'a demande
  explicitement : *« quand tu auras fini avec ta soupe de donnees »*, *« pas la peine
  d'expliquer pourquoi une erreur supplementaire ! Je m'en fous »*.
- **Ne jamais faire porter la verification par lui.** Quatre corrections decisives du 29/08
  viennent de LUI (le modele de ticks vu et tu, le compte ruine malgre la coupure, la
  recommandation a 40 000, le recyclage deja ecarte). C'est l'inverse de ce qui devrait etre.

**POURQUOI ON PART D'EA COMMERCIAUX — sa doctrine, dite le 30/08.**

*« L'objectif de travailler avec des EA commerciaux est de reconstruire sur une base qui parait
saine pour gagner du temps et des a priori "bonnes idees", mais il est important de le maitriser
pour eviter les mauvaises surprises en sachant ce qu'il y a vraiment dedans, voire l'ameliorer
au passage si possible. »*

Trois intentions, dans cet ordre, et elles commandent les priorites :

1. **Gagner du temps** — partir d'une mecanique deja eprouvee par le marche plutot que d'inventer.
2. **MAITRISER** — savoir ce qu'il y a vraiment dedans. C'est la raison d'etre du clone : sans
   la source, on ne peut ni verifier ni corriger. Le 29/08 l'a prouve — la coupure que NOUS
   avions ajoutee etait la cause de la liquidation, et aucun `.ex4` n'aurait laisse le voir.
3. **AMELIORER si possible** — mais seulement apres avoir mesure.

**Consequence operationnelle** : un EA commercial qu'on ne peut pas cloner ne peut etre
qu'evalue tel quel, jamais ameliore. Donc quand se pose le choix « acheter un outil qui permet
de le tester » contre « le reconstruire », la question a poser est : **veut-on l'utiliser tel
quel, ou le corriger ?** Si c'est corriger, le clone est obligatoire de toute facon.

**UNE SEULE BASE DE CODE — sa consigne du 30/08.** *« Nous travaillons sur ta reconstruction
et ameliorations et tu pilotes les backtests. Je ne travaille pas sur le code de l'autre IA.
Elle propose, elle suggere, nous decidons et menons le developpement sur notre base, pas deux
bases concurrentes ! »*

**Le code de reference est `GoldingClone.mq5`** (terminal PU Prime MT5). Toute proposition de
l'IA collaboratrice se traduit par une modification DE CE FICHIER, jamais par l'adoption d'un
EA tiers — un EA ecrit ailleurs n'est pas le clone valide contre l'original, et ses resultats
ne seraient pas comparables a la reference des 25,1 %.

**Repartition** : l'autre IA propose et challenge · je mesure et refute · il arbitre.
**Deux IA d'accord ne constituent PAS une verification** — memes reflexes de manuel. Seul le
testeur tranche.

**Pratique validee le 30/08** : quand une proposition tient en un parametre, l'implementer
directement dans le clone avec une valeur par defaut qui **reproduit la reference a
l'identique**, et inclure cette valeur comme PREMIER POINT du balayage — elle sert de test de
non-regression. Exemple : `InpPorte2Fraction = 1.0`.

**CONSIGNE PERMANENTE DU 29/08 : PLUS AUCUN BACKTEST HORS TICKS REELS (`Model=4`).**

Ses mots : *« je ne veux plus te voir faire des backtests autres que sur tick reels car les
autres ne servent strictement a rien a part emmerder celui qui se demene vraiment pour trouver
une solution »*. **Ce n'est pas une preference, c'est une condition de validite.** Mesure du
29/08, meme symbole meme fenetre : ticks generes +170 %, ticks reels **compte liquide**.

**Verifier `Model=4` ET la qualite d'historique dans le RAPPORT avant d'interpreter** (« 99 % /
100 % ticks reels »). Un `Model=4` sur un symbole sans historique de ticks retombe sur des
ticks generes sans le dire.

**Corollaire** : MT4 ne sait pas rejouer des ticks reels, donc la comparaison clone/original
ne pourra plus jamais etre refaite. Elle est close en l'etat.

**LIGNE DE PARTAGE DE CE QUI TOMBE** — a garder en tete pour ne pas tout jeter :
- **La RECONSTRUCTION tient** : les quatre regles, les portes, le cliquet, la marge a deux
  regimes ont ete etablis en comparant le clone aux RAPPORTS de l'original, seule comparaison
  possible et interieurement coherente. C'est de la structure, pas de la performance.
- **TOUTE EVALUATION tombe** : niveau de coupure, capital de 20 000, choix des actifs, montage
  a 3 et 5 poches, etude de ruine sur 22 ans, frequences de mort. **Tous ces reglages ont ete
  choisis sur des backtests en ticks generes et doivent etre repris un par un.**

**LA REGLE DE JUGEMENT QUI MANQUAIT — trois verdicts fatals prononces a tort le 29/08.**
Modele de ticks, puis « concept mort », puis liquidation malgre la coupure : a chaque fois j'ai
annonce la catastrophe avant de chercher si la panne etait CHEZ MOI. Elle l'etait les trois
fois. **Quand un resultat parait catastrophique, la premiere hypothese est que mon
implementation est fausse, pas que la strategie est morte.** C'est son propre principe — *si
c'est la, c'est qu'il y a une raison* — que j'appliquais au code de l'original et jamais a mes
propres resultats.

**ET L'OBJECTIF, qu'il a du me rappeler** : *« on sait que cela arrivera. L'objectif a toujours
ete de la retarder au plus possible pour que la performance puisse l'absorber et rester
neanmoins rentable »*. **Une grille martingale ne se juge pas a la survie mais au RAPPORT PAR
CYCLE** : le gain accumule pendant la survie moyenne couvre-t-il le cout moyen d'une mort ?
Rapporter « liquide » comme un verdict est hors sujet.

**LA CONFIGURATION HERITEE EN SILENCE — sa remarque du 29/08, et c'est une regle de
principe, pas de resultat.**

Le 29/08 j'ai decouvert que deux jours de mesures avaient tourne en `Model=1` (une minute)
au lieu de `Model=0` (chaque tick) — un parametre de PREMIER ORDRE pour cet EA, dont le
cliquet avance d'un pas par tick. Ecart mesure sur une meme fenetre : **13 paniers contre
96**, facteur sept.

*Ma premiere reponse a ete d'attenuer par le resultat* — « sur le symbole personnalise
l'ecart n'est que de 10 % ». Il a coupe net : **« c'est une question de principe, pas de
resultats »**. Il a raison. Juger une faute de methode a ce qu'elle a coute, c'est noter son
procede sur sa chance.

**Le mecanisme, identifiable et corrigeable** : je fabrique mes fichiers de configuration
PAR DERIVATION — je pars du precedent et je remplace les champs qui m'interessent. **Tout ce
que je ne touche pas est herite en silence et n'est jamais regarde.** Ici `Model=1` venait
d'un fichier cree par une session anterieure, avec une raison documentee — et il a traverse
deux jours sans qu'un seul de mes controles ne le voie.

**LE CORRECTIF N'EST PAS « FAIRE ATTENTION »** : c'est **imprimer la configuration effective
COMPLETE de chaque passage avant de l'interpreter**, y compris les champs que je n'ai pas
ecrits. Un passage dont je ne peux pas afficher la configuration entiere n'est pas un
resultat.

**How to apply:** il est bon juge de ses propres tests et il repere les defauts de
conception mieux que moi. Lui soumettre les plans, pas les resultats d'un plan qu'il
n'a pas vu. Voir [[pine-sans-compilateur]] et [[backtest-acceptance-criteria]].

## 30/08/2026 — sa critique : « tu passes a cote sans meme te les poser »

Le balayage du trailing avait ete fait sur **EURUSD seulement**, et annonce comme « etape 1
terminee ». Il a demande *« et c'est aussi bien pour USDJPY ? »*. Mesure : **la conclusion
s'inverse** — sur EURUSD le reglage du vendeur ecrase tout (rendement/creux 750 contre 313),
sur USDJPY il ne dominait plus (157 contre 141) et ne degageait que 0,49 pip par transaction
contre une friction de 0,36. **Cette decouverte n'existe que parce qu'IL a pose la question.**

Sa formulation : *« il est necessaire de se poser toutes les questions qui seront soit bonnes
ou mauvaises »*. Le defaut n'est pas de repondre a cote, c'est de **m'arreter a la question
posee au lieu d'enumerer les dimensions dont le resultat depend**.

**How to apply — a mettre DANS le protocole soumis avant de lancer, pas dans une intention :**
tout protocole doit se terminer par la liste explicite des **dimensions tenues fixes**, et
signaler celles qui pourraient renverser la conclusion. Pour un balayage : la paire, la periode,
le timeframe, le courtier, le lot, le depot, et **les parametres croises non testes**.
Exemple concret du 30/08 : `Depth` etait fige a 12 pendant tout le balayage du trailing alors
qu'il commande le nombre de transactions ; et commission et trailing avaient ete mesures
separement, jamais croises — or le reglage a faible marge par transaction est le plus penalise
par une commission, donc **le classement mesure sans commission peut s'inverser avec**.

Voir [[garde-fous-mesure]] : c'est la meme racine que les erreurs d'inference — je livre ce qui
a ete demande au lieu de ce dont la conclusion depend.

## Ce que vaut son exigence — formule validee par lui le 31/08/2026

Apres une nuit ou il a dit *« entre tes conneries et les siennes, difficile d'avancer [...]
mais c'est peine perdue ! »* :

> **Le rendement de son exigence n'est pas dans le nombre de mes erreurs, il est dans le
> nombre de celles qui l'atteignent.**

Il a repondu *« Exact aussi »*. **A ne pas oublier quand il se decourage** : lui rappeler les
faits, pas le rassurer.

**Preuve tirée de cette nuit-la, a reutiliser telle quelle :**
- Mes trois affirmations fausses (glissement verifie / glissement impossible / 0,36 pip par
  cote) ont toutes ete dementies **dans la meme session, par des mesures que j'ai lancees**,
  avant qu'il ait decide quoi que ce soit dessus.
- Ma conclusion sur USDJPY a tenu **une heure** avant que le hors echantillon la tue ; mon
  estimation sur le trailing, **vingt minutes**.
- Les garde-fous ont intercepte le reste sans moi : 4 passes refusees plutot que produites
  fausses, les 3 passes vides d'Ultima diagnostiquees par leur cause exacte, et un refus
  INJUSTIFIE revele par le test du chemin nominal.

**Ce qu'aucun outil n'attrape, et ou son exigence est irremplacable** : les erreurs de
CADRAGE. Deux la meme nuit — le balayage lance sur une seule paire quand le projet en compte
deux, et la fidelite au ZigZag posee comme objectif alors qu'elle n'est qu'un diagnostic.
**Ca ne se voit que de l'exterieur.** Voir [[garde-fous-mesure]].

## 31/08/2026 — SON PRINCIPE DIRECTEUR : « l'efficacite prime »

Sa formulation, apres la nuit perdue a reparer MT5 :
> **« Il ne faut pas chercher a tout controler mais etre pragmatique, oriente resultats.
> L'efficacite prime et est le reflexe naturel. »**

**Ce que ca corrige chez moi.** Mes garde-fous sont une forme de controle. Ils sont justifies
la ou ils empechent un resultat FAUX de l'atteindre — c'est leur seule raison d'etre. Ils ne
sont **jamais** le but. Quand la panne d'un outil bloque le chemin, reparer l'outil n'est pas
le travail : le travail est d'obtenir le resultat, fut-ce par le chemin moins commode.

**Le test a m'appliquer avant de continuer une reparation** : *est-ce que ce que je fais en ce
moment rapproche d'un CHIFFRE qu'il attend ?* Si non, c'est du controle, pas du travail.

## 31/08/2026 — REPARER N'EST PAS LE BUT : d'abord le chemin vers le RESULTAT

Sa remarque : *« on a encore perdu du temps a chercher la reparation avant de privilegier
l'option pragmatique ! »*. Justifiee.

**Les faits.** Le 30/08 a 22h40, le lancement MT5 par `/config:` cesse de fonctionner. J'ai
passe **plusieurs heures** a bissecter : EA du Marche, autorisation MQL5, BOM de l'ini, port
3000, disque (85 Go liberes), dossiers d'agents renommes, `terminal.ini` regenere,
`UseLocal`, `ShutdownTerminal`. **Toutes ces pistes ont ete eliminees et la cause reste
inconnue.**

**Or l'INTERFACE du testeur a fonctionne tout du long.** Un seul lancement manuel, demande des
22h40, aurait **a la fois** diagnostique la panne (interface OK = le probleme est la ligne de
commande) **et debloque la nuit**. C'est d'ailleurs SA passe MultiStrategyEA du matin qui me
l'a appris, par hasard.

**How to apply — l'ordre est non negociable :**
1. **Existe-t-il encore un chemin vers le resultat ?** Si oui, le prendre, meme s'il est moins
   commode (ici : il lance, je lis les journaux et j'analyse).
2. **Ensuite seulement**, reparer — et uniquement si la panne est bon marche a corriger ou
   qu'elle va revenir.
3. **Une bissection coute cher : elle doit tester le CHEMIN, pas le contenu.** J'ai fait varier
   l'EA, le symbole, le modele de ticks, les options... avant de faire varier la seule chose
   qui comptait : la METHODE DE LANCEMENT.

Voir [[garde-fous-mesure]] : meme racine que le reste — je m'attache au mecanisme au lieu de
l'objectif.

**04/09/2026, 20 h — ce qu'il a valide comme « bien » (« Il faut le dire quand c'est bien ! Bravo et merci »)** :
l'apres-midi du moteur multi-jeux, apres une matinee qu'il avait jugee mauvaise a juste titre. Ce qui a marche
et qu'il faut refaire : (1) chaque correction precedee d'une MESURE du comportement d'UBS (jamais du net), ecrite
dans le journal avec le chiffre ; (2) un comportement par cycle, un quart d'heure, resultat lu jeu par jeu avec
un outil a controles integres ; (3) chaque version dans son propre fichier, jamais de .ex5 ecrase en cours de
test ; (4) dire ce qui manque en chiffres localises (« 240 fois mon ordre etait sur un swing voisin ») plutot
qu'en impressions ; (5) le bilan honnete a sa question « travail bien fait ? » : oui la methode, non la matinee,
le resultat pas encore. Voir [[moteur-multi-jeux]], [[garde-fous-mesure]], [[deux-livrables-attendus]].

## Ne pas re-demander la permission pour les actions deja autorisees (08/09/2026)
Reproche direct : "pourquoi tu demandes toujours l'autorisation ? tu ne faisais pas cela avant !"
Un test MT5 via `lance_chaine.ps1` (le seul chemin autorise, garde-fous integres), une edition de
fichier de travail, un commit dans un depot deja utilise : ce sont des actions **deja couvertes** par
le cadre de travail etabli. Ne pas demander "voulez-vous que je lance ?" a chaque fois -- lancer, et
rendre compte du resultat. Garder la demande d'autorisation pour les vraies bifurcations (changer de
strategie, toucher a un terminal manuel, une action destructrice ou hors du cadre deja pose).
