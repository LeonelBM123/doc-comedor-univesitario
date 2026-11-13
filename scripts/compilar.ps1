# Compila main.tex y/o main_v2.tex (pdflatex -> biber -> pdflatex x2) y resume errores.
# Uso:  powershell -File scripts/compilar.ps1 -Doc ambos   (valores: main | v2 | ambos)
param([ValidateSet('main','v2','ambos')][string]$Doc = 'ambos')

Set-Location (Split-Path $PSScriptRoot -Parent)

function Compilar([string]$nombre) {
    Write-Host "== Compilando $nombre.tex =="
    $args = @('-interaction=nonstopmode', '-halt-on-error', "$nombre.tex")
    & pdflatex @args | Out-Null;           if ($LASTEXITCODE -ne 0) { Write-Host "ERROR en pdflatex (1)"; return }
    & biber --winunicode $nombre | Out-Null
    & pdflatex @args | Out-Null;           if ($LASTEXITCODE -ne 0) { Write-Host "ERROR en pdflatex (2)"; return }
    & pdflatex @args | Out-Null;           if ($LASTEXITCODE -ne 0) { Write-Host "ERROR en pdflatex (3)"; return }
    $log = Get-Content "$nombre.log" -Raw
    $errores = ([regex]::Matches($log, '(?m)^!')).Count
    $indef = ([regex]::Matches($log, 'undefined')).Count
    Write-Host "$nombre.pdf generado. Errores: $errores. Referencias/citas indefinidas: $indef."
}

if ($Doc -in 'main','ambos') { Compilar 'main' }
if ($Doc -in 'v2','ambos')   { Compilar 'main_v2' }
