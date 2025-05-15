. bin\commons.ps1

$path = Prompt-Path-If-Empty $args[0] "Veuillez entrer le chemin du fichier à déchiffrer et contrôler"

.\bin\dechiffrer-verifier-signature.ps1 $path -recipientKeystore .\certs\ge-encrypt-keystore.p12  -recipientKeystorePasswordPath .\certs\ge-encrypt-password.txt -senderCertificate .\certs\imprimeur-sign-cert.pem

Pause $args[1]