---
name: sources-goldinghedge
description: Les sources web qui documentent le code dont Goldinghedge est rebadge - a consulter avant toute hypothese sur ses parametres
metadata: 
  node_type: memory
  type: reference
  originSessionId: 82d3828f-2f80-4d36-bead-d03e08c7569e
  modified: 2026-08-26T16:20:20.439Z
---

Trouvees le 26/08/2026 sur sa suggestion — « il n'existe aucune littérature ? ». Il y en
avait. **A consulter AVANT de formuler une hypothese sur un parametre**, pas apres l'avoir
testee : elles ont deja corrige deux verdicts faux et confirme quatre mesures.

Goldinghedge est introuvable sur le web, **mais son code est rebadge** : un produit nomme
**« Larry Fx EA MT4 »** expose exactement le meme jeu de parametres avec exactement les
memes valeurs par defaut — douze valeurs identiques.

## La source principale

**https://eafxstore.com/blog/larry-fx-ea-mt4-settings/** — le tableau complet des
parametres avec leur description. C'est celle qui a livre le plus.

Le domaine est bloque par `WebFetch` sur la page produit mais **accessible sur la page
blog**. `sys-tre.com` et `eaforexstore.com` (memes EA) sont bloques.

Autres membres de la meme famille, non explores : **Massive Engine EA**, **Gold Veritas**,
**Blitz Trendpro**, **Excellence Code**, **Breakouts Master**, **EA Thomas**, **Prado**,
**North East Way**, **Trade Angel**, **Snowballed** — tous trouves avec la meme DLL de
crack dans son dossier `forex`, donc probablement la meme base de code.

## Ce que la source a CONFIRME

| parametre | wording de la source | notre mesure independante |
|---|---|---|
| `MinProfit = 10` | « active la gestion de trailing apres **10 points de profit** » | seuil d'armement du stop : zero stop pose en perte sur 1 051 poses |
| `StopProfit = 30` | « securise les profits apres 30,0 » | sortie directionnelle, minimum **exactement 30,00** |
| `MinDistance = 80` | « **distance minimale entre les ordres** » | contrainte de pose : ecart 1,17 -> 1,80 quand on l'impose |
| `CloseAll = 5.0` | « ferme tout quand la condition atteint 5,0 » | minimum **exactement 5,00**, 638 fois |

## Ce que la source a CORRIGE

1. **`TrailingStop = 1` = mode « Candle trailing »**, pas « Fractales ». Le panneau de
   l'utilisateur affiche « Fractales » mais le mode 1 suit l'**extreme de bougie**. La
   page precise que l'EA dispose de « candle, fractal **and pip** trailing stop methods » —
   plusieurs modes, le 1 est celui de la bougie. Explique pourquoi les fractales Bill
   Williams ne reproduisaient que 5,2 % des poses contre 58 a 64 % pour l'extreme H1.
2. **`iCount = 5` limite les « niveaux d'ordres simultanes »**, pas les positions. Mais
   attention : l'interpretation « donc l'original tient 4 ordres en attente » en a ete
   tiree et s'est revelee FAUSSE le soir meme (artefact d'un episode unique). **Le sens
   reel de `iCount` reste inconnu.**

## Ce que la source ne donne PAS

Interrogee directement sur la mecanique, elle ne repond a **aucune** de ces questions :
comment un ordre en attente est deplace une fois pose, ce que `iCount` limite exactement,
comment le prix du niveau suivant est calcule, ce qui declenche la pose d'un nouveau
niveau. **Elle documente des valeurs, pas des mecanismes.** Ceux-la ne s'obtiennent que
par la mesure sur les journaux.

## Source secondaire, utile pour le vocabulaire

La litterature generique sur les grilles MT4 donne la semantique standard d'un « trailing
step » : *« distance depuis le prix ou la modification precedente a eu lieu, qui doit etre
parcourue avant d'en placer une nouvelle »*. **Attention : cette semantique generique a
ete testee sur Goldinghedge et NE correspond PAS** — ses repositionnements sont continus,
mediane 1 seconde, 93,4 % sous 2 secondes. Le vocabulaire d'une famille ne vaut pas
mesure sur un individu.

**Why:** il a dit « ce sont nos bibles ». Elles valent surtout parce qu'elles ont
corrige des erreurs que la mesure seule n'avait pas vues — l'etiquette « Fractales » nous
a coute une soiree.

**How to apply:** avant d'emettre une hypothese sur un parametre, verifier d'abord si la
source en parle. Mais ne jamais substituer sa description a une mesure : c'est de la
documentation commerciale sur un produit voisin, pas la specification du binaire.
Voir [[lazyalgo-multistrategy-state]] et [[feuille-de-route-clone]].

## LES PARAMETRES REELS DE L'ORIGINAL SONT IMPRIMES DANS TOUT RAPPORT DE BACKTEST

Decouvert le 28/08 apres avoir passe la journee a les reconstruire par la mesure. **Lancer
n'importe quel backtest de « Goldinghedge trial » et lire la section Parametres du .htm.**

```
FirstStep=50      MinDistance=80     Step=80        MinDistance1=30   Step1=80
iCount=5          StepTrallOrders=5  MaxLoss=100000 MaxLossCloseAll=5
lot=0.01          PlusLot=0          K_Lot=1.3      DigitsLot=2
CloseAll=5        StopProfit=30      StopLoss=100000  Magic=94  MinProfit=10
TrailingStop=1    TrailingStep=0     delta=0        TF_Tralling=0
Buy=true  Sell=true  FirstOrder=true  OpenTrend=false  sj=false
star=1  end=20  Key=0  m="time"
Parametres_du_Trailing_Stop = "Fractales, ..."
contact_details = "Telegram : @mathiscalp"
```

**CONFIRMENT mes mesures** : FirstStep 0,50 ; Step 0,80 ; MinDistance 0,80 ; K_Lot 1,3 ;
lot 0,01 ; CloseAll +5 (porte 1) ; StopProfit +30 (porte 2) ; MinProfit 10 points (porte 3).

**CORRIGENT ou completent :**
- **`MaxLossCloseAll=5`** = le seuil de perte du sens perdant que j'avais mesure a « toutes
  les fermetures sous -4 ». Coherent (bande ouverte). **Valeur a retenir : 5.**
- **`StepTrallOrders=5`** alors que le pas du cliquet MESURE vaut 0,0625, soit 6,25 points
  (signature 75/25 entre 0,06 et 0,07, reproduite exactement). **Les deux ne concordent
  pas** — StepTrallOrders n'est donc pas le pas en points du prix. Non resolu.
- **`MinDistance1=30` et `Step1=80`** : une SECONDE grille, jamais modelisee. Piste la plus
  serieuse pour la construction du cote faible et la queue des gros paniers.
- **`iCount=5`** : declare, mais les paniers atteignent 32 positions — donc pas un plafond
  de positions. Role inconnu.
- **`star=1` / `end=20`** ressemblait a un filtre horaire : **REFUTE**, l'original pose des
  ordres a 21h, 22h et 23h.

**LECON** : chercher la documentation avant de reconstruire. J'ai infere par la mesure des
valeurs qui etaient imprimees dans chaque rapport.
