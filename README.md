# CockroachDB Tests for PostgreSQL

## 📊 统计

- **总测试数**: 37,910
- **PostgreSQL 兼容**: 35,872 (94.6%)
- **需要适配**: 1,281 (3.4%)
- **不兼容**: 757 (2.0%)

## 📁 目录结构

```
postgres_tests/
├── README.md              # 本文件
├── compatible/            # 直接兼容的测试
├── adaptable/             # 需要适配的测试
│   └── adaptation_log.json
├── incompatible_report.md # 不兼容测试报告
└── run_postgres_tests.sh  # 测试运行器
```

## 🚀 快速开始

### 1. 设置 PostgreSQL

```bash
# 安装 PostgreSQL
brew install postgresql@16  # macOS
# 或 apt-get install postgresql-16  # Ubuntu

# 启动服务
pg_ctl -D /usr/local/var/postgres start

# 创建测试数据库
createdb crdb_tests
```

### 2. 运行兼容测试

```bash
# 运行单个测试文件
psql crdb_tests < compatible/aggregate.sql

# 批量运行
for f in compatible/*.sql; do
    echo "Running $f..."
    psql crdb_tests < "$f"
done
```

### 3. 验证输出

```bash
diff <(psql crdb_tests < compatible/aggregate.sql) \
     compatible/aggregate.expected
```

## 🔧 主要差异

### CockroachDB 特定功能（不支持）

- `EXPERIMENTAL`
- `SHOW RANGES`
- `SHOW ZONE`
- `SPLIT AT`
- `SCATTER`
- `RELOCATE`
- `SCRUB`
- `BACKUP`
- `RESTORE`
- `CHANGEFEED`
- `AS OF SYSTEM TIME`
- `TENANT`
- `VIRTUAL CLUSTER`

### 类型映射

| CockroachDB | PostgreSQL |
|-------------|------------|
| STRING | TEXT |
| BYTES | BYTEA |
| INT2 | SMALLINT |
| INT4 | INTEGER |
| INT8 | BIGINT |
| FLOAT4 | REAL |
| FLOAT8 | DOUBLE PRECISION |
| REGPROC | REGPROC |
| UUID | UUID |

## 📝 已知限制

1. **SHOW 语句**: 某些 SHOW 命令需要转换为 information_schema 查询
2. **Hints**: PostgreSQL 不支持索引 hints
3. **系统表**: 某些 crdb_internal 表不存在

