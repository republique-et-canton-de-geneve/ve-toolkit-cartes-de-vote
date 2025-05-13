$input = $args[0]

.\bin\dechiffrer-verifier-signature.ps1 $input -recipientKeystore .\certs\ge-encrypt-keystore.p12  -recipientKeystorePasswordPath .\certs\ge-encrypt-password.txt -senderCertificate .\certs\imprimeur-sign-cert.pem
if ($args[1] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
