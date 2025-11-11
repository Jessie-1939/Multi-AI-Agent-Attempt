# 快速测试脚本 - 验证安装

Write-Host "测试多AI代理系统..." -ForegroundColor Cyan
Write-Host ""

# 检查Python
Write-Host "1. 检查Python..." -ForegroundColor Yellow
try {
    $version = python --version 2>&1
    Write-Host "   ✓ Python: $version" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Python未安装" -ForegroundColor Red
    exit 1
}

# 检查项目文件
Write-Host ""
Write-Host "2. 检查项目文件..." -ForegroundColor Yellow
$files = @("app.py", "requirements.txt", "templates\index.html", "static\css\style.css", "static\js\main.js")
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "   ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $file 缺失" -ForegroundColor Red
    }
}

# 检查虚拟环境
Write-Host ""
Write-Host "3. 检查虚拟环境..." -ForegroundColor Yellow
if (Test-Path "venv") {
    Write-Host "   ✓ 虚拟环境存在" -ForegroundColor Green
} else {
    Write-Host "   ⚠ 虚拟环境未创建，请运行 setup.ps1" -ForegroundColor Yellow
}

# 检查配置
Write-Host ""
Write-Host "4. 检查配置..." -ForegroundColor Yellow
if (Test-Path ".env") {
    $content = Get-Content ".env" -Raw
    if ($content -match "DEEPSEEK_API_KEY=(.+)") {
        $key = $matches[1]
        if ($key -eq "your_api_key_here") {
            Write-Host "   ⚠ API密钥未配置" -ForegroundColor Yellow
        } else {
            Write-Host "   ✓ API密钥已配置" -ForegroundColor Green
        }
    }
} else {
    Write-Host "   ⚠ .env文件不存在" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "测试完成！" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "1. 运行 .\setup.ps1 进行安装" -ForegroundColor White
Write-Host "2. 配置 .env 文件中的API密钥" -ForegroundColor White
Write-Host "3. 运行 .\run.ps1 启动应用" -ForegroundColor White
Write-Host ""
