$input = $args[0]
if ([string]::IsNullOrWhiteSpace($input)) {
    $input = Read-Host -Prompt "Veuillez entrer le chemin du fichier à signer et chiffrer"
}

.\bin\signer-chiffrer.ps1 $input -senderKeystore .\certs\imprimeur-sign-keystore.p12 -senderKeystorePasswordPath .\certs\imprimeur-sign-password.txt -recipientCertificate .\certs\ge-encrypt-cert.pem
if ($args[1] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
