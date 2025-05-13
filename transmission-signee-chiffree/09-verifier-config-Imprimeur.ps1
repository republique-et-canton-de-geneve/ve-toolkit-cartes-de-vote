$input = $args[0]
.\bin\verifier-config.ps1 $input -senderCertificate .\certs\imprimeur-conf-cert.pem
if ($args[1] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
