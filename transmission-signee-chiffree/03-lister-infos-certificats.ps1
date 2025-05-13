.\bin\empreintes-certificats.ps1 -certsDir .\certs\
if ($args[0] -ne "AUTO") {
    Read-Host -Prompt "Tapez Entree pour continuer..."
}
