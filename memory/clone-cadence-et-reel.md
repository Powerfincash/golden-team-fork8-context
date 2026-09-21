---
name: clone-cadence-et-reel
description: "L'ecart de cadence du clone reste inexplique (l'hypothese des ticks est refutee), et les chiffres du compte reel PU Prime qui calibrent tout"
metadata: 
  node_type: memory
  type: project
  originSessionId: 97938010-9132-4f59-8a64-0a35079912b2
  modified: 2026-08-27T19:08:51.416Z
---

**Mesuré le 27/08/2026. Deux acquis qui ferment des questions restées ouvertes des semaines.**

**1. RETRACTE LE 28/08 — l'ecart de cadence n'est PAS un artefact de ticks.**

Ce que j'avais conclu le 27/08 (« c'est la densite de ticks de MT5, question close ») est **faux**.
Le journal du testeur MT4 de l'original le refute directement :

| | ticks par barre H1 | paniers (7 semaines) |
|---|---|---|
| **ORIGINAL, MT4** | **21 484** | **1 124** |
| clone, XAUUSD.p, Model=0 | 23 834 | 2 802 |
| clone, XAUUSD.p, Model=1 | 239 | 912 |

**Meme densite a 10 % pres, 2,5 fois plus de paniers.** Le Model=1 qui donnait 912 etait une
coincidence, pas une reproduction du mecanisme. **La cause du 2,5 reste INCONNUE.**

**Facteur de correction de l'etude longue : 4,1** (et non 2,5). Mesure du 28/08 : le clone sur
le symbole `XAUUSD_22`, restreint a la fenetre de reference, produit **4 647 paniers** contre
1 124 a l'original. Le symbole importe n'a pas la meme densite que celui du courtier :
3 859 ticks/barre sur 22 ans contre 18 955 sur la seule fenetre recente — les annees anciennes
sont clairsemees et diluent la moyenne.

**Refaire l'etude en Model=1 ne sert a rien** : 47 990 paniers contre 53 453, soit -10 %.
Fait le 28/08, PF 1,66 contre 1,45.

**Deux faits pratiques decouverts le 28/08 :**
- **L'original met 57 h 36 min** pour les 7 semaines (16 865 465 tick events, 785 barres).
  C'est toute la raison d'etre du clone, enfin chiffree.
- **Tick Data Suite echoue a s'authentifier depuis au moins le 21/08** et se decharge.
  L'original a donc tourne SANS TDS : la comparaison avec le clone reste valide.
- **Le testeur MT4 se pilote en passant l'ini en argument direct** (`terminal.exe fichier.ini`),
  PAS avec `/config:` qui est la convention MT5. Perdu une heure la-dessus le 28/08.

**2. Le compte réel PU Prime calibre le modèle, et il est plus sévère que lui.**
Relevé 04 → 25/08/2026, XAUUSD.sc, dépôt 42 443 USC (contrat 1 once, compte en cents — la valeur
affichée vaut donc 100 × la variation de prix × lots).

- rendement **+25,8 % en 21 jours = 36,8 %/mois**, profit factor **1,31** (mon modèle disait 57 %/mois : je surestime d'environ 1,5)
- **swaps −153 sur 10 944 de profit = 1,4 %** : négligeables, la question est close
- échelle confirmée rang par rang jusqu'au **rang 25** (5,43 lots)
- le « drawdown maximal » du relevé se calcule sur le **solde** : −5 778 (−10,5 %). L'excursion
  **flottante** réelle du 19/08 était de **−9 942, soit −23,4 %** — plus du double.
- l'or est monté de 38,8 points en sept minutes ce jour-là ; **43,6 points prenaient la moitié du compte**

**3. Ce qui marche et ce qui est écarté.** Plafond de rang à 20 : gratuit (−0,2 % de gain) et il
réduit le pire panier de 21 %. **Recyclage écarté** dans ses trois formes — abaisser le seuil de 0 à −5
n'a converti que 3 refus sur 12 145 : il n'existe aucune jambe gagnante quand l'échelle est enfoncée.

**3 bis. LE PLAFOND A UNE FALAISE, ET DEUX GRANDEURS PORTENT LE MEME NOM.**

Balayage complet de `InpMaxNiveaux` (fenetre 7 semaines) :

| plafond | paniers | PF | positions max/panier | pire panier REALISE |
|---|---|---|---|---|
| aucun | 2 802 | 1,48 | 25 | −17 |
| 12 | 2 325 | 1,16 | **398** | **−14 286** |
| 15 | 2 491 | 1,09 | **364** | **−17 383** |
| 18 | 2 788 | 1,55 | 27 | −17 |
| 21 à 30 | 2 802 | ~1,48 | 25 | −17 (inerte) |

- **A 12 et 15, le panier ne peut plus atteindre +5 et ne se ferme jamais** : 398 jambes sur un
  seul panier. **Un plafond a 5 ou 6 serait bien pire.** Il l'a demande le 28/08 : jamais decide,
  et a ne pas faire.
- **Falaise brutale entre 15 et 18** (PF 1,09 → 1,55). Le plafond a 20 est au-dessus avec cinq
  crans de marge, mais la falaise n'a ete localisee que sur 7 semaines : **la re-mesurer sur 22 ans
  avant toute mise en production.**
- **Piege de vocabulaire a ne plus refaire** : « pire panier » designe ici le resultat REALISE
  (−17) ; les −12 432 du 27/08 sont la pire EXCURSION FLOTTANTE reconstruite sur les prix M1.
  Deux grandeurs differentes — ne pas les comparer.

**4. À FAIRE — plan convenu le 27/08 au soir, dans cet ordre.**

- **Trancher la question de plateforme par la mesure, pas par l'avis.** Le testeur MT4 reproduit son
  compte réel à 8 % près (264 positions/jour en réel, 285 au testeur), tandis que le clone MT5 en
  produit 437. Ce qui n'est **pas** mesuré : le rythme de MT5 **en live**. Protocole : poser le clone
  sur un démo MT5 chez PU Prime, laisser tourner 24 h, compter les positions. 264 → MT5 vaut MT4,
  question close. 437 → il a raison, il faut réécrire en MQL4.
  Indice contraire à garder en tête : avec les **vrais ticks** (Model=4) le clone posait 24,9 ordres
  par barre contre 19,6 en ticks générés — le flux réel est plus dense, pas moins.
- **Refaire l'étude longue en `Model=1`.** Celle de 22 ans a tourné en Model=0 : toutes les fréquences
  de ruine annoncées surestiment.
- **Ne jamais supposer que « plus rapide » = « plus dangereux ».** Ce n'est pas établi. Plus de paniers,
  c'est plus de profit ET plus d'occasions de s'enfoncer ; l'étude de 22 ans confondait les deux.
- **Jours fériés : testable** (dates connues). **Filtre de news : non testable** dans le testeur, faute
  de calendrier — ne pas l'ajouter à l'aveugle.
- **Diversification avec gestion commune : possible sur le clone MQL5, pas sur l'original.** Il ne peut
  pas modifier le `.ex4` ; sur MT4 il ne resterait qu'un superviseur externe, qui peut couper mais pas
  retenir — l'original rouvre derrière lui.

**5. DECISION du 27/08 au soir : on porte le clone en MQL4. Ses raisons, qui n'ont RIEN a voir
avec la cadence — j'avais passe une heure a repondre a la mauvaise question.**

- **Continuite** : si l'essai expire ou si le vendeur disparait, un clone MQL5 ne remplace rien.
  Un clone MQL4 se substitue a l'original sur place, meme compte, meme montage.
- **Protections** : le `.ex4` est intouchable. Plafond de rang, jours feries, superviseur — rien de
  ce qu'on valide n'est applicable a l'original. En MQL4 c'est son code, donc applicable.
- **Benefice supplementaire (a lui rappeler)** : en MQL4 le clone et l'original tournent dans le MEME
  testeur, sur le MEME generateur de ticks. Tous les facteurs de correction (2,5 · 3,1 · 1,23)
  deviennent inutiles : comparaison directe, jambe par jambe.

**Repartition arretee : MT5 = instrument de mesure (testeur rapide, vrais ticks, etudes longues).
MT4 = plateforme de production.**

**Critere d'acceptation du portage, dur :** reproduire les **9 984 ouvertures** et les **1 124 paniers**
de l'original sur la fenetre de reference 23/04 -> 10/06/2026. Pas « a peu pres ».

**Avertissement technique :** les 963 lignes du clone reposent sur l'API positions de MQL5. MQL4 ne
connait que des ordres (`OrderSend` / `OrderSelect` / `OrderProfit`, pas de CTrade). La logique de
panier est a REECRIRE, pas a transposer. Compter une journee.

**Contrainte de methode acceptee le 27/08 :** aucun chiffre dans mon texte qui n'apparaisse pas dans
une sortie d'outil affichee juste au-dessus. S'il manque, il le rejette a vue.

**6. JOURNEE DU 28/08 — le clone MQL4 existe, et six hypotheses sont mortes.**

**L'acquis :** `GoldingClone4.mq4` compile et tourne. Fenetre de reference en 80 s ; l'original fait
deux jours en 7 min 30 (les 57 h etaient pour 7 semaines sur machine chargee). **On dispose enfin de
deux traces appariees** : meme testeur, meme FXT, meme symbole, meme depot.

**Mecanique du testeur MT4, a ne pas reperdre :**
- lancer avec `terminal.exe "cheminichier.ini"` — **PAS** `/config:` qui est MT5 (1 h perdue).
- MT4 ecrit ses parametres dans `tester/<Expert>.ini`, en **ANSI**, avec une section `<common>` et
  des lignes `Cle=`, `Cle,F=`, `Cle,1=`... Il **ignore** un `TestExpertParameters` a un autre nom.
  Editer SON fichier, dans SON format.
- **Le depot est dans `<common>` de ce fichier** : l'original a tourne a **10 000**. A 3 000, la marge
  bride le clone et fausse tout (10 193 ouvertures au lieu de 13 084). Toujours le fixer.
- Toujours verifier les entrees dans la ligne `GoldingClone4 inputs:` du journal avant de conclure.

**Six hypotheses REFUTEES sur donnees appariees** (ne pas les reproposer) :
densite de ticks · seuil `MinProfit` de la porte 3 · ordre des portes 1 et 2 · delai de rearmement
(les deux rearment en 0 s) · pas du cliquet `StepTrall` (4/5/6 : 118/115/112 paniers) ·
exigence des deux sens pour denouer (verifie applique, resultat identique).

**Etat sur la fenetre appariee 05 -> 07 mai 2026 :**

| | ORIGINAL | CLONE | rapport |
|---|---|---|---|
| ouvertures | 507 | 763 | 1,50 |
| paniers | 57 | 112 | 1,90 |
| sorties porte 2 | 19 | 18 | **identique** |
| jambes/panier | 8,7 | 6,8 | |

L'excedent est **entierement** dans les paniers de 3 a 6 jambes : 23 chez lui, 68 chez moi.
Le seuil +5 est reconfirme (min 5,00, aucun en dessous) et les deux distributions de fermeture ont
la meme forme.

**LA PISTE VIVE, mesuree le 28/08 :** l'espacement entre deux remplissages consecutifs du meme sens.

| | q1 | mediane | q3 |
|---|---|---|---|
| ORIGINAL | 1,38 | **2,32** | 3,60 |
| CLONE | 1,64 | **1,94** | 2,36 |

Ses jambes sont 20 % plus espacees et **beaucoup plus dispersees**. Ses paniers couvrent 20,2 points
contre 13,2. **Attention** : c'est la distance entre REMPLISSAGES, pas les NIVEAUX POSES (que la spec
a mesures a 0,80) — le cliquet separe les deux. Prochaine mesure : comparer les niveaux **poses**
poste a poste sur la fenetre appariee.

