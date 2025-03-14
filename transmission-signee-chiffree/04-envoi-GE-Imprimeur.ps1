$input = $args[0]

.\bin\signer-chiffrer.ps1 $input -senderKeystore .\certs\direct_trust_keystore_canton.p12 -senderKeystorePasswordPath .\certs\direct_trust_pw_canton.txt -recipientCertificate .\certs\imprimeur-encrypt-cert.pem