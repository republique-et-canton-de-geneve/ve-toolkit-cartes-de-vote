$input = $args[0]

.\bin\signer-chiffrer.ps1 $input -senderKeystore .\certs\ge-sign-keystore.p12 -senderKeystorePasswordPath .\certs\ge-sign-password.txt -recipientCertificate .\certs\imprimeur-encrypt-cert.pem