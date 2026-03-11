#!/bin/bash

set -e

echo "开始初始化项目..."

echo ""
echo "配置代理环境变量..."

PROXY_CONFIG=$(cat << 'EOF'

# Proxy configuration
export http_proxy=http://sys-proxy-rd-relay.byted.org:8118
export https_proxy=http://sys-proxy-rd-relay.byted.org:8118
export no_proxy=.byted.org
EOF
)

BASHRC_FILE="$HOME/.bashrc"
if ! grep -q "# Proxy configuration" "$BASHRC_FILE"; then
    echo "$PROXY_CONFIG" >> "$BASHRC_FILE"
    echo "已添加代理配置到 $BASHRC_FILE"
    source "$BASHRC_FILE"
else
    echo "代理配置在 $BASHRC_FILE 中已存在，跳过"
fi

echo ""
echo "检查和安装zsh..."

if ! command -v zsh &> /dev/null; then
    echo "zsh未安装，正在安装..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install zsh
        else
            echo "Homebrew未安装，请先安装Homebrew或手动安装zsh"
            exit 1
        fi
    else
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y zsh
        elif command -v yum &> /dev/null; then
            sudo yum install -y zsh
        else
            echo "无法自动安装zsh，请手动安装"
            exit 1
        fi
    fi
    echo "zsh安装完成"
else
    echo "zsh已安装"
fi

echo ""
echo "检查和安装oh-my-zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh未安装，正在安装..."
    if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        echo "GitHub安装失败，尝试备用镜像..."
        sh -c "$(curl -fsSL https://install.ohmyz.sh/)" "" --unattended
    fi
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "oh-my-zsh安装完成"
    else
        echo "oh-my-zsh安装失败，请检查网络连接"
    fi
else
    echo "oh-my-zsh已安装"
fi

ZSHRC_FILE="$HOME/.zshrc"

echo ""
echo "zsh 安装完成！"
echo ""
echo "💡 您现在可以立即使用 zsh 了！"
echo "   运行: zsh"

echo ""
echo "配置zsh环境变量..."

if ! grep -q "# Proxy configuration" "$ZSHRC_FILE"; then
    echo "$PROXY_CONFIG" >> "$ZSHRC_FILE"
    echo "已添加代理配置到 $ZSHRC_FILE"
else
    echo "代理配置在 $ZSHRC_FILE 中已存在，跳过"
fi

echo ""
echo "检查和安装nvm..."

export NVM_DIR="$HOME/.nvm"

if [ ! -d "$NVM_DIR" ]; then
    echo "nvm未安装，正在安装..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    echo "nvm安装完成"
    
    echo "正在加载nvm..."
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    echo "正在安装最新LTS版本的Node.js..."
    nvm install --lts
    nvm use --lts
    echo "Node.js安装完成"
    echo "Node.js版本: $(node --version)"
    echo "npm版本: $(npm --version)"
else
    echo "nvm已安装"
    
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if ! command -v node &> /dev/null; then
        echo "Node.js未安装，正在安装最新LTS版本..."
        nvm install --lts
        nvm use --lts
        echo "Node.js安装完成"
        echo "Node.js版本: $(node --version)"
        echo "npm版本: $(npm --version)"
    else
        echo "Node.js已安装: $(node --version)"
    fi
fi

echo ""
echo "配置nvm自动加载..."

NVM_AUTOLOAD_CONFIG=$(cat << 'EOF'

# NVM auto load configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto load .nvmrc when changing directory
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
EOF
)

BASH_NVM_CONFIG=$(cat << 'EOF'

# NVM auto load configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto load .nvmrc when changing directory
cd() {
  builtin cd "$@" || return
  if [ -f ".nvmrc" ]; then
    nvm use
  fi
}
EOF
)

if [ -f "$BASHRC_FILE" ] && ! grep -q "# NVM auto load configuration" "$BASHRC_FILE"; then
    echo "$BASH_NVM_CONFIG" >> "$BASHRC_FILE"
    echo "已添加nvm自动加载配置到 $BASHRC_FILE"
else
    if [ -f "$BASHRC_FILE" ]; then
        echo "nvm自动加载配置在 $BASHRC_FILE 中已存在，跳过"
    fi
