# D�finition des noms de fichiers
$binaryFileName = "random_binary_file.bin"
$zipFileName = $args[0]

Write-Host "Cr�ation d'un fichier de test binaire et zipp�."

# R�cup�rer le chemin du r�pertoire pour le fichier ZIP
$zipDirPath = Split-Path -Path $zipFileName -Parent

# V�rifier si le r�pertoire existe et le cr�er si n�cessaire
if (-not (Test-Path -Path $zipDirPath)) {
    New-Item -Path $zipDirPath -ItemType Directory -Force
    Write-Host "R�pertoire cr�� : $zipDirPath"
}

# G�n�rer un fichier binaire al�atoire avec OpenSSL
openssl rand -out $binaryFileName 100000000

# Cr�er un fichier ZIP contenant le fichier binaire
Compress-Archive -Path $binaryFileName -DestinationPath $zipFileName -Force

# Supprimer le fichier binaire temporaire
Remove-Item -Path $binaryFileName

Write-Host "Fichier ZIP cr�� : $zipFileName"