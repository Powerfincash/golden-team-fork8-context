---
name: mt4-lancement-un-seul-chemin
description: "Erreur répétée (30/08, 18/09) — terminal.exe /config: est la syntaxe MT5, le MT4 l'ignore en silence ; sa remarque « cette erreur est déjà arrivée plusieurs fois pourtant ! » ; réponse = le lanceur existant outils/lancer_mt4.sh (TDS + ticks Dukascopy obligatoires) + règle CLAUDE.md ; ne jamais réécrire un lanceur"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d0e7cce4-cea8-47de-9dd2-1ae784bc5f8a
  modified: 2026-09-18T18:45:51.535Z
---

**Le fait.** Le 30/08 (3 h perdues) puis le 18/09 (banc Luna AI Pro), j'ai lancé un backtest MT4 avec
`terminal.exe /config:x.ini`. C'est la syntaxe MT5. Le MT4 démarre, ignore l'argument sans message,
reste ouvert sans test, et comme une seule instance MT4 est possible, tout est bloqué jusqu'à ce que
l'utilisateur ferme la fenêtre (consigne : je ne touche jamais au processus `terminal`). La note existait
dans [[mt5-pieges-outillage]] depuis le 30/08 (« le piège m'a coûté 3 h alors qu'il était DÉJÀ noté »).
Sa remarque du 18/09 : « Cette erreur est déjà arrivée plusieurs fois pourtant ! »

**Pire, le 18/09** : le projet avait DÉJÀ un lanceur MT4 sous garde-fous, `outils/lancer_mt4.sh` (01/09 :
refus si l'installation tourne, TDS actif exigé, ticks Dukascopy du symbole exigés via `duka_symbole.py`,
témoin de configuration dans les deux encodages, santé du passage à 90 s, rapport contrôlé). Je ne l'ai
pas vu et j'ai écrit deux lanceurs à la volée (`mt4_luna_chaine.ps1`, `lance_mt4.ps1`), supprimés le soir
même. Et le vrai blocage du banc Luna n'était pas la syntaxe mais TDS : sans ticks Dukascopy pour le
symbole, TDS bloque le testeur (« no tick data », `.fxt cannot open [5]`).

**Why :** une note qu'il faut relire ne protège pas ; ce qui protège, c'est un outil qui refuse ou vérifie
([[garde-fous-mesure]]), et il faut CHERCHER l'outil existant avant d'en écrire un
([[inventorier-avant-de-lancer]] : `ls outils/*mt4*`, `dejavu.py`).

**How to apply :**
- Tout backtest MT4 : `outils/lancer_mt4.sh <terminal.exe> <dossier de données> <fichier.ini> [--attendre]`
  (règle ajoutée au CLAUDE.md le 18/09). Jamais `Start-Process terminal.exe` à la main, jamais un lanceur
  réécrit pour un banc.
- Avant un banc MT4 sur un symbole nouveau : ticks Dukascopy téléchargés dans Tick Data Manager (par
  l'utilisateur), dossier `AppData\Local\Tick Data Suite\Dukascopy\<symbole>` présent ; ET le symbole
  affiché dans la Market Watch du terminal (`history/<serveur>/symbols.sel`) — sinon « TestGenerator:
  <SYM> symbol not found », rapport vide, 0 tick (Luna EURGBP/AUDCAD, 18/09 soir). Les deux ajouts ne se
  font que dans l'interface ; le lanceur refuse (contrôles 3bis et 4), et c'est le bon comportement.
- Quand une erreur se répète alors qu'elle est notée, la réponse n'est pas une note de plus mais un chemin
  unique outillé et une règle CLAUDE.md. Voir [[methode-de-travail]].
