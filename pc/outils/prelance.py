# -*- coding: utf-8 -*-
"""prelance.py <fichier.ini> [...]  — contrôles AVANT tout lancement d'un test MT5 (appelé par lance_chaine.ps1).
Sortie : une ligne par contrôle, puis 'OK' ou 'REFUS'. Code retour 0 = OK, 1 = REFUS.
Contrôles nés des échecs : disque plein (n50, 06/09), journal inondé par PrintLogs=true et les erreurs 4805 sur les
symboles hors graphique (n50), mise à jour MT5 bloquant la chaîne sur l'UAC (n51, 06/09), terminal inactif qui bloque
la chaîne (jour4x), ini mal encodé, dossier de jeux vide."""
import sys, os, re, glob, shutil, subprocess
sys.stdout.reconfigure(encoding='utf-8')
T = r"C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\E62C655ED163FFC555DD40DBEA67E6BB"
COMMON = r"C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\Common\Files"
EXE = r"C:\Program Files\PU Prime MT5 Terminal\terminal64.exe"
MIN_GO = 10
def lit(p):
    b = open(p, 'rb').read()
    if b[:2] == b'\xff\xfe': return b.decode('utf-16'), 'utf-16'
    return b.decode('utf-8', 'replace'), 'autre'
def champs(s):
    d = {}
    for l in s.splitlines():
        l = l.strip()
        if '=' in l and not l.startswith(';') and not l.startswith('['):
            k, v = l.split('=', 1); d.setdefault(k.strip(), v.strip())
    return d
def chemins_processus(nom):
    """Chemins complets des processus <nom>.exe. 10/09 : ne JAMAIS raisonner sur le seul nom —
    un compte reel tourne sur un autre terminal64.exe (banc Ultima, outils/BANC-ULTIMA-09-09.md)."""
    ps = ("Get-CimInstance Win32_Process -Filter \"name='%s.exe'\" | "
          "ForEach-Object { $_.ExecutablePath }" % nom)
    out = subprocess.run(['powershell', '-NoProfile', '-Command', ps],
                         capture_output=True, text=True).stdout
    return [l.strip() for l in out.splitlines() if l.strip()]


def processus():
    dossier = os.path.dirname(EXE).lower()
    testeur = [c for c in chemins_processus('terminal64') if c.lower() == EXE.lower()]
    autres = [c for c in chemins_processus('terminal64') if c.lower() != EXE.lower()]
    if autres:
        print("autre(s) terminal64 en service, ignore(s) par le lanceur : " + " ; ".join(autres))
    # 10/09 : filtrer AUSSI metatester64 par chemin. Un agent d'un autre terminal ne nous concerne pas.
    agents = [c for c in chemins_processus('metatester64') if c.lower().startswith(dossier)]
    out = subprocess.run(['tasklist'], capture_output=True, text=True).stdout.lower()
    return {'terminal64': bool(testeur),
            'metatester64': bool(agents),
            'consent': 'consent.exe' in out}
def maj_en_attente():
    lu = os.path.join(T, 'liveupdate'); fs = glob.glob(os.path.join(lu, '*'))
    return [os.path.basename(f) for f in fs]
def controle(ini):
    err, avert = [], []
    if not os.path.exists(ini): return ["ini introuvable : " + ini], avert
    s, enc = lit(ini)
    if enc != 'utf-16': err.append("ini pas en UTF-16 (le testeur l'ignore en silence)")
    c = champs(s)
    for k in ('Expert', 'Symbol', 'Report', 'FromDate', 'ToDate'):
        if k not in c: err.append("champ manquant : " + k)
    if c.get('ShutdownTerminal') != '1': err.append("ShutdownTerminal doit valoir 1 (sinon le terminal reste ouvert et bloque la chaîne)")
    if c.get('Model') != '4': avert.append("Model=%s : pas des ticks réels (règle : le modèle de ticks décide tout)" % c.get('Model'))
    if c.get('PrintLogs', 'false').lower() == 'true': err.append("PrintLogs=true : journal illimité, a rempli le disque le 06/09 (3 Go en 8 min)")
    exp = os.path.join(T, 'MQL5', 'Experts', c.get('Expert', '') + ('' if c.get('Expert', '').endswith('.ex5') else '.ex5'))
    if not os.path.exists(exp): err.append("expert introuvable : " + exp)
    rep = os.path.join(T, c.get('Report', '') + '.htm')
    if os.path.exists(rep) and c.get('ReplaceReport') != '1': err.append("rapport déjà présent et ReplaceReport≠1 : " + rep)
    if os.path.exists(rep) and c.get('ReplaceReport') == '1': avert.append("rapport existant sera écrasé : " + os.path.basename(rep))
    # jeux UBS : dossier et symbole du graphique
    if c.get('UseAutoLoader', 'false').lower() == 'true':
        dos = os.path.join(COMMON if c.get('UseCommonFolder', 'false').lower() == 'true' else os.path.join(T, 'MQL5', 'Files'), c.get('Sets_Folder', ''))
        sets = glob.glob(os.path.join(dos, '*.set'))
        if not sets: err.append("dossier de jeux vide ou absent : " + dos)
        autres = []
        for f in sets:
            js, _ = lit(f); m = re.search(r'^ForceSymbol=([^\r\n|]*)', js, re.M)
            if m and m.group(1).strip() and m.group(1).strip() != c.get('Symbol'): autres.append("%s→%s" % (os.path.basename(f)[:-4], m.group(1).strip()))
        if autres: avert.append("jeux sur un autre symbole que le graphique (risque d'erreurs 4805 en boucle sur indices) : " + ", ".join(autres))
    return err, avert
def principal(inis):
    global_err = []
    libre = shutil.disk_usage("C:\\").free / 1e9
    print("disque libre : %.1f Go" % libre)
    if libre < MIN_GO: global_err.append("disque libre < %d Go" % MIN_GO)
    pr = processus()
    if pr['terminal64'] or pr['metatester64']: global_err.append("terminal64/metatester64 déjà en cours : un test tourne ou un terminal inactif bloque")
    if pr['consent']: global_err.append("consent.exe présent : une fenêtre UAC attend l'utilisateur")
    lu = maj_en_attente()
    if lu: print("mise à jour MT5 en attente dans liveupdate (%d fichiers) : le lanceur la neutralise avant le démarrage, sinon blocage UAC" % len(lu))
    if not os.path.exists(EXE): global_err.append("terminal64.exe introuvable")
    for e in global_err: print("REFUS :", e)
    ok = not global_err
    for ini in inis:
        err, avert = controle(ini)
        for a in avert: print("  avertissement %s : %s" % (os.path.basename(ini), a))
        for e in err: print("  REFUS %s : %s" % (os.path.basename(ini), e))
        if err: ok = False
        else: print("  %s : contrôles passés" % os.path.basename(ini))
    print("OK" if ok else "REFUS"); return 0 if ok else 1
if __name__ == '__main__':
    # 10/09 : --exe / --data visent un autre terminal (Vantage). Sans eux, PU Prime comme avant.
    _a = sys.argv[1:]
    while len(_a) >= 2 and _a[0] in ('--exe', '--data'):
        if _a[0] == '--exe':
            EXE = _a[1]
        else:
            T = _a[1]
        _a = _a[2:]
    sys.exit(principal(_a))
