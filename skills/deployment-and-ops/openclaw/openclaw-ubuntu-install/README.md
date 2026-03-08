# openclaw-ubuntu-install

用于在 Ubuntu 服务器上安装、初始化并稳定运行 OpenClaw 的中文 Skill。

## 适用场景

当你需要在 Ubuntu 云服务器、VPS 或长期运行的 Linux 主机上部署 OpenClaw，并希望：

- 先通过 `nvm` 安装 Node.js，而不是依赖安装脚本自动处理。
- 用更稳的 `systemd` 系统级服务，而不是依赖 `systemctl --user`。
- 通过 SSH 隧道访问控制界面，而不是直接把端口暴露到公网。
- 在安装过程中顺手规避 root/普通用户混用、端口冲突、daemon 安装失败等常见问题。

## 这个 Skill 的核心结论

这份 Skill 最重要的结论有 4 个：

1. Ubuntu 服务器上优先采用 `nvm + Node.js 22 + npm 全局安装 openclaw` 的路线。
2. 首次执行 `openclaw onboard` 时只做配置，不要在向导里安装用户级 daemon。
3. 对 VPS / 云服务器，更推荐手动创建 `systemd` 系统级服务。
4. 控制界面建议通过 SSH 隧道访问，不建议把 OpenClaw 端口直接暴露到公网。

## 目录说明

- `SKILL.md`：可直接执行的安装与排障主流程。
- `references/vps-systemd-notes.md`：为什么在服务器场景优先使用系统级服务。

## 推荐标签

- `OpenClaw`
- `Ubuntu`
- `Node.js`
- `nvm`
- `systemd`
- `SSH`
- `VPS`
- `部署`
- `故障排查`

## 当前归类

本 Skill 当前放在：

- `deployment-and-ops / openclaw / openclaw-ubuntu-install`

这个归类适合后续继续收纳 OpenClaw 的服务器部署、服务管理、渠道接入和故障排查类 Skill。