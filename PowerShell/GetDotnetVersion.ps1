param(
		[ValidatePattern("^([2-4](\.[0-9](\.[0-9][0-9.]*)?)?)?$")]
		[string]$requiredVersion = "1",
		[parameter( ValueFromRemainingArguments = $true )]
		[string[]]$ignoredArgs,
		[switch]$h
)

function Compare-Versions {
	param(
		[parameter( Mandatory = $true )]
		[string]$vera,
		[parameter( Mandatory = $true )]
		[string]$verb
	)
	
	# [version] cast throws errors on some strings that LOOK acceptable, so
	# we'll just split the version strings at the dots and compare each "digit"
	
	# add 3 "digits" so we'll have at least 4 "digits" to compare
	$vera   = "$vera.0.0.0"
	$verb   = "$verb.0.0.0"
	# convert to arrays that can be iterated through
	$array1 = $vera -split "\."
	$array2 = $verb -split "\."
	# default if versions match
	$result = 0;
	for ( $i = 0; $i -lt 4; $i++ ) {
		if ( $array1[$i] -gt $array2[$i] ) {
			# vera greater than verb
			$result = 1
			# abort to ignore "digits" of lesser significance
			break
		} elseif ( $array1[$i] -lt $array2[$i] ) {
			# verb greater than vera
			$result = -1
			# abort to ignore "digits" of lesser significance
			break
		}
	}
	$result
}

function Get-Version {
	# return the "Version" value if it exists at the current registry path
	Get-ChildItem -Path . | ForEach-Object {
		$_ | Get-ItemProperty -Name "Version" -ErrorAction SilentlyContinue
	}
}
	
if ( $h -or $ignoredArgs ) {
	Write-Host
	Write-Host "GetDotNETVersion.ps1,  Version 1.00"
	Write-Host "List the .NET Framework versions installed in Windows"
	Write-Host
	Write-Host "Usage:  powershell  ./GetDotNETVersion.ps1  [ required ]"
	Write-Host
	Write-Host "Where:  required    is the minimum version required"
	Write-Host "                    (2..4.9.*, e.g. 3 or 3.5.30729.5420 or 4.6)"
	Write-Host
	Write-Host "Note:   The return code will be 0 if the script completed"
	Write-Host "        successfully, 1 if the minimum version requirement"
	Write-Host "        is not met or in case of (command line) errors"
	Write-Host
	Write-Host "Written by Rob van der woude"
	Write-Host "http://www.robvanderwoude.com"
	Write-Host

	Exit 1
} else {
	# initial location, to be restored when done
	$startlocation = ( Get-Location )
	
	# is a minimumrequirement set?
	[boolean]$reqVerSet = ( $requiredVersion -ne "1" )
	
	# .NET List<string> object to contain all unique version strings we will find
	[Collections.Generic.List[String]]$uniqueVersions = @( )
	
	# set the starting location in the registry from where we will search for version strings
	Set-Location -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP"
	# iterate through all subkeys recursively
	Get-ChildItem -Path . -Recurse | ForEach-Object -ErrorAction SilentlyContinue {
		$regpath = ( "Registry::" + $_.Name )
		Set-Location -Path $regpath
		# a separate function was used here because the sript
		# often tripped on the nested ForEach-Object invocations
		$version = ( Get-Version ).Version
		if ( $version ) {
			# in case more than one version is presented in the string...
			$version -split "\s" | ForEach-Object {
				# prevent duplicates, add unique versions only
				if ( -not $uniqueVersions.Contains( $_ ) ) {
					$uniqueVersions.Add( $_ )
				}
			}
		}
	}
	
	# sort the list
	$uniqueVersions.Sort( )
	
	# worst case return code
	$rc = 1
	
	# Display the results
	$uniqueVersions | ForEach-Object {
		if ( $reqVerSet ) {
			if ( ( Compare-Versions $_ $requiredVersion ) -gt -1 ) {
				# matches minimum requirement: show in green
				Write-Host $_ -ForegroundColor Green
				# at least one match, hence return code 0
				$rc = 0
			} else {
				# does not match minimum requirement: show in red
				Write-Host $_ -ForegroundColor Red
			}
		} else {
			Write-Host $_
			# at least one match, hence return code 0
			$rc = 0
		}
	}
	
	# restore initial location
	Set-Location $startlocation
	
	Exit $rc
}