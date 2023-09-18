$progressPreference = 'silentlyContinue'
New-Item -Type Directory -Path $env:TEMP\temp | Out-Null
echo "Downloading Xaml..."
Invoke-WebRequest -Uri https://globalcdn.nuget.org/packages/microsoft.ui.xaml.2.7.0.nupkg -OutFile "$env:TEMP\temp\xaml.zip" -UseBasicParsing
Expand-Archive -Path $env:TEMP\temp\xaml.zip -Force -DestinationPath $env:TEMP\temp\
Add-AppxPackage -Path $env:TEMP\temp\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx
Add-AppxPackage -Path $env:TEMP\temp\tools\AppX\x86\Release\Microsoft.UI.Xaml.2.7.appx
echo "Done."
echo "Downloading winget..."
$latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
$latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "$env:TEMP\$latestWingetMsixBundle"
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile "$env:TEMP\temp\Microsoft.VCLibs.x64.14.00.Desktop.appx"
Add-AppxPackage  "$env:TEMP\Microsoft.VCLibs.x64.14.00.Desktop.appx"
Add-AppxPackage "$env:TEMP\$latestWingetMsixBundle"
Remove-Item -Path $env:TEMP\temp -Force -Recurse
echo Done.
