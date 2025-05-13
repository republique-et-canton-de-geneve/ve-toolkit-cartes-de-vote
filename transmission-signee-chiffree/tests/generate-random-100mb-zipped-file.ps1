# Définition des noms de fichiers
$binaryFileName = "random_binary_file.bin"
$zipFileName = $args[0]

Write-Host "Création d'un fichier de test binaire et zippé."

# Récupérer le chemin du répertoire pour le fichier ZIP
$zipDirPath = Split-Path -Path $zipFileName -Parent

# Vérifier si le répertoire existe et le créer si nécessaire
if (-not (Test-Path -Path $zipDirPath)) {
    New-Item -Path $zipDirPath -ItemType Directory -Force
    Write-Host "Répertoire créé : $zipDirPath"
}

# Générer un fichier binaire aléatoire avec OpenSSL
openssl rand -out $binaryFileName 100000000

# Créer un fichier ZIP contenant le fichier binaire
Compress-Archive -Path $binaryFileName -DestinationPath $zipFileName -Force

# Supprimer le fichier binaire temporaire
Remove-Item -Path $binaryFileName

Write-Host "Fichier ZIP créé : $zipFileName"