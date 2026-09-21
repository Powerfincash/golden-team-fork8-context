---
name: pine-sans-compilateur
description: Aucun compilateur Pine dans cet environnement - relire et controler avant d'envoyer une version
metadata:
  type: feedback
---

Il n'y a **aucun moyen de compiler du Pine Script** ici, et le navigateur
(claude-in-chrome) n'est pas connecte. Toute erreur de syntaxe n'apparait donc que
chez l'utilisateur, apres un copier-coller manuel.

Le 22/08/2026 j'ai envoye trois versions successives du combo TradingView sans les
relire, en supposant tour a tour un probleme de transparence puis de version chargee.
La vraie cause tenait en quatre lignes : **Pine n'a pas d'affectation composee**
(`x += 1` est interdit, il faut `x := x + 1`). L'utilisateur a du me dire
« restez concentre » puis « assez joue ».

**Why:** chaque version envoyee coute a l'utilisateur un Ctrl+A, un collage et un
aller-retour. Trois cycles perdus sur un instrument de mesure, pas sur la strategie.

**How to apply:**
- Avant tout envoi de Pine, relire ligne a ligne le code **nouvellement ecrit** et
  faire tourner le controleur maison (balance des parentheses, affectations
  composees, `:=` sur variable non declaree, indentation des continuations).
- Autres pieges deja rencontres : `vwap` -> `ta.vwap` en v5 ; une fonction ne peut
  pas etre declaree dans un bloc `if` ; la taille d'un `plotshape` doit etre une
  constante ; un oscillateur et des prix ne peuvent pas partager une echelle
  (`force_overlay` casse l'echelle de la fenetre).
- **Numeroter les versions** dans une banniere en tete ET dans le `shorttitle`, pour
  que la legende du graphique dise laquelle tourne. Sans ca on perd des echanges a
  savoir quelle version est chargee.
- Quand un outil de diagnostic coute plus que ce qu'il mesure, l'abandonner :
  l'entonnoir equivalent existe deja cote MQL5. Voir
  [[lazyalgo-multistrategy-state]] et [[backtest-acceptance-criteria]].
