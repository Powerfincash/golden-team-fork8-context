---
name: vps-ny4
description: "VPS NY4 (188.119.100.103, hôte fxut9881301) — accès SSH par clé depuis le 13/09 ; état des trois terminaux ; Ultima y est à 72 ms contre 24 ms depuis le PC, NY4 ne sert que Vantage (7,8 ms) et Axi"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-17T19:51:05.238Z
---

**Accès (13/09/2026, option B)** : `ssh -i C:\Users\User\.ssh\vps_ny4 trader@188.119.100.103` (OpenSSH Server, clé
ed25519 sans phrase de passe, mots de passe interdits, shell par défaut PowerShell). Le compte `trader` a pour profil
**`C:\Users\Administrator`** ; les terminaux sont sous `C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\`.
Windows Server 2022 sur KVM, 4 cœurs EPYC, **4-5 Go de RAM** (serré pour trois terminaux), 149 Go disque, **heure UTC**
(Paris = UTC+2 l'été) — à retenir pour toute tâche planifiée. Pour lire un journal MT5 ouvert : `File.Open` avec
`FileShare.ReadWrite` + StreamReader Unicode (ReadAllText échoue, fichier verrouillé). Scripts déposés dans le profil :
`inv.ps1` (inventaire terminaux/pings), `ult.ps1`, `axi.ps1`.

**État le 13/09** :
- `43A9BD89` Ultima Markets MT5, compte **33982313 réel (cent)** : ping **71,9 ms** via AS04 — contre **24 ms depuis
  le PC** (AS05). Aucun expert chargé : le terminal ne fait que recevoir les notifications ; **le banc de 37 instances
  tourne depuis le PC** (« placed for execution » n'apparaît que là). Pas de doublon d'exécution constaté.
- `725B72F2` Vantage MT5, compte 26077080 **démo**, ping **7,8 ms** (serveur new-yorkais).
- `6FBEE76C` Axi MT5, installé le 12/09 14:42, **aucun compte connecté**.

**Mesure du 13/09 qui clôt la question « où est Ultima ? »** (une fiche web affirme « Equinix NY4, < 2 ms » — faux) :
les terminaux MT5 passent par des points d'accès MetaQuotes ; le VPS est branché sur **Secaucus NJ** (45.94.185.81, 0 ms
de NY4) et affiche 72 ms ; le PC passe par **Amsterdam** (194.164.179.244, 15,6 ms) et affiche 24 ms. Le ping MT5 est
l'aller-retour jusqu'au serveur de trading : celui-ci est ~72 ms derrière New York et ~8 ms derrière Amsterdam → **Londres
(LD4/LD5)**. Vantage est bien à New York (7,8 ms). **Axi : à New York aussi selon lui (13/09)** — à confirmer par le ping au premier « authorized ».

**Why :** il a pris NY4 en croyant les serveurs Ultima à New York ; la mesure dit l'inverse. Déplacer le banc Ultima sur
NY4 tripleraient la latence ; le bon VPS pour Ultima est à **Londres** (celui qu'il avait).

**How to apply :** NY4 = Vantage (compte cent à créer, symboles `.r`) + Axi ; Ultima = Londres (ancien VPS) ou ce PC. La comparaison de glissement Londres/NY4 n'a de sens que pour Vantage et Axi.
Prochaine étape convenue : chien de garde en alerte seule (voir [[vps-acces-chien-de-garde]]).

**Jeux déposés le 13/09 dans `Common\Files` du VPS** : `SetsUltima*` (.sc), `SetsVantage*` (sans suffixe, démo standard
26077080), `SetsAxi*` (sans suffixe, jambe or SetsB2, à confirmer une fois le compte Axi connecté) — tous en
`UseAutoLoader=false` + dossier commun (montage du banc). Le compte cent Vantage à créer aura des symboles `.r` : refaire
`SetsVantage*` avec ce suffixe. URL à autoriser dans chaque terminal : `worldtimeserver.com`, `tradewithwim.com`.
Cause de « l'expert disparaît du graphique » : `No .set files found in folder` (dossier absent), pas la licence.

**État confirmé par lui le 17/09 soir : le banc Ultima (compte cent RÉEL 33982313) tourne sur le VPS de Londres ; Vantage (démo
26077080) sur le VPS NY4.** Le PC n'exécute plus le banc. Revue hebdo du 15/09 : Londres 60 positions / −10 USC (percentile 22 de
la distribution du backtest), NY4 Vantage 27 positions / +27 $ (percentile 50). Manque encore la mesure du glissement par jeu.

**17/09 soir — Vantage RÉEL est à Londres** : le terminal Vantage de NY4 est passé sur le compte réel `34803874` (VantageMarkets-Live 14) à 72 ms
→ serveur londonien. Sur sa demande, le Vantage du VPS de Londres (`725B72F2`, déjà connecté à Live 14) a reçu depuis NY4 : `Zebra_v1.ex5`,
`Heron_v1.ex5`, presets Zebra/Heron/UBS, six dossiers `SetsVantage*` (symboles Live 14 sans suffixe, `BTCUSD.bc`), et le profil de 10 graphiques
sous le nom `Vantage_NY4` (3 Zebra, 2 Heron, 5 UBS) — à charger par lui (Fichier → Profils), puis **arrêter le Vantage de NY4** (même compte réel).
Scripts sur les deux VPS : `inv2.ps1` (inventaire complet), `symb.ps1`, `prof.ps1`, `verif.ps1`.

## Carte des serveurs (13/09) — deux VPS, deux courtiers chacun
- **Londres (LD4)** : Ultima Markets (mesuré : 24 ms d'ici via Amsterdam, 72 ms de NY4), **Darwinex Zero** (selon lui) → VPS de Londres.
- **New York (NY4)** : Vantage (mesuré 7,8 ms), Axi (selon lui, à confirmer au premier ping), **PU Prime** (mesuré 13/09 : 102 ms d'ici via le point d'accès d'Amsterdam à 18 ms → ~82 ms au-delà = New York) → VPS NY4 (188.119.100.103).
- Méthode : le ping MT5 est l'aller-retour jusqu'au serveur de trading ; on le compare au temps TCP jusqu'au point d'accès MetaQuotes (Amsterdam 194.164.179.x d'ici, Secaucus 45.94.185.81 de NY4) — la différence situe le serveur.

## VPS de Londres (nouveau, 13/09) — `ssh vps-london`
`fxut9888731`, **62.216.73.101**, SSH port 22 (le 42014 de l'hébergeur est le Bureau à distance), utilisateur `trader`
(profil `C:\Users\Administrator`), Windows Server 2022, UTC, 6 Go de RAM, 150 Go. Alias posés dans `C:\Users\User\.ssh\config` :
`vps-ny4` et `vps-london`, même clé `vps_ny4`. Terminal Ultima MT5 installé, compte 33982313, aucun expert, **0 ms du
point d'accès 194.164.179.244** (le même que depuis le PC) → ping MT5 attendu ~8 ms. `SetsUltima*` déposés dans
`Common\Files`. L'ancien VPS de Londres (62.216.81.78) était encore connecté au compte le 13/09 à 14:09 UTC — à vérifier
sans expert avant suppression.
**17/09 20:10 UTC — état après bascule** : Londres Vantage (profil Default, 9 graphiques) actif et posant des ordres (or 20:01 et 20:10, EUR à reposer) ;
NY4 Vantage : auto-trading coupé 20:05, UBS déchargés 20:06, Zebra ×3 + Heron ×2 encore attachés mais bloqués (10027) — à fermer proprement. Pas de
graphique BTC sur Londres (NY4 en avait un). Compte 1 500 $ en lots 0,01 : sous le capital minimum du compte propre (2 865 $ à 10 % de creux).
