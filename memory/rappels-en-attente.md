---
name: rappels-en-attente
description: "Choses que l'utilisateur m'a explicitement demande de lui rappeler plus tard"
metadata: 
  node_type: memory
  type: project
  originSessionId: 82d3828f-2f80-4d36-bead-d03e08c7569e
  modified: 2026-08-25T10:20:39.146Z
---

L'utilisateur compte sur moi pour **revenir de ma propre initiative** sur ces points.
Ne pas attendre qu'il y repense : c'est precisement ce qu'il a demande d'eviter.
Moment propice : un debut de session, ou une longue attente de calcul — pas au milieu
d'un sujet en cours.

## 1. FAIT ET CLOS — Documents chiffre dans NordLocker
Lance et **termine le 24/08/2026 a 23h13** : `robocopy /MIR` de `OneDrive\Documents`
vers `NordLocker_4513930\My Files\Documents`. **14 230 fichiers, 15,78 Go, zero echec**,
verifie par recomptage source/destination (ecart nul), pas seulement par le journal.
Racine du coffre intacte (`forex`, `outils forex`, `Sauvegardes-Code`). Journal :
`C:\Users\User\nordlocker_miroir.log`.

**Ce qui reste, et qu'il m'a demande de lui rappeler le 25/08** — « rappelle-le moi
c'est preferable, je ne suis qu'un humain ;-) » :

- **Televersement termine le 25/08 a 08h56**, confirme par surveillance du debit :
  montee soutenue a 2,5 Mo/s pendant pres d'une heure, 7,36 Go envoyes pendant la seule
  surveillance, puis chute a 1-3 Ko/s et connexions NordLocker tombees de 16 a 0. Une
  fin de transfert, pas un blocage — un blocage garderait les connexions ouvertes.
  Leçon a garder : **copier dans le dossier n'est pas monter**. Le seul signe fiable
  depuis l'exterieur est le debit montant qui retombe durablement ; le script de
  surveillance est dans `Tools\goldinghedge_stop` si besoin de le refaire.
- **RESTE : sa veille est toujours desactivee** (`standby-timeout-ac 0`, hibernation 0).
  Son reglage d'origine etait **30 min** — le lui rappeler :
  `powercfg /change standby-timeout-ac 30`. L'extinction de l'ecran est restee a 30 min,
  sans effet sur les transferts.
- **FAIT le 25/08** : le miroir est integre a `refresh.sh`. Passage incrementiel mesure
  a **12 s** pour 14 230 fichiers. Garde-fou pose : le script **refuse** le miroir si la
  source tombe sous 1 000 fichiers ou sous 80 % du contenu du coffre — sans lui, un
  OneDrive non monte ferait vider le coffre par `/MIR`.
  Piege corrige au passage : Git Bash transforme `/MIR` en `MIR:/`, robocopy renvoie 16
  et ne fait rien. D'ou `MSYS2_ARG_CONV_EXCL="*"` devant l'appel.
- **`refresh.sh` lui-meme n'est copie que sur `D:`**, pas sur OneDrive ni NordLocker.
  Lui proposer de completer les deux `cp` : la sauvegarde deviendrait autonome.
- Si la machine part chez le technicien avant la fin, **rien n'est perdu** : la montee
  reprend au retour.

Piege a ne pas refaire : `robocopy` renvoie **le code 1 quand tout s'est bien passe**
(« des fichiers ont ete copies »). Le lanceur de taches l'a signale comme un echec.
Lire le tableau de fin du journal, jamais le code de sortie seul.

## 1 ter. FAIT le 26/08 — analyse Defender. RESTE : mots de passe et VPS

**Le scan a eu lieu.** Resultat, apres enquete complete :

