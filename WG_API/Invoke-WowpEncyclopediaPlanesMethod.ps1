<#
.Synopsis
    Method returns list of all aircrafts from Encyclopedia.
.Description
    QQDescription
.Example
    Invoke-WowpEncyclopediaPlanesMethod
.Example
    Another example of how to use this cmdlet
.Inputs
    Inputs to this cmdlet (if any)
.Outputs
    PSCustomObject
.Notes
    NAME:      Invoke-WowpEncyclopediaPlanesMethod
    AUTHOR:    DESKTOP-NH0V78R\ivnne
    LASTEDIT:  04/08/2016 20:13:09
.Component
    The component this cmdlet belongs to
.Role
    The role this cmdlet belongs to
.Functionality
    The functionality that best describes this cmdlet
.Link
    QQLink
#>
function Invoke-WowpEncyclopediaPlanesMethod
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

		# Response field. The fields are separated with commas. Embedded fields are separated with dots. To exclude a field, use “-” in front of its name. In case the parameter is no defined, the method returns all fields.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=2)]
		[string[]]$fields ,

		# Type. Valid values: 
        #
        #    "fighter" - Fighter 
        #    "fighterHeavy" - Heavy Fighter 
        #    "assault" - Attack Aircraft 
        #    "navy" - Multirole Fighter 
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=3)]
		[string]$type ,

		# Nation. Valid values: 
        #
        #    "ussr" - U.S.S.R. 
        #    "germany" - Germany 
        #    "usa" - U.S.A. 
        #    "france" - France 
        #    "uk" - U.K. 
        #    "china" - China 
        #    "japan" - Japan 
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=4)]
		[string]$nation
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
        $response = Invoke-RestMethod "http://api.worldofwarplanes.eu/wowp/encyclopedia/planes/$query_string"
        
        # Check the response status and handle errors
        if ($response.status -ne 'ok') {
            Write-Error -Message $response.error.message
        }
    }
    End
    {
    }
}
# Invoke-WowpEncyclopediaPlanesMethod
