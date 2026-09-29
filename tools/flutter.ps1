# Thiết lập bộ công cụ trong phạm vi tiến trình, không đổi cấu hình toàn máy.
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$FlutterArguments)
$ErrorActionPreference = 'Stop'
$projectDirectory = Split-Path -Parent $PSScriptRoot
$flutterExecutable = Join-Path $projectDirectory '.tools/flutter/bin/flutter.bat'
if (-not (Test-Path -LiteralPath $flutterExecutable)) {
    $flutterExecutable = (Get-Command flutter -ErrorAction Stop).Source
}
$env:PUB_CACHE = Join-Path $projectDirectory '.tools/pub-cache'
$env:GRADLE_USER_HOME = Join-Path $projectDirectory '.tools/gradle'
$env:ANDROID_USER_HOME = Join-Path $projectDirectory '.tools/android-user'
$localAndroidSdk = Join-Path $projectDirectory '.tools/android'
if (Test-Path -LiteralPath $localAndroidSdk) {
    $env:ANDROID_HOME = $localAndroidSdk
    $env:ANDROID_SDK_ROOT = $localAndroidSdk
}
if (Test-Path -LiteralPath 'C:/Program Files/Java/jdk-17/bin/java.exe') {
    $env:JAVA_HOME = 'C:/Program Files/Java/jdk-17'
}
Push-Location $projectDirectory
try {
    & $flutterExecutable @FlutterArguments
    $flutterExitCode = $LASTEXITCODE
} finally {
    Pop-Location
}
exit $flutterExitCode
