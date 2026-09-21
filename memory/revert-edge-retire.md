---
name: revert-edge-retire
description: Revert Edge retiré le 03/09 — je le recommandais sur un backtest alors que ses acheteurs mesurent un facteur de profit sous 1
metadata: 
  node_type: memory
  type: project
  originSessionId: ad015105-f722-4c5f-9697-c4b1c268474a
  modified: 2026-09-03T09:22:11.863Z
---

**Retiré le 03/09/2026 à 11 h 15.** Je le recommandais depuis la veille comme
seconde jambe, sur la foi d'un backtest : PF 1,57 sur 2012-2025, et **+22 % de
rendement à creux égal** ajouté à Gold Phantom. **C'était une erreur de méthode.**

**Ce que dit le réel :**
- **999 $**, note **2,64/5** sur 12 avis, **aucun signal live**
- un acheteur, six mois de démo : **facteur de profit 0,27 à 0,96**, perte 44-71 %
- « après la mise à jour 2.0, le backtest ne correspond pas au réel »
- l'EA est en **version 4.30** après plusieurs **changements de stratégie**
- auteur Levi Dane Benjamin / DaneTrades

**La leçon, et elle est structurelle :** un EA réécrit plusieurs fois puis
backtesté sur treize ans est ajusté à cette histoire **par construction**. Aucun
backtest ne peut le détecter, puisqu'on teste la version finale sur les données
qui l'ont façonnée. **Le numéro de version est un signal en soi** — v4.30 après
« changements de stratégie » invalide tout backtest long.

**À ajouter au crible** : avant de mesurer un EA, regarder son **numéro de
version** et l'historique des mises à jour. Une version élevée + des changements
de stratégie annoncés = backtest long sans valeur.

**Trend Alpha écarté aussi** : 499 $, même auteur, aucun signal live, 1 avis,
218 démos — et c'est une cassure de plage sur indices, redondante avec les
stratégies US30/US500/USTEC d'[[profalgo-un-seul-moteur]] et avec ORB by ARGUS.

Voir [[backtest-refute-ne-confirme-pas]], [[pas-de-formule-de-portefeuille]].
