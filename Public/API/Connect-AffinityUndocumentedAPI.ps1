<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function Connect-AffinityUndocumentedAPI {
    [CmdletBinding(DefaultParameterSetName = 'Okta')]
    [Alias('Connect-AUAPI')]
    [OutputType([bool])]
    Param (
        # Credentials
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [pscredential]
        $Credentials = $AffinityUndocumentedCredentials,

        # Affinity Subdomain
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AffinitySubdomain,

        # Okta Subdomain
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'Okta',
                   Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string]
        $OktaSubdomain
    )
    
    begin {
        # HTTP headers
        $HTTPHeaders = @{
            'accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8'
            'accept-encoding' = 'gzip'
            'accept-language' = 'en-US,en'
            'cache-control' = 'no-cache'
            'dnt' = '1'
            'pragma' = 'no-cache'
            'upgrade-insecure-requests' = '1'
        }

        # HTTP user agent
        $HTTPUserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
        <#
        $HTTPUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) " + `
                         "AppleWebKit/537.36 (KHTML, like Gecko) " + `
                         "Chrome/60.0.3112.113 " + `
                         "Safari/537.36"
        #>

        # HTTP maximum redirect
        $HTTPMaximumRedirection = 10
    }

    process {
        # Start Affinity session
        $ssoresponse = Invoke-WebRequest    -Method Get `
                                            -Uri ('https://{0}.affinity.co/sso' -f $AffinitySubdomain) `
                                            -SessionVariable HTTPSession `
                                            -Headers $HTTPHeaders `
                                            -UserAgent $HTTPUserAgent `
                                            -MaximumRedirection $HTTPMaximumRedirection

        # Get Okta session token
        $authnresponse = Invoke-RestMethod  -Method Post `
                                            -Uri ('https://{0}.okta.com/api/v1/authn' -f $OktaSubdomain) `
                                            -ContentType 'application/json' `
                                            -Body ( @{
                                                'username' = $Credentials.UserName
                                                'options' = @{
                                                    'warnBeforePasswordExpired' = 'true'
                                                    'multiOptionalFactorEnroll' = 'true'
                                                }
                                                'password' = $Credentials.GetNetworkCredential().password
                                            } | ConvertTo-Json )
        
        if ($ssoresponse.StatusCode -eq 200 -and $ssoresponse.BaseResponse.RequestMessage.RequestUri -and `
            $authnresponse.status -ilike 'SUCCESS' -and $authnresponse.sessionToken) {
            # Get Okta id_token (requires basic parsing or PoSh will launch a browser window)
            $redirectresponse = Invoke-WebRequest   -Method Get `
                                                    -UseBasicParsing `
                                                    -Uri ('https://{0}.okta.com/login/sessionCookieRedirect' -f $OktaSubdomain) `
                                                    -WebSession $HTTPSession `
                                                    -Body @{ 
                                                        'checkAccountSetupComplete' = 'true'
                                                        'token' = $authnresponse.sessionToken
                                                        'redirectUrl' = $ssoresponse.BaseResponse.RequestMessage.RequestUri 
                                                    }
            
            if ($redirectresponse.StatusCode -eq 200) {
                # Post Affinity state and Okta id_token to Affinity callback
                $callbackresponse = Invoke-WebRequest   -Method Post `
                                                        -Uri ('https://{0}.affinity.co/sso/callback' -f $AffinitySubdomain) `
                                                        -WebSession $HTTPSession `
                                                        -Body @{
                                                            'state' = (
                                                                $redirectresponse.InputFields | 
                                                                Where-Object { $_.name -ilike 'state' } | 
                                                                Select-Object -First 1 -ExpandProperty 'value'
                                                            )
                                                            'id_token' = (
                                                                $redirectresponse.InputFields | 
                                                                Where-Object { $_.name -ilike 'id_token' } | 
                                                                Select-Object -First 1 -ExpandProperty 'value'
                                                            )
                                                        }
                
                if ($callbackresponse.StatusCode -eq 200) {
                    $Cookies = $HTTPSession.Cookies.GetCookies('https://{0}.affinity.co' -f $AffinitySubdomain)

                    if ($Cookies['rack.session'].value) {
                        Set-Variable -Name AffinityUndocumentedLoggedInWebSession `
                                     -Scope script `
                                     -Value $HTTPSession

                        Set-Variable -Name AffinityUndocumentedBaseUrl `
                                     -Scope script `
                                     -Value ('https://{0}.affinity.co/api' -f $AffinitySubdomain)

                        return $true
                    }
                }
            }
        }
    }
}