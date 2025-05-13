# Define parameters
param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Chemin vers le dossier à compresser et à signer")]
    [string]$inputFilePath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le fichier keystore PKCS#12")]
    [string]$senderKeystore,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le fichier contenant le mot de passe du keystore")]
    [string]$senderKeystorePasswordPath
)
# Define file paths
$baseName     = Split-Path $inputFilePath -Leaf
$inputFileDir = Split-Path $inputFilePath -Parent
$zipFile      = Join-Path $inputFileDir "$baseName.zip"
$sigFile      = Join-Path $inputFileDir "$baseName.sig"
$hashFile     = Join-Path $inputFileDir "$baseName.sha256"
$tmpPemCert   = Join-Path (Split-Path $SenderKeystore -Parent) "cert-extracted.tmp.pem"

# 1. Compression
Write-Host "Compression de '$inputFilePath' en '$zipFile'..."
if (Test-Path $zipFile) {
    Write-Host "Suppression de l'ancien ZIP : $zipFile"
    Remove-Item $zipFile -Force
}
Compress-Archive -Path $inputFilePath -DestinationPath $zipFile -Force

# 2. Calcul de l'empreinte SHA256 de la configuration
Write-Host "Calcul de l'empreinte SHA256 de la configuration..."
$sha256Hash = (openssl sha256 -r $zipFile).Split(' ')[0]
Write-Host "SHA256($zipFile) = $sha256Hash"

# Sauvegarde de l'empreinte
$sha256Hash | Out-File -FilePath $hashFile -Encoding ASCII

# Extract the certificate and private key from the PKCS#12 file to a temporary pem file
# because openssl cms cannot use a password protected p12 file
Write-Host "Conversion du certicat PKCS12 $senderKeystore en PEM $tmpPemCert"
openssl pkcs12 -in $senderKeystore -out $tmpPemCert -passin file:$senderKeystorePasswordPath -nodes

Write-Host "Signature du fichier $hashFile"
Write-Host "   >>> Informations du certificat de signature"
& "$PSScriptRoot\infos-certificat.ps1" -certPath $tmpPemCert

# 3. Signature CMS
Write-Host "Signature CMS/SHA256 PSS de '$hashFile' dans '$sigFile'..."
openssl cms -sign -binary -nodetach -md sha256 -in $hashFile -signer $tmpPemCert -nocerts -outform der -out $sigFile -keyopt rsa_padding_mode:pss

# 5. Cleanup
Write-Host "Nettoyage du fichier temporaire '$tmpPemCert'..."
Remove-Item $tmpPemCert -Force

Write-Host "Terminé ! Fichiers générés :"
Write-Host "  - ZIP        : $zipFile"
Write-Host "  - Signature  : $sigFile"
Write-Host "  - Empreinte  : $hashFile"
