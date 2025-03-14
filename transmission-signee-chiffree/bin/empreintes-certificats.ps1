# Define parameters
param (
    [Parameter(Mandatory = $true, HelpMessage = "Chemin vers le r�pertoire contenant les certificats")]
    [string]$certsDir
)

# V�rifier si le r�pertoire existe
if (Test-Path -Path $certsDir)
{
    # Lister tous les fichiers PEM dans le r�pertoire
    Get-ChildItem -Path $certsDir -Filter *.pem | ForEach-Object {
        $certPath = $_.FullName

        $output = openssl x509 -in "$certPath" -subject -noout 2>&1
        if ($LASTEXITCODE -eq 0)
        {
            Write-Host "Certificat : $certPath"
            # Utiliser OpenSSL pour afficher l'empreinte du certificat
            $thumbprint = openssl x509 -in "$certPath" -sha256 -fingerprint -noout
            Write-Host "Empreinte : $thumbprint"
            $thumbprint = openssl x509 -in "$certPath" -subject -noout
            Write-Host "Sujet : $thumbprint"
            Write-Host "------------------------"
        }
    }
}
else
{
    Write-Host "Le r�pertoire $certsDir n'existe pas."
}