# D�finition des noms de fichiers
$binaryFileName = "random_binary_file.bin"
$zipFileName = $args[0]

Write-Host "Cr�ation d'un fichier de test binaire et zipp�."

# G�n�rer un fichier binaire al�atoire avec OpenSSL
openssl rand -out $binaryFileName 100000000

# Cr�er un fichier ZIP contenant le fichier binaire
Compress-Archive -Path $binaryFileName -DestinationPath $zipFileName -Force

# Supprimer le fichier binaire temporaire
Remove-Item -Path $binaryFileName

Write-Host "Fichier ZIP cr�� : $zipFileName"