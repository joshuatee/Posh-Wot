<#
.Synopsis
    Method returns list of adjacent positions in specified rating.
.Description
    QQDescription
.Example
    Invoke-WowpRatingsNeighborsMethod
.Example
    Another example of how to use this cmdlet
.Inputs
    Inputs to this cmdlet (if any)
.Outputs
    PSCustomObject
.Notes
    NAME:      Invoke-WowpRatingsNeighborsMethod
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
function Invoke-WowpRatingsNeighborsMethod
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

		# Rating period
        [Parameter(Mandatory=$True, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=3)]
		[string]$type ,

		# Ratings calculation date. Up to 7 days before the current date; default value: yesterday. Date in UNIX timestamp or ISO 8601 format. E.g.: 1376542800 or 2013-08-15T00:00:00
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=4)]
		[datetime]$date ,

		# Player account ID
        [Parameter(Mandatory=$True, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=5)]
		[int]$account_id ,

		# Rating category
        [Parameter(Mandatory=$True, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=6)]
		[string]$rank_field ,

		# Maximum number of adjacent positions in rating
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=7)]
		[int]$limit
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
        $response = Invoke-RestMethod "http://api.worldofwarplanes.eu/wowp/ratings/neighbors/$query_string"
        
        # Check the response status and handle errors
        if ($response.status -ne 'ok') {
            Write-Error -Message $response.error.message
        }
    }
    End
    {
    }
}
# Invoke-WowpRatingsNeighborsMethod
