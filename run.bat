@echo off
chcp 65001 >nul
echo ================================
echo   多AI代理系统 - 启动
echo ================================
echo.

REM 检查虚拟环境
if not exist venv (
    echo ✗ 未找到虚拟环境
    echo 请先运行安装脚本: setup.bat
    pause
    exit /b 1
)

REM 检查.env文件
if not exist .env (
    echo ✗ 未找到.env配置文件
    echo 请先配置.env文件（参考.env.example）
    pause
    exit /b 1
)

REM 检查API密钥
findstr /C:"your_api_key_here" .env >nul
if not errorlevel 1 (
    echo ⚠ 警告: API密钥可能未配置
    echo 应用可能无法正常工作
    echo.
    set /p CONTINUE="是否继续启动? (y/N): "
    if /i not "%CONTINUE%"=="y" (
        exit /b 0
    )
)

echo 激活虚拟环境...
call venv\Scripts\activate.bat

echo 启动应用...
echo.
echo ================================
echo 应用启动后，请访问:
echo http://localhost:5000
echo ================================
echo.
echo 按 Ctrl+C 停止服务器
echo.

python app.py
