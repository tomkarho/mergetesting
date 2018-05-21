[CmdLetBinding()]
Param(
    [Parameter()]$envType = "Dev",
    [Parameter()]$resourceGroup = "",
    [Parameter()]$webApp = "",
    [Parameter()]$spUser = "",
    [Parameter()]$spPswd = "",
    [Parameter()]$spTenant = ""
)

Write-Host "Creating environment..."