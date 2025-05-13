.\tests\generate-random-100mb-zipped-file.ps1 .\data\file-GE.zip
.\tests\generate-random-100mb-zipped-file.ps1 .\data\file-imprimeur.zip

.\01-generer-certificat-GE.ps1 AUTO
.\02-generer-certificats-Imprimeur.ps1 AUTO
.\03-lister-infos-certificats.ps1 AUTO
.\04-envoi-GE-Imprimeur.ps1 .\data\file-GE.zip AUTO
.\05-reception-Imprimeur.ps1 .\data\file-GE.zip.bin AUTO
.\06-envoi-Imprimeur-GE.ps1 .\data\file-imprimeur.zip AUTO
.\07-reception-GE.ps1 .\data\file-imprimeur.zip.bin AUTO
.\08-signer-config-Imprimeur.ps1 .\data\configuration AUTO
.\09-verifier-config-Imprimeur .\data\configuration.zip AUTO