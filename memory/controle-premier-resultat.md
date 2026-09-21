---
name: controle-premier-resultat
description: "Sa remarque du 03/09 — je vérifie à la fin d'une file au lieu du premier résultat, et MT4 échoue en silence"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ad015105-f722-4c5f-9697-c4b1c268474a
  modified: 2026-09-02T22:33:27.213Z
---

**« pourquoi il a encore fallu te le dire pour que tu réagisses ? »** — 03/09/2026, 00 h 30.

Ce qui s'était passé : j'avais lancé une file de quatre backtests Advanced Scalper
avec un fichier `.set` que MT4 a **silencieusement refusé** (guillemets autour des
chaînes et lignes vides — format invalide). Aucune erreur, aucun message dans le
journal : le rapport était simplement faux. Ma sonde ne se déclenchait qu'à la fin
des quatre passes. Sans sa question « un test a fini ? », les quatre seraient
parties fausses et je lui aurais annoncé des chiffres inventés au réveil.

**Pourquoi c'est grave :** j'avais déjà écrit `chien_de_garde.sh` pour exactement
ce problème, et j'ai le précédent du `.ini` en UTF-16 que MT4 ouvre, journalise et
lit vide. Le principe existait, je ne l'ai pas appliqué.

**Comment l'appliquer :** toute file de passes vérifie son **PREMIER** résultat
contre une condition explicite, et s'arrête si le contrôle échoue — jamais un
contrôle qui ne se déclenche qu'à la fin. Implémenté dans `nuit4_scalper.ps1` :
`Select-String -Pattern "LotPerBalance_step=1000"` sur le rapport, puis `break`.

Et avant une file longue, une **passe de contrôle courte** (un an, deux minutes)
qui vérifie que le paramètre est bien lu. Deux minutes contre une nuit.

**La règle générale :** MT4 échoue en silence. Tout ce que je lui donne — `.ini`,
`.set`, encodage — se vérifie sur son premier résultat, pas sur le dernier.

Voir [[methode-de-travail]], [[mt5-pieges-outillage]], [[garde-fous-mesure]].
