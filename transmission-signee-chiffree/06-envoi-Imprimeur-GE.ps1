$input = $args[0]

.\bin\signer-chiffrer.ps1 $input -senderKeystore .\certs\imprimeur-sign-keystore.p12 -senderKeystorePasswordPath .\certs\imprimeur-sign-password.txt -recipientCertificate .\certs\ge-encrypt-cert.pem