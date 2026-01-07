# backend-dev-docker-compose

使用 Docker Compose 快速构建后端开发场景使用的中间件环境。

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/sugarlesss/backend-dev-docker-compose.git
cd backend-dev-docker-compose
```

### 2. 赋予脚本执行权限

```bash
chmod +x rebuild.sh
```

### 3. 启动服务

```bash
./rebuild.sh
```

脚本会自动执行以下操作：
- 切换到脚本所在目录
- 关闭所有现有容器
- 初始化数据目录
- 根据配置启动所有服务

## 服务配置说明

### MySQL 8.0.44

**基本配置**
- **容器名称**: mysql
- **镜像版本**: mysql:8.0.44
- **主机地址**: localhost 或 127.0.0.1
- **端口**: 3306
- **用户名**: root
- **密码**: `ddXRaM5jr0BjjD6FCgeOMDcvNyzo0CBG`

**连接方式**
```bash
# 命令行连接
mysql -h 127.0.0.1 -P 3306 -u root -p
# 输入密码: ddXRaM5jr0BjjD6FCgeOMDcvNyzo0CBG
```

**关键配置参数**
- **字符集**: utf8mb4
- **默认存储引擎**: INNODB
- **Buffer Pool 大小**: 256M
- **最大连接数**: 100
- **表名大小写**: 不区分（lower_case_table_names=1）
- **慢查询日志**: 启用（阈值 3 秒）
- **通用日志**: 启用
- **Binlog**: 启用（格式：ROW，保留 30 天）
- **InnoDB 日志文件**: 1G × 4 个文件
- **InnoDB 刷盘策略**: 1（双1配置，保证数据安全）
- **时区**: Asia/Shanghai

**数据持久化**
- 配置文件: `./MySQL/conf` → `/etc/mysql/conf.d`
- 数据文件: `./MySQL/data` → `/var/lib/mysql`
- 日志文件: `./MySQL/log` → `/var/log/mysql`
- 初始化脚本: `./MySQL/init` → `/docker-entrypoint-initdb.d`

**初始化脚本**
将 SQL 文件放入 `MySQL/init/` 目录，首次启动时会自动执行。

---

### Redis 7.4.7

**基本配置**
- **容器名称**: redis
- **镜像版本**: redis:7.4.7
- **主机地址**: localhost
- **端口**: 6379
- **密码**: 无（未配置密码验证）
- **绑定地址**: 0.0.0.0（允许外部访问）
- **保护模式**: 启用

**连接方式**
```bash
# 命令行连接
redis-cli -h 127.0.0.1 -p 6379
# 无需密码
```

**关键配置参数**
- **数据库数量**: 16 个
- **连接超时**: 0（永不超时）
- **TCP Keepalive**: 300 秒
- **日志级别**: notice
- **RDB 持久化**: 启用
  - 1800 秒内有 1 个 key 变化
  - 300 秒内有 100 个 key 变化
  - 60 秒内有 1000 个 key 变化
- **RDB 压缩**: 启用
- **RDB 校验和**: 启用
- **复制**: 只读副本启用
- **副本提供过期数据**: 是

**数据持久化**
- 配置文件: `./Redis/conf` → `/usr/local/etc/redis`
- 数据文件: `./Redis/data` → `/data`
- 日志文件: `./Redis/log` → `/var/log/redis`

---

### ElasticSearch 8.17.0

**基本配置**
- **容器名称**: elasticsearch
- **镜像版本**: elasticsearch:8.17.0
- **主机地址**: localhost
- **端口**: 9200 (HTTP), 9300 (Transport)
- **用户名**: elastic
- **密码**: 123456（开发模式下已禁用安全验证）
- **堆内存**: 1GB (-Xms1024m -Xmx1024m)
- **运行模式**: 单节点（discovery.type=single-node）

**连接方式**
```bash
# 开发模式（无认证）
curl http://localhost:9200

# 带认证（如果启用安全验证）
curl -u elastic:123456 http://localhost:9200
```

**关键配置参数**
- **安全验证**: 开发模式已禁用
  - xpack.security.enabled=false
  - xpack.security.http.ssl.enabled=false
  - xpack.security.transport.ssl.enabled=false
- **内存锁定**: 启用（bootstrap.memory_lock=true）
- **内存限制**: memlock unlimited

**数据持久化**
- 数据文件: `./Elasticsearch/data` → `/usr/share/elasticsearch/data`
- 日志文件: `./Elasticsearch/log` → `/usr/share/elasticsearch/log`
- 插件目录: `./Elasticsearch/plugins` → `/usr/share/elasticsearch/plugins`

**注意事项**
- ElasticSearch 默认分配 1GB 堆内存，如果机器内存不足，可以在 `docker-compose.yml` 中调整
- 生产环境必须启用安全设置（SSL、密码验证）

---

### Kibana 8.17.0

**基本配置**
- **容器名称**: kibana
- **镜像版本**: kibana:8.17.0
- **主机地址**: localhost
- **端口**: 5601
- **语言**: 中文（I18N_LOCALE=zh-CN）
- **依赖服务**: elasticsearch

**访问方式**
```
http://localhost:5601
```

**关键配置**
- **ElasticSearch 地址**: http://elasticsearch:9200
- 通过容器网络与 ElasticSearch 通信

---

## 环境变量配置

通过编辑 `.env` 文件可以启用或禁用特定服务：

```bash
# 默认情况下，不设置任何变量，服务都会启动
# 如果要禁用某项服务，取消注释即可

# 禁用 MySQL
# MYSQL_DISABLED=true

# 禁用 Redis
# REDIS_DISABLED=true

# 禁用 ElasticSearch
# ELASTICSEARCH_DISABLED=true
```

修改 `.env` 文件后，重新运行 `./rebuild.sh` 即可生效。

## 常用命令

```bash
# 查看服务状态
docker compose ps

# 查看服务日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f mysql

# 停止所有服务（保留数据）
docker compose stop

# 停止并删除容器（保留数据）
docker compose down

# 停止并删除容器和数据
docker compose down -v

# 进入容器
docker compose exec mysql bash
docker compose exec redis bash
docker compose exec elasticsearch bash
```

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。