---
name: openclaw-ubuntu-install
description: 在 Ubuntu 服务器上用 nvm 安装 Node.js 22 并以 systemd 稳定部署 OpenClaw 的流程
---

# 适用场景

当你要在 Ubuntu 服务器上部署 OpenClaw，并且希望安装过程可控、长期运行稳定、便于后续维护时，使用本 Skill。

尤其适合下面这些情况：

- 服务器是云主机或 VPS，需要长期常驻运行。
- 希望先安装 `nvm`，再通过 `nvm` 安装 `Node.js 22`。
- 不想把 OpenClaw 控制端口直接暴露到公网。
- 遇到 `systemctl --user` 不可用、daemon 安装失败、root 与普通用户配置混用等问题。

# 排查目标

- 在 Ubuntu 服务器上完成 OpenClaw 安装。
- 保持 Node 环境可升级、可切换、可追踪。
- 让 OpenClaw 以 `systemd` 系统级服务稳定运行。
- 通过 SSH 隧道安全访问控制界面。

# 推荐方案总览

推荐采用下面这条路线：

1. 用普通用户通过 SSH 登录服务器。
2. 安装基础依赖。
3. 安装 `nvm`。
4. 通过 `nvm` 安装 `Node.js 22`。
5. 视网络情况配置 npm 镜像。
6. 用 `npm install -g openclaw@latest` 安装 OpenClaw。
7. 执行 `openclaw onboard` 完成初始化，但不要在向导中安装 daemon。
8. 手动创建 `systemd` 系统级服务。
9. 用 SSH 隧道访问本地界面并做健康检查。

# 处理步骤

## 第 1 步：登录服务器并准备基础环境

建议优先用普通用户登录，而不是先登录 `root` 再 `su` 切换。

```powershell
ssh ubuntu@xx.xx.xx.xx
```

安装基础依赖：

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git ca-certificates build-essential ufw
```

可选动作：

```bash
sudo timedatectl set-timezone Asia/Shanghai
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

## 第 2 步：安装 nvm 和 Node.js 22

先安装 `nvm`：

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
command -v nvm
```

再安装并切换到 Node.js 22：

```bash
nvm install 22
nvm use 22
nvm alias default 22
node -v
npm -v
which node
which npm
```

如果国内网络访问 npm 不稳定，可以先切换镜像：

```bash
npm config set registry https://registry.npmmirror.com
npm config get registry
npm ping
```

## 第 3 步：安装 OpenClaw

```bash
npm install -g openclaw@latest
openclaw --version
npm prefix -g
```

如果镜像源还没同步到最新包，可以临时切回官方源后再安装：

```bash
npm config set registry https://registry.npmjs.org/
```

## 第 4 步：运行首次引导，但不要安装用户级 daemon

只执行：

```bash
openclaw onboard
```

引导过程中建议：

- Gateway 运行在本机。
- 绑定方式优先选择 `loopback`。
- Workspace 使用默认值。
- 模型提供方和渠道按需填写，没准备好可先跳过。
- 如果向导问是否安装 daemon / service / systemd service，选择 `No`、`Skip` 或 `Not now`。

原因：

- 在 VPS 场景下，`systemctl --user` 经常因为会话环境不完整而失败。
- 即使 `openclaw onboard` 没带 `--install-daemon`，只要你在向导里选择安装服务，依然可能掉进用户级 systemd 流程。

## 第 5 步：优先改为 systemd 系统级服务

先确认 `openclaw` 和 `node` 的绝对路径：

```bash
which openclaw
which node
```

准备变量：

```bash
OPENCLAW_BIN="$(which openclaw)"
NODE_BIN_DIR="$(dirname "$(which node)")"
printf '%s\n' "$OPENCLAW_BIN"
printf '%s\n' "$NODE_BIN_DIR"
```

创建系统级服务文件：

```bash
sudo bash -c "cat > /etc/systemd/system/openclaw-gateway.service <<EOF
[Unit]
Description=OpenClaw Gateway
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu
Environment=HOME=/home/ubuntu
Environment=OPENCLAW_STATE_DIR=/home/ubuntu/.openclaw
Environment=OPENCLAW_CONFIG_PATH=/home/ubuntu/.openclaw/openclaw.json
Environment=PATH=${NODE_BIN_DIR}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ExecStart=${OPENCLAW_BIN} gateway --port 18789
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF"
```

启用并检查服务：

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now openclaw-gateway.service
sudo systemctl status openclaw-gateway.service
sudo journalctl -u openclaw-gateway.service -n 200 --no-pager
```

## 第 6 步：做健康检查并通过 SSH 隧道访问

优先验证：

```bash
openclaw health
sudo systemctl status openclaw-gateway.service
sudo ss -ltnp | grep 18789
```

再在本地电脑建立 SSH 隧道：

```powershell
ssh -N -L 18789:127.0.0.1:18789 ubuntu@xx.xx.xx.xx
```

然后在本地浏览器访问：

```text
http://127.0.0.1:18789
```

# 常见问题快速判断

## 1. `systemctl --user` 报错怎么办

如果报错类似下面这种：

```text
systemctl is-enabled unavailable
```

优先判断：

- 你是不是 `root` 登录后再 `su - ubuntu`。
- 你是不是在没有完整 user systemd 环境的 SSH 会话里操作。
- 你是不是已经在向导里触发了用户级 daemon 安装。

对 Ubuntu VPS，更推荐直接放弃用户级服务路线，改用前面的 `systemd` 系统级服务方案。

## 2. 不要混用 `root` 和普通用户两套 OpenClaw

重点风险：

- `root` 和 `ubuntu` 会各自生成独立的 `.openclaw` 目录。
- 两套实例可能抢占同一个端口。
- 容易出现 token 不一致、配置错乱、状态互相覆盖。

建议只保留普通用户这一套。

## 3. `openclaw gateway status` 显示不准怎么办

如果你已经采用手动创建的系统级服务，`openclaw gateway status` 可能显示 `non-standard` 或 `stopped`。这不一定代表服务真的有问题。

优先相信下面三个检查：

- `openclaw health`
- `sudo systemctl status openclaw-gateway.service`
- `sudo ss -ltnp | grep 18789`

## 4. SSH 提示主机指纹变化

如果服务器重装过系统，执行：

```powershell
ssh-keygen -R xx.xx.xx.xx
```

然后重新连接并确认新指纹即可。

# 使用建议

- 服务器场景优先用普通用户部署，再通过 `sudo` 管理系统服务。
- 不建议把 OpenClaw 管理端口直接开放到公网。
- 真正长期运行时，把“CLI 初始化”和“systemd 服务管理”分开处理会更稳。
- 后续如果要接入飞书、Telegram 等渠道，建议在 Gateway 稳定后再继续扩展。