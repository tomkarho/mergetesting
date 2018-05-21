[CmdLetBinding()]
Param(
    [Parameter()]$environment = "",
    [Parameter()]$webApp = "",
    [Parameter()]$resourceGroup = ""
)

Write-Host "Configuring..."