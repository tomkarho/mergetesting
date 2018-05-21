[CmdLetBinding()]
Param(
        [Parameter()]$resourceGroup = "",
        [Parameter()]$webApp = ""
)

Write-Host "Deploying..."