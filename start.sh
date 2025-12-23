#!/bin/bash

# 快速启动脚本 - 启动所有服务
echo "========================================="
echo "启动所有后端开发中间件..."
echo "========================================="

./rebuild.sh

echo ""
echo "✅ 服务启动完成！"
echo ""
echo "查看服务状态："
echo "  docker compose ps"
echo ""
echo "查看服务日志："
echo "  docker compose logs -f"
echo ""
