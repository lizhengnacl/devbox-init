# DevBox 初始化脚本

一键初始化开发环境的Shell脚本，自动配置常用工具和环境。

[![GitHub](https://img.shields.io/badge/GitHub-lizhengnacl%2Fdevbox--init-blue?style=flat-square)](https://github.com/lizhengnacl/devbox-init)

## 快速开始

### 方式零：直接复制粘贴运行（最简单）

如果完全无法访问GitHub，直接复制以下代码在终端运行：

```bash
# ==========================================
# 第一步：配置代理
# ==========================================
PROXY_URL="http://sys-proxy-rd-relay.byted.org:8118"
NO_PROXY=".byted.org"

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

# 添加到.bashrc
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ] && ! grep -q "# DevBox Proxy configuration" "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo "# DevBox Proxy configuration" >> "$BASHRC"
    echo "export http_proxy=$PROXY_URL" >> "$BASHRC"
    echo "export https_proxy=$PROXY_URL" >> "$BASHRC"
    echo "export no_proxy=$NO_PROXY" >> "$BASHRC"
    echo "export HTTP_PROXY=$PROXY_URL" >> "$BASHRC"
    echo "export HTTPS_PROXY=$PROXY_URL" >> "$BASHRC"
    echo "export NO_PROXY=$NO_PROXY" >> "$BASHRC"
    echo "已添加代理配置到 $BASHRC"
fi

# 添加到.zshrc
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ] && ! grep -q "# DevBox Proxy configuration" "$ZSHRC"; then
    echo "" >> "$ZSHRC"
    echo "# DevBox Proxy configuration" >> "$ZSHRC"
    echo "export http_proxy=$PROXY_URL" >> "$ZSHRC"
    echo "export https_proxy=$PROXY_URL" >> "$ZSHRC"
    echo "export no_proxy=$NO_PROXY" >> "$ZSHRC"
    echo "export HTTP_PROXY=$PROXY_URL" >> "$ZSHRC"
    echo "export HTTPS_PROXY=$PROXY_URL" >> "$ZSHRC"
    echo "export NO_PROXY=$NO_PROXY" >> "$ZSHRC"
    echo "已添加代理配置到 $ZSHRC"
fi

echo ""
echo "代理配置完成！现在继续安装devbox-init..."
echo ""

# ==========================================
# 第二步：运行devbox-init脚本
# ==========================================
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lizhengnacl/devbox-init/main/init.sh)"
```

---

### 方式一：一键安装（推荐）

如果已配置代理，直接通过curl或wget运行脚本：

```bash
# 使用curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lizhengnacl/devbox-init/main/init.sh)"

# 或使用wget
bash -c "$(wget -O- https://raw.githubusercontent.com/lizhengnacl/devbox-init/main/init.sh)"
```

### 方式二：使用GitHub镜像

如果无法直接访问GitHub，可以使用镜像站：

```bash
# 使用ghproxy镜像
bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/lizhengnacl/devbox-init/main/init.sh)"

# 使用fastgit镜像
bash -c "$(curl -fsSL https://raw.fastgit.org/lizhengnacl/devbox-init/main/init.sh)"
```

### 方式三：手动下载脚本

如果以上方式都不行，可以手动下载脚本：

```bash
# 先临时配置代理（如果有的话）
export http_proxy=http://your-proxy:port
export https_proxy=http://your-proxy:port

# 然后下载脚本
curl -o init.sh https://raw.githubusercontent.com/lizhengnacl/devbox-init/main/init.sh
chmod +x init.sh
bash init.sh
```

### 方式四：克隆仓库安装

```bash
git clone https://github.com/lizhengnacl/devbox-init.git
cd devbox-init
bash init.sh
```

**注意**：如果无法访问GitHub，也可以先下载zip包，解压后运行init.sh。

## 功能特性

### 1. 代理环境变量配置
- 自动配置HTTP/HTTPS代理
- 配置no_proxy排除规则
- 同时支持bash和zsh

### 2. Zsh和Oh My Zsh安装
- 自动检测并安装zsh
- 自动安装Oh My Zsh框架
- 支持macOS和Linux系统

### 3. NVM和Node.js安装
- 自动检测并安装nvm (Node Version Manager)
- 自动安装最新LTS版本的Node.js
- 自动配置npm
- 显示Node.js和npm版本信息
- 配置nvm自动加载：切换目录时自动读取并使用.nvmrc中的Node.js版本

### 4. Screen命令Alias配置
- 配置常用screen命令快捷方式
- 智能检测已存在的alias

**Alias列表：**
- `sc` → `screen`
- `scl` → `screen -ls`
- `scr` → `screen -r`
- `scd` → `screen -d`
- `scdr` → `screen -d -r`

### 5. SSH密钥生成
- 自动生成GitHub和GitLab SSH密钥
- 使用ed25519算法（更安全高效）
- 自动显示公钥内容

**生成的密钥：**
- `~/.ssh/id_github` - GitHub专用密钥
- `~/.ssh/id_gitlab` - GitLab专用密钥

### 6. Git SSH配置
- 自动配置ssh-agent
- 自动添加SSH密钥
- 同时支持bash和zsh配置

## 前置要求

- macOS系统需要先安装Homebrew
- Linux系统需要有apt-get或yum包管理器

## 执行顺序

脚本按以下顺序执行：

1. 配置代理环境变量
2. 检查和安装zsh
3. 检查和安装oh-my-zsh
4. 检查和安装nvm及Node.js
5. 配置screen常用命令alias
6. 生成SSH密钥
7. 配置Git SSH

## 注意事项

### 网络问题处理

- 如果无法访问 raw.githubusercontent.com，请参考"快速开始"部分的多种安装方式
- 脚本本身会自动配置代理，但安装脚本之前可能需要先临时配置代理
- 可以使用GitHub镜像站（如ghproxy、fastgit等）来下载脚本

### 其他注意事项

- 脚本会自动检查配置是否已存在，避免重复添加
- SSH密钥生成时不会设置密码保护
- 生成的公钥会显示在终端，可以直接复制使用
- 如需将zsh设置为默认shell，请手动运行：`chsh -s $(which zsh)`

## 系统要求

- macOS 10.14+ 或 Linux (Ubuntu/CentOS等)
- Bash 4.0+
