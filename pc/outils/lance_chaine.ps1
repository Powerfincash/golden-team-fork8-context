# lance_chaine.ps1 -Inis n51_ubs_eurusd,n52_ubs_fx2 [-Journal jourXX.log]
# LE SEUL chemin autorisé pour lancer un test MT5 (voir C:\Users\User\.claude\CLAUDE.md).
# Avant chaque test : prelance.py (refus = arrêt), neutralisation de la mise à jour MT5 en attente (blocage UAC du 06/09).
# Pendant : garde-fous disque (< 3 Go) et journal du testeur (> 1 Go = inondation d'erreurs, cf. n50), détection du
# blocage UAC (« LiveUpdate start » sans « testing started »), terminal inactif après rapport.
# Après : contrôle du premier résultat = rapport non vide (mesure.py), sinon arrêt de la chaîne.
param([Parameter(Mandatory=$true)][string[]]$Inis, [string]$Journal = "chaine_$(Get-Date -Format 'yyyyMMdd_HHmm').log",
      [ValidateSet('PUPrime','Vantage')][string]$Terminal = 'PUPrime')
# 15/09 : via Start-Process -File, "-Inis a,b" arrive en UN element "a,b" (fichier "a,b.ini" introuvable) : on redecoupe ici.
$Inis = @($Inis | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
# 10/09 : le lanceur ne connaissait qu'un terminal. Vantage MT5 (compte demo indices) en exige un
# second. PUPrime reste le defaut : sans -Terminal, le comportement est STRICTEMENT celui d'avant.
$TERMINAUX = @{
  'PUPrime' = @{ exe  = "C:\Program Files\PU Prime MT5 Terminal\terminal64.exe"
                 data = "C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\E62C655ED163FFC555DD40DBEA67E6BB" }
  'Vantage' = @{ exe  = "C:\Program Files\Vantage Markets MT5 Terminal\terminal64.exe"
                 data = "C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\725B72F25E46C780EF59F57016D58156" }
}
$exe = $TERMINAUX[$Terminal].exe; $T = $TERMINAUX[$Terminal].data
$D="C:\Users\User\OneDrive\Documents\forex"; $O="$D\outils"; $jr="$D\$Journal"
function Trace($m){Add-Content -Path $jr -Value ("{0}  {1}" -f (Get-Date -Format 'HH:mm:ss'),$m) -Encoding utf8}
# 10/09 : ne JAMAIS travailler par nom de processus. Un compte reel tourne sur un autre terminal64.exe
# (banc Ultima Markets, cf. outils/BANC-ULTIMA-09-09.md) ; Stop-Process -Name terminal64 le tuait.
function CheminDe($p){ try { $p.Path } catch { $null } }
function Testeur(){ Get-Process -Name terminal64 -ErrorAction Ignore | Where-Object { (CheminDe $_) -eq $exe } }
# 10/09 : un metatester64 orphelin survivait a la coupure et faisait refuser la chaine suivante.
$dossierExe = Split-Path $exe
function Agents(){ Get-Process -Name metatester64 -ErrorAction Ignore | Where-Object { (CheminDe $_) -like "$dossierExe*" } }
function AutresTerminaux(){ Get-Process -Name terminal64 -ErrorAction Ignore | Where-Object { (CheminDe $_) -ne $exe } }
function TueTesteur(){ Testeur | Stop-Process -Force -ErrorAction Ignore; Agents | Stop-Process -Force -ErrorAction Ignore }
function LibreGo(){ [math]::Round((Get-PSDrive C).Free/1GB,1) }
function TailleJournalTesteurMo(){ $s=0; Get-ChildItem "$T\Tester\logs\*.log","$T\Tester\Agent-*\logs\*.log" -ErrorAction Ignore | ForEach-Object { $s += $_.Length }; [math]::Round($s/1MB) }
function JournalTerminal(){ $f="$T\logs\$(Get-Date -Format 'yyyyMMdd').log"; if(Test-Path $f){ Get-Content $f -Encoding Unicode -ErrorAction Ignore } }
Trace "CHAINE $($Inis -join ', ') [terminal $Terminal]"
$autres = AutresTerminaux
if($autres){ Trace ("ATTENTION : {0} autre(s) terminal64 en service, NON touche(s) : {1}" -f $autres.Count, (($autres | ForEach-Object { CheminDe $_ }) -join ' ; ')) }
# 24/09 : un terminal de test laisse ouvert a la main (PU Prime, 22/09 15h57) faisait refuser
# toutes les chaines par prelance. S'il n'a aucun agent de test actif, il est inactif : on le ferme
# proprement (fenetre), puis de force s'il reste. Seul CE terminal (par chemin), jamais les autres.
if((Testeur) -and -not (Agents)){
  Trace "terminal de test $Terminal ouvert et inactif (aucun agent de test) : fermeture"
  Testeur | ForEach-Object { $_.CloseMainWindow() | Out-Null }
  for($i=0; $i -lt 15 -and (Testeur); $i++){ Start-Sleep -Seconds 2 }
  if(Testeur){ Trace "toujours la apres 30 s : arret force"; TueTesteur; Start-Sleep -Seconds 5 }
}
foreach($r in $Inis){
  $ini="$D\$r.ini"
  $ctrl = & python "$O\prelance.py" --exe "$exe" --data "$T" $ini 2>&1; $ctrl | ForEach-Object { Trace "  prelance: $_" }
  if($LASTEXITCODE -ne 0){ Trace "ARRET : prelance refuse $r"; break }
  # mise à jour MT5 en attente : la retirer du dossier liveupdate (elle se retéléchargera, et s'installera quand l'utilisateur ouvrira MT5 lui-même)
  $lu = Get-ChildItem "$T\liveupdate" -ErrorAction Ignore
  if($lu){ $lu | Remove-Item -Force -ErrorAction Ignore; Trace "mise à jour MT5 en attente retirée de liveupdate ($($lu.Count) fichiers) pour éviter le blocage UAC" }
  $rep="$T\$r.htm"; if(Test-Path $rep){ Remove-Item $rep -Force }
  # 10/09 : le garde-fou mesurait la taille CUMULEE des journaux du testeur, y compris ceux des jours
  # passes. Un journal de 960 Mo laisse par une inondation du 08/09 a fait couper une chaine saine.
  # On mesure desormais la CROISSANCE depuis le lancement de ce test-ci.
  $jt0 = TailleJournalTesteurMo
  $t0=Get-Date; Trace "LANCE $r (libre $(LibreGo) Go, journaux testeur $jt0 Mo)"; Start-Process -FilePath $exe -ArgumentList "/config:$ini"; Start-Sleep -Seconds 60
  $demarre=$false; $tue=$false; $motif=""
  while(-not (Test-Path $rep) -or (Testeur)){
    Start-Sleep -Seconds 20
    $jt = JournalTerminal | Where-Object { $_ -match "$($t0.ToString('HH:mm')).*" -or $true } | Select-Object -Last 400
    if(-not $demarre -and ($jt -match 'automatic testing started')){ $demarre=$true; Trace "$r : test démarré" }
    if(-not $demarre -and ((Get-Date)-$t0).TotalMinutes -gt 5 -and ($jt -match 'LiveUpdate.*start') -and (Get-Process -Name consent -ErrorAction Ignore)){ $motif="BLOQUE par la mise à jour MT5 : fenêtre UAC à l'écran, seul l'utilisateur peut cliquer"; Trace "$r : $motif"; $tue=$true; break }
    if(-not $demarre -and ((Get-Date)-$t0).TotalMinutes -gt 20 -and -not (Testeur)){ $motif="terminal parti sans démarrer le test"; Trace "$r : $motif"; $tue=$true; break }
    if((LibreGo) -lt 3){ $motif="disque < 3 Go"; Trace "$r : $motif : arrêt du testeur (PU Prime seulement)"; TueTesteur; $tue=$true; break }
    if(((TailleJournalTesteurMo) - $jt0) -gt 1024){ $motif="journal du testeur +1 Go depuis le lancement (inondation d'erreurs)"; Trace "$r : $motif : arrêt du testeur"; TueTesteur; $tue=$true; break }
    if((Test-Path $rep) -and (Testeur)){ Start-Sleep -Seconds 60; if(Testeur){ Trace "testeur inactif après rapport : fermé"; TueTesteur } }
  }
  if($tue){ Trace "CHAINE INTERROMPUE ($motif)"; break }
  $duree=[math]::Round(((Get-Date)-$t0).TotalMinutes)
  $m = & python "$O\mesure.py" $rep 2>&1 | Select-Object -First 3
  if(($m -join ' ') -match 'NON VERIFIE'){ Trace "$r : RAPPORT VIDE ou illisible après $duree min : $($m -join ' | ')"; Trace "CHAINE INTERROMPUE (rapport vide)"; break }
  Trace "$r terminé en $duree min : $($m -join ' | ')"
}
Trace "FIN de chaine"
