#!/bin/bash

PROXY_URL="http://sys-proxy-rd-relay.byted.org:8118"
NO_PROXY=".byted.org"

echo "开始配置代理环境变量..."

set_proxy() {
    export http_proxy="$PROXY_URL"
    export https_proxy="$PROXY_URL"
    export no_proxy="$NO_PROXY"
    export HTTP_PROXY="$PROXY_URL"
    export HTTPS_PROXY="$PROXY_URL"
    export NO_PROXY="$NO_PROXY"
    echo "代理已配置："
    echo "  http_proxy=$http_proxy"
    echo "  https_proxy=$https_proxy"
    echo "  no_proxy=$no_proxy"
}

add_to_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        touch "$file"
        echo "已创建 $file"
    fi
    
    if ! grep -q "# DevBox Proxy configuration" "$file"; then
        echo "" >> "$file"
        echo "# DevBox Proxy configuration" >> "$file"
        echo "export http_proxy=$PROXY_URL" >> "$file"
        echo "export https_proxy=$PROXY_URL" >> "$file"
        echo "export no_proxy=$NO_PROXY" >> "$file"
        echo "export HTTP_PROXY=$PROXY_URL" >> "$file"
        echo "export HTTPS_PROXY=$PROXY_URL" >> "$file"
        echo "export NO_PROXY=$NO_PROXY" >> "$file"
        echo "已添加代理配置到 $file"
    else
        echo "代理配置在 $file 中已存在，跳过"
    fi
}

set_proxy

BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"

if [ -f "$BASHRC" ]; then
    add_to_file "$BASHRC"
fi

if [ -f "$ZSHRC" ]; then
    add_to_file "$ZSHRC"
fi

echo ""
echo "=========================================="
echo "代理配置完成！"
echo ""
echo "当前会话代理已生效"
echo "重新登录后也会自动生效"
echo ""
echo "现在可以运行 devbox-init 脚本了："
echo "bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/lizhengnacl/devbox-init/main/init.sh)\""
echo "=========================================="
