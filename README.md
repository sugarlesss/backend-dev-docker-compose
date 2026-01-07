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

### Prometheus 3.0.1

**基本配置**
- **容器名称**: prometheus
- **镜像版本**: prom/prometheus:v3.0.1
- **主机地址**: localhost
- **端口**: 9090
- **运行模式**: 单节点

**访问方式**
```bash
# Web UI
http://localhost:9090

# 查看监控目标
http://localhost:9090/targets

# HTTP API
curl http://localhost:9090/api/v1/targets
```

**关键配置参数**
- **全局抓取间隔**: 10 秒
- **全局抓取超时**: 10 秒
- **规则评估间隔**: 10 秒
- **数据保留时间**: 1 分钟（开发环境）
- **数据保留大小**: 1GB
- **热重载**: 启用（--web.enable-lifecycle）
- **配置文件路径**: /etc/prometheus/prometheus.yml

**重新加载配置**
```bash
# 热重载 Prometheus 配置（无需重启）
curl -X POST http://localhost:9090/-/reload
```

**数据持久化**
- 配置文件: `./Prometheus/conf` → `/etc/prometheus`
- 数据文件: `./Prometheus/data` → `/prometheus`
- 日志文件: `./Prometheus/log` → `/prometheus/log`

**配置文件说明**
Prometheus 配置文件位于 `Prometheus/conf/prometheus.yml`，包含以下抓取配置：
- **prometheus**: 监控 Prometheus 自身（127.0.0.1:9090）
- **backend-service**: 监控后端服务示例（192.168.9.1:12345）
  - 抓取间隔: 5 秒
  - 指标路径: /actuator/prometheus
  - 可根据实际需求修改目标地址

**注意事项**
- 开发环境数据保留时间设置为 1 分钟，可根据需要调整
- 如需添加新的监控目标，编辑 `Prometheus/conf/prometheus.yml` 后执行热重载命令
- 生产环境建议增加数据保留时间和大小限制

---

### Grafana 11.4.0

**基本配置**
- **容器名称**: grafana
- **镜像版本**: grafana/grafana:11.4.0
- **主机地址**: localhost
- **端口**: 3000
- **用户名**: admin
- **密码**: grafana9527

**访问方式**
```
http://localhost:3000
```

**关键配置参数**
- **管理员用户名**: admin
- **管理员密码**: grafana9527
- **运行用户**: grafana (UID:GID 472:472)

**数据持久化**
- 数据文件: `./Grafana/data` → `/var/lib/grafana`
- 日志文件: `./Grafana/log` → `/var/log/grafana`
- 配置文件: 使用容器默认配置

**使用说明**
- 首次登录使用默认账号密码：admin / grafana9527
- 登录后可以在设置中修改密码和语言
- 支持中文界面，可在设置中切换语言
- 可以添加 Prometheus 作为数据源进行可视化

**注意事项**
- Grafana 使用 root 用户运行，确保数据目录权限正确
- 生产环境建议修改默认密码
- 可以通过 Grafana 的 Web UI 配置数据源和仪表板

---

### RocketMQ 5.3.2

**基本配置**
- **镜像版本**: apache/rocketmq:5.3.2
- **组件**: NameServer、Broker、Proxy

#### NameServer
- **容器名称**: rocketmq-namesrv
- **主机地址**: localhost
- **端口**: 9876
- **运行用户**: rocketmq (UID:GID 3000:3000)

#### Broker
- **容器名称**: rocketmq-broker
- **主机地址**: localhost
- **端口**: 10909, 10911, 10912
- **依赖服务**: rocketmq-namesrv
- **运行用户**: rocketmq (UID:GID 3000:3000)

#### Proxy
- **容器名称**: rocketmq-proxy
- **主机地址**: localhost
- **端口**: 8080 (HTTP), 8081 (gRPC)
- **依赖服务**: rocketmq-broker, rocketmq-namesrv
- **运行用户**: rocketmq (UID:GID 3000:3000)

**连接方式**
```bash
# NameServer 地址
rocketmq-namesrv:9876

# Proxy 地址（用于客户端连接）
localhost:8081
```

**数据持久化**
- NameServer 数据: `./RocketMQ/data/namesrv` → `/home/rocketmq/store`
- Broker 数据: `./RocketMQ/data/broker` → `/home/rocketmq/store`
- Broker 日志: `./RocketMQ/log/broker` → `/home/rocketmq/logs`
- Proxy 数据: `./RocketMQ/data/proxy` → `/home/rocketmq/store`
- Proxy 日志: `./RocketMQ/log/proxy` → `/home/rocketmq/logs`

**使用说明**
- RocketMQ 5 采用新的架构，包含 NameServer、Broker 和 Proxy 三个组件
- 客户端通过 Proxy 连接到 RocketMQ 集群
- Proxy 端口：8080 (HTTP), 8081 (gRPC)
- NameServer 端口：9876
- Broker 端口：10909, 10911, 10912

**创建 Topic**
```bash
# 进入 broker 容器
docker compose exec rocketmq-broker bash

# 创建 Topic
sh mqadmin updatetopic -t TestTopic -c DefaultCluster
```

**注意事项**
- RocketMQ 容器使用 UID:GID 为 3000:3000 的用户运行
- 数据目录权限已设置为 3000:3000，确保容器有读写权限
- Broker 依赖 NameServer，Proxy 依赖 Broker 和 NameServer
- 生产环境建议使用集群模式部署

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

# 禁用 Prometheus
# PROMETHEUS_DISABLED=true

# 禁用 Grafana
# GRAFANA_DISABLED=true

# 禁用 RocketMQ
# ROCKETMQ_DISABLED=true
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
docker compose exec prometheus bash
docker compose exec grafana bash
```

**Prometheus 特定命令**
```bash
# 重新加载 Prometheus 配置（热重载）
curl -X POST http://localhost:9090/-/reload

# 查看 Prometheus 版本信息
curl http://localhost:9090/api/v1/status/buildinfo

# 查看所有监控目标
curl http://localhost:9090/api/v1/targets
```

**Grafana 特定命令**
```bash
# 查看 Grafana 版本信息
curl http://localhost:3000/api/health

# 查看 Grafana 配置（需要认证）
curl -u admin:grafana9527 http://localhost:3000/api/settings
```

**RocketMQ 特定命令**
```bash
# 进入 Broker 容器创建 Topic
docker compose exec rocketmq-broker bash
sh mqadmin updatetopic -t TestTopic -c DefaultCluster

# 查看集群信息
docker compose exec rocketmq-broker sh mqadmin clusterList

# 查看 Topic 列表
docker compose exec rocketmq-broker sh mqadmin topicList
```

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。