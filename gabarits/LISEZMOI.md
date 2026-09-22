# Gabarits de pages

## `quatre-standards-21-09-2026.html` — page « Quatre Standards — Portefeuille »

**C'est LE gabarit. On le reprend tel quel, on ne réinvente jamais la mise en page.**

Récupéré le 22/09/2026 depuis l'artefact publié
<https://claude.ai/code/artifact/3e284374-0491-4826-8d64-5cb8ea8cfa10>
(alias <https://claude.ai/artifact/8gBCb4uY5GdWvemSy48p9V>), version du 21/09/2026 au soir.
Sur le PC, la source vit dans `outils/quatre_standards_18-09.html` (versions antérieures :
`quatre_standards.html` du 13/09, `_bis`, `_ter` du 15/09).

### Règles de la page, dans l'ordre où elles ont été rappelées

1. **Rien ne se retire.** Toutes les rubriques de `QUATRE-STANDARDS-*.txt` et de la sortie de
   `etat_portefeuilles.py tout` sont dans la page : rapport hors tirage, rapport d'ajustement,
   net 4 ans, creux, rendement, **capital minimum**, instances, **mensuel médian ET moyen**,
   mois négatifs, pire mois, délais, trades par semaine. Reproché deux fois (12/09 et 13/09).
   Si une rubrique doit disparaître, le dire dans le message, jamais en silence.
2. **Toutes les variantes d'une jambe restent dans la page** (SetsB / SetsB2, AdvSc backtest MT4 /
   AdvSc au protocole n113, UBS / Eagle-owl). Code couleur :
   - **fond rosé** (`.config.regle`, badge `À PRIVILÉGIER`) = la variante à privilégier pour ce
     type de compte, selon la règle du 17/09 ;
   - **fond jaune** (`.config.alt`, badge `ALTERNATIVE ADMISE`) = alternative UBS tant que le
     moteur maison n'est pas fidèle ;
   - **fond gris** (`.config.info`, badge `POUR INFO`) = conservé pour mémoire.
3. **La page montre les portefeuilles-type retenus et leurs chiffres. Jamais la liste des EA
   éliminés** (retirée à sa demande le 21/09).
4. **Chaque chiffre porte sa date.** Le titre porte la date de la page ; les blocs de mise à jour
   en tête disent quelle mesure a bougé et laquelle n'a pas été rejouée.

### Pour republier

Passer l'URL de l'artefact ci-dessus en `url` de l'outil Artifact (lire d'abord, publier ensuite),
sinon un doublon est créé et l'ancien lien continue de vivre avec de vieux chiffres.

Les chiffres des variantes se produisent avec `outils/standards_variantes.py` (jambe or SetsB2
imposée ×1 pour les blocs « règle » : sans la contrainte l'optimiseur écarte l'or et le rapport
hors tirage tombe).
