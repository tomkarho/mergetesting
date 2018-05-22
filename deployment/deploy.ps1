[CmdLetBinding()]
Param(
        [Parameter()]$resourceGroup = "",
        [Parameter()]$webApp = ""
)

$ErrorActionPreference = "stop"

$staging = "$webApp-staging";

$slot = "$webApp/slots/staging"

$publishingProfile = az webapp deployment list-publishing-profiles  --resource-group $resourceGroup --name $slot --query "[].{Username:userName,Password:userPWD}|[0]" -o json | ConvertFrom-Json
$gitDeploymentUrl = "https://$($publishingProfile.Username):$($publishingProfile.Password)@$($staging).scm.azurewebsites.net/$($staging)-staging.git"


Write-Host "Deploying to '$gitDeploymentUrl'"

Copy-Item "$PsScriptRoot/etc/web.config" "$PsScriptRoot/../dist/"

Push-Location "$PsScriptRoot/../dist/"
    git init

    git config user.email "deploy@deploy.com"
    git config user.name "deploy@deploy.com"

    git add . -A
    git commit -am "Build"


    git remote remove azure
    git remote add azure $gitDeploymentUrl

    git push azure master -f
Pop-Location

Write-Host "https://$staging.azurewebsites.net"

az webapp deployment slot swap  -g $resourceGroup -n $webApp --slot staging --target-slot production