---
name: vps-acces-chien-de-garde
description: FAIT le 13/09 — SSH par clé sur les deux VPS et chien de garde MT5 (alerte seule, toutes les 5 min, pont MetaTrader5) déployé sur Londres et NY4 ; Telegram à renseigner par lui
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-15T07:29:42.694Z
---

**Sa décision du 12/09/2026, à faire le 13/09 :** donner à Claude un accès au VPS NY4 et construire un
dispositif d'intervention si quelque chose tourne mal chez un courtier.

**Ce qui a été convenu :**
1. Accès **A** d'abord : tâche planifiée `robocopy` des journaux MT5 du VPS vers `OneDrive\Documents\forex\vps-ny4\`
   (lecture seule, zéro accès entrant). Accès **B** (OpenSSH Server sur le VPS, clé publique posée par lui dans
   `administrators_authorized_keys`) seulement s'il veut que Claude agisse sur le VPS. **Jamais de mot de passe.**
2. **Chien de garde** Python (`MetaTrader5`, s'attache au terminal connecté) sur le VPS : terminal connecté,
   fonds propres au-dessus du seuil, positions plausibles, erreurs d'EA. **Première semaine : alerte seule, sans
   action, sur le compte cent Ultima.** Le droit de fermer vient après, courtier par courtier, selon des règles
   d'engagement écrites par lui (seuil, action).
3. Claude n'est pas en veille : il agit sur demande en session ; c'est le chien de garde qui réagit seul.

**Why :** il fait tourner de l'argent réel sur un VPS distant, et la seule mesure existante (glissement) se lit
dans des journaux qu'il faut d'abord rapatrier.

**How to apply :** le 13/09, commencer par A (dix minutes), puis le chien de garde en lecture. Ne pas proposer
d'action automatique avant les règles écrites et une semaine d'alertes. Voir [[vps-ny4]].

**FAIT le 13/09** : option B (SSH par clé) sur les deux VPS ; Python 3.12 + `MetaTrader5` installés ; `chien_de_garde.py`
(`outils/vps/`) déployé dans `C:\Users\Administrator\chien_de_garde\` sur Londres (Ultima) et NY4 (Ultima, Vantage,
Axi, PU Prime), tâche « Chien de garde MT5 » toutes les 5 min, session `trader`, résultat 0. Seuils par défaut : perte
flottante 5 %, perte du jour 3 %, 40 positions, marge 300 %, journal muet 30 min. Alertes dans
`chien_de_garde_alertes.log` (lu par SSH) + Telegram dès qu'il pose jeton/chat dans le json. **Aucune action** sur les
positions tant qu'il n'a pas écrit les règles d'engagement et qu'une semaine d'alertes n'est pas passée.

## 15/09/2026 — Revue hebdomadaire des trades
Tâche Windows « Revue hebdo banc », lundi 08:00 : `outils/revue_hebdo.cmd` exporte les positions fermées des deux VPS
(`outils/vps/deals_export.py`, copié dans `C:\Users\Administrator\chien_de_garde\` sur chaque VPS) et lance
`outils/revue_hebdo.py` → `outils/signaux/revue_YYYYMMDD.txt`. Chaque jeu est jugé contre la distribution des semaines de son
rapport de référence 2021-2024 (P10-P90) ; USC du compte cent ≡ $ à 0,01 lot standard. Test 21 de TESTS-A-REALISER.md.
Première revue 10-14/09 : Londres percentile 22, Vantage 50 ; mêmes jeux, même jour, résultats opposés entre courtiers (à suivre).
