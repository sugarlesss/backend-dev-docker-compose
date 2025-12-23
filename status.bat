@echo off
REM 查看状态脚本

echo =========================================
echo 后端开发中间件服务状态
echo =========================================
echo.

REM 查看运行中的服务
docker compose ps

echo.
echo 查看实时日志：
echo   docker compose logs -f
echo.
echo 查看特定服务日志：
echo   docker compose logs -f mysql
echo.
pause
