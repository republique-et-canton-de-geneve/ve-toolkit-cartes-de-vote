param (
    [Parameter(Mandatory=$true, HelpMessage="Chemin vers le r�pertoire de destination des fichiers cr��s")]
    [string]$outputDir,

    [Parameter(Mandatory=$true, HelpMessage="Nom de base des fichiers g�n�r�s")]
    [string]$baseFilename,

    [Parameter(Mandatory=$true, HelpMessage="Sujet inscrit dans le certificat")]
    [string]$subject
)

$keyLength=3072

if (Test-Path -Path $outputDir)
{
    Write-Host "G�n�ration des certificats $baseFilename pour $subject"

    $keyPath = "$outputDir\$baseFilename-key.pem"
    $certPath = "$outputDir\$baseFilename-cert.pem"
    $keystorePath = "$outputDir\$baseFilename-keystore.p12"
    $keystorePasswordPath = "$outputDir\$baseFilename-password.txt"

    # Generate a random 256-bit key
    openssl rand -hex 32 > $keystorePasswordPath

    openssl req -x509 -newkey rsa:$keyLength -keyout $keyPath -out $certPath -days 3650 -nodes -subj "$subject"
    openssl pkcs12 -export -in $certPath -inkey $keyPath -out $keystorePath -passout file:$keystorePasswordPath -name "$baseFilename"

    # Delete the intermediate files
    Write-Host "Cleanup."
    Remove-Item -Path $keyPath -Force

    Write-Host "Certificat public: $certPath"
    Write-Host "Keystore prot�g� par mot de passe: $keystorePath"
    Write-Host "Fichier contenant le mot de passe du keystore: $keystorePasswordPath"
} else {
    Write-Host "Le r�pertoire $outputDir n'existe pas."
}