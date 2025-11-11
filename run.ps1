# 多AI代理系统 - Windows PowerShell 启动脚本

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  多AI代理系统 - 启动" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 检查虚拟环境
if (-not (Test-Path "venv")) {
    Write-Host "✗ 未找到虚拟环境" -ForegroundColor Red
    Write-Host "请先运行安装脚本: .\setup.ps1" -ForegroundColor Yellow
    pause
    exit 1
}

# 检查.env文件
if (-not (Test-Path ".env")) {
    Write-Host "✗ 未找到.env配置文件" -ForegroundColor Red
    Write-Host "请先配置.env文件（参考.env.example）" -ForegroundColor Yellow
    pause
    exit 1
}

# 检查API密钥
$envContent = Get-Content ".env" -Raw
if ($envContent -match "your_api_key_here") {
    Write-Host "⚠ 警告: API密钥可能未配置" -ForegroundColor Yellow
    Write-Host "应用可能无法正常工作" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "是否继续启动? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 0
    }
}

Write-Host "激活虚拟环境..." -ForegroundColor Yellow
& "venv\Scripts\Activate.ps1"

Write-Host "启动应用..." -ForegroundColor Green
Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "应用启动后，请访问:" -ForegroundColor White
Write-Host "http://localhost:5000" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "按 Ctrl+C 停止服务器" -ForegroundColor Yellow
Write-Host ""

python app.py
