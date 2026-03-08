# idea-loopback-recovery

用于处理 IntelliJ IDEA 在 Git 交互、回环访问、本地授权页、askpass 等链路上出现异常时的恢复流程。

## 适用场景

当你在 IDEA 中执行 Git 相关操作时，出现以下类似问题，可以优先使用这个 Skill：

- IDEA 无法正常弹出 Git 登录或授权窗口。
- 本地回环地址页面打不开，导致授权卡住。
- Git 操作在 IDE 内挂起、无响应或反复失败。
- `askpass`、本地 helper、系统目录锁定等问题相互叠加。
- Windows 环境下，重启 IDEA 后问题仍然持续。

## 这个 Skill 的定位

这不是单一命令的“修复脚本”，而是一套可复用的处理流程，重点在于：

- 快速判断问题是不是发生在 IDEA 本地交互链路。
- 分层排查 Git、IDEA、本地回环和系统缓存之间的关系。
- 在不扩大影响面的前提下优先做低风险恢复。
- 在必要时执行清理脚本和目录恢复动作。

## 目录说明

- `SKILL.md`：核心处理流程，适合直接照着执行。
- `references/windows-intellij-loopback.md`：Windows + IDEA 回环交互的背景说明。
- `references/git-askpass-loopback.md`：Git askpass 与本地交互链路的补充说明。
- `scripts/clear-idea-system-lock.ps1`：辅助清理脚本，用于释放常见锁定痕迹。

## 推荐标签

- `IDEA`
- `JetBrains`
- `Git`
- `askpass`
- `loopback`
- `Windows`
- `故障排查`

## 当前归类

本 Skill 当前放在：

- `development-tools / jetbrains-idea / idea-loopback-recovery`

如果你后面会整理更多与 IDE、编辑器、插件故障有关的 Skill，这个归类会比较稳定。