fi

if ! grep -q "# NVM auto load configuration" "$ZSHRC_FILE"; then
    echo "$NVM_AUTOLOAD_CONFIG" >> "$ZSHRC_FILE"
    echo "已添加nvm自动加载配置到 $ZSHRC_FILE"
else
    echo "nvm自动加载配置在 $ZSHRC_FILE 中已存在，跳过"
fi

echo ""
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
echo "配置自动切换到zsh..."

AUTO_SWITCH_CONFIG=$(cat << 'EOF'

# Auto switch to zsh
if command -v zsh &> /dev/null && [ -z "$ZSH_VERSION" ]; then
    exec zsh
fi
EOF
)

if [ -f "$BASHRC_FILE" ] && ! grep -q "# Auto switch to zsh" "$BASHRC_FILE"; then
    echo "$AUTO_SWITCH_CONFIG" >> "$BASHRC_FILE"
    echo "已添加自动切换到zsh配置到 $BASHRC_FILE"
else
    if [ -f "$BASHRC_FILE" ]; then
        echo "自动切换到zsh配置在 $BASHRC_FILE 中已存在，跳过"
    fi
fi

BASH_PROFILE="$HOME/.bash_profile"
if [ -f "$BASH_PROFILE" ] && ! grep -q "# Auto switch to zsh" "$BASH_PROFILE"; then
    echo "$AUTO_SWITCH_CONFIG" >> "$BASH_PROFILE"
    echo "已添加自动切换到zsh配置到 $BASH_PROFILE"
fi

echo ""
echo "生成SSH密钥..."

generate_ssh_key() {
    local key_name="$1"
    local key_path="$HOME/.ssh/$key_name"
    local comment="$2"
    
    if [ ! -f "$key_path" ]; then
        echo "正在生成 $key_name 密钥..."
        ssh-keygen -t ed25519 -C "$comment" -f "$key_path" -N ""
        echo "$key_name 密钥已生成"
        echo ""
        echo "=== $key_name 公钥内容 ==="
        cat "${key_path}.pub"
        echo "========================="
        echo ""
    else
        echo "$key_name 密钥已存在，跳过生成"
    fi
}

generate_ssh_key "id_github" "lizhengnacl@163.com"
generate_ssh_key "id_gitlab" "lizheng.626@bytedance.com"

echo ""
echo "配置Git SSH..."

SSH_CONFIG=$(cat << 'EOF'

# Git SSH configuration
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_github
ssh-add ~/.ssh/id_gitlab
EOF
)

if ! grep -q "# Git SSH configuration" "$BASHRC_FILE"; then
    echo "$SSH_CONFIG" >> "$BASHRC_FILE"
    echo "已添加Git SSH配置到 $BASHRC_FILE"
else
    echo "Git SSH配置在 $BASHRC_FILE 中已存在，跳过"
fi

if ! grep -q "# Git SSH configuration" "$ZSHRC_FILE"; then
    echo "$SSH_CONFIG" >> "$ZSHRC_FILE"
    echo "已添加Git SSH配置到 $ZSHRC_FILE"
else
    echo "Git SSH配置在 $ZSHRC_FILE 中已存在，跳过"
fi

echo "正在立即生效Git SSH配置..."
eval "$(ssh-agent -s)"
if [ -f ~/.ssh/id_github ]; then
    ssh-add ~/.ssh/id_github
fi
if [ -f ~/.ssh/id_gitlab ]; then
    ssh-add ~/.ssh/id_gitlab
fi
echo "Git SSH配置已生效"

echo ""
echo "项目初始化完成！"
echo ""
echo "💡 已配置自动切换到 zsh！"
echo "   下次打开新终端时会自动进入 zsh"
echo "   现在可以运行 'source ~/.bashrc' 立即生效"
echo ""
echo "尝试自动加载 zsh 配置..."
if command -v zsh &> /dev/null && [ -f "$ZSHRC_FILE" ]; then
    zsh -c "source $ZSHRC_FILE 2>/dev/null || true"
    echo "zsh 配置已准备就绪"
fi
