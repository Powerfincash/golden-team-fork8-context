---
name: vantage-cent-indices
description: "Vantage propose des comptes cent AVEC indices — la seule façon de trancher la question des indices, ouverte depuis le 06/09/2026"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8bdaad5-dac5-4fdf-8d5a-2dc87bb80f85
  modified: 2026-09-10T08:42:55.326Z
---

**Son information du 10/09/2026** : *« Vantage fournit des comptes cent avec indices ! Faudra tester
aussi. »*

## Pourquoi ça compte : ça débloque une question qui traîne

Le rôle des indices est **ouvert depuis le 06/09** ([[a-completer-apres-ubs]]) et il l'est pour une
raison précise : **on n'a pas de quoi mesurer**. Les 13 jeux DJ30/NAS100/SP500 d'UBS sont les seuls
corrélés positivement à l'or (+0,33, +0,17, 0,00) et **annulent l'apport des autres** — les 30 jeux
ensemble ne donnent que +7 % là où les 17 sans indices donnent +74 %.

Mais ce verdict repose sur **14 mois sur 48** : PU Prime n'a d'historique indices que depuis 2023, et
94 % du résultat vient de la seule année 2024, sans réserve possible. Voir [[ubs-hors-or-mesure]] et
[[zebra-indices]], où le classement des quatre indices reproduisait exactement leur écart/ATR.

Un compte cent avec indices permettrait **la mesure en direct** — écart réel, glissement réel — au
lieu d'un backtest sur une fenêtre trop courte. Exactement la logique du [[banc-mesure-ultima]] :
exposition dérisoire, information réelle.

## MESURÉ LE 10/09 : `DJ30.r`, historique depuis 2018

Compte démo **26077080** ouvert le 10/09, 1 083 symboles. Le Dow s'appelle **`DJ30.r`** et son
historique remonte à **2018** — sept ans, incluant **le krach de mars 2020 et la baisse de 2022**.

**C'est exactement ce qui manquait.** Trois dossiers étaient bloqués faute de fenêtre contenant une
baisse : les 13 jeux indices d'UBS (jugés sur 14 mois, 94 % du résultat en 2024), Zebra sur indices
(historique depuis fin 2023), et Wall Street Scalper. Les trois deviennent mesurables — sans TDS,
sans import, sans bricolage.

Premier usage : Wall Street Scalper, mesuré sur sept ans. Il **gagne** en 2020 et 2022, sa meilleure
année étant la pire du marché. Voir `outils/CRIBLE-EA-NON-MESURES-10-09.md`.

**Le lanceur sait viser ce terminal** : `lance_chaine.ps1 -Terminal Vantage` (défaut PUPrime,
comportement inchangé sans l'option).

## Ce qui est déjà en place

Le terminal **Vantage International MT4** existe sur la machine (`F1BBCAACDA8825381C125EAF07296C41`)
— c'est lui qui héberge le rapport de référence d'Advanced Scalper (`n4_as_USDJPY.htm`, 138 Mo) et
les jeux du vendeur. La relation avec le courtier existe donc déjà.

**À vérifier avant de s'engager** : que les indices soient en MT5 (le banc y est) et pas seulement en
MT4, et les tailles de contrat — la leçon du 10/09 sur Ultima est que rien ne se suppose, tout se lit
dans la spécification du symbole.
