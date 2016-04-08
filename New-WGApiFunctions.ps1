#Requires -Version 3
Set-StrictMode -Version Latest

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-WGApi_Request
{
    [CmdletBinding()] 
    param(
        [Parameter(Position=0)]
        [String]$Verb="Verb",

        [Parameter(Position=1)]
        [String]$Noun="Noun",

        [Parameter(Position=2)]
        [PSCustomObject[]]$Parameter="QQParameterName",

        [Parameter()]
        [String]$Synopsis="QQSynopsis",

        [Parameter()]
        [String]$Description="QQDescription",

        [Parameter()]
        [String]$Link="QQLink",

        [Parameter()]
        [String]$Region="Region",

        [Parameter()]
        [String]$BasePath="QQBasePath"
    )
    $ReturnValue="PSCustomObject"
    <# We convert to a scriptblock and then back to text to ensure
    that we are creating a valid script #>
    $Body = "" + [ScriptBlock]::Create(
@"
    [CmdletBinding(
        SupportsShouldProcess=`$False,
        SupportsTransactions=`$False, 
        ConfirmImpact="None",
        DefaultParameterSetName="")]
    [OutputType([$ReturnValue])]
    param($($i=0
            foreach ($param in @($Parameter))
            {@"
$(if($i){",`r`n`r`n`t`t"}else{"`r`n`t`t"})# $($param.Help -replace "`n","`r`n        #" -replace "&mdash;","-" -replace " \* ", "* " -replace "\* ", "    ")
        [Parameter(Mandatory=`$$($param.Required), 
                   ValueFromPipeline=`$true,
                   ValueFromPipelineByPropertyName=`$true, 
                   ValueFromRemainingArguments=`$false, 
                   Position=$i)]$("`r`n`t`t")$($param.Type)`$$($param.Name)
"@
                $i++
            }
        )
    )
    Begin
    {
    }
    Process
    {
        `$query_string = '?'
        `$MyInvocation.BoundParameters | %{
            `$_.GetEnumerator() | % {
                    `$query_string += '&' + (Get-Variable `$_.Key).Name + '=' + (Get-Variable `$_.Key).Value
                }
        }
        `$query_string.TrimStart('&')
        `$response = Invoke-RestMethod "http://$uri`$query_string"
        
        # Check the response status and handle errors
        if (`$response.status -ne 'ok') {
            Write-Error -Message `$response.error.message
        }
    }
    End
    {
    }
"@
)
    
    $Cmdlet = $("$($verb)-$($noun)")
@"
<#
.Synopsis
    $Synopsis
.Description
    $Description
.Example
    $($verb)-$($Noun)
.Example
    Another example of how to use this cmdlet
.Inputs
    Inputs to this cmdlet (if any)
.Outputs
    $ReturnValue
.Notes
    NAME:      $($verb)-$($Noun)
    AUTHOR:    $("$ENV:USERDOMAIN\$ENV:USERNAME")
    LASTEDIT:  $(Get-Date)
.Component
    The component this cmdlet belongs to
.Role
    The role this cmdlet belongs to
.Functionality
    The functionality that best describes this cmdlet
.Link
    $Link
#>
function $Cmdlet
{
$body
}
# $Cmdlet
"@    
}

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-WGApiDescription
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([PSCustomObject])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $Region
    )

    Begin
    {
        $api_cache = "$PSScriptRoot\wg_api_cache.json"
        $wg_api = @()
    }
    Process
    {
        if (Test-Path $api_cache -PathType Leaf)
        {
            $wg_api = Get-Content $api_cache | ConvertFrom-Json
            $wg_api
        }
        else
        {
            $wg_api_root | % { $wg_api += Invoke-RestMethod "https://api.$($PSItem.Domain).$($Region)$($PSItem.Root)" }
            $wg_api | ConvertTo-Json -Depth 16 | out-file $api_cache
            $wg_api
        }
    }
    End
    {
    }
}

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-WGApiFunctions
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([void])]
    Param
    (
        # Region help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]
        $Region,

        # AppID help description
        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]
        $AppID
    )

    Begin
    {
        $wg_api_root = @(
            @{
                Domain = 'worldoftanks'
                Root = '/wot/'
            },
            @{
                Domain = 'wotblitz'
                Root = '/wotb/'
            },
            @{
                Domain = 'worldofwarplanes'
                Root = '/wowp/'
            },
            @{
                Domain = 'worldofwarships'
                Root = '/wows/'
            },
            @{
                Domain = 'worldoftanks'
                Root = '/wgn/'
            }
        )
    }
    Process
    {
        $api_folder = "$psScriptRoot\WG_API"
        if (Test-Path $api_folder -PathType Container) { Remove-Item $api_folder -Recurse -Force}
        New-Item $api_folder -ItemType Directory | Out-Null
        
        foreach ($api in Get-WGApiDescription -Region $Region)
        {
            Write-Verbose "Creating APIs for category `"$($api.long_name)`". Available methods:"
            $hash = $wg_api_root|where Root -EQ "/$($api.name)/"
            $domain = "api.$($hash.Domain).$region"
            $api_type= $hash.Root
            $base_uri = $domain + $api_type
            
            $i = 0
            foreach ($method in $api.methods)
            {
                $i ++
                Write-Verbose "$($i). $($method.name)"
                #if ([bool]$($method.deprecated)) { Write-Error -Message "$($method.name) method is deprecated" -ErrorAction Continue; Continue }
                $uri = $base_uri + "$($method.url)/"
                $verb = 'Invoke'
                $tmp = $method.url
                $tmp -match "(?<content1>.*)/(?<content2>.*)" | ForEach-Object {
                    if (-not $PSItem)
                    {
                        Write-Error -Message "Could't Match" -ErrorAction Continue
                        Continue
                    }
                }
                $tmp = $api_type -replace "/"
                $first_noun = "$($tmp.substring(0, 1).toUpper())$($tmp.substring(1))"
                $second_noun = "$($matches['content1'].substring(0, 1).toUpper())$($matches['content1'].substring(1))"
                $third_noun = "$($matches['content2'].substring(0, 1).toUpper())$($matches['content2'].substring(1))"
                $noun = "$first_noun$second_noun$($third_noun)Method"

                $parameters = @()
                foreach ($field in $method.input_form_info.fields)
                {
                    #if ([bool]$($field.deprecated)) { Write-Error -Message "$($field.name) field is deprecated" -ErrorAction Continue; Continue }
                    $parameters += @{
                        Name = $field.name
                        Type = ConvertTo-PowerShellType -WGApiType $field.doc_type -DbgMethod $noun -DbgField $field.name
                        Required = $field.required
                        Help = $field.help_text
                        Deprecated = $field.deprecated
                        DeprecatedText = $field.deprecated_text
                    }

                }
                #@('Method', 'Protocol') | % { $parameter += $PSItem }
                $synopsis = $method.description
                New-WGApi_Request -Verb $verb -Noun $noun -Parameter $parameters -Synopsis $synopsis | Out-File "$api_folder\$verb-$noun.ps1"
				#New-WGApi_Request -Verb $verb -Noun $noun -Parameter $parameters -Synopsis $synopsis >> "WG_API.ps1"
            }
        }
    }
    End
    {
    }
}

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function ConvertTo-PowerShellType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$WGApiType,

        [Parameter()]
        [string]$DbgMethod,

        [Parameter()]
        [string]$DbgField
    )

    Begin
    {
    }
    Process
    {
        # NOTE: a strongly typed array that can store whole numbers only:
        # [int[]]$array = 1,2,3
        # one dimensional array of size 10 that can store whole numbers only
        # $array1 = New-Object 'int[]' 10
        # 2D, 10X20
        # $array2 = New-Object 'int[,]' 10,20
        
        switch ($WGApiType)
        {
            'numeric' { $type = '[int]'}
            'string' { $type = '[string]'}
            'string, list' { $type = '[string[]]'}
            'numeric, list' { $type = '[int[]]'}
            'timestamp/date' {
                # ISO 8601. 2013-08-15T00:00:00. ISO 8601 is ZONE DEPENDENT???
                # Get-Date -Format s
                # [datetime]::UtcNow.ToString("s") #shpi;d be enough
                # [datetime]::Now.ToString("s")
                # [datetime]::UtcNow.ToString("s", [CultureInfo]::InvariantCulture)
                # [datetime]::UtcNow.ToString([CultureInfo]::InvariantCulture.DateTimeFormat.SortableDateTimePattern)
                $type = '[datetime]' 
            } 
            Default
            {
                Write-Error -Message "Couldn't convert '$WGApiType' to a PowerShell Type in $DbgMethod/$DbgField"
                $type = ''
            }
        }
        Write-Output $type
    }
    End
    {
    }
}

New-WGApiFunctions -Region eu -AppID demo -Verbose



