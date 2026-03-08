# VPS 场景下优先使用 systemd 系统级服务的说明

## 为什么不优先用 `systemctl --user`

在 Ubuntu 云服务器或 VPS 场景里，`systemctl --user` 往往依赖完整的用户会话环境。如果你是通过 `root` 登录再切换用户、或者当前 SSH 会话没有正确建立 user systemd 环境，就容易出现：

- `systemctl is-enabled unavailable`
- `systemctl --user status` 无法访问
- 用户级 service 文件还没生成就提前失败

## 为什么系统级服务更稳

对于长期运行的服务器，系统级服务有几个优点：

- 不依赖当前交互式 SSH 会话。
- 更适合开机自启和长期守护。
- 统一用 `sudo systemctl ...` 管理，更容易排查。
- 与 OpenClaw 在 VPS 上的常驻运行场景更匹配。

## 实操建议

- 用普通用户完成 `openclaw onboard` 配置。
- 不要在向导里安装 daemon。
- 再手动写 `/etc/systemd/system/openclaw-gateway.service`。
- 用 `sudo systemctl enable --now openclaw-gateway.service` 启动服务。
- 验证时优先看 `openclaw health`、`systemctl status` 和端口监听，而不是只看 `openclaw gateway status`。