**7. DEUX REGLES DE L'ORIGINAL DECOUVERTES LE 28/08, sur donnees appariees. Elles sont
maintenant le comportement PAR DEFAUT de `GoldingClone4.mq4`.**

**a) REANCRAGE APRES DENOUEMENT PARTIEL.** Sur ses 405 poses de grille : apres un remplissage,
337 suivent la grille et 2 non (0,6 %). Mais **apres un STOP touche : 45 sur 45 partent du
MARCHE. Apres un sens solde par la porte 2 : 19 sur 19.** Cent pour cent, les deux fois.
Quand des positions disparaissent, la reference du dernier remplissage n'a plus de sens.
`InpReancrerApresDenouement = true`.
**Piege d'implementation** : la pose reancree est a FirstStep (0,50) du marche, or le controle
`MinDistance` (0,80) la rejette systematiquement. Il faut l'exempter, sinon le clone se bloque
(27 remplissages au lieu de 763).

**b) ~~LA PORTE 3 SE CALCULE CONTRE LA JAMBE LA PLUS PROFONDE~~ — CONCLUSION FAUSSE,
CORRIGEE LE 28/08. Voir section 20.** Je l'avais tranchee sur le seul nombre de NIVEAUX DE
STOP DISTINCTS (moyenne ponderee 16, jambe la plus profonde 33, premiere jambe 10, original
33). Ce critere ne dit rien de la JUSTESSE des niveaux. `InpRefStop = 0`.

**Etat de fidelite apres ces deux corrections** (fenetre appariee 05-07 mai) :

| | ORIGINAL | CLONE corrige |
|---|---|---|
| ouvertures | 507 | 877 |
| paniers | 57 | 132 |
| jambes/panier | 8,7 | 6,6 |
| niveaux de stop | 33 | **33** |
| poses reancrees | 16,3 % | 20,5 % |

**Les deux signatures de REGLE collent maintenant. L'ecart de CADENCE, lui, resiste a tout** —
sept hypotheses refutees dans la journee. Le clone ouvre toujours 1,7 fois trop.

## 8. Consultation de Gemini, 28/08 — cinq refutations et une vraie trouvaille

Brief envoye avec les onze hypotheses deja refutees. Dix pistes rendues. Testees sur les
journaux apparies, boucle de 80 s :

- **refutees** : ordres au marche (0 sur 507), repose du cote oppose (le clone le fait
  PLUS : 58,4 % contre 49,5 %), asymetrie Bid/Mid (ecart 1,32 des deux cotes, donc
  Ask+0,50 / Bid-0,50 confirme, le modele mid donnerait 1,00), fermetures partielles
  (0 des deux cotes).
- **trouvaille** : la distance de pose du cote MINORITAIRE quand l'autre a 3-4 jambes.
  Original q1 = mediane = q3 = 0,80, 12 % hors grille. Clone : mediane -1,25, 59 % hors
  grille. C'est ce qui a mene au bug ci-dessous.

## 9. Le bug du drapeau global — corrige v4.14, commit 7ca7c6d

`g_denoue` etait une variable unique, pas un tableau par sens. Un denouement du cote
vente faisait donc reancrer le cote ACHAT sur le marche, alors qu'il n'avait rien subi.
Et le sens reellement denoue etait deja couvert par la branche `nSens == 0`. La regle 1
n'ajoutait donc que du bruit sur le sens indemne.

Effet, meme fenetre, memes ticks (original entre parentheses) :

| | avant | apres | original |
|---|---|---|---|
| remplissages | 664 | **625** | 507 |
| paniers | 103 | **90** | 57 |
| jambes/panier | 6,4 | **6,9** | 8,7 |
| survie k=4 | 75 % | **80 %** | 87 % |
| survie k=7 | 71 % | **78 %** | 85 % |
| survie k=8 | 58 % | **60 %** | 79 % |

**Premier gain sur la cadence apres une journee de refutations.** L'ecart n'est pas
comble, mais il recule pour la premiere fois, et par un vrai defaut de mon code — pas
par un reglage.

Restent ouvertes : resserrement conditionnel de la grille gagnante, ancrage sur sommet
glissant, jambe de realignement, vitesse des ticks.

## 10. Le pas du cliquet vaut 0,0625 — commit 7dc298f

Le cliquet est strictement monotone des deux cotes (0 recul sur 12 473 deplacements) :
la piste du sommet glissant par RECUL est refutee. Mais son PAS n'est pas constant —
0,06 dans 74,5 %, 0,07 dans 23,0 %, 0,08 dans 2,4 %, rien au-dela.

**Modele du collage au marche : refute.** Balayage de la distance de collage :
D=50 → 934 remplissages et 48 % de pas au-dela de 0,08 ; D=130 → 715 ; D=250 → 646 et
96 % a 0,06. Aucune distance ne passe par 74,5/23,0, et toutes degradent les paniers.

**Modele du pas reel de 0,0625 : confirme.** Sur 16 pas, 12 tombent a 0,06 et 4 a 0,07,
soit 75/25. Mesure sur le clone : 75,0 / 25,0. **Condition indispensable** : garder la
cible NON ARRONDIE dans une variable. Relire `OrderOpenPrice()` reintroduit l'arrondi a
chaque tour et redonne 0,06 partout — c'etait mon erreur.

**Contrepartie assumee, et c'est le fait interessant** : la regle est confirmee mais
l'agregat recule (99 paniers contre 90, survie k=4 74 % contre 80 %). Il cliquette 4 %
plus vite que moi et remplit pourtant MOINS. Une autre regle compense chez lui — ses
ordres sont poses plus loin, ou plus retenus. Mes deux erreurs se compensaient en partie.

