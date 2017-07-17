function getSubscriptionList 
{
    #Please make sure you have logged in using Azure AD App

    $subscriptionIDList=@()
    #$subscriptionNameList=@()
    $subscriptionDetails= Get-AzureRmSubscription    
    for($tempIndex=0;$tempIndex -lt $subscriptionDetails.Count;$tempIndex++)
    {
        if($subscriptionDetails[$tempIndex].State= 'Enabled')
        {
             $subscriptionIDList+=$subscriptionDetails[$tempIndex].ID
           # $subscriptionNameList+=$subscriptionDetails[$tempIndex].Name                      
        }
    }  

    return $subscriptionIDList
} 

function eventTrackingAlert([hashtable]$AlertData){



$returnValue = Test-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile  $EventTrackingtemplate -TemplateParameterObject  $AlertData  -Verbose 

#Check Template is valid or not.
if(-not $returnValue)
{

#Command to execute the template for provisioning resources.
 $JsonPayload = New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile $EventTrackingtemplate  -TemplateParameterObject  $AlertData -Verbose


}
else
{

Write-Host "Invalid Template" : $returnValue.Message

}
 
}

#Getting Path where template and parameter resides.
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$eventTrackingtemplate = "$scriptDirectory\Template\EventTrackingAlert.json"
$eventTrackingPara = "$scriptDirectory\Parameter\EventTrackingParameter.json"


#Getting subscription List
$subId=getSubscriptionList
$subId.Count
#initializing index value
$Index = 0

for($Index=0; $Index -lt $subId.Count; $Index++ )
{
 #Set Authentication info to session
Set-AzureRmContext -SubscriptionId $subId[$Index]
$RGName= "EventTracking"

$masterJson = Get-Content $EventTrackingPara -Raw | ConvertFrom-Json
$length=$masterJson.Length

#for($i=0;$i -lt $length;$i++)
#{

#Getting length of marster data based oj index.
$len=$masterJson[0].PSObject.Properties.Name.Length
 #Creating empty hashtable  
$AlertData=@{}

for($index1=0; $index1 -lt $len; $index1++)

{
    $AlertData+=@{
            $masterJson[0].PSObject.Properties.Name[$index1]=$masterJson[0].$($masterJson[0].PSObject.Properties.Name[$index1])
            }
            
    
       }
#}
#Calling function to provision all monitoring alerts
eventTrackingAlert($AlertData)
#Clearing old data for creating new alerts.
 #$AlertData.clear()  
}




