# Demande à l'utilisateur de saisir un chemin s'il n'a pas été défini
# Les double quotes sont supprimés si l'utilisateur en rajoute pour éviter des erreurs de chemin par la suite
function Prompt-Path-If-Empty {
    param (
        [string]$path,
        [string]$PromptText
    )
    if ([string]::IsNullOrWhiteSpace($path))
    {
        $path = Read-Host -Prompt $PromptText
    }

    if ($path.StartsWith('"') -and $path.EndsWith('"'))
    {
        return $path.Substring(1, $path.Length - 2)
    } else
    {
        return $path
    }
}

# Met en pause le script en attendant que l'utilisateur appuie sur Entrée
function Pause {
    param (
        [string]$autoArg
    )

    if ($autoArg -ne "AUTO") {
        Read-Host -Prompt "Tapez Entree pour continuer..."
    }
}