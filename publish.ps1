# 把 minivr 推到 GitHub。
# 用法（在你自己的 PowerShell 窗口里，不是这个 agent 里）：
#   .\publish.ps1
#   或
#   .\publish.ps1 -RepoUrl https://github.com/你的用户名/minivr.git

param(
    [string]$RepoUrl
)

$ErrorActionPreference = "Stop"

$vs  = "C:\Program Files\Microsoft Visual Studio\2022\Community"
$git = "$vs\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd\git.exe"

if (-not (Test-Path $git)) {
    Write-Host "找不到 VS 自带的 git，请确认 Visual Studio 2022 已安装。" -ForegroundColor Red
    exit 1
}

Push-Location $PSScriptRoot

# 1. 远程地址
if (-not $RepoUrl) {
    $remotes = & $git remote
    if ($remotes -contains "origin") {
        $cur = (& $git remote get-url origin).Trim()
        Write-Host "已配置的远程地址：$cur" -ForegroundColor DarkGray
        $ans = Read-Host "直接使用这个地址？(Y/n)"
        if ([string]::IsNullOrWhiteSpace($ans) -or $ans -match '^[Yy]') { $RepoUrl = $cur }
    }
}
if (-not $RepoUrl) {
    Write-Host "先在 https://github.com/new 建一个空仓库（不要勾 README / .gitignore / license）" -ForegroundColor Yellow
    $user = Read-Host "你的 GitHub 用户名"
    $repo = Read-Host "仓库名（直接回车 = minivr）"
    if ([string]::IsNullOrWhiteSpace($repo)) { $repo = "minivr" }
    $RepoUrl = "https://github.com/$user/$repo.git"
}

# 2. 提交身份
$name = & $git config --global user.name
if ([string]::IsNullOrWhiteSpace($name)) {
    $name = Read-Host "git 提交显示名（用你 GitHub 的名字）"
    & $git config --global user.name $name
}
$mail = & $git config --global user.email
if ([string]::IsNullOrWhiteSpace($mail)) {
    $mail = Read-Host "git 提交邮箱（可用 GitHub 的 noreply 邮箱）"
    & $git config --global user.email $mail
}

# 3. 提交
& $git add -A
$pending = & $git status --porcelain
if ($pending) {
    & $git commit -m "init: M0 输出渐变图"
} else {
    Write-Host "没有新改动需要提交。" -ForegroundColor DarkGray
}
& $git branch -M main

# 4. 远端
$remotes = & $git remote
if ($remotes -contains "origin") {
    & $git remote set-url origin $RepoUrl
} else {
    & $git remote add origin $RepoUrl
}

# 5. 推送（会在浏览器弹出 GitHub 登录窗口）
Write-Host ""
Write-Host "开始推送，若弹出浏览器请登录 GitHub 授权 ..." -ForegroundColor Cyan
& $git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "推送失败。常见原因：" -ForegroundColor Red
    Write-Host "  1) 仓库建的时候勾了 README，远端已有提交 -> 改用 git push -u origin main --force"
    Write-Host "  2) 没登录 -> 重新运行本脚本，把浏览器授权走完"
    Write-Host "  3) 仓库名或用户名写错 -> .\publish.ps1 -RepoUrl https://github.com/xxx/minivr.git"
    Pop-Location
    exit 1
}

Write-Host ""
Write-Host "完成，仓库地址：$RepoUrl" -ForegroundColor Green
Write-Host "记得去仓库 Settings 里确认它是 Public。" -ForegroundColor Green
Pop-Location
