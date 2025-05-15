. bin\commons.ps1

$path = Prompt-Path-If-Empty $args[0] "Veuillez entrer le chemin du fichier à signer et chiffrer"

.\bin\signer-chiffrer.ps1 $path -senderKeystore .\certs\ge-sign-keystore.p12 -senderKeystorePasswordPath .\certs\ge-sign-password.txt -recipientCertificate .\certs\imprimeur-encrypt-cert.pem

Pause $args[1]