Restent inexpliques : ses 2,4 % de pas a 0,08, et toujours la cadence.

**Lecon de methode** : une signature de forme (la distribution d'un pas) identifie une
regle bien plus surement qu'un agregat. C'est l'arithmetique 12/16 vs 4/16 qui a donne
0,0625, pas un balayage.

## 11. Le referentiel de prix : le .fxt, pas la M1

La M1 locale ne remonte qu'au 10/06/2026, ecrasee par les telechargements. Mais le
`.fxt` du testeur contient les ticks rejoues : en-tete 728 octets, enregistrements de
56 (`<qddddqii` : bar, OHLC, volume, **ctm = heure du tick**, flag). Verification :
50 349 824 - 728 = 899 091 x 56, exactement les « 899 091 bar states » du journal.
**C'est la source de verite pour tout ce qui demande un prix de marche.**

## 12. Ce qui est ELIMINE comme cause de la cadence

Mesure au tick exact, identique pour les deux robots :

| | ORIGINAL | CLONE |
|---|---|---|
| distance de pose (q1 / med / q3) | 0,50 / 0,80 / 0,84 | 0,50 / 0,81 / 0,84 |
| deplacements de cliquet par ordre | 23,9 | 23,9 |
| delai remplissage → pose (mediane) | 230 s | 197 s |
| taux de remplissage des poses | 97,3 % | 99,1 % |

**Distance, effort, delai : identiques.** Et surtout : je pose 23 % de plus mais je ferme
74 % de paniers en plus. L'ecart de paniers est le triple de celui des poses — donc le
probleme n'est PAS que je remplisse trop, c'est que **mes paniers se ferment trop tot**.

Le verrou du sens gagnant (`InpJambesGagnant`) est **redondant** : balaye a 1/2/3, resultat
identique au chiffre pres. Raison comprise : quand il est atteint, le sens gagnant a son
niveau de grille 0,80 DERRIERE le marche, donc la marge le refuse de toute facon. Ce
n'est pas le verrou qui interdit la 2e jambe gagnante, c'est la geometrie.

## 13. LE MECANISME MANQUANT — la jambe de realignement (piste 8 de Gemini)

Pour construire la 2e jambe du cote gagnant il faut la REANCRER SUR LE MARCHE. La branche
existait dans mon code (`InpSuivreGagnant`) et etait desactivee depuis le debut.

| | rempl | paniers | jambes | expo nette | >=2 faibles | survie k=4 |
|---|---|---|---|---|---|---|
| ORIGINAL | 507 | 57 | 8,7 | 40 % | 60 % | 87 % |
| v4.16 | 636 | 99 | 6,4 | 55 % | 38 % | 74 % |
| **suivi MG=2** | 878 | 110 | **7,9** | **36 %** | 100 % | 100 % |
| suivi MG=3 | 1109 | 107 | 10,3 | 47 % | 9 % | 73 % |
| suivi MG=99 | 3519 | 64 | 53,4 | 0 % | - | 100 % |

**Toutes les metriques structurelles bougent ensemble vers l'original.** Mecanisme
confirme. Mais le dosage est faux : a MG=2 il se declenche 100 % du temps contre 60 %
chez l'original, et les remplissages empirent (878 contre 507). **Pas mis par defaut.**

Prochaine cible : la CONDITION de declenchement. Gemini annoncait la distance a la jambe
la plus profonde du cote oppose. Et la distance de pose de cette branche est codee en dur
a `InpMinDistance + 1` = 0,81, valeur arbitraire jamais mesuree.

## 14. PIEGE DE PARSEUR — les stops ne sont pas des « close »

MT4 journalise une sortie sur stop `Tester: stop loss #N at PRIX`, **pas** `close #N`.
Sur l'original : 419 `close` + 88 `stop loss` = 507 ouvertures. En les ignorant, le suivi
des positions derive completement (97 positions simultanees suivies au lieu de 20) et
toutes les distances calculees deviennent absurdes. **Ce piege a invalide ma premiere
caracterisation des poses** (les 12,6 % / 23,6 % « hors grille sans fermeture »).

## 15. La piste 8 corrigee : l'original ne reancre PAS un sens ouvert

Avec le bon parseur, poses sur un sens **deja ouvert** :

| | sur grille | realignees | dont sens gagnant |
|---|---|---|---|
| ORIGINAL | 335 | **4** | **0 %** |
| CLONE v4.16 | 344 | 47 | 36 % |

**Il ne realigne jamais un sens gagnant.** Il construit sa jambe faible par la grille
normale, pendant que ce sens PERD. Mes poses de grille sont appariees aux siennes
(335 / 344) — l'excedent est ailleurs.

Couper le reancrage entierement (v4.18) est PIRE : 114 paniers, 5,5 jambes, survie k=4
66 %. Il aide meme mal dose. **v4.16 reste la reference.**

Egalement apparies et donc elimines : taux de sortie sur stop (16,4 % contre 18,6 %),
distances de pose, pas du cliquet, effort par ordre, delai.

## 16. LA CONTRAINTE DURE : il ne solde JAMAIS un panier sous +5,00

Profit reel par panier, calcule prix par prix depuis le journal :

| | paniers | q1 | mediane | q3 | min | max |
|---|---|---|---|---|---|---|
| ORIGINAL | 58 | 5,46 | **9,24** | 35,08 | **5,00** | 79,03 |
| CLONE v4.16 | 100 | 5,01 | 5,09 | 10,35 | **-219,01** | 106,17 |

| repartition | < 0 | 0 a 5 | 5 a 6 | 6 a 10 | >= 10 |
|---|---|---|---|---|---|
| ORIGINAL | **0** | **0** | 19 | 11 | 28 |
| CLONE | 8 | 6 | 42 | 19 | 25 |

**Zero panier negatif sur 58, malgre 83 sorties sur stop.** Mon clone en solde 14 sous le
seuil dont 8 en perte, jusqu'a -219. Et sa mediane est a 9,24 contre 5,09 : il laisse
courir, je ferme des le franchissement (42 de mes paniers dans la tranche 5-6 contre 19).

**Portee** : ceci concerne le portage MQL4 uniquement. Le clone MQL5, avec lequel tournent
les etudes longues, calcule deja la moyenne ponderee. Voir section 20.

## 17. La porte de sortie : ce qu'elle N'EST PAS

Flottant MAXIMAL atteint avant fermeture, reconstruit tick par tick depuis le .fxt :

| | q1 | mediane | q3 | 5-6 | 6-10 | 10-30 | >=30 |
|---|---|---|---|---|---|---|---|
| ORIGINAL | 16,38 | 27,97 | 61,91 | 4 | 2 | 27 | 26 |
| CLONE v4.16 | 7,12 | 16,74 | 28,76 | 20 | 11 | 47 | 23 |

Les deux laissent le flottant monter bien au-dela de +5 sans fermer : **le seuil de +5
n'est PAS ce qui ferme la plupart des paniers**. Les paniers profonds sont comparables
(53 chez lui, 70 chez moi) ; **tout mon excedent est dans les paniers qui meurent tot** —
31 dont le flottant n'a jamais depasse 10, contre 6 chez lui.

**Le seuil ne depend ni des jambes ni du volume.** Profit median / volume median par
tranche, original : 189 (3-4 jambes), 79 (5-6), 84 (7-9), 181 (10+). Non monotone.

Taille a la fermeture : l'original s'etale de 3 a 21 jambes presque uniformement ; moi je
me concentre sur 4-6 (60 paniers sur 100), mode **1+3** (21 fois).

## 18. L'INVARIANT — le cote fort est reproduit exactement

Remplissages par statut du cote :

| | cote FAIBLE | egalite | cote FORT |
|---|---|---|---|
| ORIGINAL | 162 | 152 | **193** |
| CLONE v4.16 | 211 | 237 | **188** |

**193 contre 188 : le cote qui tend est reproduit au chiffre pres.** Mon excedent de 129
se decompose en +85 sur l'egalite et +49 sur le faible — et +85 correspond exactement aux
42 paniers supplementaires qui redemarrent (~2 remplissages en egalite chacun).

Autrement dit : **tout est apparie sauf le nombre de fermetures**, et l'excedent de
remplissages est une CONSEQUENCE des fermetures, pas leur cause.

## 19. Mesure abandonnee (a ne pas refaire telle quelle)

Compter les sorties directionnelles en detectant « un sens passe a zero » est FAUX :
pendant un CloseAll les positions se ferment une par une, un cote atteint zero avant
l'autre et le transitoire est compte comme une sortie directionnelle. Il faut grouper les
fermetures par horodatage avant de classer.

## 20. CORRECTION MAJEURE — la porte 3 se calcule bien sur la MOYENNE PONDEREE

**Origine du diagnostic** : chaque panier perdant du clone l'est a cause de ses stops, et la
part des stops y est plus negative que le total. Sans eux, tous seraient positifs.

**Le raisonnement qui tranche.** `moyenne` est ponderee par les volumes, donc pour un sens
`somme vi (niveau - pi) = (somme vi)(niveau - moyenne)`. Un stop arme sur la moyenne **ne
peut pas** solder un sens en perte. `InpRefStop = 1` remplace cette reference par la jambe la
plus profonde — la MEILLEURE du sens — ce qui rend l'armement bien plus permissif et autorise
la perte.

| | paniers | negatifs | sous +5 | min | mediane | **TOTAL** | niveaux stop |
|---|---|---|---|---|---|---|---|
| ORIGINAL | 58 | **0** | 0 | 5,00 | 9,24 | **1139,09** | 33 |
| RefStop=1 | 100 | 8 | 14 | -219,01 | 5,09 | 475,30 | 29 |
| **RefStop=0** | 110 | **0** | 6 | 0,62 | 5,23 | **1124,68** | 18 |

**La moyenne ponderee reproduit le profit total a 1,3 % pres et retablit l'invariant zero
panier negatif.** Avec RefStop=1 le clone gagnait **58 % de moins que l'original**.

**Lecon de methode, la vraie de la journee** : j'avais apparie un COMPTE (33 niveaux
distincts) et casse un INVARIANT (aucun sens solde en perte). Un critere de forme ne vaut que
si rien de plus fort ne le contredit. Ici l'algebre donnait la reponse sans aucun test — je ne
l'avais pas faite.

