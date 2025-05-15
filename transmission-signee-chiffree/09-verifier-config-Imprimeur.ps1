. bin\commons.ps1

$path = Prompt-Path-If-Empty $args[0] "Veuillez entrer le chemin du fichier à contrôler"

.\bin\verifier-config.ps1 $path -senderCertificate .\certs\imprimeur-conf-cert.pem

Pause $args[1]