# Scripts-yard
Many of the Powershell scripts can also be found at Powershell Gallery: https://www.powershellgallery.com/profiles/jmollami

Use these at your own risk, they may contain bugs, errors or don't work at all.

Feel free to create any pull requests you want with improvements or bugfixes.

## Powershell scripts:

* **Kubechanger:** Updates your *kubectl.exe* version to avoid problems when connecting to Kubernetes clusters. Kubectl versions are downloaded from googleapis.com and an "pseudocache" of already downloaded versions is kept for allowing quick swapping between frequently used versions.

* **DotnetRenamer:** Renames a *dotnet C#* ( .sln and .csproj ) app solution and dependant projects, updating the corresponding references in project files to avoid errors when loading the renamed solution in visual studio. It does not rename namespaces and class names a this moment.