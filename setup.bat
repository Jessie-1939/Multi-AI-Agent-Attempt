@echo off
chcp 65001 >nul
echo ================================
echo   多AI代理系统 - 自动安装
echo ================================
echo.

REM 检查Python是否安装
echo 检查Python环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo ✗ 未找到Python，请先安装Python 3.8或更高版本
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✓ 发现Python: %PYTHON_VERSION%

REM 检查是否存在虚拟环境
if exist venv (
    echo ✓ 发现现有虚拟环境
    set /p RECREATE="是否重新创建虚拟环境? (y/N): "
    if /i "%RECREATE%"=="y" (
        echo 删除旧的虚拟环境...
        rmdir /s /q venv
    ) else (
        echo 使用现有虚拟环境
    )
)

REM 创建虚拟环境
if not exist venv (
    echo 创建Python虚拟环境...
    python -m venv venv
    if errorlevel 1 (
        echo ✗ 创建虚拟环境失败
        pause
        exit /b 1
    )
    echo ✓ 虚拟环境创建成功
)

REM 激活虚拟环境
echo 激活虚拟环境...
call venv\Scripts\activate.bat

REM 升级pip
echo 升级pip...
python -m pip install --upgrade pip

REM 安装依赖
echo 安装依赖包...
pip install -r requirements.txt
if errorlevel 1 (
    echo ✗ 依赖安装失败
    pause
    exit /b 1
)
echo ✓ 依赖安装成功

REM 检查.env文件
echo.
echo 检查环境配置...
if not exist .env (
    echo ⚠ 未找到.env文件
    if exist .env.example (
        copy .env.example .env >nul
        echo ✓ 已从.env.example创建.env文件
        echo.
        echo ⚠ 重要: 请编辑.env文件，填入你的DeepSeek API密钥!
        echo 获取API密钥: https://platform.deepseek.com/
        echo.
        set /p OPEN_FILE="是否现在打开.env文件编辑? (Y/n): "
        if /i not "%OPEN_FILE%"=="n" (
            notepad .env
        )
    )
) else (
    echo ✓ 发现.env配置文件
    findstr /C:"your_api_key_here" .env >nul
    if not errorlevel 1 (
        echo ⚠ API密钥未配置，请编辑.env文件
        set /p OPEN_FILE="是否现在打开.env文件编辑? (Y/n): "
        if /i not "%OPEN_FILE%"=="n" (
            notepad .env
        )
    ) else (
        echo ✓ API密钥已配置
    )
)

REM 显示已安装的包
echo.
echo 已安装的包:
pip list

echo.
echo ================================
echo   安装完成!
echo ================================
echo.
echo 下一步:
echo 1. 确保已在.env文件中配置DeepSeek API密钥
echo 2. 运行应用: run.bat
echo    或手动运行: python app.py
echo 3. 打开浏览器访问: http://localhost:5000
echo.

pause
