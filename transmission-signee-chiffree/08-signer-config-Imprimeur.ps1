$input = $args[0]
if ([string]::IsNullOrWhiteSpace($input)) {
    $input = Read-Host -Prompt "Veuillez entrer le chemin du répertoire à compresser et signer"
}

.\bin\signer-config.ps1 $input -senderKeystore .\certs\imprimeur-conf-keystore.p12 -senderKeystorePasswordPath .\certs\imprimeur-conf-password.txt
if ($args[1] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
