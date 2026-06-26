param(
  [string]$AppPath = ""
)

if (-not $AppPath) {
  # Try to find the debug build
  $possiblePaths = @(
    "$PSScriptRoot\..\build\windows\x64\runner\Debug\watch_atlas.exe"
    "$PSScriptRoot\..\build\windows\x64\runner\Release\watch_atlas.exe"
  )
  foreach ($p in $possiblePaths) {
    if (Test-Path $p) {
      $AppPath = (Resolve-Path $p).Path
      break
    }
  }
}

if (-not $AppPath -or -not (Test-Path $AppPath)) {
  Write-Error "Could not find watch_atlas.exe. Build the project first with: flutter build windows --debug"
  Write-Error "Or pass -AppPath pointing to your watch_atlas.exe"
  exit 1
}

Write-Host "Registering io.supabase.flutter:// protocol for: $AppPath"

$regPath = "HKEY_CURRENT_USER\Software\Classes\io.supabase.flutter"

# Remove existing if any
if (Test-Path "Registry::$regPath") {
  Remove-Item -Path "Registry::$regPath" -Recurse -Force
}

# Create protocol entry
New-Item -Path "Registry::$regPath" -Force | Out-Null
Set-ItemProperty -Path "Registry::$regPath" -Name "(Default)" -Value "URL:io.supabase.flutter Protocol"
Set-ItemProperty -Path "Registry::$regPath" -Name "URL Protocol" -Value ""

# Create shell\open\command
$shellPath = "$regPath\shell\open\command"
New-Item -Path "Registry::$shellPath" -Force | Out-Null
Set-ItemProperty -Path "Registry::$shellPath" -Name "(Default)" -Value "`"$AppPath`" `"%1`""

Write-Host "Done. io.supabase.flutter:// links will now open WatchAtlas."

# Also add the redirect URL to Supabase settings reminder
Write-Host ""
Write-Host "IMPORTANT: Add 'io.supabase.flutter://callback' to your Supabase"
Write-Host "dashboard under Authentication -> Settings -> Redirect URLs"
Write-Host "Then restart your app and try Google sign-in again."
