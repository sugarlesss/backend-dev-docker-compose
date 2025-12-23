#!/bin/bash

# 查看状态脚本
echo "========================================="
echo "后端开发中间件服务状态"
echo "========================================="
echo ""

# 查看运行中的服务
docker compose ps

echo ""
echo "========================================="
echo "资源使用情况"
echo "========================================="
echo ""

# 查看资源使用
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" $(docker compose ps -q)

echo ""
echo "查看实时日志："
echo "  docker compose logs -f"
echo ""
echo "查看特定服务日志："
echo "  docker compose logs -f mysql"
echo ""
