. bin\commons.ps1

.\bin\generer-certificat.ps1 -outputDir .\certs -baseFilename ge-sign -subject /CN=GE -daysOfValidity 365
.\bin\generer-certificat.ps1 -outputDir .\certs -baseFilename ge-encrypt -subject /CN=GE -daysOfValidity 365

Pause $args[0]