# 一键编译并运行。用法：右键 -> 使用 PowerShell 运行，或在终端里执行 .\build.ps1
$ErrorActionPreference = "Stop"

$vs    = "C:\Program Files\Microsoft Visual Studio\2022\Community"
$cmake = "$vs\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"

if (-not (Test-Path $cmake)) {
    Write-Host "找不到 VS 自带的 CMake，请确认 Visual Studio 2022 已安装。" -ForegroundColor Red
    exit 1
}

Write-Host "[1/3] 配置 ..." -ForegroundColor Cyan
& $cmake -S $PSScriptRoot -B "$PSScriptRoot\build" -G "Visual Studio 17 2022" -A x64
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "[2/3] 编译 ..." -ForegroundColor Cyan
& $cmake --build "$PSScriptRoot\build" --config Release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "[3/3] 运行 ..." -ForegroundColor Cyan
Push-Location $PSScriptRoot
$exe = Get-ChildItem "$PSScriptRoot\build" -Recurse -Filter minivr.exe | Select-Object -First 1
& $exe.FullName
Pop-Location

Write-Host ""
Write-Host "完成。打开 $PSScriptRoot\out.bmp 看看。" -ForegroundColor Green
