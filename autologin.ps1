
##Use this creds for multi-subs scenario
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

$password = ConvertTo-SecureString "CJtbj9QFDI9RHSk3AccyL3BX8XC3WLYwEjryeVHJYzY=" -AsPlainText –Force
$AppId = "126e07a8-75c1-477e-9f85-b343e35e214d"
$tenantId = "188285f7-8f1e-4c0d-a0bc-797e3e38c5b3"

$cred = New-Object -TypeName pscredential –ArgumentList $AppId , $password

Login-AzureRmAccount -Credential $cred -ServicePrincipal –TenantId $tenantId



  



 