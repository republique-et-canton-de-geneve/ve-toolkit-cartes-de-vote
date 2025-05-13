.\bin\generer-certificat.ps1 -outputDir .\certs -baseFilename imprimeur-encrypt -subject /CN=IMPRIMEUR -daysOfValidity 365
.\bin\generer-certificat.ps1 -outputDir .\certs -baseFilename imprimeur-sign -subject /CN=IMPRIMEUR -daysOfValidity 365
.\bin\generer-certificat.ps1 -outputDir .\certs -baseFilename imprimeur-conf -subject /CN=IMPRIMEUR -daysOfValidity 365
if ($args[0] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
