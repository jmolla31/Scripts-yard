<#

#>

<#PSScriptInfo

.VERSION 0.1

.GUID 21801f8c-0115-455a-bb78-44fd9262f695

.AUTHOR jmollami

.COPYRIGHT 
    Copyright 2019 - Javi Mollà Micó

.RELEASENOTES
    0.1 => Initial release and upload to Powershell Gallery
#>

<# 
.SYNOPSIS
    Renames dotnet c# solutions mantaining project dependencies
.DESCRIPTION
    Renames a dotnet C# ( .sln and .csproj ) app solution and dependant projects, updating the corresponding references in project files to avoid errors when loading 
    the renamed solution in visual studio. It does not rename namespaces and class names a this moment.
.NOTES
    File Name      : dotnetRenamer.ps1
    Author         : Javi Mollà (javimollamico@gmail.com)
    Prerequisite   : PowerShell V2 over W7 and upper.
    Version        : 0.1
    Copyright 2019 - Javi Mollà Micó
#> 

Write-Host -ForegroundColor DarkYellow 'Warning! Close any instances of Visual Studio, VS Code or other IDEs opened in the solution.'
Write-Host -ForegroundColor DarkYellow 'Warning! This script is only compatible with C# (.csproj) projects. Other projects such as Docker and SqlServer need to be renamed manually'
Write-Host ""

$baseSolution = Read-Host -Prompt 'Input the solutions base directory (where .sln is located)'
$newSolutionName = Read-Host -Prompt 'Rename the solution to?'

if ($baseSolution.Equals("") -OR $newName.Equals(""))
{
    Write-Host -BackgroundColor White -ForegroundColor Red 'Error, null argument given!'
    Exit
}


$startDirectory = pwd

cd $baseSolution

#Get solution .sln object

$oldSolutionSln = Get-ChildItem *.sln
if (!(Test-Path $oldSolutionSln))
{
    Write-Host -BackgroundColor White -ForegroundColor Red 'Error, no solution file found!'
    Exit
}
Write-Host "Found .sln in base folder => $oldSolutionSln"



#Get solution projects folder references
$projectFolders = Get-ChildItem -Directory ($oldSolutionSln.BaseName + '*')

if ($projectFolders.Lenght -eq 0)
{
    Write-Host -BackgroundColor White -ForegroundColor Red 'Error, 0 project folders found!'
    Write-Host -ForegroundColor DarkYellow 'Warning! Projects only using the following naming convention are allowed => SOLUTIONNAME.XXX'
    Exit
}

#Print found folders
foreach ($folder in $projectFolders)
{
    Write-Host "Project folder found => $folder"
}

#Get into all .csproj files, replace references to the old solution name with the provided $newSolutionName
$oldSolutionName = $oldSolutionSln.BaseName
foreach($folder in $projectFolders)
{
    $oldCsproj = ($folder.Name + "\" + $folder.BaseName + '.csproj')
    $newCsproj = ($folder.Name + "\" + $folder.Name.Replace(($oldSolutionName),($newSolutionName)) + '.csproj')
    
    if (!$folder.Name.Contains("Docker") -and !$folder.Name.Contains("Database"))
    {
        (Get-Content $oldCsproj).Replace(($oldSolutionName),($newSolutionName)) | Set-Content $oldCsproj
        Write-Host "Renaming $oldCsproj to $newCsproj"
        Move-Item $oldCsproj $newCsproj
    }
}

#TODO: Add Docker and Database projects compatibility

#Rename project folders to new names:
foreach($folder in $projectFolders)
{
    Rename-Item $folder.Name $folder.Name.Replace(($oldSolutionName),($newSolutionName))
}

#Update references to projects in .sln and rename file
(Get-Content $oldSolutionSln).Replace(($oldSolutionName),($newSolutionName)) | Set-Content $oldSolutionSln
Move-Item $oldSolutionSln "$newSolutionName.sln"

#Go back to where the script was executed:
cd $startDirectory