**Portee du defaut — CORRECTION IMMEDIATE.** J'ai d'abord ecrit que l'etude de ruine sur
22 ans etait biaisee par lui. **C'est FAUX.** Ce defaut n'existe que dans le portage MQL4
ecrit le 28/08. Le clone **MQL5** calcule `moyBuy = pvBuy / vBuy` — pondere par les volumes —
et n'a jamais eu d'option `RefStop`. L'etude, faite en MT5, n'est pas concernee.

**Verifier la LIGNEE avant d'annoncer une consequence.** Les deux clones ont diverge : ce qui
est vrai de l'un ne l'est pas de l'autre. Etat au 28/08 :

| correction du 28/08 | MQL4 | MQL5 |
|---|---|---|
| drapeau de denouement par sens | corrige | **la regle 1 n'existe pas du tout** |
| porte 3 sur moyenne ponderee | corrige (etait faux) | deja correct |
| pas du cliquet a 0,0625 | corrige | **corrige le 28/08, v5.07** |

Reste donc un ecart reel en MQL5 : **la regle 1 est absente**. Or la couper en MQL4 degrade
(114 paniers contre 99, jambes 5,5 contre 6,4). A porter.

## 21. LA FREQUENCE DE RUINE, ENFIN MESUREE — 28/08

**Le compteur de morts n'avait JAMAIS ete arme.** `InpMaxFlottantPct = 0.0` signifie
« jamais » (ligne 75 du .mq5, garde `if(InpMaxFlottantPct > 0.0 && ...)`). Les trois inis
des campagnes longues — `ruine22.ini`, `ruine22_m1.ini`, `crise2008.ini` — l'avaient toutes
a 0,0. Aucune n'a donc jamais mesure une ruine ; elles ont mesure des flottants.

Relance avec `InpMaxFlottantPct = 50` et `InpCapitalNotionnel = 10 000`, clone v5.07,
XAUUSD_22, Model=1, 2004.06.12 -> 2026.06.10, 26 350 661 ticks :

| | detection desarmee | **detection armee** |
|---|---|---|
| MORTS | 0 (impossible) | **88, soit 3,99 par an** |
| survie moyenne | 1146,7 sem. (= toute la periode) | **12,0 semaines** |
| cout moyen d'une mort | - | **5 523,75** |
| pire flottant porte | -416 472 | -17 796 |
| gain cumule | 2 607 403 | 3 339 152 |
| positions max / panier | 38 | 27 |
| rang maximal | 32 | 21 |

**LE CHIFFRE : sur un compte de 10 000, cet EA perd la moitie du capital environ quatre
fois par an, et survit 12 semaines en moyenne.** Le cout depasse le seuil (5 524 pour un
seuil a 5 000) : le flottant traverse le seuil sans s'y arreter.

**Caveats a garder attaches au chiffre** — il ne vaut que borne :
- mesure avec le CLONE, pas l'original. Le clone MQL5 n'a toujours pas la regle 1.
- le backtest tourne **sans surveillance** : ni filtre de news, ni coupure manuelle, alors
  que les comptes reels sont proteges a la main. C'est donc un MAJORANT du risque reel.
- InpCapitalNotionnel etait a 10 000 : la frequence depend directement de ce montant.

## 22. COURBE RUINE / CAPITAL — 28/08, clone v5.07, 22 ans, Model=1

Seuil de mort a 50 % du capital notionnel, quatre points :

| capital | morts / 22 ans | par an | survie moyenne | cout moyen | cout / capital |
|---|---|---|---|---|---|
| 10 000 | 88 | **3,99** | 12,0 sem. | 5 524 | 55 % |
| 25 000 | 40 | 1,81 | 26,6 sem. | 14 894 | 60 % |
| 50 000 | 21 | 0,95 | 51,9 sem. | 27 181 | 54 % |
| 100 000 | 8 | **0,36** | 96,1 sem. | 52 076 | 52 % |

**Trois regularites mesurees :**

1. **La survie est proportionnelle au capital** — 12 / 27 / 52 / 96 semaines pour 1x / 2,5x /
   5x / 10x. Doubler la mise double le temps de survie, ni plus ni moins. **Aucun palier
   protecteur, aucun effet de seuil.**
2. **Le cout d'une mort depasse toujours le seuil de 52 a 60 %** pour un seuil a 50 % :
   le flottant le traverse sans s'arreter, et l'excedent ne depend pas de la taille du compte.
3. **Esperance annuelle de perte par ruine** (frequence x cout, calcul derive) :
   22 041 / 26 958 / 25 822 / 18 747 par an — soit **220 % / 108 % / 52 % / 19 %** du capital.
   **En valeur absolue elle est quasi invariante.** La machine detruit une quantite a peu pres
   fixe de capital par an ; augmenter la mise ne reduit pas la destruction, elle la DILUE.

**Consequence a confronter au montage en poches** : compartimenter en trois sous-comptes de
10 000 ne divise pas le risque par trois — ca multiplie par trois un cout annuel qui ne
depend pas de la taille. A poser comme mesure, PAS comme verdict : il manque le gain annuel
par configuration, non extrait. **A faire avant toute decision de montage.**

Voir [[feuille-de-route-clone]], qui prevoit trois sous-comptes compartimentes.

## 23. POURQUOI L'INVARIANCE TIENT, ET POURQUOI LE GAIN NE TIENT PAS

**L'invariance du cout annuel de ruine est une consequence, pas une coincidence.**

| capital | morts | morts x capital | cout/mort | cout / capital |
|---|---|---|---|---|
| 10 000 | 88 | 880 000 | 5 524 | 55 % |
| 25 000 | 40 | 1 000 000 | 14 894 | 60 % |
| 50 000 | 21 | 1 050 000 | 27 181 | 54 % |
| 100 000 | 8 | 800 000 | 52 076 | 52 % |

`morts x capital` est constant a **±13 %** : la frequence varie en 1/capital. Le cout d'une
mort varie proportionnellement au capital (52-60 %). Le produit — le cout annuel — est donc
NECESSAIREMENT invariant : **18 700 a 27 000 par an quelle que soit la taille**.
L'EA detruit une quantite fixe de capital par unite de temps ; le dimensionner plus gros
allonge le delai, ne reduit pas la destruction.

**Implication arithmetique pour les trois poches** : trois compartiments de 10 000 portent
chacun leur cout, soit ~66 000/an, contre ~22 000/an pour un compte unique de 30 000.
**La compartimentation TRIPLE le cout de ruine.** Mecanique, puisque le cout ne depend pas
de la taille.

**MAIS — conclusion IMPOSSIBLE en l'etat.** Il faut le rapport gain / cout, or les gains ne
sont pas exploitables :

| capital | 10 000 | 25 000 | 50 000 | 100 000 |
|---|---|---|---|---|
| gain / semaine | 2 912 | 723 | 748 | 2 217 |

Non monotone, extremes hauts et milieu bas. **Verifie** : le testeur est deterministe (le
point a 10 000 rejoue redonne 3 339 152,19 au centime), les inis sont corrects, et
`InpCapitalNotionnel` n'agit QUE sur le seuil de mort (`InpDelaiRenflouementH` = 24 h, soit
88 jours sur 8 000, negligeable).

