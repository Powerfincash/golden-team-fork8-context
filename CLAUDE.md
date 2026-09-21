# Consignes de processus (chargées à chaque session)

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
