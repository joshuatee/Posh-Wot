<#
.Synopsis
    Method returns a tanks' gun list.

The logic of this method and some field values may vary according to optional parameters passed.

Changeable fields:

 * **damage**
 * **piercing_power**
 * **rate**
 * **price_credit**
 * **price_gold**

Optional input parameters work as follows:

 * correct **turret_id** passed — tank guns are filtered by whether they are placed on the turret and the abovementioned values change according to the turret;
 * correct **turret_id** and **module_id** passed — the method returns details on each module with the abovementioned values changed according to the turret, or returns null if the module is not compatible with the turret;
 * correct **tank_id** passed — if tank type matches one of AT-SPG, SPG, mediumTank, tank guns are filtered by whether they belong to the tank, the abovementioned values change according to the tank; otherwise, returns an error and requests **turret_id**. If **module_id** is also passed, the method returns details on each module with the abovementioned values changed according to the tank, or returns null if the module is not compatible with the tank;
 * compatible **turret_id** and **tank_id** passed — tank guns are filtered by whether they belong to the tank and are placed on the turret, the abovementioned values changed according to the turret.

.Description
    QQDescription
.Example
    Invoke-WotEncyclopediaTankgunsMethod
.Example
    Another example of how to use this cmdlet
.Inputs
    Inputs to this cmdlet (if any)
.Outputs
    PSCustomObject
.Notes
    NAME:      Invoke-WotEncyclopediaTankgunsMethod
    AUTHOR:    DESKTOP-NH0V78R\ivnne
    LASTEDIT:  04/08/2016 20:13:07
.Component
    The component this cmdlet belongs to
.Role
    The role this cmdlet belongs to
.Functionality
    The functionality that best describes this cmdlet
.Link
    QQLink
#>
function Invoke-WotEncyclopediaTankgunsMethod
{
    [CmdletBinding(
        SupportsShouldProcess=$False,
        SupportsTransactions=$False, 
        ConfirmImpact="None",
        DefaultParameterSetName="")]
    [OutputType([PSCustomObject])]
    param(
		# Application ID
        [Parameter(Mandatory=$True, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
		[string]$application_id ,

		# Localization language. Valid values: 
        #
        #    "en" - English (by default)
        #    "ru" - Русский 
        #    "pl" - Polski 
        #    "de" - Deutsch 
        #    "fr" - Français 
        #    "es" - Español 
        #    "zh-cn" - 简体中文 
        #    "tr" - Türkçe 
        #    "cs" - Čeština 
        #    "th" - ไทย 
        #    "vi" - Tiếng Việt 
        #    "ko" - 한국어 
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1)]
		[string]$language ,

		# Response field. The fields are separated with commas. Embedded fields are separated with dots. To exclude a field, use “-” in front of its name. In case the parameter is not defined, the method returns all fields.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=2)]
		[string[]]$fields ,

		# Module ID
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=3)]
		[int[]]$module_id ,

		# Nation
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=4)]
		[string[]]$nation ,

		# Compatible turret ID
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=5)]
		[int]$turret_id ,

		# Compatible vehicle ID
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=6)]
		[int]$tank_id
    )
    Begin
    {
    }
    Process
    {
        $query_string = '?'
        $MyInvocation.BoundParameters | %{
            $_.GetEnumerator() | % {
                    $query_string += '&' + (Get-Variable $_.Key).Name + '=' + (Get-Variable $_.Key).Value
                }
        }
        $query_string.TrimStart('&')
        $response = Invoke-RestMethod "http://api.worldoftanks.eu/wot/encyclopedia/tankguns/$query_string"
        
        # Check the response status and handle errors
        if ($response.status -ne 'ok') {
            Write-Error -Message $response.error.message
        }
    }
    End
    {
    }
}
# Invoke-WotEncyclopediaTankgunsMethod
