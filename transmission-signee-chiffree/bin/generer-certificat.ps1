param (
    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le répertoire de destination des fichiers créés")]
    [string]$outputDir,

    [Parameter(Mandatory = $true, HelpMessage = "Nom de base des fichiers générés")]
    [string]$baseFilename,

    [Parameter(Mandatory = $true, HelpMessage = "Sujet inscrit dans le certificat")]
    [string]$subject,

    [Parameter(Mandatory = $true, HelpMessage = "Nombre de jours de validité")]
    [string]$daysOfValidity
)

$keyLength = 3072

Write-Host "Génération des certificats $baseFilename pour $subject"

# Vérifier si le répertoire existe et le créer si nécessaire
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
    Write-Host "Répertoire créé : $outputDir"
}

$keyPath = "$outputDir\$baseFilename-key.pem"
$certPath = "$outputDir\$baseFilename-cert.pem"
$keystorePath = "$outputDir\$baseFilename-keystore.p12"
$keystorePasswordPath = "$outputDir\$baseFilename-password.txt"

# Generate a random 256-bit key
openssl rand -hex 32 > $keystorePasswordPath

openssl req -x509 -newkey rsa:$keyLength -keyout $keyPath -out $certPath -days $daysOfValidity -nodes -subj "$subject"
openssl pkcs12 -export -in $certPath -inkey $keyPath -out $keystorePath -passout file:$keystorePasswordPath -name "$baseFilename"

# Delete the intermediate files
Write-Host "Cleanup."
Remove-Item -Path $keyPath -Force

Write-Host "Certificat public: $certPath"
Write-Host "Keystore protégé par mot de passe: $keystorePath"
Write-Host "Fichier contenant le mot de passe du keystore: $keystorePasswordPath"