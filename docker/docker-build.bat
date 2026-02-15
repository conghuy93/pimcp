@echo off
REM ============================================================
REM miniZ MCP Docker - Build & Run Script (Windows)
REM ============================================================

cd /d "%~dp0"

echo.
echo 🐳 miniZ MCP Docker Builder
echo ================================

REM Check Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker khong duoc cai dat!
    echo    Vui long cai Docker Desktop: https://docs.docker.com/desktop/windows/
    pause
    exit /b 1
)

REM Check .env
if not exist .env (
    echo ⚠️  File .env chua ton tai
    echo    Dang tao tu .env.example...
    copy .env.example .env
    echo.
    echo 📝 Vui long cap nhat API keys trong docker\.env
    echo.
)

:menu
echo.
echo Chon hanh dong:
echo   1) Build ^& Start
echo   2) Start (khong build lai)
echo   3) Stop
echo   4) Restart
echo   5) Logs
echo   6) Status
echo   0) Exit
echo.
set /p choice="Lua chon [1]: "

if "%choice%"=="" set choice=1

if "%choice%"=="1" goto build
if "%choice%"=="2" goto start
if "%choice%"=="3" goto stop
if "%choice%"=="4" goto restart
if "%choice%"=="5" goto logs
if "%choice%"=="6" goto status
if "%choice%"=="0" goto end

echo ❌ Lua chon khong hop le
goto menu

:build
echo.
echo 🔨 Building Docker image...
docker-compose up -d --build
echo.
echo ✅ Done! API dang chay tai: http://localhost:8000
goto end

:start
echo.
echo ▶️  Starting containers...
docker-compose up -d
echo ✅ Started!
goto end

:stop
echo.
echo ⏹️  Stopping containers...
docker-compose down
echo ✅ Stopped!
goto end

:restart
echo.
echo 🔄 Restarting containers...
docker-compose restart
echo ✅ Restarted!
goto end

:logs
echo.
echo 📋 Showing logs (Ctrl+C to exit)...
docker-compose logs -f
goto end

:status
echo.
echo 📊 Container Status:
docker-compose ps
goto end

:end
echo.
pause
