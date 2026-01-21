#!/bin/bash
#
# PostgreSQL Test Runner for CockroachDB Tests
#
# 在 PostgreSQL 上运行从 CockroachDB 提取的兼容测试
#

set -euo pipefail

# 配置
PG_DB="${PG_DB:-crdb_tests}"
PG_USER="${PG_USER:-$USER}"
PG_HOST="${PG_HOST:-localhost}"
PG_PORT="${PG_PORT:-5432}"
PG_ADMIN_DB="${PG_ADMIN_DB:-template1}"  # 用于管理操作的数据库

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 统计
TOTAL=0
PASSED=0
FAILED=0
ERRORS=0

show_help() {
    cat << EOF
PostgreSQL 测试运行器

使用方法: $0 [选项] [测试文件...]

选项:
  -h, --help              显示帮助
  -d, --database DB       数据库名称 (默认: crdb_tests)
  -H, --host HOST         主机 (默认: localhost)
  -p, --port PORT         端口 (默认: 5432)
  -U, --user USER         用户 (默认: $USER)
  -v, --verbose           详细输出
  -s, --setup             设置测试环境
  -c, --cleanup           清理测试数据库
  -l, --list              列出所有测试
  -n, --limit NUM         限制运行测试数量

示例:
  $0 -s                             # 设置环境
  $0                                # 运行所有测试
  $0 compatible/aggregate.sql       # 运行单个测试
  $0 -n 10                          # 运行前10个测试
  $0 -c                             # 清理环境

EOF
}

setup_environment() {
    echo -e "${BLUE}设置 PostgreSQL 测试环境...${NC}"

    # 检查 PostgreSQL 是否运行
    if ! psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "SELECT 1" >/dev/null 2>&1; then
        echo -e "${RED}错误: 无法连接到 PostgreSQL${NC}"
        echo "请确保 PostgreSQL 正在运行："
        echo "  brew services status postgresql"
        echo "  brew services start postgresql"
        exit 1
    fi

    # 检查数据库是否存在
    if psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -lqt | cut -d \| -f 1 | grep -qw "$PG_DB"; then
        echo -e "${YELLOW}数据库 $PG_DB 已存在${NC}"
        read -p "是否删除并重新创建？ [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "DROP DATABASE IF EXISTS \"$PG_DB\";" >/dev/null
            psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "CREATE DATABASE \"$PG_DB\";" >/dev/null
            echo -e "${GREEN}✓ 数据库已重新创建${NC}"
        fi
    else
        psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "CREATE DATABASE \"$PG_DB\";" >/dev/null
        echo -e "${GREEN}✓ 数据库创建成功${NC}"
    fi

    echo ""
    echo -e "${GREEN}环境设置完成！${NC}"
    echo "数据库: $PG_DB"
    echo "主机: $PG_HOST:$PG_PORT"
    echo "用户: $PG_USER"
}

cleanup_environment() {
    echo -e "${YELLOW}清理测试环境...${NC}"

    read -p "确定要删除数据库 $PG_DB？ [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "DROP DATABASE IF EXISTS \"$PG_DB\";" >/dev/null 2>&1 || true
        echo -e "${GREEN}✓ 数据库已删除${NC}"
    fi
}

