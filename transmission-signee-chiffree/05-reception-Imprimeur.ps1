$input = $args[0]
if ([string]::IsNullOrWhiteSpace($input)) {
    $input = Read-Host -Prompt "Veuillez entrer le chemin du fichier à déchiffrer et contrôler"
}

.\bin\dechiffrer-verifier-signature.ps1 $input -recipientKeystore .\certs\imprimeur-encrypt-keystore.p12  -recipientKeystorePasswordPath .\certs\imprimeur-encrypt-password.txt -senderCertificate .\certs\ge-sign-cert.pem
if ($args[1] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
