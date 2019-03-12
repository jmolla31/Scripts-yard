
<#PSScriptInfo

.VERSION 1.1

.GUID 112b2dda-54ca-46d9-bde4-9a892e3e0004

.AUTHOR jmollami

.SYNOPSIS
 Kubectl.exe version changer with an .exe cache.

.DESCRIPTION 
 Kubechanger updates your kubectl.exe version to avoid problems when connecting to Kubernetes clusters.
 Kubectl versions are downloaded from googleapis.com and an "pseudocache" of already downloaded versions is kept
 for allowing quick swapping between frequently used versions.

#>

 param (
    [string]$arg = $( Read-Host "Input version [X.X.X]" )
 )


#Parse input arguments
if ($arg -eq 'last'){
    $last = Invoke-WebRequest https://storage.googleapis.com/kubernetes-release/release/stable.txt
    $version = $last.Content.Trim()
    $version = $version.Trim("v")
}
else
{
    $version = $arg
}

if ($arg -eq 'help'){
    echo "Type 'last' to download the latest version availiable in google apis"
    echo "Type a defined version number in the format: X.X.X"
    echo "The script doesn't check for bad version numbers, it will simply fail to download data"
    exit 0
}




#Check if kube-exes "pseudocache" folder exists ( this should only be executed on the first launch )
if ( -Not (Test-Path -Path  $env:USERPROFILE\.kube\kube-exes ))
{
    mkdir $env:USERPROFILE\.kube\kube-exes
}



$route = "https://storage.googleapis.com/kubernetes-release/release/v$version/bin/windows/amd64/kubectl.exe"


#Check for existing "pseudocached" kubectl exe's
if ( Test-Path $env:USERPROFILE\.kube\kube-exes\kubectl#$version.exe )
{
    Copy-Item -Path $env:USERPROFILE\.kube\kube-exes\kubectl#$version.exe -Destination $env:USERPROFILE\.kube\kubectl.exe -force
    echo "Done!"
}
else 
{
    Invoke-WebRequest $route  -OutFile $env:USERPROFILE\.kube\kube-exes\kubectl#$version.exe
    Copy-Item -Path $env:USERPROFILE\.kube\kube-exes\kubectl#$version.exe -Destination $env:USERPROFILE\.kube\kubectl.exe -force
    echo "Done!"
}





