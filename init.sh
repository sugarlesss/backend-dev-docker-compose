#!/bin/bash

# 预操作函数
init_mysql() {
    echo "MySQL Init..."
    # mkdir -p ./MySQL/{data,conf,log,init}
    # 删除 data log 目录下面的内容，初始化
    rm -rf ./MySQL/data/*
    rm -rf ./MySQL/log/*
    
    # 设置目录权限
    chown -R 999:999 ./MySQL
    # 注意：999:999 是 MySQL 容器内的用户 UID:GID
    # Windows 下可能需要使用 icacls 或在 WSL 中执行
}

init_redis() {
    echo "Redis Init..."
}

# 主函数
main() {
    echo "========================================="
    echo "开始准备容器环境..."
    echo "========================================="
    
    # 检查 .env 文件
    if [ ! -f .env ]; then
        echo "警告: 未找到 .env 文件"
    fi
    
    # 根据 .env 中的配置决定执行哪些预操作
    source .env 2>/dev/null || true
    
    echo "========================================="
    echo "启动 Docker Compose 服务..."
    echo "========================================="
    
    # 只为启用的服务执行预操作
    if [ "$MYSQL_DISABLED" != "true" ]; then
        init_mysql
    fi
    if [ "$REDIS_DISABLED" != "true" ]; then
        init_redis
    fi
    

    # 启动服务（可以传递参数）
    docker compose up -d "$@"
}

main "$@"

# 启动所有服务
# ./init.sh
# 只启动特定服务
# ./init.sh mysql
# 查看日志
# ./init.sh --no-detach