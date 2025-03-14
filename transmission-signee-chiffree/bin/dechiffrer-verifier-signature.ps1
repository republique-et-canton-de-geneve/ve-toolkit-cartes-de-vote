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

# Get the private key from the recipient keystore
Write-Host "Extraction de la cl� priv�e du keystore du destinataire."
$recipientKey = "extracted_recipient_key.tmp.pem"
openssl pkcs12 -in $recipientKeystore -out $recipientKey -passin file:$recipientKeystorePasswordPath -nodes -nocerts

Write-Host "D�chiffrement et v�rification de la signature du fichier."
$decryptedFilePath = [System.IO.Path]::ChangeExtension($encryptedFilePath, ".der")
openssl cms -decrypt -binary -in $inputFilePath -inkey $recipientKey -inform der -out $decryptedFilePath
openssl cms -verify -binary -in $decryptedFilePath -inform der -out $verifiedFilePath -certfile $senderCertificate -CAfile $senderCertificate

# Delete intermediate files
Write-Host "Cleanup."
Remove-Item -Path $recipientKey -Force
Remove-Item -Path $decryptedFilePath -Force

Write-Host "Fichier d�chiffr� et v�rifi�: $verifiedFilePath"