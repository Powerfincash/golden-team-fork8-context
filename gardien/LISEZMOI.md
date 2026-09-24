# Gardien de paquet (argent) — 24/09/2026

`GardienPaquet.mq5` + `GardienPaquet.mqh` : un petit robot MT5 qui **n'ouvre jamais rien**. Il surveille
les positions d'un symbole et, dès qu'un paquet (tous les achats, ou toutes les ventes, ouverts
ensemble) perd plus que le plafond, **il ferme tout le paquet**. Le plafond est celui que Denis a accepté
le 24/09 : **450 par 0,01 lot à 64,44 $, proportionnel au prix** (voir `resultats/plafond_paquet_xag/PLAFOND.md`).

## Ce qu'il compte

- Perte du paquet = positions encore ouvertes (profit + swap) **+ ce que le paquet a déjà encaissé
  ou perdu** depuis sa première position (sorties, commissions, swaps). C'est la même définition que
  le rejeu minute par minute.
- Plafond du jour = 450 × (prix du jour / 64,44), dans la monnaie du compte (USC sur un compte cent),
  pour le plus petit lot du paquet (0,01). Il l'affiche au démarrage et en haut à gauche du graphique.
- Si le marché est fermé au moment de couper (vu au test le 17/09 à 01h00 serveur), il **réessaie
  toutes les 2 secondes** jusqu'à ce que tout soit fermé, même si la perte se réduit entre-temps.
- Il retient le début du paquet même après un redémarrage du terminal.

## Réglages

| Réglage | Valeur | Rôle |
|---|---|---|
| GP_Plafond | 450 | plafond au prix de référence, par 0,01 lot |
| GP_PrixRef | 64.44 | prix de référence |
| GP_Magic | -1 | toutes les positions du symbole (seuls les jeux argent d'UBS y tradent) |
| GP_PauseMinutes | 0 | après une coupe, refermer ce qui rouvre pendant N minutes (0 = non, comme au test) |
| GP_Observation | false | true = il prévient sans rien fermer |
| GP_Notifier | true | notification sur le téléphone à chaque coupe |

## Essais au testeur (24/09, PU Prime, ticks réels, profil fidèle v1.47, 0,01 lot)

Banc : `EagleOwl_GP` = Eagle-owl v1.47 **plus trois lignes** qui appellent le gardien (rien d'autre ne
change). Chiffres de `mesure.py`, VÉRIFIÉ sur les six rapports. Détail : `essais_testeur_24-09.txt`.

| Période | Sans gardien | Avec gardien | Écart | Coupes |
|---|---|---|---|---|
| 2021-2024 | 104 491 | 104 494 | +3 | 2 (22/03/2021, 18/02/2022) |
| 2025 | 100 552 | 100 603 | +51 | 1 (03/12/2025) |
| 2026 au 23/09 | 104 284 | 104 550 | +266 | 3 (17/06, 03/08, 17/09) |

Les six coupes sont exactement les six paquets désignés par le rejeu minute par minute. Ici le robot
continue de tourner après la coupe (il peut rouvrir) : c'est ce qui manquait au rejeu, et le résultat
reste positif sur les trois périodes.

## Pose sur le compte réel — PAS FAITE, exige l'accord écrit de Denis

À faire seulement quand l'argent revient en réel, **avant** de remettre les jeux argent :
1. Copier les deux fichiers dans `MQL5\Experts\Gardien\` du terminal Ultima (VPS Londres), compiler.
2. Ouvrir un **second** graphique `XAGUSD.sc` (UBS garde le sien), y glisser `GardienPaquet`,
   cocher « Autoriser le trading algorithmique ».
3. Contrôle : l'onglet Experts doit afficher « plafond 450 à 64.44, aujourd'hui … pour 0,01 lot »
   avec un nombre proche de 7 × le prix de l'argent. Sinon, le retirer et le signaler.
