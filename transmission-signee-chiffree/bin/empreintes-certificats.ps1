# Define parameters
param (
    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le r�pertoire contenant les certificats")]
    [string]$certsDir
)

# V�rifier si le r�pertoire existe
if (Test-Path -Path $certsDir)
{
    Write-Host "Informations des certificats contenus dans le r�pertoire $certsDir"
    # Lister tous les fichiers PEM dans le r�pertoire
    Get-ChildItem -Path $certsDir -Filter *.pem | ForEach-Object {
        $certPath = $_.FullName

        # V�rifier qu'on a bien un certificat x509 valide
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
    Write-Host "Le r�pertoire $certsDir n'existe pas."
}