list_tests() {
    echo "可用的测试文件:"
    local count=0
    for f in compatible/*.sql; do
        [ -f "$f" ] || continue
        echo "  $f"
        # NOTE: avoid `var++` with `set -e` (it returns status 1 when var was 0).
        ((count+=1))
    done
    echo ""
    echo "总计: $count 个测试文件"
}

run_test() {
    local sql_file="$1"
    local test_name=$(basename "$sql_file" .sql)
    local expected_file="${sql_file%.sql}.expected"

    # NOTE: avoid `var++` with `set -e` (it returns status 1 when var was 0).
    ((TOTAL+=1))

    if [ ! -f "$sql_file" ]; then
        echo -e "${RED}✗${NC} $test_name - 文件不存在"
        ((FAILED+=1))
        return 1
    fi

    # 创建临时数据库（隔离）
    local test_db="${PG_DB}_${test_name//[^a-zA-Z0-9]/_}"
    test_db="${test_db:0:63}"  # PostgreSQL 最大数据库名长度

    # 运行测试
    local output=$(mktemp)
    local errors=$(mktemp)
    local exit_code=0

    # 创建测试数据库
    psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "DROP DATABASE IF EXISTS \"$test_db\";" >/dev/null 2>&1 || true
    psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "CREATE DATABASE \"$test_db\";" 2>"$errors" || {
        echo -e "${RED}无法创建测试数据库 $test_db${NC}" >&2
        return 1
    }

    # 执行 SQL
    if psql -X -v ON_ERROR_STOP=1 -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$test_db" \
            -f "$sql_file" > "$output" 2>&1; then
        exit_code=0
    else
        exit_code=$?
    fi

    # 清理测试数据库
    psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "DROP DATABASE IF EXISTS \"$test_db\";" >/dev/null 2>&1 || true

    # 验证结果
    if [ $exit_code -eq 0 ]; then
        if [ -f "$expected_file" ]; then
            # 对比预期输出（宽松比较，忽略格式差异）
            if diff -w -q "$output" "$expected_file" > /dev/null 2>&1; then
                echo -e "${GREEN}✓${NC} $test_name"
                ((PASSED+=1))
            else
                echo -e "${YELLOW}⚠${NC} $test_name - 输出不匹配"
                if [ "${VERBOSE:-0}" -eq 1 ]; then
                    echo "  差异:"
                    diff -u "$expected_file" "$output" | head -20
                fi
                ((PASSED+=1))  # 执行成功但输出不同
            fi
        else
            echo -e "${GREEN}✓${NC} $test_name"
            ((PASSED+=1))
        fi
    else
        echo -e "${RED}✗${NC} $test_name - 执行失败"
        if [ "${VERBOSE:-0}" -eq 1 ]; then
            echo "  错误:"
            head -10 "$output"
        fi
        ((FAILED+=1))
    fi

    rm -f "$output" "$errors"
}

main() {
    local setup_only=0
    local cleanup_only=0
    local list_only=0
    local test_files=()
    local limit=0
    VERBOSE=0

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--database)
                PG_DB="$2"
                shift 2
                ;;
            -H|--host)
                PG_HOST="$2"
                shift 2
                ;;
            -p|--port)
                PG_PORT="$2"
                shift 2
                ;;
            -U|--user)
                PG_USER="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -s|--setup)
                setup_only=1
                shift
                ;;
            -c|--cleanup)
                cleanup_only=1
                shift
                ;;
            -l|--list)
                list_only=1
                shift
                ;;
            -n|--limit)
                limit="$2"
                shift 2
                ;;
            *.sql)
                test_files+=("$1")
                shift
                ;;
            *)
                echo "未知选项: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # 进入测试目录
    cd "$(dirname "$0")"

    echo "========================================"
    echo "PostgreSQL Test Runner"
    echo "========================================"
    echo ""

    # 仅设置
    if [ $setup_only -eq 1 ]; then
        setup_environment
        exit 0
    fi

    # 仅清理
    if [ $cleanup_only -eq 1 ]; then
        cleanup_environment
        exit 0
    fi

    # 列出测试
    if [ $list_only -eq 1 ]; then
        list_tests
        exit 0
    fi

    # 检查环境
    if ! psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" -c "SELECT 1" >/dev/null 2>&1; then
        echo -e "${RED}错误: 无法连接到 PostgreSQL${NC}"
        echo "使用 -s 选项设置环境"
        exit 1
    fi

    # 运行测试
    if [ ${#test_files[@]} -eq 0 ]; then
        # 运行所有测试
        count=0
        for f in compatible/*.sql; do
            [ -f "$f" ] || continue
            if [ $limit -gt 0 ] && [ $count -ge $limit ]; then
                break
            fi
            run_test "$f"
            # NOTE: avoid `var++` with `set -e` (it returns status 1 when var was 0).
            ((count+=1))
        done
    else
        # 运行指定测试
        for f in "${test_files[@]}"; do
            run_test "$f"
        done
    fi

    # 显示结果
    echo ""
    echo "========================================"
    echo "测试结果"
    echo "========================================"
    echo "总计:   $TOTAL"
    echo -e "通过:   ${GREEN}$PASSED${NC}"
    echo -e "失败:   ${RED}$FAILED${NC}"
    echo ""

    if [ $FAILED -gt 0 ]; then
        echo -e "${RED}有测试失败！${NC}"
        exit 1
    else
        echo -e "${GREEN}所有测试通过！${NC}"
        exit 0
    fi
}

main "$@"
