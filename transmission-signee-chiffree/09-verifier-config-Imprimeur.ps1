$input = $args[0]
if ([string]::IsNullOrWhiteSpace($input)) {
    $input = Read-Host -Prompt "Veuillez entrer le chemin du fichier à contrôler"
}

.\bin\verifier-config.ps1 $input -senderCertificate .\certs\imprimeur-conf-cert.pem
if ($args[1] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
