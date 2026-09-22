# Consignes de processus (chargées à chaque session)

## À LIRE EN PREMIER, DANS CET ORDRE (avant toute réponse, toute mesure, toute recherche)

1. **`ETAT.md`** — où on en est : décidé, en cours, bloqué, prochain geste, ne pas refaire.
   C'est le seul fichier qui fait foi sur l'état vivant du chantier.
2. **`memory/MEMORY.md`** — l'index des mémoires. Suivre les liens qui concernent le sujet du jour,
   pas les 70 fiches.
3. **`RESULTATS_CORRIGES.md`** — les chiffres vérifiés des chaînes MT4. Il corrige des erreurs
   d'attribution réelles : il l'emporte sur tout artefact ou résumé plus ancien.

Ne rien lire d'autre pour démarrer. Le log `chaine_mt4_*.log` se consulte quand une ligne précise
est contestée, pas pour se mettre au courant.

### Trois règles de lecture

- **Le dépôt fait foi, jamais un artefact.** Un artefact vivant, un résumé de session ou une
  capture se périment sans prévenir et peuvent contenir des erreurs d'attribution — il y en a
  eu trois le 21/09. En cas de désaccord entre un artefact et ce dépôt, le dépôt gagne.
- **Un chiffre sans date est un chiffre périmé.** Le dater ou le remesurer, jamais le reprendre tel quel.
- **Ce qui n'est pas dans le dépôt n'existe pas pour la session suivante.** Une session infonuagique
  n'a aucun accès au PC : le dépôt est le seul pont.

## SAUVEGARDE : « sauvé » veut dire « disponible partout »

- La seule commande : **`./sauver.sh "ce qui a changé"`**. Elle date `ETAT.md`, commite, pousse,
  et **vérifie que le dépôt distant a bien reçu le commit** avant d'annoncer quoi que ce soit.
- **Ne jamais dire « sauvé » ni « commité » sans le lien du commit** rendu par le script.
  Un commit local n'est pas une sauvegarde : fork 7 a été perdu exactement comme ça.
- **Quand la lancer** : à chaque décision prise, à chaque mesure terminée, avant tout changement
  de session, et à la fin de chaque session. Pas une seule fois à la fin.
- Il suffit qu'il écrive **« sauve »** pour la déclencher — mais c'est à la session d'y penser,
  pas à lui.
- **Mettre `ETAT.md` à jour d'abord, pousser ensuite.** Un push qui ne change pas `ETAT.md`
  après une décision ou une mesure ne sauve rien d'utile à la session suivante.

## AVANT DE QUITTER (ou d'annoncer un changement de session)

Trois lignes, dans cet ordre :
1. Mettre `ETAT.md` à jour — en particulier la section **En cours** : ce qui tourne seul et
   continuera sans surveillance.
2. `./sauver.sh "fin de session — <ce qui a changé>"`.
3. Le lui dire avec le lien du commit, et nommer ce qui reprend tout seul.


## Le gabarit de la page « Quatre Standards »
- La page se reprend **telle quelle** depuis `gabarits/quatre-standards-*.html`. Ne jamais réinventer sa mise en page.
- Rien ne se retire : toutes les rubriques de `QUATRE-STANDARDS-*.txt` et de `etat_portefeuilles.py tout` y sont (capital minimum, instances, mensuel médian ET moyen, mois négatifs, pire mois, délais). Si une rubrique doit disparaître, le dire, jamais en silence.
- Toutes les variantes d'une jambe restent visibles ; fond rosé = à privilégier pour ce type de compte, jaune = alternative admise, gris = pour info.
- La page montre les portefeuilles-type retenus et leurs chiffres, **jamais la liste des EA éliminés**. Chaque chiffre porte sa date. Détail dans `gabarits/LISEZMOI.md`.

## Rapatrier ce qui n'est que sur le PC
- Une seule ligne, dans `COMMANDE.md`, à coller dans Git Bash. Elle lance `./rapatrier.sh` : outils, `.set`, `.ini` sans identifiant, sources `.mq4`/`.mq5`, gabarits, journaux, index des rapports, puis commit, push et **vérification que le distant a reçu**. `INVENTAIRE.md` dit ce qui entre et ce qui reste dehors, avec les raisons.
- Une seconde ligne, dans le même fichier, crée la tâche Windows « Rapatriement Golden Team » : elle lance `auto.sh` chaque nuit à 3 h, avec rattrapage au démarrage suivant si le PC était éteint. Un commit par jour au maximum.
- **`AUTOMATIQUE.md` est le témoin de vie** : sa première ligne donne la date du dernier passage. Plus de deux jours = la tâche ne tourne plus, le dire à Denis. Ne jamais supposer qu'un fichier du PC est arrivé sans avoir regardé cette date.

## Lancement d'un test MT5 : un seul chemin
- Tout test MT5 se lance par `C:\Users\User\OneDrive\Documents\forex\outils\lance_chaine.ps1 -Inis <nom1>,<nom2>` (noms des .ini dans `Documents\forex`, sans extension), en arrière-plan et fenêtre cachée. Jamais `Start-Process terminal64` à la main, jamais un `jourXX.ps1` écrit à la volée.
- Le lanceur appelle `prelance.py` (refus = pas de lancement), retire une mise à jour MT5 en attente (sinon blocage UAC), coupe si le disque < 3 Go ou si le journal du testeur > 1 Go, et vérifie que le rapport n'est pas vide avec `mesure.py`. Lire son journal `chaine_*.log` avant de dire quoi que ce soit sur un test.
- Contrôler le premier résultat de toute chaîne dans les 5 minutes (journal du lanceur : « test démarré »), pas à la fin.
- Ne jamais toucher au processus `terminal` (MT4, démo Wolf). `Stop-Process -Name terminal64` seulement, et seulement par le lanceur.

