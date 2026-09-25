# importe_ticks.ps1 -Modele XAUUSD.p -Symbole XAUUSD_VRAI [-Debut 2021.01.01] [-Fin 2026.09.24] [-Minutes 90]
# 25/09 : copie les ticks d'un symbole PU Prime dans un symbole personnalise (EA Outils\ImporteTicks, compile le 25/09).
# Ce n'est PAS un test : les tests passent toujours par lance_chaine.ps1. Ce script ouvre le terminal PU Prime avec
# l'EA d'import attache au demarrage ([StartUp]) ; l'EA ferme le terminal quand il a fini.
# Garde-fous repris de lance_chaine : refus si le terminal PU Prime ou un de ses agents tourne (un test en cours) ;
# on ne travaille que par CHEMIN (jamais par nom : Vantage et le banc Ultima tournent a cote) ; butee de temps.
param([Parameter(Mandatory=$true)][string]$Modele, [Parameter(Mandatory=$true)][string]$Symbole,
      [string]$Debut = '2021.01.01', [string]$Fin = '2026.09.24', [int]$Minutes = 90)
$exe = "C:\Program Files\PU Prime MT5 Terminal\terminal64.exe"
$T   = "C:\Users\User\AppData\Roaming\MetaQuotes\Terminal\E62C655ED163FFC555DD40DBEA67E6BB"
$D   = "C:\Users\User\OneDrive\Documents\forex"; $jr = "$D\importe_ticks_$Symbole.log"
function Trace($m){ Add-Content -Path $jr -Value ("{0}  {1}" -f (Get-Date -Format 'HH:mm:ss'), $m) -Encoding utf8 }
function CheminDe($p){ try { $p.Path } catch { $null } }
function Terminal(){ Get-Process -Name terminal64 -ErrorAction Ignore | Where-Object { (CheminDe $_) -eq $exe } }
function Agents(){ Get-Process -Name metatester64 -ErrorAction Ignore | Where-Object { (CheminDe $_) -like "$(Split-Path $exe)*" } }
Trace "IMPORT $Modele -> $Symbole du $Debut au $Fin"
if(Terminal){ Trace "REFUS : le terminal PU Prime est ouvert (test ou autre usage en cours)"; exit 1 }
if(Agents){ Trace "REFUS : un agent de test PU Prime tourne"; exit 1 }
if(-not (Test-Path "$T\MQL5\Experts\Outils\ImporteTicks.ex5")){ Trace "REFUS : ImporteTicks.ex5 absent"; exit 1 }
$set = "$T\MQL5\Presets\imp_ticks_$Symbole.set"
# 25/09 : dans un .set, une date se donne en SECONDES depuis 1970 ; "2021.01.01" y est lu comme 0 (import vide du 25/09 10:35).
function Sec($d){ [long](([datetime]::ParseExact($d, 'yyyy.MM.dd', $null)) - [datetime]'1970-01-01').TotalSeconds }
$p = @("InpModele=$Modele", "InpSymbole=$Symbole", "InpDebut=$(Sec $Debut)", "InpFin=$(Sec $Fin)", "InpFermer=true")
[System.IO.File]::WriteAllText($set, ($p -join "`r`n") + "`r`n", [System.Text.Encoding]::Unicode)
$ini = "$D\imp_ticks_$Symbole.ini"
$c = @("[StartUp]", "Expert=Outils\ImporteTicks", "ExpertParameters=imp_ticks_$Symbole.set", "Symbol=$Modele", "Period=M1")
[System.IO.File]::WriteAllText($ini, ($c -join "`r`n") + "`r`n", [System.Text.Encoding]::Unicode)
$lu = Get-ChildItem "$T\liveupdate" -ErrorAction Ignore
if($lu){ $lu | Remove-Item -Force -ErrorAction Ignore; Trace "mise a jour MT5 en attente retiree de liveupdate (blocage UAC)" }
$t0 = Get-Date
Start-Process -FilePath $exe -ArgumentList "/config:$ini"
Start-Sleep -Seconds 30
while((Terminal) -and ((Get-Date) - $t0).TotalMinutes -lt $Minutes){ Start-Sleep -Seconds 15 }
if(Terminal){ Trace "BUTEE $Minutes min : arret du terminal PU Prime (par chemin)"; Terminal | Stop-Process -Force; exit 1 }
$f = "$T\MQL5\Files\importe_ticks.log"
if(Test-Path $f){ Get-Content $f -Tail 3 | ForEach-Object { Trace "  EA: $_" } }
Trace ("terminal ferme apres {0:N0} min" -f ((Get-Date) - $t0).TotalMinutes)
