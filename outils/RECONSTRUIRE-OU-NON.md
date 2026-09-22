# Reconstruire Forex GOLD Investor et GOLD Scalper PRO ? Ce qu'il faut pour trancher

**Sa consigne du 22/09** : ces deux briques de réserve ne sont pas destinées à être achetées mais
**reconstruites, si elles en valent la peine**. Comme UBS l'a été avec Eagle-owl.

## 1. Pourquoi reconstruire, et pas acheter

Ce n'est pas une affaire de 484 $. Deux raisons de fond, déjà écrites pour UBS :

- **Un EA commercial est interdit en algo chez Axi Select.** Une reconstruction maison ne l'est pas.
  C'est ce qui a justifié Eagle-owl, et cela vaut ici à l'identique.
- **L'indépendance et la liberté de le challenger.** Un binaire acheté ne se règle que par ses
  paramètres ; un moteur maison se mesure, se dose et s'améliore.

## 2. Ce qu'on sait déjà de leur mécanique — et c'est peu

| | Forex GOLD Investor | GOLD Scalper PRO |
|---|---|---|
| Éditeur | FXAutomater (Krastev) | FXAutomater (Krastev) |
| Symbole / unité | XAUUSD M15 | XAUUSD M15 |
| Réglages mesurés | défaut du vendeur, lot fixe 0,01 | défaut du vendeur, lot fixe 0,01, **AutoMM 0** |
| Rapport 2021-2024 | **1,8** | **1,7** |
| Réserve 2025 | **7,3** | **8,1** |
| Signal réel | **aucun signal public** | 41 avis, 8 mois de réel, en **AutoMM 1 %** (d'où les 27 % de creux affichés) |
| Crible d'entrée | passé — la grille n'est pas le moteur | passé |
| Famille | cassure / impulsion sur l'or M15 | cassure / impulsion sur l'or M15 |

Corrélations mesurées le 20/09 : **+0,17 entre eux**, **+0,15 et +0,34** avec le livre or Eagle-owl,
**≈ 0** avec le hors or et le JPY D1.

**Ce qu'on ne sait pas, et c'est l'essentiel** : leur logique d'entrée. Personne n'a encore ouvert
leurs paramètres. On sait ce qu'ils rapportent, pas comment ils décident.

## 3. Ce qui a rendu Eagle-owl possible, et qu'il faut retrouver ici

La reconstruction d'UBS a marché pour trois raisons précises, pas par talent :

1. **Le mécanisme était lisible dans les `.set`** — stratégies, distances, plafonds, horaires. Rien
   n'a été deviné.
2. **Il existait un rapport de référence** pour mesurer la fidélité entrée par entrée
   (`fidelite_entrees.py` : communes, manquées, inventées).
3. **Le coût était accepté** : du 04/09 au 20/09, une quarantaine de versions pour arriver à 96,5 %.

**Les deux premières conditions se vérifient en une heure, sans rien coder.** C'est par là qu'il
faut commencer.

## 4. Les trois questions qui tranchent, dans l'ordre

**Q1. Le mécanisme est-il lisible ?** Ouvrir les deux démos dans MT5 et **exporter la liste de leurs
paramètres d'entrée**. Trois cas :
- les paramètres décrivent la logique (niveaux, ATR, sessions, distances, plafonds) → reconstruction
  possible, on continue ;
- ils sont opaques (« Risk », « Mode », « Sensitivity ») → la logique est cachée dans le binaire, la
  reconstruction devient de la rétro-ingénierie à l'aveugle. **Coûteux et incertain : on s'arrête.**
- la logique se révèle être une grille ou une récupération → éliminatoire, comme WallStreet
  Recovery PRO.

**Q2. A-t-on de quoi mesurer la fidélité ?** Oui, en principe : les backtests en ticks réels du
20/09 donnent déjà la liste des entrées de référence. À confirmer qu'on a bien les heures et les
prix, et pas seulement les agrégats. Sans cela, aucune reconstruction ne peut se contrôler.

**Q3. Le gain vaut-il le chantier ?** C'est la question que je pose en retour, et ma réponse
n'est pas évidente.

## 5. Mon avis, et il est réservé

**Pour** : les corrélations sont basses (+0,15 et +0,34 avec le livre or, ≈ 0 avec le reste), les
réserves 2025 sont excellentes (7,3 et 8,1), et une version maison est jouable chez Axi Select là
où l'originale ne l'est pas. C'est un vrai apport.

**Contre, et c'est le point à peser** : ces deux briques sont **de la cassure sur l'or M15**, comme
le reste du livre, qui est déjà **100 % cassure**. Le poste vacant est le **retour à la moyenne**.
Un chantier de reconstruction de plusieurs jours dépensé sur deux robots de la famille qu'on a déjà
en abondance, pendant que le poste vacant reste vacant, est un **coût d'opportunité**, pas seulement
un coût.

**Ce que je propose** : faire Q1 d'abord — une heure, aucun code. Si les paramètres sont lisibles,
on saura ce qu'on reconstruit et on pourra chiffrer le chantier. S'ils sont opaques, la question est
tranchée toute seule et on garde l'effort pour le poste vacant.

## 6. Les seuils, fixés d'avance

| Question | Seuil | Si raté |
|---|---|---|
| Lisibilité des paramètres (Q1) | la logique d'entrée se **déduit** des paramètres | rétro-ingénierie à l'aveugle : on renonce |
| Référence de fidélité (Q2) | entrées **horodatées** disponibles | pas de contrôle possible : on renonce |
| Fidélité de la reconstruction | **≥ 90 %** d'entrées communes, comme le seuil retenu pour Eagle-owl | pas adoptable |
| Réserve 2025 de la version maison | **positive**, et proche des 7,3 / 8,1 mesurés | la reconstruction a perdu ce qui faisait l'intérêt |
| Corrélation au livre or | **≤ +0,50** | redondant : disqualifiant |
