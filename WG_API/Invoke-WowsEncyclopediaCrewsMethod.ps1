<#
.Synopsis
    Method returns the information about Commanders.
.Description
    QQDescription
.Example
    Invoke-WowsEncyclopediaCrewsMethod
.Example
    Another example of how to use this cmdlet
.Inputs
    Inputs to this cmdlet (if any)
.Outputs
    PSCustomObject
.Notes
    NAME:      Invoke-WowsEncyclopediaCrewsMethod
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
function Invoke-WowsEncyclopediaCrewsMethod
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

		# Commander ID
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=3)]
		[int[]]$commander_id
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
        $response = Invoke-RestMethod "http://api.worldofwarships.eu/wows/encyclopedia/crews/$query_string"
        
        # Check the response status and handle errors
        if ($response.status -ne 'ok') {
            Write-Error -Message $response.error.message
        }
    }
    End
    {
    }
}
# Invoke-WowsEncyclopediaCrewsMethod
