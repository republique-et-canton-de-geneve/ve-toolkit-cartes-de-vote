.\tests\generate-random-100mb-zipped-file.ps1 .\data\file-GE.zip
.\tests\generate-random-100mb-zipped-file.ps1 .\data\file-imprimeur.zip

.\01-generer-certificat-GE.ps1
.\02-generer-certificats-Imprimeur.ps1
.\03-lister-empreintes-certificats.ps1
.\04-envoi-GE-Imprimeur.ps1 .\data\file-GE.zip
.\05-reception-Imprimeur.ps1 .\data\file-GE.zip.bin
.\06-envoi-Imprimeur-GE.ps1 .\data\file-imprimeur.zip
.\07-reception-GE.ps1 .\data\file-imprimeur.zip.bin