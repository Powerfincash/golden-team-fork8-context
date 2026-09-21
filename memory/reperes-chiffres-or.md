---
name: reperes-chiffres-or
description: Les trois chiffres de reference a rappeler a l'utilisateur - or H1, portage, et l'alternative a battre
metadata:
  type: project
---

Transmis par l'utilisateur le 22/08/2026, depuis la session LazyAlgo. **Il a demande
explicitement que je les lui rappelle** — ils viennent d'une autre session et leur
derivation n'est pas dans mon contexte : les restituer tels quels, sans les
reinterpreter ni les recalculer de tete.

| Repere | Valeur |
|---|---|
| Or en H1, mesure | **PF 0,99** |
| Portage de l'or | **2 % / an** |
| **L'alternative a battre** | **10 % / an pour −47 % de drawdown** |
| **Sa reference de rendement, dite le 04/09/2026** | **45 % / an pour 25 % de creux au maximum — c'est ce que Gold Phantom lui a donne** ; toute alternative doit faire au moins cela |

**Ce que ca veut dire pour le projet.** Un PF de 0,99 sur l'or en H1, c'est le seuil de
non-rentabilite : la strategie ne perd pas d'argent, elle n'en gagne pas non plus. Et
detenir l'or sans rien faire rapporte 2 % par an. Toute strategie active sur l'or doit
donc d'abord battre 2 % avant de meriter la moindre complexite.

Le troisieme chiffre est le vrai juge : **10 % par an avec −47 % de creux**, c'est le
niveau de reference qu'un systeme doit surpasser pour justifier son existence — sinon
autant acheter et attendre. Un systeme qui ferait 8 % par an avec un drawdown de 20 %
serait, lui, superieur en rendement ajuste du risque meme s'il rapporte moins.

**Le 04/09/2026, il a corrige deux fois de suite ma lecture** : la reference est
**45 %/an pour au plus 25 % de creux** — dans cet ordre. A ne pas confondre avec la mesure du
clone Goldinghedge (25,1 %/an pour ~40-50 % de creux), qui est un resultat obtenu et juge
insuffisant, pas une reference. J'avais inverse les deux nombres dans une phrase, puis
maintenu l'erreur en relisant mes notes : « Tu ne me rassures toujours pas ».

**Why:** l'utilisateur a lui-meme pose la question de savoir si le trading rapporte plus
qu'un indice. Ces trois chiffres sont sa reponse chiffree, et sa regle d'arret : sans
les battre, un systeme ne vaut pas les soirees qu'il coute.

**How to apply:** les ressortir des qu'un backtest affiche un resultat « prometteur »,
avant de se rejouir. Voir [[backtest-acceptance-criteria]] et
[[lazyalgo-multistrategy-state]].
