#!/bin/bash

# 快速停止脚本 - 停止所有服务
echo "========================================="
echo "停止所有后端开发中间件..."
echo "========================================="

docker compose stop

echo ""
echo "✅ 服务已停止！"
echo ""
echo "如需删除容器（保留数据），运行："
echo "  docker compose down"
echo ""
echo "如需删除容器和数据，运行："
echo "  docker compose down -v"
echo ""
