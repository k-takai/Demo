if (!(Get-Module -Name Az -ListAvailable))
{
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
}

Connect-AzAccount
Get-AzSubscription
# 複数のサブスクリプションが存在する場合、リソースを作成するサブスクリプションを指定
#$context = Get-AzSubscription -SubscriptionId 00000000-0000-0000-0000-000000000000
#Set-AzContext $context

$rgName = "Int19-ClsSets"
$region = "Japan East"
New-AzResourceGroup -Name $rgName -Location $region

$templateUri = "https://raw.githubusercontent.com/k-takai/Demo/master/20190629-Interact2019/ClusterSets/Azure/azuredeploy.json"
New-AzResourceGroupDeployment -Name ClusterSetsLab -ResourceGroupName $rgName -TemplateUri $templateUri -Verbose

mstsc /v:((Get-AzPublicIpAddress -ResourceGroupName $rgName).IpAddress)
