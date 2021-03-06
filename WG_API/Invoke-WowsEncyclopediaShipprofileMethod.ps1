<#
.Synopsis
    Method returns parameters of ships in all existing configurations.
.Description
    QQDescription
.Example
    Invoke-WowsEncyclopediaShipprofileMethod
.Example
    Another example of how to use this cmdlet
.Inputs
    Inputs to this cmdlet (if any)
.Outputs
    PSCustomObject
.Notes
    NAME:      Invoke-WowsEncyclopediaShipprofileMethod
    AUTHOR:    DESKTOP-NH0V78R\ivnne
    LASTEDIT:  04/08/2016 20:13:10
.Component
    The component this cmdlet belongs to
.Role
    The role this cmdlet belongs to
.Functionality
    The functionality that best describes this cmdlet
.Link
    QQLink
#>
function Invoke-WowsEncyclopediaShipprofileMethod
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

		# Response field. The fields are separated with commas. Embedded fields are separated with dots. To exclude a field, use “-” in front of its name. In case the parameter is not defined, the method returns all fields.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1)]
		[string[]]$fields ,

		# Localization language. Valid values: 
        #
        #    "cs" - Čeština 
        #    "de" - Deutsch 
        #    "en" - English (by default)
        #    "es" - Español 
        #    "fr" - Français 
        #    "ja" - 日本語 
        #    "ko" - 한국어 
        #    "pl" - Polski 
        #    "ru" - Русский 
        #    "th" - ไทย 
        #    "zh-tw" - 繁體中文 
        #    "tr" - Türkçe 
        #    "zh-cn" - 中文 
        #    "pt-br" - Português do Brasil 
        #    "es-mx" - Español (México) 
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=2)]
		[string]$language ,

		# Ship ID
        [Parameter(Mandatory=$True, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=3)]
		[int]$ship_id ,

		# Main Battery ID. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=4)]
		[int]$artillery_id ,

		# Torpedo tubes' ID. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=5)]
		[int]$torpedoes_id ,

		# ID of Gun Fire Control System. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=6)]
		[int]$fire_control_id ,

		# ID of Flight Control System. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=7)]
		[int]$flight_control_id ,

		# Hull ID. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=8)]
		[int]$hull_id ,

		# Engine ID. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=9)]
		[int]$engine_id ,

		# Fighters' ID. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=10)]
		[int]$fighter_id ,

		# Dive bombers' ID. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=11)]
		[int]$dive_bomber_id ,

		# Torpedo bombers' ID. If the module is not indicated, module of basic configuration is used.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=12)]
		[int]$torpedo_bomber_id
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
        $response = Invoke-RestMethod "http://api.worldofwarships.eu/wows/encyclopedia/shipprofile/$query_string"
        
        # Check the response status and handle errors
        if ($response.status -ne 'ok') {
            Write-Error -Message $response.error.message
        }
    }
    End
    {
    }
}
# Invoke-WowsEncyclopediaShipprofileMethod
