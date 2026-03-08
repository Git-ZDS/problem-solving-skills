$processNames = @(
    "idea64",
    "idea"
)

foreach ($processName in $processNames) {
    Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force
}

$tempPatterns = @(
    "JetBrains*",
    "idea*"
)

foreach ($pattern in $tempPatterns) {
    Get-ChildItem -Path $env:TEMP -Filter $pattern -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
        } catch {
        }
    }
}

Write-Host "IDEA 相关进程和临时残留已尝试清理。"