**Donc les ecarts sont reels — et c'est ce qui les rend inutilisables.** Chaque mort coupe un
panier a un instant donne et decale toute la suite. Sur une grille c'est chaotique : avec
8 a 88 evenements de coupure, le gain d'un PARCOURS UNIQUE est domine par QUELS episodes ont
ete tranches, pas par le capital. Les morts, elles, se comptent par dizaines et s'alignent en
1/capital : robustes. Le gain : bruit de trajectoire.

**GARDE-FOU, valable au-dela de cette question** : ne jamais comparer deux configurations sur
les TOTAUX d'un parcours unique quand le parametre compare modifie la trajectoire. Mesurer
sur des FENETRES INDEPENDANTES — tranches glissantes de 2 ans, une vingtaine — et comparer
les DISTRIBUTIONS. **A faire avant toute decision de montage.**

## 24. FENETRES INDEPENDANTES, 44 passages — ***GAINS INVALIDES, VOIR SECTION 26***

11 fenetres de 2 ans NON chevauchantes sur 2004-2026, x 4 capitaux. Chaque fenetre est un
test separe, donc un depart a neuf : c'est ce qui casse la dependance de trajectoire.
Resultats bruts dans `scratchpad/fenetres.csv`.

**a) Les totaux du parcours unique etaient bien du BRUIT — confirme.** Trois fenetres
aberrantes portent presque tout : F04 (10 000 → 1 100 205 contre 49 293 ailleurs),
F06 (100 000 → 1 685 833 contre ~29 000), F11 (10 000 → 1 847 465 contre ~380 000).

**b) Mon critere pre-enregistre a ECHOUE, et il etait mauvais.** J'avais annonce « premier
7 fois sur 11 » ; 100 000 sort premier 6 fois. Le test des premieres places ne gere ni les
ex aequo (F01, F03) ni les aberrantes. Test apparie post hoc, bien meilleur :

| | superieur | inferieur | ex aequo |
|---|---|---|---|
| 100 000 vs 25 000 | 8 | **0** | 3 |
| 100 000 vs 50 000 | 7 | **0** | 4 |
| 100 000 vs 10 000 | 8 | 2 | 1 |
| 50 000 vs 10 000 | 8 | 2 | 1 |

Jamais de majorite inverse. **Le capital a donc un effet REEL sur le gain** — mais faible :
gain median par fenetre 46 116 / 47 199 / 48 689 / 54 372. **x10 de capital = +18 % de
gain seulement**, car le lot de base est fixe a 0,01.

**c) CONCLUSION IMPOSSIBLE sur le montage — l'estimateur change le SIGNE :**

| capital | net %/an, morts MEDIANES | net %/an, morts MOYENNES |
|---|---|---|
| 10 000 | +69,7 % | +16,1 % |
| 25 000 | +36,5 % | **-10,8 %** |
| 50 000 | +21,9 % | **-2,4 %** |
| 100 000 | +27,2 % | +8,2 % |

Cause : distribution des morts tres asymetrique, ex. 10 000 = [0,2,3,3,3,6,7,7,10,11,**36**].
**11 fenetres ne suffisent pas.** Il en faut plus (tranches d'un an → 22) avant tout verdict.

**d) LE FAIT LE PLUS ACTIONNABLE — le regime actuel est le pire mesure.**
Le 36 est **F11 = 2024-2026**, la periode en cours. Sur 10 000, la ruine y survient
**36 fois en 2 ans, soit une fois toutes les 3 semaines**, contre 4 fois par an en moyenne
sur 22 ans — **9 fois pire que la moyenne historique**. C'est le regime dans lequel le
compte reel tourne, a peu pres a cette taille. Morts en F11 par capital : 36 / 13 / 5 / 3.

Voir [[goldinghedge-exploitation]] et [[feuille-de-route-clone]].

## 25. 22 FENETRES D'UN AN — ***GAINS INVALIDES, VOIR SECTION 26***

Donnees : `Experts/GoldingClone/mesures/fenetres_1an.csv`.

**a) LE GAIN N'EST PAS ESTIMABLE EN MOYENNE.** Distribution du gain annuel a 10 000 :
`0 2 3 5 6 8 9 11 11 13 14 16 22 24 27 31 36 73 77 83 1092 1775` (en milliers).
**La meilleure annee fait 53 % du total de 22 ans, les deux meilleures 86 %.** A 100 000 :
66 % pour une seule annee. Mon estimateur principal pre-enregistre (la moyenne) est donc
**INAPPLICABLE** — je ne l'ai pas remplace en douce, j'ai change de quantite mesuree.

**b) Les medianes sont quasi identiques : 15 856 / 15 857 / 16 101 / 23 699.**
Dans une annee ordinaire le capital ne change presque rien au gain (lot de base fixe).

**c) LE RESULTAT CENTRAL — gain MEDIAN (robuste) contre cout de ruine MOYEN (88 evenements,
bien estime) :**

| capital | gain median | morts/an | cout ruine | NET | %/an |
|---|---|---|---|---|---|
| 10 000 | 15 856 | 4,00 | 21 394 | **-5 538** | **-55,4 %** |
| 25 000 | 15 857 | 1,82 | 26 013 | **-10 156** | **-40,6 %** |
| 50 000 | 16 101 | 0,95 | 26 713 | **-10 612** | **-21,2 %** |
| 100 000 | 23 699 | 0,36 | 18 978 | +4 721 | +4,7 % |

**DANS UNE ANNEE ORDINAIRE, LA MACHINE DETRUIT DU CAPITAL A TOUTES LES TAILLES SAUF
100 000.** Elle n'est rentable sur 22 ans que grace a une ou deux annees exceptionnelles.

**d) Les annees exceptionnelles sont les plus MEURTRIERES.** A 10 000 la meilleure est
**F22 = 2025-2026 : 1 775k de gain AVEC 25 morts**. Trois dernieres annees : 7, 11, 25 morts.
Forte volatilite = beaucoup de cycles = beaucoup de gain brut ET beaucoup de ruines. Les
deux vont ensemble, ce ne sont pas deux regimes distincts.

**e) Test apparie pre-enregistre (>=15/22 sans majorite inverse)** : effet du capital sur le
gain RETENU pour 50 000 (15-3) et 100 000 (16-2) contre 10 000. Non retenu au-dela —
100 000 contre 50 000 : 8-2 avec 12 ex aequo.

**f) A VERIFIER AVANT DE S'EN SERVIR** : le 1 775k de F22 a 10 000 est invraisemblable pour
un lot de base a 0,01 — 177 fois le capital en un an. La conclusion (c) n'en depend pas
(elle repose sur la mediane), mais **toute affirmation de rentabilite globale en depend**.

## 26. LE BUG QUI INVALIDE TOUS LES GAINS DU 28/08 — corrige en v5.08

`g_gainCumule += flot` s'executait **sans verifier que `ToutFermer()` avait reussi**. Quand
la fermeture echoue, les positions restent et le tick suivant RECOMPTE le meme flottant.

Pris sur le fait, journal instrumente, fenetre 2025-2026 a 10 000 :

```
2026.02.11 00:39:59  gain 14916  1 achat -34  18 ventes +14950
2026.02.11 00:40:00  gain 14916  1 achat -34  18 ventes +14950
2026.02.11 00:40:20  gain 14916  1 achat -34  18 ventes +14950
```

Valeurs identiques au centime a 20 s d'intervalle. **131 « paniers » de plus de 1 000 le
seul 11/02/2026, totalisant 1 525 886 — 86 % du gain annuel annonce.**

| meme fenetre | avant | apres |
|---|---|---|
| paniers fermes | 7 870 | 4 835 |
| gain cumule | 1 774 726 | **87 291** |
| fermetures ratees | n/c | 4 905 |
| morts | 25 | **25** |

**CE QUI TOMBE** : tous les gains du 28/08 — campagnes 22 ans, sections 22, 24 et 25 de
cette note, et la conclusion « dans une annee ordinaire la machine detruit du capital »,
fondee sur des medianes elles aussi contaminees.

**CE QUI TIENT** : les morts, inchangees. Le compteur de ruine est protege par la pause de
24 h qui suit chaque mort, donc il ne peut pas boucler. Frequence de ruine, courbe en
1/capital, invariance du cout : **valides**.

## 27. LES SESSIONS DU SYMBOLE SONT CORRECTES — mon diagnostic etait faux

J'avais annonce que `XAUUSD_22` bloquait le trading de 00h a 01h « alors que sur un vrai
courtier l'or se traite a ces heures-la ». **FAUX, affirme sans verifier.** Mesure :

