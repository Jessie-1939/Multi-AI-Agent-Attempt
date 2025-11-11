# 多AI代理系统 - Windows PowerShell 自动安装脚本

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  多AI代理系统 - 自动安装" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 检查Python是否安装
Write-Host "检查Python环境..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ 发现Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ 未找到Python，请先安装Python 3.8或更高版本" -ForegroundColor Red
    Write-Host "下载地址: https://www.python.org/downloads/" -ForegroundColor Yellow
    pause
    exit 1
}

# 检查是否存在虚拟环境
if (Test-Path "venv") {
    Write-Host "✓ 发现现有虚拟环境" -ForegroundColor Green
    $recreate = Read-Host "是否重新创建虚拟环境? (y/N)"
    if ($recreate -eq "y" -or $recreate -eq "Y") {
        Write-Host "删除旧的虚拟环境..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force venv
    } else {
        Write-Host "使用现有虚拟环境" -ForegroundColor Green
    }
}

# 创建虚拟环境
if (-not (Test-Path "venv")) {
    Write-Host "创建Python虚拟环境..." -ForegroundColor Yellow
    python -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ 创建虚拟环境失败" -ForegroundColor Red
        pause
        exit 1
    }
    Write-Host "✓ 虚拟环境创建成功" -ForegroundColor Green
}

# 激活虚拟环境
Write-Host "激活虚拟环境..." -ForegroundColor Yellow
& "venv\Scripts\Activate.ps1"

# 升级pip
Write-Host "升级pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

# 安装依赖
Write-Host "安装依赖包..." -ForegroundColor Yellow
pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 依赖安装失败" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "✓ 依赖安装成功" -ForegroundColor Green

# 检查.env文件
Write-Host ""
Write-Host "检查环境配置..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Write-Host "⚠ 未找到.env文件" -ForegroundColor Yellow
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "✓ 已从.env.example创建.env文件" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠ 重要: 请编辑.env文件，填入你的DeepSeek API密钥!" -ForegroundColor Red
        Write-Host "获取API密钥: https://platform.deepseek.com/" -ForegroundColor Yellow
        Write-Host ""
        
        $openFile = Read-Host "是否现在打开.env文件编辑? (Y/n)"
        if ($openFile -ne "n" -and $openFile -ne "N") {
            notepad .env
        }
    }
} else {
    Write-Host "✓ 发现.env配置文件" -ForegroundColor Green
    
    # 检查API密钥是否配置
    $envContent = Get-Content ".env" -Raw
    if ($envContent -match "your_api_key_here") {
        Write-Host "⚠ API密钥未配置，请编辑.env文件" -ForegroundColor Yellow
        $openFile = Read-Host "是否现在打开.env文件编辑? (Y/n)"
        if ($openFile -ne "n" -and $openFile -ne "N") {
            notepad .env
        }
    } else {
        Write-Host "✓ API密钥已配置" -ForegroundColor Green
    }
}

# 显示已安装的包
Write-Host ""
Write-Host "已安装的包:" -ForegroundColor Cyan
pip list

Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "  安装完成!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "1. 确保已在.env文件中配置DeepSeek API密钥" -ForegroundColor White
Write-Host "2. 运行应用: .\run.ps1" -ForegroundColor White
Write-Host "   或手动运行: python app.py" -ForegroundColor White
Write-Host "3. 打开浏览器访问: http://localhost:5000" -ForegroundColor White
Write-Host ""

pause
