<#
.Synopsis
    Method returns statistics slices by dates in specified time span.
.Description
    QQDescription
.Example
    Invoke-WowsAccountStatsbydateMethod
.Example
    Another example of how to use this cmdlet
.Inputs
    Inputs to this cmdlet (if any)
.Outputs
    PSCustomObject
.Notes
    NAME:      Invoke-WowsAccountStatsbydateMethod
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
function Invoke-WowsAccountStatsbydateMethod
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

		# Access token is used to access personal user data. The token is obtained via authentication and has expiration time.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=3)]
		[string]$access_token ,

		# Extra fields to be included into the response. Valid values: 
        #
        #    pve
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=4)]
		[string[]]$extra ,

		# Player account ID
        [Parameter(Mandatory=$True, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=5)]
		[int]$account_id ,

		# List of dates to return statistics slices for. Format: YYYYMMDD. Max. dates range - 28 days from the current date. Statistics slice for yesterday will be returned by default. Max limit is 10.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=6)]
		[string[]]$dates
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
        $response = Invoke-RestMethod "http://api.worldofwarships.eu/wows/account/statsbydate/$query_string"
        
        # Check the response status and handle errors
        if ($response.status -ne 'ok') {
            Write-Error -Message $response.error.message
        }
    }
    End
    {
    }
}
# Invoke-WowsAccountStatsbydateMethod
