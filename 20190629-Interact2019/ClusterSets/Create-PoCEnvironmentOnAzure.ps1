if (!(Get-Module -Name Az -ListAvailable))
{
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
}

Connect-AzAccount
$s = Get-AzSubscription
if ($s.Count -gt 1)
{
    $s = $s | Where-Object { $_.Name -like "*Sponsorship" }
    if ($null -ne $s) {
        Set-AzContext -Subscription $s
    }
}
# 複数のサブスクリプションが存在する場合、リソースを作成するサブスクリプションを指定
#$context = Get-AzSubscription -SubscriptionId 00000000-0000-0000-0000-000000000000
#Set-AzContext $context

$rgName = "Int19-ClsSets"
$region = "Japan East"
New-AzResourceGroup -Name $rgName -Location $region

$templateUri = "https://raw.githubusercontent.com/k-takai/Demo/master/20190629-Interact2019/ClusterSets/Azure/azuredeploy.json"
New-AzResourceGroupDeployment -Name ClusterSetsLab -ResourceGroupName $rgName -TemplateUri $templateUri -Verbose

Write-Host "Please configure Network Security Group."
Write-Host "Press enter to continue..."
Read-Host | Out-Null

mstsc /v:((Get-AzPublicIpAddress -ResourceGroupName $rgName).IpAddress)
