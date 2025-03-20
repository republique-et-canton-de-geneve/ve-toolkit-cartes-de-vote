# Define parameters
param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Chemin vers le fichier � signer et chiffrer")]
    [string]$inputFilePath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le fichier keystore PKCS#12")]
    [string]$senderKeystore,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le fichier contenant le mot de passe du keystore")]
    [string]$senderKeystorePasswordPath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le certificat du destinataire")]
    [string]$recipientCertificate
)

# Define file paths
Write-Host "Fichier � signer et chiffrer: $inputFilePath"

$encryptedFilePath = "$inputFilePath.bin"
$tmp_pem_cert = "extracted_cert.tmp.pem"

# Extract the certificate and private key from the PKCS#12 file
Write-Host "Conversion du certicat PKCS12 $keystore en PEM $pem_cert"
openssl pkcs12 -in $senderKeystore -out $tmp_pem_cert -passin file:$senderKeystorePasswordPath -nodes

# Sign and encrypt the file using OpenSSL CMS
$signedFilePath = "$inputFilePath.der"


$thumbprintSender = openssl x509 -in "$tmp_pem_cert" -sha256 -fingerprint -noout
Write-Host "Signature du fichier $inputFilePath avec $senderKeystore [$thumbprintSender]"
openssl cms -sign -binary -nodetach -md sha256 -in $inputFilePath -signer $tmp_pem_cert -nocerts -outform der -out $signedFilePath -keyopt rsa_padding_mode:pss

$thumbprintRecipient = openssl x509 -in "$recipientCertificate" -sha256 -fingerprint -noout
Write-Host "Chiffrement du fichier $signedFilePath avec le certificat $recipientCertificate [$thumbprintRecipient]"
openssl cms -encrypt -binary -aes-256-gcm -aes256-wrap -in $signedFilePath -inform der -out $encryptedFilePath -outform der -recip $recipientCertificate

# Delete the intermediate files
Write-Host "Cleanup."
Remove-Item -Path $tmp_pem_cert -Force
Remove-Item -Path $signedFilePath -Force

Write-Host "Fichier sign� et chiffr� r�sultant: $encryptedFilePath"