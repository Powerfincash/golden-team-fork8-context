---
name: banc-mesure-ultima
description: "Compte cent Ultima Markets lancé le 09/09/2026 comme banc de mesure du glissement réel, pas comme portefeuille de rendement"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-09T18:36:11.591Z
---

Compte **cent** Ultima Markets Live 1, n° 33982313, solde **80 057,84 cents = 800,58 USD réels**.
Terminal `43A9BD896CCB6BF2DF5C71EA198AE39D`. Lancé le **09/09/2026 au soir**.

**Ce qui y tourne, tout en lot 0,01** : Zebra_v1 sur `XAUUSD.sc`, `EURUSD.sc`, `GBPUSD.sc` en H1
(magics 20260901/02/03, sets dans `MQL5\Presets\Zebra`) + **UBS, 14 jeux or**, un seul graphique
`XAUUSD.sc` en M15, set `MQL5\Presets\UBS\ubs_or_14jeux.set`.

**Ce n'est PAS un portefeuille de rendement.** À 0,01 lot sur un compte cent, l'exposition réelle est
au centième : le dosage mesuré vaudrait 0,40 / 4,00 / 4,00 pour Zebra. Rendement attendu ≈ **9 cents
par mois**, creux attendu ≈ 4 $. C'est **un banc de mesure du glissement réel**, seul chiffre qui
manquait au livre. Ne pas juger la performance dessus ; monter les lots seulement après la mesure.

**Ce qu'il faut en tirer en priorité** : le glissement de **M5_C et M5_H** (magics 87003 et 87008),
les deux seuls jeux du livre qui **entrent au marché** — 100 % de leurs entrées dans les 5 premières
secondes d'une minute, contre 5-16 % pour les douze autres, qui posent des ordres stop. Voir
[[ubs-or-ticks-reels]] et [[a-completer-apres-ubs]].

**Pièges rencontrés à l'installation, à ne pas refaire** :
- les 14 sets de `Common\Files\SetsB` portent `ForceSymbol=XAUUSD.p` → copie adaptée dans
  `Common\Files\SetsUltima` avec `XAUUSD.sc`, **SetsB laissé intact** pour le testeur ;
- `Risk=0` + `StartLots=0.01` + `AdjustLotsizeToVariableValues=false` sont obligatoires : sinon UBS
  dimensionne sur le solde affiché (80 057) et pose 8× les lots du backtest ;
- UBS exige un compte MQL5 actif dans le terminal, et l'URL `https://www.worldtimeserver.com/`
  autorisée (AutoGMT) sans quoi aucun set ne se charge.

**Réseau** : VPN NordVPN coupé le 09/09 — il faisait voir au courtier des IP de pays différents sur un
compte réel. Un seul incident réseau non provoqué en onze jours, rattrapé en 0,6 s. Veille et veille
prolongée déjà désactivées. Le terminal n'avait jamais passé une nuit allumé avant celle-ci.

**17/09 — première lecture au jour (9 jours, Ultima cents réels VPS Londres / Vantage démo VPS NY4)** : glissement réel sur stop chez Ultima :
or médiane +0,14 $ (max +1,39), Bitcoin +7 $ (max +96), devises 0 ; Vantage démo 0 partout → la démo ne mesure pas l'exécution. **Argent Till
(AGA04/06/09) : −455 USC en 12 trades à −37…−40 $ chacun, percentile 0 de la référence n134** — le backtest 2021-2024 n'a jamais vu l'argent à
62 $ ; les distances scalées par prix/DefaultValue font des stops ~2,5× plus gros qu'en moyenne 2021-2024 : la jambe argent du turbo pèse ~2,5×
ce que le livre modélise. Hors argent, les deux bancs sont dans la distribution. `revue_hebdo.cmd` ne réécrit pas les CSV (à corriger).


## 20/09 soir : argent Till RETIRÉ du live (sa décision), Vantage réel sur VPS Londres

Revue du 20/09 (`revue_hebdo.py 9`, exports SSH des deux VPS) : Ultima cents 13-18/09, 101 positions, −427 USC dont **−455 pour les
trois jeux argent Till** (12 trades, 0 gagnant, sous le P10 pour la deuxième revue ; l'argent à 62 $ n'existe pas dans 2021-2024) ;
le reste +28 USC, dans la distribution. **Dossiers `Common\Files\SetsUltima_XAG` et `SetsVantage_XAG` renommés `_retire_20260920`
sur le VPS Londres** ; l'instance UBS déjà chargée garde les jeux en mémoire jusqu'à réinitialisation → lui demander de fermer le
graphique XAGUSD (ou redémarrer le terminal Ultima) avant l'ouverture du lundi. BTC gardé (R8/R9 au-dessus du P90, glissement
mesuré : stops Reaper 1 +33 $ médian — réserve du 06/09 toujours ouverte). **Vantage : compte RÉEL 34803874 (USD) créé par lui le
18/09 sur le VPS Londres** (latence) ; l'export NY4 du 20/09 ne montre plus que ce compte (3 positions : Zebra ×2, AS ×1, aucun jeu
UBS) — le profil Vantage Londres a 9 graphiques (Zebra ×3, UBS or/EUR/GBP/JPY, Heron ×2) : à vérifier quels jeux tournent réellement.
