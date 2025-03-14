$input = $args[0]

.\bin\dechiffrer-verifier-signature.ps1 $input -recipientKeystore .\certs\imprimeur-encrypt-keystore.p12  -recipientKeystorePasswordPath .\certs\imprimeur-encrypt-password.txt -senderCertificate .\certs\direct_trust_certificate_canton.pem