<#
.Synopsis
    Method authenticates user based on Wargaming.net ID (OpenID) which is used in World of Tanks, World of Tanks Blitz, World of Warships, World of Warplanes, and WarGag.ru. To log in, player must enter email and password used for creating account, or use a social network profile.
Authentication is not available for iOS Game Center users in the following cases:
*  the account is not linked to a social network account, or
*  email and password are not specified in the profile.

Information on authorization status is sent to URL specified in **redirect_uri** parameter.

If authentication is successful, the following parameters are sent to **redirect_uri**:

*  **status: ok** — successful authentication
*  **access_token** — access token is passed in to all methods that require authentication
*  **expires_at** — expiration date of **access_token**
*  **account_id** — user ID
*  **nickname** — user name.

If authentication fails, the following parameters are sent to **redirect_uri**:

*  **status: error** — authentication error
*  **code** — error code
*  **message** — error message.
.Description
    QQDescription
.Example
    Invoke-WotAuthLoginMethod
.Example
    Another example of how to use this cmdlet
.Inputs
    Inputs to this cmdlet (if any)
.Outputs
    PSCustomObject
.Notes
    NAME:      Invoke-WotAuthLoginMethod
    AUTHOR:    DESKTOP-NH0V78R\ivnne
    LASTEDIT:  04/08/2016 20:13:06
.Component
    The component this cmdlet belongs to
.Role
    The role this cmdlet belongs to
.Functionality
    The functionality that best describes this cmdlet
.Link
    QQLink
#>
function Invoke-WotAuthLoginMethod
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

		# **Access_token*    expiration time in UNIX. Delta can also be specified in seconds.
        #
        #Expiration time and delta must not exceed two weeks from the current time.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1)]
		[int]$expires_at ,

		# Page URL where user is redirected after authentication.
        #
        #Default page: 
        #[{API_HOST}/blank/](https://{API_HOST}/blank/)
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=2)]
		[string]$redirect_uri ,

		# Layout for mobile applications. Valid values: **page**, **popup**. Valid values: 
        #
        #    "page" - Page 
        #    "popup" - Popup window 
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=3)]
		[string]$display ,

		# If parameter **nofollow=1*    is passed in, the user is not redirected. URL is returned in response.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=4)]
		[int]$nofollow
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
        $response = Invoke-RestMethod "http://api.worldoftanks.eu/wot/auth/login/$query_string"
        
        # Check the response status and handle errors
        if ($response.status -ne 'ok') {
            Write-Error -Message $response.error.message
        }
    }
    End
    {
    }
}
# Invoke-WotAuthLoginMethod