- **Un seul fichier en position operationnelle** : `msimg32.dll`, 5 524 Ko, date du
  19/09/2022, dans
  `Terminal\F1BBCAACDA8825381C125EAF07296C41\MQL4\Libraries\` — le MT4 **Vantage
  International**. Classe `HackTool:Win32/crack`, severite 4. **Supprime par Defender.**
- **Les menaces de severite 5** trouvees dans `OneDrive\Documents\forex` — dont
  `Backdoor:MSIL/Bladabindi.AJ` (njRAT) et `Trojan:Win32/Meterpreter!mclg` — etaient
  **toutes a l'interieur d'archives `.rar` / `.zip`**, jamais installees. La plupart de
  ces archives ont ete effacees par le nettoyage. 30 detections au total.
- **Aucune persistance** : rien au demarrage, aucune tache planifiee, dossier Startup vide.
- **Aucune trace d'execution** : pas d'entree Prefetch pour `launcher.exe`, `msimg32`,
  `oleacc` ni `patch`.
- **Bitdefender, l'antivirus ACTIF de la machine, n'avait rien signale.** C'est Defender,
  en mode passif, qui a tout trouve. Point a garder en tete.

**Les deux fichiers restants ont ete mis en QUARANTAINE le 26/08**, dans
`C:\Users\User\Quarantaine-EA-20260826\`, extension modifiee pour qu'ils ne puissent etre
ni executes ni charges :

- `launcher.exe_GoldingScalpPatch` — 4 353 Ko, `NotSigned`, `PUA:Win32/Packunwan`
- `oleacc.dll_BlitzTrendpro` — 6 776 Ko, `NotSigned`, **non detecte par Defender** alors
  que la vraie `oleacc.dll` de Windows fait 395 Ko, soit 17 fois moins

Rien n'est detruit, tout est recuperable. Ce dossier est **hors OneDrive et hors du
miroir NordLocker** : ces fichiers ne partent nulle part.

**Verifie apres coup : il ne reste AUCUNE DLL portant un nom de composant systeme dans
tout le dossier `forex`.**

**Consequence pour le miroir, a ne pas diagnostiquer comme une panne :** le nombre de
fichiers de `Documents` est passe de **14 230 a 14 121** — 109 de moins. C'est le menage,
pas un defaut de `robocopy`. L'ancien repere « ecart de 4 » est perime : **source et
coffre sont de nouveau a 14 121, ecart nul.**

**PIEGE MAJEUR RENCONTRE LE 26/08, a ne jamais oublier :** apres le menage, le coffre
NordLocker contenait encore **44 DLL malveillantes** que la source n'avait plus.
`robocopy /MIR` les avait bien DETECTEES comme surnumeraires — le code 3 le disait — mais
**n'a pas reussi a les effacer**, vraisemblablement parce que NordLocker monte le coffre
comme un volume virtuel. Le script annoncait « OK » et le coffre restait sale : les
fichiers etaient deja televerses chez Nord. Il a fallu les deplacer a la main.
**Consequence : apres toute suppression massive dans `Documents`, RECOMPTER source et
coffre. Le « OK » de `refresh.sh` ne prouve pas que les suppressions ont ete propagees.**

Les 44 sont dans `Quarantaine-EA-20260826\coffre\`, chemin d'origine encode dans le nom.
Total de la quarantaine : **253 Mo, 46 fichiers**.

### RAPPEL DEMANDE LE 26/08 : changer les mots de passe

Il l'a demande explicitement. **Les comptes concernes sont ceux du terminal touche**,
pas tous — releves dans ses journaux :

| compte | serveur | nature | priorite |
|---|---|---|---|
| **2036866** | **FusionMarkets-Live 2** | **REEL** | **la seule qui compte vraiment** |
| 100974877 | PUPrime-Demo | demo | accessoire, mais gratuit |

Ne pas lui dire « change PU Prime Demo » : il l'avait compris ainsi, c'est faux. Et ce
n'est pas MT5 mais **MT4**.

### QUESTION OUVERTE, plus importante que les mots de passe

**Le VPS.** Ses comptes qui portent de l'argent — PU Prime cent reel et Ultima — tournent
sur le VPS, pas sur cette machine. La DLL trouvee ici ne les concerne donc pas
directement. **Mais s'il a installe sur le VPS des EA venant du meme dossier `forex`, la
meme DLL y est probablement**, et la elle cohabiterait avec les comptes reels.
**Lui reposer la question s'il n'y a pas repondu.**

## 2. Installer Obsidian
Demande le 22/08/2026, apres que j'ai conseille d'attendre les resultats des backtests
plutot que de le faire le soir meme.
Le dossier `C:\Users\User\.claude\projects\C--Users-User--claude\memory` s'ouvre tel
quel comme coffre : les notes sont deja du markdown relie par des liens `[[...]]`.
A ajouter aussi : `Experts\LazyAlgo\README.md` (les ~60 configurations testees et
ecartees) et `Reference\INDICATEURS.md`.
**Graphify** : il l'a evoque en meme temps, je ne sais pas de quel produit il s'agit —
lui redemander le lien plutot que de deviner.

## 3. Controler GardienHoraire sur la demo, au retour de la machine
Demande le 24/08/2026 : « On attendra le retour de l'ordi, note-le ».

L'EA `GardienHoraire.mq4` est ecrit et compile (0 erreur) mais **jamais execute**.
Il applique la coupure du vendredi a Goldinghedge en supprimant ses ordres en attente.
La machine part chez le technicien le **25/08/2026** (RAM 8 -> 24 Go).

Controle a faire avant tout usage reel, dix minutes sur la demo : poser l'EA avec
`InpHeureBlocage` sur l'heure courante, verifier dans le journal qu'il supprime bien
les ordres et que Goldinghedge cesse d'ouvrir, puis remettre a 18.
**Ne pas mettre en reel sans l'avoir vu agir.**

Restent aussi a poser : les deux taches planifiees Windows sur le VPS (arret du
terminal vendredi 22h30, relance lundi 2h) — et le fuseau du VPS est a verifier
avant, sinon tout est decale.

Detail dans `Experts\LazyAlgo\Reconstructions\EXPLOITATION_GOLDINGHEDGE.md` et
`Experts\GardienHoraire\LISEZ-MOI.md`. Voir [[goldinghedge-exploitation]].

**Why:** il a dit que ce projet lui coute du temps, de l'argent et ses illusions. Une
promesse de rappel non tenue s'ajoute a la liste.

**How to apply:** rayer un point une fois traite, et supprimer cette note quand elle est
vide. Voir [[lazyalgo-multistrategy-state]].

## StrategyQuant — idee posee le 29/08, PAS un chantier ouvert

**Pas installe** (seul un raccourci web sur le bureau). Idee evoquee en passant pour
**generer des candidats**, explicitement mise de cote : « cela n'a rien a voir avec notre
session ». **Ne pas l'ouvrir avant la fin du projet clone.**

C'est une famille differente — regles d'entree/sortie sur indicateurs, jamais une grille
couverte. Donc une piste parallele, pas une aide au projet en cours.

**Les trois points qui decideraient du resultat**, si on y vient un jour :
1. **Le cout de transaction** — le reglage qu'on oublie et qui decide de tout. Avec le
   spread par defaut, SQ sort des milliers de faux positifs convaincants. Il faut y mettre
   la friction MESUREE : 0,36 pip, et le seuil de 27,5 % en M15 (voir
   [[trading-friction-timeframe]] et [[reperes-m15-puprime]]).
2. **Un echantillon reserve** cache avant la premiere generation, jamais montre.
3. **Un critere que les criteres actuels n'ont PAS** : combien de candidats ont ete testes
   avant celui qu'on retient. Sur mille strategies generees, une cinquantaine passe
   n'importe quel filtre par hasard — sans ce compte, le hors-echantillon ne protege plus.
   Voir [[backtest-acceptance-criteria]].


**06/09/2026 — pont TradingView cassé, à lui rappeler.** `src/server.js` a disparu du disque du dépôt
`~/claudeverstradingview`, et c'est le fichier vers lequel pointe `~/.claude/.mcp.json`. Le pont ne peut
donc pas démarrer. Le fichier est intact dans l'historique git mais **impossible à recréer** : la
création est refusée pour ce nom précis alors qu'elle réussit pour `serveur.js`, `server.mjs` ou
`srv.js` dans le même dossier, avec le même contenu. L'accès contrôlé aux dossiers de Defender est
désactivé et aucun antivirus tiers n'est déclaré — un moteur de sécurité l'a très probablement mis en
quarantaine. **Deux issues, à SON choix** : (1) il ajoute une exception pour ce dossier, je restaure en
une commande ; (2) on renomme le point d'entrée (ex. `src/tv-mcp.mjs`) et on corrige le chemin dans
`.mcp.json` — mais c'est contourner le blocage, donc décision explicite de sa part requise.
Il a dit « on verra plus tard, tu me le rappelles ».
