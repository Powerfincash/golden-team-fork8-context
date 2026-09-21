---
name: inventorier-avant-de-lancer
description: La règle de la nuit du 03/09 — inventorier et classer ce qui existe déjà sur le disque AVANT de lancer un calcul
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ad015105-f722-4c5f-9697-c4b1c268474a
  modified: 2026-09-02T22:58:34.534Z
---

**« Quel manquement encore une fois ! Tu rates vraiment tout. »** — 03/09/2026, 1 h.

Trois échecs dans la même nuit, et **c'est la même erreur trois fois** :

1. J'ai bâti une file de quatre backtests sur le jeu de paramètres `a1`, qui est
   l'**avant-dernier des huit** (rapport gain/creux 0,79 contre 8,18 pour `a5`).
   Les huit rapports étaient sur le disque depuis deux jours ; le classement a
   pris une commande, lancée seulement après qu'il m'ait dit d'arrêter.
2. Mon fichier `.set` était refusé en silence par MT4 — d'abord des guillemets,
   puis un `\r\r\n`. Un `.set` valide (`Wolf 2.0 EURUSD.set`) était dans le même
   dossier ; le comparer prenait dix secondes.
3. J'ai bâti des tables de levier sur 4,9 % de creux alors que le vrai est
   19,75 %. **Les deux chiffres sont dans le même en-tête de rapport.**

**Le fil commun : je produis du travail neuf au lieu de lire ce qui est déjà là.**
Les trois réponses existaient avant que je commence. Et les trois fois, c'est sa
question qui a débloqué — « un test a fini ? », « le max DD n'était pas plutôt
20 % ? », « si le concepteur ne les a pas proposées, j'en doute ».

**La règle :** avant de lancer un calcul, **inventorier ce qui existe déjà sur le
disque et le classer.** Rapports, fichiers de réglages livrés par le concepteur,
en-têtes complets. Un `find` et un tri valent des heures de testeur.

Corollaire déjà appliqué ailleurs : [[controle-premier-resultat]].
Détail chiffré dans `forex/outils/POURQUOI-CETTE-NUIT-A-RATE.md`.

Voir [[methode-de-travail]], [[garde-fous-mesure]].
