# Réserve 2025 des trois jeux argent de Till — protocole

Sa décision du 22/09 : on la lance. Voici ce qui existe déjà, ce qui manque, et les seuils.

## 1. Une partie existe déjà — et elle est positive

Mesuré le **19/09** (`outils/reserve2025.py`, neuf jambes rejouées en profil Kestrel, moteur
v1.34-v1.35) : **jambe argent Till, rapport 2,78 en échantillon → 1,86 en 2025, net +840 $.**
Verdict de l'époque : « tient ».

**Ce n'est pas suffisant pour trancher**, pour quatre raisons :

1. **C'est l'agrégat de la jambe, pas le détail des trois jeux.** L'échec en réel était concentré :
   12 trades, 0 gagnant. Les trois jeux sont-ils mauvais, ou un seul tire tout vers le bas ?
2. **C'est en profil Kestrel**, alors que l'argent est joué en **fidèle** dans le livre principal.
3. **C'est en v1.34-v1.35.** Le 20/09, la fidélité de l'argent est passée de 89,9 à 92,1 puis
   **95,8 %** (v1.45, v1.46). Le chiffre est périmé au sens de la règle : un chiffre sans sa version
   ne se reprend pas.
4. **Le dosage n'a pas été refait sur la volatilité courante** — et c'est le point décisif, ci-dessous.

## 2. Le point qui décide de tout : le régime, pas la rentabilité

Deux faits déjà écrits, et ils vont ensemble :

- **94 % du net des trois jeux a été réalisé en 2023-2024**, et la fenêtre d'optimisation du vendeur
  est inconnue. Un résultat concentré sur la fenêtre que le vendeur a probablement réglée n'est pas
  une preuve.
- **L'argent à 62 $ pèse environ 2,5 fois son modèle 2021-2024.** Le backtest n'a jamais vu ce
  niveau : pire trade −22 / −32 $, pire semaine −57 / −68 $ par jeu. Les 12 trades réels ont été
  stoppés à −37…−40 $.

**Conséquence de méthode, à ne pas sauter** : une passe 2025 au même lot fixe sous-estime le creux,
puisque le même lot porte environ 2,5 fois plus de risque aujourd'hui. **Le creux ne se lit qu'après
avoir redosé sur la volatilité courante.** Un rapport 2025 flatteur au lot d'origine ne veut rien
dire.

## 3. La passe

Une seule, en **v1.47**, profil **fidèle**, sur **2025**, les trois jeux **séparément**
(AGA04, AGA06, AGA09), puis :

1. `outils/mesure.py` sur le rapport — aucun chiffre ne sort d'ailleurs ;
2. `outils/parjeu.py <rapport> --csv` pour la série **mensuelle** jeu par jeu ;
3. `python outils/correlation_jambes.py <csv_argent_mensuel> mesures/parjeu_n132_eagleowl_or_b2_v147_mensuel.csv "argent Till" "jambe or SetsB2"` ;
4. redosage au **pire des deux moitiés**, puis lecture du creux.

## 4. Les seuils, fixés d'avance

| Question | Seuil | Si raté |
|---|---|---|
| Réserve 2025, les trois jeux ensemble | **positive** | dossier clos, l'argent sort du livre |
| Réserve 2025, **jeu par jeu** | chaque jeu **positif** | le ou les jeux négatifs sortent, pas toute la jambe |
| Creux **après redosage** sur la volatilité courante | tenable au dosage du livre | si le dosage tombe sous 0,01 lot, la jambe n'est pas jouable au capital prévu |
| Corrélation à la jambe or | **≤ +0,50** | redondance : disqualifiant, l'argent n'apporte rien à côté de l'or |
| Concentration | la part de 2023-2024 dans le net doit **baisser** une fois 2025 inclus | si elle reste à 94 %, le résultat reste un artefact de fenêtre |

Par-dessus : dosage au pire des deux moitiés ; **un rapport unique fait foi, jamais une recomposition
de séries** ; la jambe se juge à creux égal sur sa contribution, pas sur son rendement propre.

## 5. Ce qui manque pour livrer la commande au caractère près

Le chemin de lancement est unique (`CLAUDE.md`) :
`outils/lance_chaine.ps1 -Inis <nom>` — le nom d'un `.ini` de `Documents\forex`, sans extension.

**Le nom du `.ini` de l'argent n'est pas au dépôt** (`rapatrier.sh` n'a pas encore ramené les
`.ini`). Il ne sera pas inventé : le 18/09, deux lanceurs ont été écrits à la volée sans voir celui
qui existait. Une ligne suffit à le lire, dans Git Bash :

```bash
ls /c/Users/User/OneDrive/Documents/forex/*.ini | grep -iE "arg|xag|till"
```

Le nom obtenu, la commande de lancement se rend immédiatement.
