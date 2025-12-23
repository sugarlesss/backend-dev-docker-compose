# backend-dev-docker-compose

使用 Docker Compose 快速构建后端开发场景使用的中间件环境

## 📋 项目简介

本项目提供了一套完整的后端开发中间件 Docker Compose 配置，帮助开发者快速搭建本地开发环境。支持一键启动/停止服务，并通过配置文件灵活管理各个中间件的启用状态。

## 🚀 支持的中间件

- **数据库**
  - MySQL
  - PostgreSQL
  - MongoDB
  
- **缓存**
  - Redis
  - Valkey

- **消息队列**
  - Kafka
  - RocketMQ
  - ZooKeeper

- **分析引擎**
  - ClickHouse
  - Doris
  - ElasticSearch

- **任务调度**
  - XXL-JOB
  - PowerJob

- **其他服务**
  - Nacos（服务发现/配置中心）
  - Nginx（反向代理）
  - Grafana（监控可视化）
  - DataEase（数据可视化）

## 📦 安装要求

- Docker 20.10+
- Docker Compose 2.0+
- Git

## 🎯 下载并运行

### Linux/Mac
```bash
# 1. 创建并进入 /data 目录
mkdir -p /data && cd /data

# 2. 克隆项目
git clone https://github.com/sugarlesss/backend-dev-docker-compose.git

# 3. 进入项目目录
cd backend-dev-docker-compose

# 4. 赋予脚本执行权限
chmod +x *.sh

# 5. 启动服务
./rebuild.sh
```

### Windows (PowerShell)

```powershell
# 1. 创建并进入目录（建议使用 D:\data）
New-Item -ItemType Directory -Force -Path "D:\data" | Out-Null
Set-Location "D:\data"

# 2. 克隆项目
git clone https://github.com/sugarlesss/backend-dev-docker-compose.git

# 3. 进入项目目录
Set-Location backend-dev-docker-compose

# 4. 启动服务（使用 Git Bash）
bash rebuild.sh
```

### Windows (Git Bash)

```bash
# 一键下载并启动
mkdir -p /d/data && cd /d/data && \
git clone https://github.com/sugarlesss/backend-dev-docker-compose.git && \
cd backend-dev-docker-compose && \
chmod +x *.sh && \
./rebuild.sh
```

## ⚡ 快速开始

### 一键启动所有服务

```bash
# Linux/Mac
./rebuild.sh

# Windows (PowerShell)
bash rebuild.sh
```

### 一键启动单个服务

```bash
# 只启动 MySQL
./rebuild.sh mysql

# 只启动 Redis
./rebuild.sh redis
```

### 一键停止所有服务

```bash
docker compose down
```

### 一键停止并删除数据

```bash
docker compose down -v
```

## 📖 详细使用说明

### 1. 克隆项目

```bash
git clone https://github.com/你的用户名/backend-dev-docker-compose.git
cd backend-dev-docker-compose
```

### 2. 配置服务

编辑 `.env` 文件来启用或禁用特定服务：

```bash
# 默认情况下，不设置任何变量，服务都会启动
# 如果要禁用某项服务，取消注释即可

# 禁用 MySQL
# MYSQL_DISABLED=true

# 禁用 Redis
# REDIS_DISABLED=true
```

### 3. 启动服务

#### 方式一：使用 rebuild.sh 脚本（推荐）

`rebuild.sh` 脚本会在启动前执行必要的初始化操作：

```bash
# 启动所有已启用的服务
./rebuild.sh

# 启动特定服务
./rebuild.sh mysql redis

# 前台运行（查看日志）
./rebuild.sh --no-detach
```

#### 方式二：直接使用 docker compose

```bash
# 启动所有服务
docker compose up -d

# 启动特定服务
docker compose up -d mysql redis

# 查看日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f mysql
```

### 4. 停止服务

```bash
# 停止所有服务（保留数据）
docker compose stop

# 停止特定服务
docker compose stop mysql

# 停止并删除容器（保留数据卷）
docker compose down

# 停止并删除容器和数据卷
docker compose down -v
```

### 5. 查看服务状态

```bash
# 查看所有服务状态
docker compose ps

# 查看服务日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f mysql
```

## 🔧 服务连接信息

### MySQL

- **主机**: localhost
- **端口**: 3306
- **用户名**: root
- **密码**: ddXRaM5jr0BjjD6FCgeOMDcvNyzo0CBG

连接命令：
```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```

### Redis

（根据实际配置添加）

### PostgreSQL

（根据实际配置添加）

## 📁 目录结构

```
.
├── .env                    # 环境变量配置
├── docker-compose.yml      # 主配置文件
├── rebuild.sh              # 初始化启动脚本
├── MySQL/                  # MySQL 配置和数据
│   ├── conf/              # 配置文件
│   ├── data/              # 数据文件
│   ├── log/               # 日志文件
│   └── init/              # 初始化 SQL 脚本
├── Redis/                  # Redis 配置和数据
├── MongoDB/                # MongoDB 配置和数据
├── PostgreSQL/             # PostgreSQL 配置和数据
└── ...                     # 其他中间件目录
```

## 🛠️ 自定义配置

### 添加新服务

1. 在 `docker-compose.yml` 中添加服务配置
2. 使用 `profiles` 实现服务的启用/禁用
3. 在 `.env` 中添加对应的开关变量
4. 在 `rebuild.sh` 中添加初始化逻辑（如需要）

示例：
```yaml
services:
  your-service:
    profiles:
      - ${YOUR_SERVICE_DISABLED:+disabled}
    image: your-image:latest
    # ... 其他配置
```

### 修改服务配置

每个服务的配置文件位于对应的目录下，例如：
- MySQL 配置：`MySQL/conf/my.cnf`
- 自定义初始化脚本：`MySQL/init/*.sql`

## 💡 常见问题

### Q1: 端口冲突怎么办？

修改 `docker-compose.yml` 中对应服务的端口映射：
```yaml
ports:
  - "3307:3306"  # 将宿主机端口改为 3307
```

### Q2: 如何重置某个服务的数据？

```bash
# 停止服务
docker compose stop mysql

# 删除数据目录
rm -rf ./MySQL/data/*

# 重新启动
./rebuild.sh mysql
```

### Q3: Windows 下权限问题怎么处理？

Windows 用户建议在 WSL2 或 Git Bash 中运行脚本。或者手动执行初始化步骤后使用 `docker compose up -d`。

### Q4: 如何查看服务占用的资源？

```bash
docker stats
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。

## 📞 联系方式

如有问题或建议，欢迎通过以下方式联系：
- 提交 Issue
- 发起 Pull Request

---

**Happy Coding! 🎉**