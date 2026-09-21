---
name: ecarts-rentables-a-garder
description: "Sa consigne du 19/09/2026 — ne pas perdre les versions du moteur qui BATTAIENT UBS tout en s'en écartant : la fidélité est un objectif, la rentabilité en est un autre, et une version écartée pour infidélité peut devenir un robot autonome"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d0e7cce4-cea8-47de-9dd2-1ae784bc5f8a
  modified: 2026-09-19T10:22:22.799Z
---

Le 19/09/2026, après trois versions d'Eagle-owl adoptées au nom de la fidélité à UBS et un recul de plusieurs rubriques
de la page des standards, il a écrit : « il serait peut-être bon de garder en mémoire ce qui battait UBS mais s'en
écartait pour en faire un robot autonome et ne pas perdre cette rentabilité ».

**Why :** le chantier Eagle-owl a un but déclaré — reproduire UBS pour le comprendre, le porter sur MT5 et brouiller
l'empreinte sur les prop firms. Mais « plus fidèle » et « plus rentable » ne sont pas le même axe, et j'ai passé la
journée à optimiser le premier en traitant le second comme un simple sous-produit. Or les entrées « inventées » que je
supprime version après version sont souvent GAGNANTES : sur Reaper 6 elles valaient +362 $ en v1.31 et encore +218 $ en
v1.32 ; sur le livre or la jambe v1.31 rendait 100,3 % du net d'UBS avec 17 % de positions en trop. Une version écartée
comme infidèle est peut-être un bon robot autonome — et si je l'écrase sans la mesurer ni la nommer, cette valeur est
perdue pour de bon.

**How to apply :**
1. **Ne jamais écraser une version sans garder son rapport.** Les copies `n*_eagleowl_*_v1XX.htm` du dossier du terminal
   sont cette mémoire ; les conserver et les nommer par la version, pas par la chaîne qui les a produits.
2. **À chaque adoption, dire les deux choses** : ce que la version gagne en fidélité (communes / manquées / inventées,
   `fidelite_entrees.py`) ET ce qu'elle coûte ou rapporte en résultat. Si la version adoptée est moins rentable que celle
   qu'elle remplace, l'écrire explicitement et garder la précédente comme candidate autonome.
3. **Tenir une liste des candidates autonomes** dans `outils/TESTS-A-REALISER.md` : version, jeu ou livre concerné, ce
   qu'elle faisait de plus qu'UBS, son résultat à creux égal, et le rapport qui le prouve.
4. Une candidate autonome se juge comme n'importe quelle jambe : contribution au portefeuille à creux égal, corrélation
   sous +0,5, et **réserve 2025 obligatoire** avant toute admission — voir [[portefeuille-sport-collectif]],
   [[backtest-refute-ne-confirme-pas]].

**Inventaire du 19/09 (creux de solde approché, à refaire avec `mesure.py` avant toute décision)** — ce que les versions
écartées valaient sur leur banc mono-jeu, contre UBS :
- **CHFJPY : le moteur en v1.27/v1.29 fait TROIS FOIS le rapport d'UBS** — 190 positions, +730 $, creux 65, rapport 2,80,
  contre 159 positions, +447 $, creux 119, rapport 0,94. **v1.30/v1.31 l'ont détruite** (rapport 0,90). Meilleure
  candidate autonome connue.
- **AGA04 argent : v1.26 à v1.29** — +1 363 $ / creux 181 / rapport 1,88 contre 1 190 / 180 / 1,66 chez UBS.
- Reaper 6 : v1.19/v1.29 font 178 % du net d'UBS mais à rapport égal (2,36 contre 2,40) : levier de VOLUME, pas
  d'avantage par trade. Même chose pour le livre or (104 % du net, rapport 3,14 contre 4,10) et GBPUSD.
Détail et tableau dans `outils/TESTS-A-REALISER.md` (19/09 13 h).

Voir [[moteur-multi-jeux]], [[garde-fous-mesure]] (l'agrégat qui tombe juste), [[meilleur-a-ce-jour]].
