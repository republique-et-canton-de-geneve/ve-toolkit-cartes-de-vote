# Define parameters
param (
    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le répertoire contenant les certificats")]
    [string]$certsDir
)

# Vérifier si le répertoire existe
if (Test-Path -Path $certsDir)
{
    Write-Host "Informations des certificats contenus dans le répertoire $certsDir"
    # Lister tous les fichiers PEM dans le répertoire
    Get-ChildItem -Path $certsDir -Filter *.pem | ForEach-Object {
        $certPath = $_.FullName

        # Vérifier qu'on a bien un certificat x509 valide
        $output = openssl x509 -in "$certPath" -subject -noout 2>&1

        if ($LASTEXITCODE -eq 0)
        {
            & "$PSScriptRoot\infos-certificat.ps1" -certPath $certPath
            Write-Host "   ---"
        }
    }
}
else
{
    Write-Host "❌ Le répertoire $certsDir n'existe pas."
}