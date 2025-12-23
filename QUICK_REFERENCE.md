# 快速参考卡片 - Quick Reference

## 一键命令速查表

### Linux/Mac 用户

| 操作 | 命令 |
|------|------|
| **启动所有服务** | `./start.sh` 或 `./rebuild.sh` |
| **停止所有服务** | `./stop.sh` |
| **查看服务状态** | `./status.sh` |
| **清理容器** | `./clean.sh` |
| **查看日志** | `docker compose logs -f` |
| **重启服务** | `docker compose restart` |

### Windows 用户

| 操作 | 命令 |
|------|------|
| **启动所有服务** | 双击 `start.bat` |
| **停止所有服务** | 双击 `stop.bat` |
| **查看服务状态** | 双击 `status.bat` |
| **查看日志** | `docker compose logs -f` |
| **重启服务** | `docker compose restart` |

## 常用 Docker Compose 命令

```bash
# 启动服务（后台运行）
docker compose up -d

# 启动特定服务
docker compose up -d mysql redis

# 停止服务
docker compose stop

# 停止并删除容器
docker compose down

# 停止并删除容器和数据
docker compose down -v

# 查看服务状态
docker compose ps

# 查看日志（实时）
docker compose logs -f

# 查看特定服务日志
docker compose logs -f mysql

# 重启服务
docker compose restart

# 重启特定服务
docker compose restart mysql

# 进入容器
docker compose exec mysql bash

# 查看资源使用
docker stats
```

## 服务管理

### 启用/禁用服务

编辑 `.env` 文件：

```bash
# 禁用 MySQL
MYSQL_DISABLED=true

# 禁用 Redis  
REDIS_DISABLED=true
```

### 初始化特定服务

```bash
# 只初始化并启动 MySQL
./rebuild.sh mysql

# 只初始化并启动 MySQL 和 Redis
./rebuild.sh mysql redis
```

## 服务默认端口

| 服务 | 端口 |
|------|------|
| MySQL | 3306 |
| Redis | 6379 |
| PostgreSQL | 5432 |
| MongoDB | 27017 |
| Nginx | 80, 443 |
| Nacos | 8848 |
| ElasticSearch | 9200, 9300 |
| Kafka | 9092 |
| ZooKeeper | 2181 |

*注意：具体端口以 docker-compose.yml 配置为准*

## 故障排查

### 端口被占用

```bash
# Windows 查看端口占用
netstat -ano | findstr :3306

# Linux/Mac 查看端口占用
lsof -i :3306
```

解决方案：修改 `docker-compose.yml` 中的端口映射

### 权限问题

```bash
# 给予脚本执行权限
chmod +x *.sh
```

### 查看容器日志

```bash
# 查看最近 100 行日志
docker compose logs --tail=100 mysql

# 持续查看日志
docker compose logs -f mysql
```

### 重置服务数据

```bash
# 1. 停止服务
docker compose stop mysql

# 2. 删除数据
rm -rf ./MySQL/data/*

# 3. 重新启动
./rebuild.sh mysql
```

## 连接信息

### MySQL

```bash
# 命令行连接
mysql -h 127.0.0.1 -P 3306 -u root -p

# 密码（默认）
ddXRaM5jr0BjjD6FCgeOMDcvNyzo0CBG
```

### 配置文件位置

| 服务 | 配置目录 |
|------|---------|
| MySQL | `./MySQL/conf/` |
| MySQL 初始化脚本 | `./MySQL/init/` |
| MySQL 数据 | `./MySQL/data/` |
| MySQL 日志 | `./MySQL/log/` |

---

💡 **提示**：将此文件保存到桌面或常用位置，方便随时查看！
