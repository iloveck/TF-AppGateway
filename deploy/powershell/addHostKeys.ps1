Param (
    [string] $subscriptionName,
    [string] $resourceGroup,
    [string] $webAppName,
    [string] $hostKey,
    [string] $slotName = ""
)
# This isn't a secure implementation. Its just a bare minium so we don't have people hitting our endpoint.
# This is to allow for multiple deployments without having to change the code during dev. 
# A better solution using AD will be crafted going forward. 

$subscriptionId = az account show -s "$subscriptionName" --query id -o tsv
$resourceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Web/sites/$webAppName"
if ($slotName -ne "") {
    $resourceId = ($resourceId + "/slots/$slotName")
}


$keyName = "TestingHostKey"
$payload = (@{ properties=@{ name=$keyName; value="$hostKey" } } | ConvertTo-Json -Compress).Replace('"', '\"')
az rest --method put --uri "$resourceId/host/default/functionkeys/$($keyName)?api-version=2018-11-01" --body "$payload"