| | XAUUSD_22 (personnalise) | XAUUSD.p (reel PU Prime) |
|---|---|---|
| Lun-Jeu | cotation 01:00-23:58, trading 01:01-23:58 | **identique** |
| Ven | 01:00-23:57 / 01:01-23:57 | **identique** |
| Sam, Dim | aucune | **identique** |

**Ligne pour ligne.** Les refus `[Market closed]` sont REALISTES. Rien a corriger sur
l'installation — verifie AVANT d'y toucher.

Note : le symbole d'or reel de ce serveur MT5 s'appelle **`XAUUSD.p`** (pas XAUUSD.s, qui
est celui du MT4 Vantage). Outil de diagnostic : `Experts/Outils/SessionsDiag.mq5`, qui
ecrit dans `MQL5/Files/sessions.txt` — passer par un FICHIER et non par Print, car les
journaux d'expert ne sont pas vides sur disque si on coupe le terminal.

## 28. LA REGLE DE SORTIE — la porte exige une PERTE MINIMALE, pas « une perte »

Methode : flottant de l'original reconstruit seconde par seconde depuis le .fxt, positions
suivies depuis le journal. **Reconstruction VALIDEE** contre une verite connue — a ses
99 fermetures CloseAll, mon clone (dont le code EXIGE un sens en perte) est confirme a
**92,9 %** ; l'ecart restant vient de l'echantillonnage a la seconde.

**Le fait brut :**

| | secondes porte OUVERTE sans fermer | episodes -> fermeture | delai median |
|---|---|---|---|
| ORIGINAL | 11 157 | 29 | 63 s |
| CLONE v4.16 | 18 | 1 | 18 s |

L'original a 320 episodes de porte ouverte ; **291 retombent sans fermeture**. Il decline
neuf fois sur dix. Mon clone ferme dans la seconde.

**LE DISCRIMINANT — la profondeur du sens perdant :**

**Premiere lecture, bandes grossieres — TROMPEUSE** : « -5 a -1 » donnait 28 fermetures sur
200, d'ou X ~ 1. La bande agregeait tout. **Bandes fines, resultat reel :**

| perte du perdant | episodes | ferment | taux | idem, episodes > 20 s |
|---|---|---|---|---|
| < -4 | 50 | **29** | **58,0 %** | 36 -> 22 (61,1 %) |
| -4 a -3 | 52 | 0 | 0,0 % | 21 -> 0 |
| -3 a -2 | 42 | 0 | 0,0 % | 24 -> 0 |
| -2 a -1,5 | 19 | 0 | 0,0 % | 5 -> 0 |
| -1,5 a -1 | 38 | 0 | 0,0 % | 11 -> 0 |
| -1 a -0,5 | 62 | 0 | 0,0 % | 14 -> 0 |
| > -0,5 | 57 | 0 | 0,0 % | 9 -> 0 |

**LES 29 FERMETURES SONT TOUTES SOUS -4**, zero sur les 270 autres episodes, et le resultat
tient en ne gardant que les episodes durables. **Le seuil vaut environ 4.**

Explication de toute la chaine : mon clone s'arme sur la moindre perte d'un centime et
ferme aussitot a +5 (99 paniers, mediane realisee 5,09) ; l'original attend, son flottant
monte pendant ce temps (57 paniers, mediane 9,24, q3 35,08).

**Piste ECARTEE au passage — l'exposition nette.** Elle semblait discriminer (0 fermeture
sur 123 episodes au-dessus de 0,6), mais ces episodes durent 6 s en mediane contre 25 s
pour les equilibres : la plupart sont des pointes que l'EA n'a jamais vues. **Il reste
malgre tout 8 episodes de plus de 30 s (jusqu'a 270 s, flottant jusqu'a 27,02) au-dessus
de 0,6 avec zero fermeture** — donc un residu reel, mais bien plus faible que le brut.

**BALAYAGE (journal verifie apres chaque passage, parametre lu DANS chaque bloc)** :

| PerteMini | 0,0 | 0,5 | 1,0 | 2,0 | 3,0 | 4,0 | 6,0 | ORIGINAL |
|---|---|---|---|---|---|---|---|---|
| paniers | 110 | 70 | 106 | 64 | 52 | **48** | 33 | **58** |
| jambes | 5,5 | 5,9 | 5,9 | 6,7 | 7,2 | **7,6** | 9,3 | **8,6** |
| mediane | 5,15 | 5,28 | 5,21 | 9,55 | 6,86 | **9,39** | 15,39 | **9,24** |
| survie k=4 | 72 % | 75 % | 82 % | 85 % | 90 % | **91 %** | 97 % | **87 %** |
| survie k=8 | 87 % | 60 % | 76 % | 81 % | 65 % | **83 %** | 78 % | **79 %** |
| total | 1121 | 796 | 1029 | 953 | 770 | 709 | 775 | 1139 |

Jambes et survie montent MONOTONEMENT avec le seuil. **Retenu : 4,0, la valeur que la
MESURE designe** — et non 2,0 qui collait mieux sur le nombre de paniers. Choisir la
valeur qui optimise le plus de criteres, c'est ajuster ; suivre la mesure, c'est
reconstruire.

**Ecart residuel a 4,0** : jambes 7,6 contre 8,6 et surtout q3 19,04 contre 35,08 — la
queue des gros paniers manque encore. C'est le deficit connu de construction du cote
faible, un defaut distinct.

## 29. PIEGE MT4 — une seule instance par installation

MT4 n'accepte **qu'une instance par installation**. Lancer `terminal.exe fichier.ini`
pendant qu'une instance tourne ne fait que ramener la fenetre existante au premier plan :
**l'ini est ignore et aucun test ne demarre**. Ma boucle attendait la disparition de
`terminal.exe`, ne la voyait jamais, tournait 200 s a vide puis annoncait « fini ».

**J'ai presente des chiffres de ce balayage fantome** — c'etaient d'anciens blocs du
journal relus par un index de bloc decale. Detecte en lisant `InpPerteMini` DANS chaque
bloc au lieu de me fier a la position : le parametre etait absent partout.

**REGLE : verifier qu'aucun `terminal.exe` ne tourne AVANT de lancer un test MT4**, et
apres coup verifier que le journal du testeur a bien ete ecrit (`tester/logs/<date>.log`,
horodatage). Ne jamais identifier un bloc par sa position : lire son parametre.

## 30. CRITERES DE FIDELITE DU CLONE — fixes AVANT mesure, 28/08 fin de journee

Les criteres de [[backtest-acceptance-criteria]] valident une STRATEGIE a trader. Ils ne
s'appliquent pas a la fidelite d'un clone. Aucun critere de fidelite n'avait jamais ete
fixe : « valide » n'avait donc pas de definition. Voici la definition, posee AVANT de
lancer la mesure hors echantillon.

**Fenetre hors echantillon : 2026.04.27 -> 2026.04.30.** Jamais utilisee ; toutes les
regles ont ete etablies sur 2026.05.05 -> 05.07. Donnees du testeur disponibles du
17/04 au 06/05 seulement.

**Interdiction : ne toucher AUCUN parametre entre la pose des criteres et le verdict.**

**Criteres RETENUS (ecart relatif a l'original) :**
- nombre de paniers : < 15 %
- jambes par panier : < 15 %
- survie a k=4 : < 15 %

**Regardes mais NON retenus** (ils dependent d'episodes rares, donc non estimables sur
3 jours) : profit total, q3 des paniers, mediane realisee.

**Etat sur la fenetre de CALIBRATION (5-6 mai), pour reference — ce n'est PAS le test :**

| | ORIGINAL | CLONE v4.21 | ecart |
|---|---|---|---|
| paniers | 58 | 48 | -17 % |
| jambes/panier | 8,6 | 7,6 | -12 % |
| mediane realisee | 9,24 | 9,39 | +2 % |
| q3 | 35,08 | 19,04 | -46 % |
| profit total | 1139,09 | 709,11 | -38 % |
| survie k=4 | 87 % | 91 % | +5 % |

Deja hors critere sur les paniers (-17 %) SUR LES DONNEES DE CALIBRATION. Le test hors
echantillon ne peut qu'etre plus severe.

## 31. VERDICT HORS ECHANTILLON — le clone MQL4 est VALIDE (28/08)

Fenetre **2026.04.27 -> 2026.04.30**, jamais utilisee ; toutes les regles ont ete etablies
sur 05.05-05.07. **Aucun parametre modifie** entre la pose des criteres et la mesure.

| | ORIGINAL | CLONE v4.21 | ecart | critere |
|---|---|---|---|---|
| paniers | 93 | 83 | **-10,8 %** | ok |
| jambes/panier | 8,7 | 9,7 | **+11,4 %** | ok |
| survie k=4 | 88,8 % | 92,2 % | **+3,9 %** | ok |
| remplissages | 817 | 809 | -1,0 % | non retenu |
| mediane realisee | 13,15 | 11,92 | | non retenu |
| q3 | 35,04 | 27,87 | -20 % | non retenu |
| profit total | 1824,96 | 2338,34 | +28 % | non retenu |

**Les remplissages tombent a 1 % pres alors que ce n'etait pas un critere** — confirmation
independante la plus forte du lot.

**RESERVES A MAINTENIR MALGRE LE VERDICT :**
1. **Une seule fenetre de 3 jours.** Passer 3 criteres sur un echantillon ne vaut pas une
   validation robuste.
2. **Le clone etait HORS critere en calibration** (-17 % sur les paniers) et dans les clous
   hors echantillon (-10,8 %). Mieux hors echantillon qu'en calibration = la variation
   inter-fenetres est du meme ordre que l'ecart mesure.
3. **Profit total +28 % et q3 -20 %** : exclus des criteres d'avance a raison (episodes
   rares), mais c'est la que le clone ne colle pas.

