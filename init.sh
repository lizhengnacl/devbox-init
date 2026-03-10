#!/bin/bash

set -e

echo "开始初始化项目..."

echo "配置screen常用命令alias..."

ALIAS_FILE="$HOME/.bash_aliases"

if [ ! -f "$ALIAS_FILE" ]; then
    touch "$ALIAS_FILE"
    echo "已创建 $ALIAS_FILE"
fi

add_alias_if_not_exists() {
    local alias_name="$1"
    local alias_value="$2"
    if ! grep -q "^alias $alias_name=" "$ALIAS_FILE"; then
        echo "alias $alias_name='$alias_value'" >> "$ALIAS_FILE"
        echo "已添加 alias $alias_name"
    else
        echo "alias $alias_name 已存在，跳过"
    fi
}

if ! grep -q "# Screen常用命令alias" "$ALIAS_FILE"; then
    echo "" >> "$ALIAS_FILE"
    echo "# Screen常用命令alias" >> "$ALIAS_FILE"
fi

add_alias_if_not_exists "sc" "screen"
add_alias_if_not_exists "scl" "screen -ls"
add_alias_if_not_exists "scr" "screen -r"
add_alias_if_not_exists "scd" "screen -d"
add_alias_if_not_exists "scdr" "screen -d -r"

echo "screen常用命令alias配置完成"
echo "请运行 'source $ALIAS_FILE' 来立即生效，或重新登录shell"

echo ""
echo "配置代理环境变量..."

BASHRC_FILE="$HOME/.bashrc"

PROXY_CONFIG=$(cat << 'EOF'

# Proxy configuration
export http_proxy=http://sys-proxy-rd-relay.byted.org:8118
export https_proxy=http://sys-proxy-rd-relay.byted.org:8118
export no_proxy=.byted.org
EOF
)

if ! grep -q "# Proxy configuration" "$BASHRC_FILE"; then
    echo "$PROXY_CONFIG" >> "$BASHRC_FILE"
    echo "已添加代理配置到 $BASHRC_FILE"
    source "$BASHRC_FILE"
    echo "代理配置已生效"
else
    echo "代理配置已存在，跳过"
fi

echo "项目初始化完成！"
