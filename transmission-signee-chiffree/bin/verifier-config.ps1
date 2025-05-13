# Define parameters
param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Chemin vers le fichier à vérifier")]
    [string]$inputFilePath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le certificat public de l'émetteur au format PEM")]
    [string]$senderCertificate
)

# --- Recomposition des chemins ---
$baseName     = [System.IO.Path]::GetFileNameWithoutExtension($inputFilePath)
$dir       = Split-Path $inputFilePath -Parent
$zipFile   = Join-Path $dir "$baseName.zip"
$sigFile   = Join-Path $dir "$baseName.sig"
$hashFile  = Join-Path $dir "$baseName.sha256"

# 1. Vérification du certificat
Write-Host "   >>> Informations du certificat de signature"
& "$PSScriptRoot\infos-certificat.ps1" -certPath $senderCertificate

# 2. Vérification de la signature de l'empreinte de la configuration
Write-Host "Vérification de la signature du fichier $sigFile"
# On redirige la sortie vers $null pour ne pas réécrire l’empreinte et masquer le résultat correct affiché sur la sortie d'erreur
&openssl cms -verify -binary -in $sigFile -inform der -content $hashFile -certfile $senderCertificate -CAfile $senderCertificate 2>&1 | Out-Null 

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ La vérification CMS a échoué !"
    exit 1
}
Write-Host "✅ Signature CMS valide !" -ForegroundColor Green

# 2) Recalculer et comparer l’empreinte SHA-256
Write-Host "`n=== 2) Vérification de l’empreinte SHA-256 ==="
if (-not (Test-Path $hashFile)) {
    Write-Error "Fichier d'empreinte introuvable : $hashFile"
    exit 1
}

# Empreinte telle qu’enregistrée
$expectedHash = (Get-Content $hashFile -Raw).Trim()
Write-Host "Empreinte attendue (.$baseName.sha256) : $expectedHash"

# Nouvelle empreinte du ZIP
$actualHash = (openssl sha256 -r $zipFile).Split(' ')[0]
Write-Host "Empreinte calculée (.$baseName.zip)    : $actualHash"

if ($actualHash -eq $expectedHash) {
    Write-Host "✅ Empreinte correcte !" -ForegroundColor Green
} else {
    Write-Error "❌ Empreinte INCORRECTE !"
    exit 1
}

Write-Host "Vérification terminée avec succès."