**PIEGE DE LECTURE rencontre ici** : ma premiere lecture du passage de l'original donnait
69 paniers / 631 remplissages — lecture PARTIELLE, journal encore en cours d'ecriture. Le
passage complet donne 93 / 817. **Toujours relire APRES la fin effective du test**, et
verifier la presence d'un bloc plus recent qui borne celui qu'on lit.

**Autre piege confirme deux fois** : le controle par horodatage du fichier journal donne
des FAUX POSITIFS — le fichier grossit encore a cause des ecritures tamponnees du passage
PRECEDENT. Le seul controle fiable : verifier qu'un bloc `<EA> inputs:` existe A LA BONNE
DATE DE DEBUT.

## 32. LA VALIDATION EST PLUS FRAGILE QUE ANNONCE — le parametre declare la casse

Les parametres reels de l'original sont imprimes dans tout rapport de backtest (voir
[[sources-goldinghedge]]). `MaxLossCloseAll=5` correspond au seuil que j'avais mesure
(« toutes les fermetures sous -4 »). **Mais l'appliquer casse la validation :**

| hors echantillon 27/04 | paniers | jambes | survie k=4 | med | q3 |
|---|---|---|---|---|---|
| ORIGINAL | 93 | 8,7 | 88,8 % | 13,15 | 35,04 |
| PerteMini = 4 (infere) | 83 | 9,7 | 92,2 % | 11,92 | 27,87 |
| PerteMini = 5 (declare) | **56** | **13,1** | 85,5 % | 15,91 | **35,97** |

A 5 : -39,8 % sur les paniers et +50,7 % sur les jambes, **hors critere**. Donc mon
`InpPerteMini` n'est PAS la meme grandeur que `MaxLossCloseAll` — unites ou semantique
differentes. **La validation de la section 31 repose donc sur une valeur AJUSTEE, pas sur
un mecanisme compris.** Elle reste vraie au sens des criteres, mais plus fragile
qu'annonce.

**Et le tableau montre le vrai probleme** : a 5, le q3 tombe a 35,97 contre 35,04 et la
mediane a 15,91 contre 13,15 — **la queue des gros paniers colle presque parfaitement**,
mais le nombre de paniers s'effondre. Un seul parametre ne peut pas regler les deux :
**il manque un mecanisme.**

**Candidat identifie : `MinDistance1=30` et `Step1=80`** — une SECONDE grille, plus serree
(0,30 au lieu de 0,80), declaree dans l'original et jamais modelisee. Declaree mais
INUTILISEE dans mes deux clones. C'est exactement ce qu'il faut pour construire le cote
faible sans multiplier les paniers. **Prochaine piste.**

Configuration laissee a `InpPerteMini = 4.0` (la valeur validee).

## 33. LE SECOND REGIME DE MARGE — le mecanisme manquant, et la VRAIE validation

**Lu dans les parametres declares puis CONFIRME par la mesure.** Distance minimale au
marche observee chez l'original selon le nombre de jambes du sens pose (27-30/04) :

| jambes | 1 | 2 | 3 | 4 | 5 | **6** | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| ORIGINAL | 0,79 | 0,79 | 0,80 | 0,80 | 0,79 | **0,30** | 0,30 | 0,30 | 0,28 | 0,33 |
| CLONE avant | 0,19 | 0,81 | 0,80 | 0,71 | 0,80 | 0,80 | 0,81 | 0,81 | 0,81 | 0,81 |

Poses sous 0,60 : **0 %** en dessous du seuil, **77 a 92 %** au-dessus. La marge tombe de
0,80 a 0,30 **a partir de la 6e jambe**. Les trois parametres declares s'emboitent :
`iCount=5` est le seuil, `MinDistance=80` le regime bas, `MinDistance1=30` le regime haut,
`Step=Step1=80` car le pas de grille ne change pas.

**`iCount=5` EST donc applique** — pas comme un plafond de positions (les paniers vont a
32) mais comme un **seuil de changement de regime**. Ma conclusion « iCount n'est pas
applique » etait fausse dans son interpretation. La memoire de l'utilisateur etait juste.

**C'est ce qui permet au cote fort de continuer a s'approfondir** : l'original atteint
16 a 23 jambes la ou le clone plafonnait a 8-9.

### VALIDATION HORS ECHANTILLON, PARAMETRES 100 % DECLARES

| 27/04 -> 30/04 | ORIGINAL | CLONE v4.22 | ecart | critere |
|---|---|---|---|---|
| paniers | 93 | 85 | **-8,6 %** | ok |
| jambes/panier | 8,7 | 9,7 | **+12,0 %** | ok |
| survie k=4 | 88,8 % | 93,5 % | **+5,3 %** | ok |
| q3 | 35,04 | 35,19 | +0,4 % | non retenu |
| mediane | 13,15 | 14,90 | | non retenu |
| panier maximal | 23 | 33 | | non retenu |

**Aucun parametre ajuste.** Tout vient de la liste declaree : iCount=5, MinDistance=80,
MinDistance1=30, MaxLossCloseAll=5, CloseAll=5, StopProfit=30, MinProfit=10, FirstStep=50,
Step=80, K_Lot=1,3, lot=0,01.

**C'est une validation d'une autre nature que celle de la section 31**, qui reposait sur
`InpPerteMini=4` infere puis retenu parce qu'il marchait. Ici, la valeur declaree 5 ne
fonctionnait PAS seule (56 paniers) et le double regime seul ne fonctionnait PAS non plus
(107 paniers) : **les deux ensemble tombent juste**. Deux erreurs se compensaient.

**Reserve maintenue** : une seule fenetre de 3 jours. Aucune autre n'est disponible —
l'historique M1 ne commence qu'au 23/04 et 23-26/04 chevauche la campagne d'acceptation.
Eprouver le verdict demandera d'importer de l'historique.

## 34. PORTAGE MQL5 DES QUATRE REGLES — 29/08, commit a610be4

Le clone MQL5 avait DIVERGE : quatre regles etablies sur la paire MQL4 lui manquaient
(reancrage par sens, second regime de marge, seuil de perte de la porte 1, lot selon
l'approfondissement) et il portait des experimentations que la reference n'a pas.

**Effet, meme binaire, deux configurations, XAUUSD_22 2025.06-2026.06 :**

| compteur | AVANT | APRES | variation |
|---|---|---|---|
| paniers fermes | 4 832 | 2 529 | -47,7 % |
| jambes / panier | 7,9 | **14,8** | +87 % |
| positions max / panier | 27 | 55 | +103,7 % |
| rang maximal | 21 | **48** | +128,6 % |
| gain cumule | 86 782 | 66 041 | -23,9 % |
| pire flottant porte | -17 796 | -14 680 | -17,5 % |
| MORTS | 25 | 25 | 0 |

**NON VALIDE** : aucun original n'existe en MT5. La DIRECTION est confirmee (paniers moins
nombreux et plus profonds, signature de l'original), la MAGNITUDE ne l'est pas.

**Correction d'une conclusion anterieure** : la v4.09 avait essaye le second regime puis
l'avait retire en v4.10 au motif qu'il « ne donne rien » — juge sur des MEDIANES alors que
le mecanisme agit sur la QUEUE. Le commentaire de l'epoque le disait lui-meme : « comme les
rangs eleves sont rares, la mediane ne bouge pas ».

## 35. LE PLAFOND DE VOLUME — ce qui limite VRAIMENT l'echelle

Mesure du 29/08 sur `XAUUSD_22` **et** sur le symbole reel `XAUUSD.p` : identiques.

```
volume min 0,01   max 100,00   pas 0,01
ecretage de l'echelle des le RANG 36 (lot theorique 126,5)
```

Le clone atteint le rang 48 : **les rangs 36 a 48 sont tous poses a 100 lots** au lieu de
126, 164, 214... La martingale cesse de doubler exactement dans la zone qui decide de la
ruine. Ce n'est PAS un bug — le plafond est reel, un vrai courtier l'applique.

**MAIS le backtest tourne avec un depot de 10 000 000.** Il explore donc des etats qu'un
compte de 10 000 ne pourrait jamais tenir, ne serait-ce qu'en MARGE : a 100 lots sur l'or,
un point vaut 10 000 $. **La frequence de ruine mesuree le 28/08 decrit un compte qui aurait
les moyens de porter des positions qu'il n'a pas les moyens de porter.**

**A CORRIGER AVANT DE REFAIRE L'ETUDE** : soit fixer le depot au capital notionnel etudie,
soit modeliser la marge. Sinon on mesure un objet qui n'existe pas.

## 36. SON OBJECTION DU 29/08 : L'ETUDE DE 22 ANS N'EST PAS OPPORTUNE — confirmee

**Son raisonnement, juste :** les parametres de l'EA sont ABSOLUS (CloseAll 5 USD, Step
0,80, MinDistance 0,80) alors que l'or est passe d'environ 400 $ en 2004 a 4 500 $ en 2026.
Un pas de 0,80 valait 0,2 % du prix en 2004 contre 0,018 % aujourd'hui : **la grille est
onze fois plus serree en relatif**, et la volatilite suit le prix.