## Lancement d'un test MT4 : un seul chemin (erreur répétée les 30/08 et 18/09)
- Tout backtest MT4 se lance par `outils/lancer_mt4.sh <terminal.exe> <dossier de données> <fichier.ini> [--attendre]` (bash), qui existe depuis le 01/09 : il refuse si l'installation tourne déjà, exige TDS actif ET des ticks Dukascopy pour le symbole (`duka_symbole.py`, dossier `AppData\Local\Tick Data Suite\Dukascopy\<symbole>`), vérifie le témoin « Started with configuration file » dans les deux encodages, contrôle la santé du passage à 90 s et le rapport à la fin. Jamais `Start-Process terminal.exe` à la main, jamais un lanceur réécrit à la volée (le 18/09 j'en ai écrit deux sans voir celui qui existait).
- Le MT4 prend le fichier .ini en ARGUMENT NU (`terminal.exe chemin.ini`) ; `/config:` est la syntaxe MT5 et le MT4 l'ignore EN SILENCE (terminal ouvert, aucun test). Le lanceur ne ferme jamais un terminal existant : c'est à l'utilisateur.
- Un symbole sans ticks Dukascopy ne se teste pas sur MT4 : télécharger d'abord dans Tick Data Manager (par l'utilisateur), sinon TDS bloque le testeur (« no tick data », `.fxt cannot open`).

## Mesure
- Un chiffre sur un rapport MT5 vient de `mesure.py` (contrôles intégrés) ; s'il affiche NON VERIFIE, il n'y a pas de chiffre.
- Pas d'estimation d'heure sans base mesurée (pourcentage du journal du terminal, durée d'un test comparable).
- Mesure jeu par jeu d un rapport UBS : `outils/parjeu.py <rapport> [--csv]` (contrôlé sur n18 : 3 550 tr, +6 024 $).

## Forme des réponses
- Première ligne de chaque réponse, en italique : *Modèle conseillé : Haiku | Sonnet | Opus | Fable — raison en cinq mots.* (Haiku : lire, lancer, surveiller ; Sonnet : écrire un script, un tableau ; Opus : analyser, comparer, décider ; Fable : concevoir, diagnostiquer.)
- Changement de modèle conseillé pour la suite : le dire, terminer le tour, armer un minuteur de 3 min (Monitor `sleep 180`). Sans message de sa part à l'échéance, poursuivre avec le modèle en cours.

## Avant toute recherche extérieure
- Tout nom de robot, signal, indicateur ou produit passe d'abord par `python outils/dejavu.py "<nom>"` (documents, mémoire, jeux UBS, rapports). S'il a déjà été vu, lire ce qui est écrit AVANT de chercher sur le web : le motif déjà consigné est presque toujours plus fort que celui qu'une fiche donnera. Né de l'erreur du 06/09 sur Luna AI Pro.

## Crible d'un produit : ne pas travailler au bazooka
- Trois éliminatoires SEULEMENT (palmarès antérieur au produit, symbole incohérent, grille qui est le moteur). Tout le reste est une réserve qui dicte une mesure, pas un rejet. Avant d'écarter : « que me manque-t-il pour le mesurer ? »
- Tout critère éliminatoire nouveau ou modifié doit être testé contre `outils/CALIBRATION-CRIBLE.md` : s'il élimine UBS, Gold Reaper, Gold Phantom, Wolf ou Advanced Scalper, il est faux. Le manuel d'UBS contient lui-même « any market, any timeframe ».
- **Sport d'équipe, pas sport individuel** : un candidat se juge sur sa contribution au portefeuille à creux égal, jamais sur son rendement propre. Redondance (corrélation > +0,5) = vrai disqualifiant ; faiblesse = pas un disqualifiant. Le poste vacant aujourd'hui est le retour à la moyenne, le portefeuille étant 100 % cassure.

## Ne pas annoncer trop tot (06/09) — sa critique la plus dure de la journee
- « Tout etait valide puis plus rien » : le defaut n'est pas de retester, c'est de PUBLIER avant d'avoir fini de lire ce qui est deja sur le disque. Trois fois le meme jour (Luna AI, rapports Advanced Scalper, jeux de reglages de Wolf).
- AVANT d'annoncer un chiffre sur un produit : `python outils/avant_publication.py "<nom>"`. Les jeux du vendeur contiennent des parametres que le comportement observable ne revele PAS (filtre d'ecart, glissement, horaires, decalages). Tant qu'une source n'est pas lue, aucun chiffre ne sort.
- Une comparaison n'a de sens que si les DEUX mesures ont les memes conditions : meme fenetre, meme lot, meme modele de ticks, meme delai d'execution. J'ai compare Zebra AVEC delai contre Wolf SANS delai et j'en ai tire une conclusion : a ne plus jamais faire.
