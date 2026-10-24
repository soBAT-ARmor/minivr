# 打开一个带 git / cmake 的终端窗口。
# 用法：在 PowerShell 里执行 . .\dev.ps1   （注意前面有个点）

$vs = "C:\Program Files\Microsoft Visual Studio\2022\Community"

$gitDir   = "$vs\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
$cmakeDir = "$vs\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"

$env:PATH = "$gitDir;$cmakeDir;$env:PATH"

Write-Host "git / cmake 已加入当前会话 PATH：" -ForegroundColor Green
& git --version
& cmake --version | Select-Object -First 1
