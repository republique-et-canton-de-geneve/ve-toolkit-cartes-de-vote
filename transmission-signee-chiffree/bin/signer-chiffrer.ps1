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

# Define file paths
Write-Host "Fichier à signer et chiffrer: $inputFilePath"

$encryptedFilePath = "$inputFilePath.bin"
$tmp_pem_cert = "extracted_cert.tmp.pem"

# Extract the certificate and private key from the PKCS#12 file
Write-Host "Conversion du certicat PKCS12 $keystore en PEM $pem_cert"
openssl pkcs12 -in $senderKeystore -out $tmp_pem_cert -passin file:$senderKeystorePasswordPath -nodes

# Sign and encrypt the file using OpenSSL CMS
$signedFilePath = "$inputFilePath.der"
Write-Host "Signature avec $keystore et chiffrement du fichier avec $recipient"
openssl cms -sign -binary -nodetach -md sha256 -in $inputFilePath -signer $tmp_pem_cert -nocerts -outform der -out $signedFilePath -keyopt rsa_padding_mode:pss
openssl cms -encrypt -binary -aes-256-gcm -aes256-wrap -in $signedFilePath -inform der -out $encryptedFilePath -outform der -recip $recipientCertificate

# Delete the intermediate files
Write-Host "Cleanup."
Remove-Item -Path $tmp_pem_cert -Force
Remove-Item -Path $signedFilePath -Force

Write-Host "Fichier chiffré et signé avec succès."
Write-Host "Fichier résultant: $encryptedFilePath"