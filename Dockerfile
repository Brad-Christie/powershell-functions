# escape=`
FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference='Stop';$ProgressPreference='SilentlyContinue';"]
RUN $PSVersionTable ; `
    Install-PackageProvider -Name 'NuGet' -Force ; `
    Install-Module -Name 'Pester', 'PSScriptAnalyzer' -Force -SkipPublisherCheck

COPY . /src
WORKDIR /src

SHELL ["powershell", "-Command", "$ErrorActionPreference='Stop';"]
# Import-Module -Name 'Pester', 'PSScriptAnalyzer' -Global ; `
RUN Invoke-ScriptAnalyzer -Path '.\src' -Fix ; Invoke-Pester '.\src'