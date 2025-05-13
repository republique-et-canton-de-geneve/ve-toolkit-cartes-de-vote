param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Chemin vers le fichier à déchiffrer et vérifier")]
    [string]$inputFilePath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le keystore de déchiffrement du destinataire au format PEM")]
    [string]$recipientKeystore,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le fichier contenant le mot de passe pour le keystore de dechiffrement du destinataire")]
    [string]$recipientKeystorePasswordPath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le certificat public de l'émetteur au format PEM")]
    [string]$senderCertificate
)


# Define file paths
$encryptedFilePath = $inputFilePath

#Set temporary file names
$decryptedFilePath = [System.IO.Path]::ChangeExtension($encryptedFilePath, ".der")

# Generate the final verified file name
$basePath = $encryptedFilePath -replace '\.bin$', ''
$originalExtension = [System.IO.Path]::GetExtension($basePath)
$verifiedFilePath = $basePath -replace ($originalExtension + '$'), "-decrypted$originalExtension"

# Extract the certificate and private key from the PKCS#12 file to a temporary pem file
# because openssl cms cannot use a password protected p12 file
$tmp_pem_cert = Join-Path (Split-Path $recipientKeystore -Parent) "extracted_cert.tmp.pem"
Write-Host "Conversion du certicat PKCS12 $recipientKeystore en PEM $tmp_pem_cert"
$recipientKey = "extracted_recipient_key.tmp.pem"
openssl pkcs12 -in $recipientKeystore -out $recipientKey -passin file:$recipientKeystorePasswordPath -nodes -nocerts
openssl pkcs12 -in $recipientKeystore -out $tmp_pem_cert -passin file:$recipientKeystorePasswordPath -nodes


$decryptedFilePath = [System.IO.Path]::ChangeExtension($encryptedFilePath, ".der")

Write-Host "Déchiffrement du fichier $inputFilePath"
Write-Host "   >>> Informations du certificat de déchiffrement"
& "$PSScriptRoot\infos-certificat.ps1" -certPath $tmp_pem_cert
openssl cms -decrypt -binary -in $inputFilePath -inkey $recipientKey -inform der -out $decryptedFilePath

Write-Host "Vérification de la signature du fichier $decryptedFilePath"
Write-Host "   >>> Informations du certificat de signature"
& "$PSScriptRoot\infos-certificat.ps1" -certPath $senderCertificate
openssl cms -verify -binary -in $decryptedFilePath -inform der -out $verifiedFilePath -certfile $senderCertificate -CAfile $senderCertificate
if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ La vérification CMS a échoué !"
    exit 1
}
Write-Host "✅ Signature CMS valide !" -ForegroundColor Green

# Delete intermediate files
Write-Host "Cleanup."
Remove-Item -Path $recipientKey -Force
Remove-Item -Path $decryptedFilePath -Force

Write-Host "✅ Fichier déchiffré et vérifié: $verifiedFilePath" -ForegroundColor Green