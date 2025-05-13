param (
    [Parameter(Mandatory=$true)]
    [string]$certPath
)

Write-Host "   Certificat : $certPath"

# Empreinte SHA256
$thumbprint = openssl x509 -in "$certPath" -sha256 -fingerprint -noout
Write-Host "   Empreinte : $thumbprint"

# Sujet
$subject = openssl x509 -in "$certPath" -subject -noout
Write-Host "   Sujet : $($subject.Replace('subject=',''))"

# Dates de validité
$dates = openssl x509 -in "$certPath" -dates -noout 2>&1
$notBefore = ($dates | Select-String -Pattern 'notBefore=').ToString().Split('=')[1]
$notAfter = ($dates | Select-String -Pattern 'notAfter=').ToString().Split('=')[1]

Write-Host "   Valide du : $notBefore"
Write-Host "   Valide jusqu'au : $notAfter"