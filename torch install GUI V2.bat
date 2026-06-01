@echo off
chcp 65001 >nul
title Conda 环境自动安装工具 - GUI版
color 0A
mode con cols=90 lines=25

:: ====================== 配置区域 ======================
::set "PYTHON_VERSION=3.7"
set "PIP_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple"
:: ======================================================

echo.
echo ============================================================
echo          Conda 环境一键搭建工具（图形选择版）
echo ============================================================
echo.
::输入python版本默认为3.7
set "PYTHON_VERSION="
set /p "PYTHON_VERSION=输入python版本，例如3.7(默认为3.7):"
if not defined PYTHON_VERSION set "PYTHON_VERSION=3.7"
:: 1. 输入环境名称
set "ENV_NAME="
set /p "ENV_NAME=请输入新建环境名称（直接回车默认：mypython）："
if not defined ENV_NAME set "ENV_NAME=mypython"
echo 已选择环境名称：%ENV_NAME%
echo.

:: 2. 选择 requirements.txt
echo 正在打开文件选择框，请选择 requirements.txt ...
for /f "delims=" %%i in ('powershell -Command "$null = [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $dlg = New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter = '文本文件 (*.txt)|*.txt|所有文件 (*.*)|*.*'; $dlg.Title = '选择 requirements.txt'; if ($dlg.ShowDialog() -eq 'OK') { Write-Output $dlg.FileName } else { exit 1 }"') do (
    set "REQUIRE_TXT=%%i"
)
if not defined REQUIRE_TXT (
    echo 错误：未选择 requirements.txt！
    pause
    exit /b 1
)
echo 已选择：%REQUIRE_TXT%
echo.

:: 3. 选择 torch .whl 文件
echo 正在打开文件选择框，请选择 torch xxx.whl ...
for /f "delims=" %%i in ('powershell -Command "$null = [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $dlg = New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter = 'Wheel文件 (*.whl)|*.whl|所有文件 (*.*)|*.*'; $dlg.Title = '选择 torch.whl'; if ($dlg.ShowDialog() -eq 'OK') { Write-Output $dlg.FileName } else { exit 1 }"') do (
    set "TORCH_WHL=%%i"
)
if not defined TORCH_WHL (
    echo 错误：未选择 torch whl 文件！
    pause
    exit /b 1
)
echo 已选择：%TORCH_WHL%
echo.

:: 4.选择torchvision.whl文件
echo 正在打开文件选择框，请选择 torchvision xxx.whl ...
for /f "delims=" %%i in ('powershell -Command "$null = [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $dlg = New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter = 'Wheel文件 (*.whl)|*.whl|所有文件 (*.*)|*.*'; $dlg.Title = '选择 torch.whl'; if ($dlg.ShowDialog() -eq 'OK') { Write-Output $dlg.FileName } else { exit 1 }"') do (
    set "TORCHVISION_WHL=%%i"
)
if not defined TORCHVISION_WHL (
    echo 错误：未选择 torchvision whl 文件！
    pause
    exit /b 1
)
echo 已选择：%TORCHVISION_WHL%


echo.

:: ====================== 开始执行 ======================
echo.
echo ============================================================
echo                    开始安装环境
echo                    环境名：%ENV_NAME%
echo ============================================================
echo.

:: 1. 删除旧环境
echo [1/5] 删除旧环境：%ENV_NAME% ...
call conda env remove -n %ENV_NAME% -y
echo.

:: 2. 创建新环境
echo [2/5] 创建环境 %ENV_NAME% (Python %PYTHON_VERSION%) ...
call conda create -n %ENV_NAME% python=%PYTHON_VERSION% -y
echo.

:: 3. 安装 requirements.txt
echo [3/5] 安装依赖包 ...
call conda run -n %ENV_NAME% pip install -r "%REQUIRE_TXT%" -i %PIP_MIRROR%
echo.

:: 4. 安装本地 torch whl
echo [4/5] 安装本地 torch ...
call conda run -n %ENV_NAME% pip install "%TORCH_WHL%"
echo.

:: 5. 安装torchvision whl
echo [5/5] 安装torchvision
call conda run -n %ENV_NAME% pip install "%TORCHVISION_WHL%"
echo.

:: ====================== 完成 ======================
echo ============================================================
echo.
echo ✅ 环境安装全部完成！
echo 环境名称：%ENV_NAME%
echo 激活命令：conda activate %ENV_NAME%
echo.
echo ============================================================
echo.

pause