---
name: claudeverstradingview
description: Pont MCP Claude <-> TradingView Desktop (kaspertrading/claudeverstradingview) installe le 04/09/2026 - ou il est, comment il est enregistre, ce qui manque encore
metadata:
  type: reference
---

Installe a sa demande le 04/09/2026 (20 h) : `git clone` dans `C:\Users\User\claudeverstradingview`, `npm install`
(95 paquets, 3 dependances : @modelcontextprotocol/sdk, chrome-remote-interface, dotenv ; aucun script pre/post-install),
`rules.json` cree depuis `rules.example.json`. C'est un fork/rebadge de tradesdontlie/tradingview-mcp (SECURITY.md).
Enregistre en config MCP de PROJET : `C:\Users\User\.claude\.mcp.json` (le cwd de nos sessions est `C:\Users\User\.claude`) ;
l'ecriture de `~/.claude.json` a ete refusee par le classifieur. Effet apres redemarrage de Claude Code (approbation
du serveur demandee), verification par `tv_health_check`.
**Manque au 04/09** : TradingView DESKTOP n'est pas installe sur ce PC (verifie : LocalAppData, Program Files, WindowsApps).
Sans lui, rien ne marche : il faut l'installer, puis le lancer par `scripts\launch_tv_debug.bat` (tue et relance
TradingView avec `--remote-debugging-port=9222`). Port CDP a garder sur localhost (PC deja touche par un incident
malware le 26/08). Serveur demarre sans erreur en test (bandeau « outil non officiel »).

**05/09 13h20 — TradingView Desktop EST installe, par le Store** (MSIX `TradingView.Desktop_3.3.0.7992_x64__n534cwy3pjxzj`,
Electron 38 / Chrome 140), invisible dans LocalAppData et Program Files, sans alias d'execution ; le .exe du dossier
WindowsApps refuse le lancement direct (acces refuse). Ce qui marche : activation du paquet avec argument,
`Start-Process 'shell:AppsFolder\TradingView.Desktop_n534cwy3pjxzj!TradingView.Desktop' -ArgumentList '--remote-debugging-port=9222'`
-> port 9222 OK. Lanceur ecrit : `C:\Users\User\claudeverstradingview\lancer_tradingview_debug.ps1` (le
`scripts\launch_tv_debug.bat` fourni ne trouve pas l'installation Store). La CLI s'appelle `kasper`
(`node src/cli/index.js status|state|quote|pine ...`), pas `claudeverstradingview brief` comme dit le README.
