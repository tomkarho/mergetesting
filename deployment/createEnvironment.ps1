[CmdLetBinding()]
Param(
    [Parameter()]$envType = "Dev",
    [Parameter()]$resourceGroup = "",
    [Parameter()]$webApp = "",
    [Parameter()]$spUser = "",
    [Parameter()]$spPswd = "",
    [Parameter()]$spTenant = ""
)

$ErrorActionPreference = "stop"
$location = "westeurope"
$servicePlan = "S1"

Write-Host "Creating environment..."

az login --service-principal -u $spUser --password $spPswd --tenant $spTenant

az group create --location $location --name $resourceGroup --tags EnvironmentType=$envType

az appservice plan create --name $webApp --resource-group $resourceGroup --sku $servicePlan
az webapp create --name $webApp --resource-group $resourceGroup --plan $webApp

az webapp config set --name $webApp --resource-group $resourceGroup --always-on true --php-version "Off"
az webapp log config --name $webApp --resource-group $resourceGroup --application-logging true --detailed-error-messages true --failed-request-tracing true --level verbose

az webapp deployment source config-local-git --name $webApp --resource-group $resourceGroup

az webapp deployment slot create --name $webApp --resource-group $resourceGroup --slot staging

az webapp deployment source config-local-git --name $webApp --resource-group $resourceGroup --slot staging