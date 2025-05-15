. bin\commons.ps1

$path = Prompt-Path-If-Empty $args[0] "Veuillez entrer le chemin du répertoire à compresser et signer"

.\bin\signer-config.ps1 $path -senderKeystore .\certs\imprimeur-conf-keystore.p12 -senderKeystorePasswordPath .\certs\imprimeur-conf-password.txt

Pause $args[1]
