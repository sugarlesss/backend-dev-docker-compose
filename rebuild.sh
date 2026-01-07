#!/bin/bash

# 检测并设置 docker compose 命令
if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
elif docker-compose --version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "错误: 未找到 docker compose 或 docker-compose 命令"
    exit 1
fi

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
    mkdir -p ./Redis/{data,conf,log}
    # 删除 data log 目录下面的内容，初始化
    rm -rf ./Redis/data/*
    rm -rf ./Redis/log/*
    # 重新创建日志文件
    touch ./Redis/log/redis.log
    # 目录权限
    chmod -R 755 ./Redis
    chmod -R 777 ./Redis/log/redis.log
    chown -R root:root ./Redis
}

init_elasticsearch() {
    echo "Elasticsearch Init..."
    mkdir -p ./Elasticsearch/{data,conf,log,plugins}

    # 删除 data log 目录下面的内容，初始化
    rm -rf ./Elasticsearch/data/*
    rm -rf ./Elasticsearch/log/*

    # 目录权限
    chmod -R 755 ./Elasticsearch
    chown -R 1000:1000 ./Elasticsearch
}

init_prometheus() {
    echo "Prometheus Init..."
    mkdir -p ./Prometheus/{data,conf,log}

    # 删除 data log 目录下面的内容，初始化
    rm -rf ./Prometheus/data/*
    rm -rf ./Prometheus/log/*

    # 目录权限
    chmod -R 755 ./Prometheus
    chown -R root:root ./Prometheus
}

# 主函数
main() {
    # 切换到脚本所在目录
    cd "$(dirname "$0")" || exit 1

    # 关闭所有容器
    echo "========================================="
    echo "关闭所有容器..."
    echo "========================================="
    $DOCKER_COMPOSE down

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
    if [ "$ELASTICSEARCH_DISABLED" != "true" ]; then
        init_elasticsearch
    fi
    if [ "$PROMETHEUS_DISABLED" != "true" ]; then
        init_prometheus
    fi

    # 启动服务
    $DOCKER_COMPOSE up -d
}

main

# 启动所有服务
# ./rebuild.sh
# 只启动特定服务
# ./rebuild.sh mysql
# 查看日志
# ./rebuild.sh --no-detach