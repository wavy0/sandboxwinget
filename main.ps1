$progressPreference = 'silentlyContinue'
New-Item -Type Directory -Path $env:TEMP\Temp
Invoke-WebRequest -Uri https://globalcdn.nuget.org/packages/microsoft.ui.xaml.2.7.0.nupkg -OutFile "$env:TEMP\temp\xaml.zip" -UseBasicParsing
Expand-Archive -Path $env:TEMP\temp\xaml.zip -Force -DestinationPath $env:TEMP\temp\
Add-AppxPackage -Path $env:TEMP\temp\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx
Add-AppxPackage -Path $env:TEMP\temp\tools\AppX\x86\Release\Microsoft.UI.Xaml.2.7.appx
$latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
$latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
Write-Information "Downloading winget to artifacts directory..."
Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage $latestWingetMsixBundle
Remove-Item -Path $env:TEMP\temp -Force -Recurse
