$input = $args[0]

.\bin\dechiffrer-verifier-signature.ps1 $input -recipientKeystore .\certs\imprimeur-encrypt-keystore.p12  -recipientKeystorePasswordPath .\certs\imprimeur-encrypt-password.txt -senderCertificate .\certs\ge-sign-cert.pem
if ($args[1] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
