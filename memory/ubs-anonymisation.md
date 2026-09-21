---
name: ubs-anonymisation
description: "Consigne du 09/09/2026 — anonymiser commentaires, sets et magics d'UBS après le test du banc Ultima, pour que la source ne soit pas identifiable"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-09T19:19:48.066Z
---

**Sa consigne du 09/09/2026 au soir** : après le test du banc Ultima, changer **tous** les
commentaires de trade, noms de sets et **numéros de magic** d'UBS qui réfèrent à UBS, Ultimate
Breakout System, Profalgo, ou aux robots Profalgo qui le composent. *« Je ne veux pas que quiconque
identifie la source. »*

**Pourquoi c'est fondé** : `EA_Comment` part au serveur avec chaque ordre et reste dans l'historique
du compte. Quatre des quatorze noms sont des produits commerciaux vendus sur MQL5 — **Gold Reaper 4
à 7**, **goldtrade_D/E/H**, **DaytradePro_XAUUSD**, **GoldbotOne_8**. C'est le motif classique de
refus de paiement en prop firm. Voir [[propfirm-choix-maison]].

**Quand** : PAS avant la fin du banc. Ces commentaires sont ce qui permet d'attribuer le glissement
jeu par jeu, et d'isoler M5_C et M5_H, les deux seuls jeux du livre qui entrent au marché. Voir
[[banc-mesure-ultima]]. Et à appliquer **livre à plat**, sinon les positions ouvertes deviennent
orphelines de leur jeu.

**La table de correspondance complète est écrite** dans `outils/UBS-ANONYMISATION.md` : les 14 jeux
deviennent `Ibis-01` à `Ibis-14`, magics `20261001` à `20261014` (convention maison 2026MMJJ, aucun
conflit avec Zebra 20260901/02/03 ni Heron 20260904). **Ibis-09 = ex M5_C, Ibis-10 = ex M5_H**, les
deux jeux à entrée au marché.

**À vérifier avant d'appliquer, pas à supposer** : qu'UBS suit ses positions par le magic et non par
le commentaire. Un changement qui casserait le suivi resterait invisible jusqu'au premier trade mal
géré.

**Ce que ça ne fait pas** : ça protège l'historique des trades, pas le poste. Le fichier reste
`Experts\Market\Ultimate Breakout System.ex5`, le nom compilé s'affiche dans le Navigateur, et le
produit figure dans l'onglet Marché du compte MQL5. Inutile face à un partage d'écran.
