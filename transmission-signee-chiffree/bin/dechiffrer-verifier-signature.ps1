param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Chemin vers le fichier � d�chiffrer et v�rifier")]
    [string]$inputFilePath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le keystore de d�chiffrement du destinataire au format PEM")]
    [string]$recipientKeystore,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le fichier contenant le mot de passe pour le keystore de d?chiffrement du destinataire")]
    [string]$recipientKeystorePasswordPath,

    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le certificat public de l'�metteur au format PEM")]
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
$tmp_pem_cert = "extracted_cert.tmp.pem"
Write-Host "Conversion du certicat PKCS12 $recipientKeystore en PEM $tmp_pem_cert"
$recipientKey = "extracted_recipient_key.tmp.pem"
openssl pkcs12 -in $recipientKeystore -out $recipientKey -passin file:$recipientKeystorePasswordPath -nodes -nocerts
openssl pkcs12 -in $recipientKeystore -out $tmp_pem_cert -passin file:$recipientKeystorePasswordPath -nodes


$decryptedFilePath = [System.IO.Path]::ChangeExtension($encryptedFilePath, ".der")

Write-Host "D�chiffrement du fichier $inputFilePath"
Write-Host "   >>> Informations du certificat de d�chiffrement"
& "$PSScriptRoot\infos-certificat.ps1" -certPath $tmp_pem_cert
openssl cms -decrypt -binary -in $inputFilePath -inkey $recipientKey -inform der -out $decryptedFilePath

Write-Host "V�rification de la signature du fichier $decryptedFilePath"
Write-Host "   >>> Informations du certificat de signature"
& "$PSScriptRoot\infos-certificat.ps1" -certPath $senderCertificate
openssl cms -verify -binary -in $decryptedFilePath -inform der -out $verifiedFilePath -certfile $senderCertificate -CAfile $senderCertificate

# Delete intermediate files
Write-Host "Cleanup."
Remove-Item -Path $recipientKey -Force
Remove-Item -Path $decryptedFilePath -Force

Write-Host "Fichier d�chiffr� et v�rifi�: $verifiedFilePath"