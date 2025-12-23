#!/bin/bash

# 快速清理脚本 - 停止并删除所有服务（保留数据）
echo "========================================="
echo "清理所有后端开发中间件容器..."
echo "========================================="

read -p "确定要停止并删除所有容器吗？(数据将被保留) [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    docker compose down
    echo ""
    echo "✅ 容器已清理完成！数据已保留。"
    echo ""
    echo "如需同时删除数据，运行："
    echo "  docker compose down -v"
else
    echo ""
    echo "❌ 已取消操作"
fi
echo ""
