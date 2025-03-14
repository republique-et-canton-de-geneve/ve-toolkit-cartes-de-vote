# Définition des noms de fichiers
$binaryFileName = "random_binary_file.bin"
$zipFileName = $args[0]

Write-Host "Création d'un fichier de test binaire et zippé."

# Générer un fichier binaire aléatoire avec OpenSSL
openssl rand -out $binaryFileName 100000000

# Créer un fichier ZIP contenant le fichier binaire
Compress-Archive -Path $binaryFileName -DestinationPath $zipFileName -Force

# Supprimer le fichier binaire temporaire
Remove-Item -Path $binaryFileName

Write-Host "Fichier ZIP créé : $zipFileName"