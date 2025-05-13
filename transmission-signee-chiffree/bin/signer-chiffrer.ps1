# Define parameters
param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Chemin vers le fichier à signer et chiffrer")]
    [string]$inputFilePath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le fichier keystore PKCS#12")]
    [string]$senderKeystore,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le fichier contenant le mot de passe du keystore")]
    [string]$senderKeystorePasswordPath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le certificat du destinataire")]
    [string]$recipientCertificate
)

$sha256Hash = openssl sha256 -r $inputFilePath | ForEach-Object { $_.Split(' ')[0] }
Write-Host "Fichier à signer et chiffrer: $inputFilePath, fingerprint sha256=$sha256Hash"

# Define file paths
$encryptedFilePath = "$inputFilePath.bin"
$tmp_pem_cert = Join-Path (Split-Path $SenderKeystore -Parent) "extracted_cert.tmp.pem"

# Extract the certificate and private key from the PKCS#12 file to a temporary pem file
# because openssl cms cannot use a password protected p12 file
Write-Host "Conversion du certicat PKCS12 $senderKeystore en PEM $tmp_pem_cert"
openssl pkcs12 -in $senderKeystore -out $tmp_pem_cert -passin file:$senderKeystorePasswordPath -nodes

# Sign and encrypt the file using OpenSSL CMS
$signedFilePath = "$inputFilePath.der"

Write-Host "Signature du fichier $inputFilePath"
Write-Host "   >>> Informations du certificat de signature"
& "$PSScriptRoot\infos-certificat.ps1" -certPath $tmp_pem_cert
openssl cms -sign -binary -nodetach -md sha256 -in $inputFilePath -signer $tmp_pem_cert -nocerts -outform der -out $signedFilePath -keyopt rsa_padding_mode:pss

Write-Host "Chiffrement du fichier $signedFilePath"
Write-Host "   >>> Informations du certificat de chiffrement"
& "$PSScriptRoot\infos-certificat.ps1" -certPath $recipientCertificate
openssl cms -encrypt -binary -aes-256-gcm -aes256-wrap -in $signedFilePath -inform der -out $encryptedFilePath -outform der -recip $recipientCertificate

# Delete the intermediate files
Write-Host "Cleanup."
Remove-Item -Path $tmp_pem_cert -Force
Remove-Item -Path $signedFilePath -Force

Write-Host "✅ Fichier signé et chiffré résultant: $encryptedFilePath" -ForegroundColor Green