**Chiffre, meme EA, meme configuration, deux fenetres d'un an :**

| | 2004-2005 | 2025-2026 | rapport |
|---|---|---|---|
| paniers fermes | 35 | 498 | **x 14** |
| ordres remplis | 1 531 | 6 580 | x 4,3 |
| gain cumule | 322 | 6 521 | x 20 |
| **morts** | **0** | **5** | — |
| pire flottant | -3 140 | -14 680 | x 4,7 |

**Ce n'est pas la meme machine.** Et le point qui condamne l'etude longue : zero mort en
2004-2005 contre cinq en 2025-2026. **Le 3,99 par an du 28/08 melange des regimes qui
different d'un ordre de grandeur** et ne decrit aucune des deux periodes.

**Deux issues :** restreindre l'etude a une periode ou le niveau du prix est comparable
(fidelite preservee), ou normaliser les parametres au prix — mais ce serait alors une AUTRE
strategie, plus le clone.

## 37. LE REGIME REEL, AVEC COUPURE — le risque de liquidation disparait

Meme fenetre 2025-2026, depot 10 000, clone v5.10, seule difference : `MaxFlottantPct = 50`.

| | sans coupure | AVEC coupure |
|---|---|---|
| paniers | 2 786 | 498 |
| positions max / panier | 88 | 46 |
| rang maximal | 78 | 32 |
| pire flottant | -286 811 | -14 680 |
| **volume nu maximal** | 147,59 lots | **3,72 lots** |
| **niveau de marge minimal** | 39,7 % | **602,2 %** |
| ruptures sous le stop out | 2 | **0** |
| morts | - | 5 / an |

**La coupure supprime entierement le risque de liquidation** : marge jamais sous six fois le
seuil, volume nu divise par 40. Le danger decrit plus tot (section 35 de
[[goldinghedge-exploitation]]) etait un artefact de paniers laisses courir au rang 78.

**Le rang maximal tombe a 32 — sous le rang 36 ou l'ecretage a 100 lots commence.** Donc
avec la coupure, le plafond de volume ne mord jamais : l'echelle reste geometrique de bout
en bout. Cela leve aussi la reserve de la section 35.

## 38. PROGRAMME CONVENU LE 29/08, dans l'ordre

1. **Etude restreinte au regime actuel** (le 22 ans est condamne, section 36).
2. **Variante a parametres normalises au prix** — pour eprouver la robustesse hors du
   regime actuel. Ce ne sera plus le clone mais une autre strategie : utile pour comprendre,
   pas pour prevoir ce que fera son compte.
3. **Niveau de coupure optimal** (sa demande du 29/08), en DEUX questions distinctes :

   **a) Le mecanisme est-il necessaire ? RESOLU LE 29/08 : OUI.** Mesure de la DUREE passee
   sous le seuil, et non plus du minimum atteint :

   | | sans coupure | avec coupure |
   |---|---|---|
   | passages sous 100 % | 191 | 1 |
   | passages sous 50 % | **9** | 1 |
   | temps cumule sous 50 % | **677 s** | **0 s** |
   | plus long passage | **300 s** | 0 s |
   | lignes « stop out » | 0 | 0 |

   **Cinq minutes d'affilee sous le seuil de liquidation n'est PAS transitoire : un vrai
   courtier aurait liquide.** Le testeur MT5 ne le fait pas. La coupure est donc NECESSAIRE.

   **CONSEQUENCE GENERALE — le testeur SOUS-MODELISE la liquidation.** Le resultat du
   compte de 10 000 finissant l'annee a +132 189 sans coupure est une FICTION : ce compte
   aurait ete solde en cours de route. **Tout resultat reposant sur une survie sans coupure
   est optimiste.**

   **b) Quel niveau ?** Balayer 20/30/40/50/60/70 % et regarder DEUX courbes, pas une :
   la survie ET le gain. Une coupure serree protege mais tue les paniers qui seraient
   revenus ; une coupure lache laisse courir. L'optimum depend du capital, donc balayer a
   deux ou trois capitaux.

   **PIEGE A EVITER** : chercher l'optimum sur une seule fenetre d'un an est de
   l'ajustement — le regime 2025-2026 est exceptionnel (section 36). Il faut plusieurs
   fenetres et retenir un **PLATEAU, pas un pic**, comme le demandent deja
   [[backtest-acceptance-criteria]].

## 39. QUESTION OUVERTE — le pire cas de marge CROIT avec le capital

Mesure du 29/08, rupture de couverture vue par un compte jeune : marge / capital au pire
vaut **0,28** a 10 000, **0,67** a 25 000, **0,62** a 50 000. Contre-intuitif : un capital
plus gros devrait diluer. Explication probable — la coupure valait 50 % du capital, donc un
capital plus gros laisse les paniers aller plus loin (rang 32 a 10 000, 48 a 25 000). **Non
verifie.** A reprendre avec la coupure en valeur absolue.

## 40. LE CLONE MQL5 EST FIDELE — et le MODELE DE TICKS change tout (29/08)

**Test de fidelite** : les trois programmes sur la MEME fenetre 27-30/04, meme courtier,
memes parametres. Le MQL5 ne peut pas etre compare a l'original (qui n'existe qu'en MT4),
donc on le compare au clone MQL4 **valide**.

| | paniers | jambes/panier |
|---|---|---|
| ORIGINAL (MT4, chaque tick) | 93 | 8,7 |
| CLONE MQL4 (MT4, chaque tick) | 85 | 9,7 |
| **CLONE MQL5 (MT5, chaque tick)** | **96** | **10,1** |
| CLONE MQL5 (MT5, 1 minute) | **13** | **22,5** |

**Le clone MQL5 est fidele** : 96 paniers contre 93 a l'original, soit +3,2 % — MIEUX que
le clone MQL4 lui-meme (-8,6 %). La chaine original -> MQL4 -> MQL5 tient. **Point regle.**

## 41. MAIS LE MODELE DE TICKS DEPLACE TOUT — d'un facteur SEPT

Meme code, memes parametres, meme fenetre, meme symbole : **13 paniers en modele « 1 minute »
contre 96 en modele « chaque tick »**. Et 22,5 jambes par panier contre 10,1.

**Mecanisme** : le cliquet avance d'un pas PAR TICK. Moins de ticks = cliquet plus lent =
ordres moins remplis = paniers moins nombreux mais bien plus profonds.

**GRAVITE : TOUS LES BACKTESTS DU MONTAGE ONT TOURNE EN MODELE « 1 MINUTE ».** Les quatre
annees, les cinq poches, le plafonnement du creux a 19,4 %, la courbe rendement/risque —
tout. La lignee vient de `ruine22_m1.ini` qui portait `Model=1`.

**A verifier avant de considerer quoi que ce soit comme acquis.** Le sens du deplacement
n'est pas connu : un modele plus dense peut ameliorer comme degrader.

**REGLE A APPLIQUER DESORMAIS** : le modele de ticks est un PARAMETRE DE PREMIER ORDRE pour
cet EA, pas un detail de configuration. Toute comparaison entre deux passages doit verifier
qu'ils partagent le meme modele — et tout resultat doit le mentionner.

Voir [[reperes-chiffres-or]], [[goldinghedge-exploitation]], [[feuille-de-route-clone]].
