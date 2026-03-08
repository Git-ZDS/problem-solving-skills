# problem-solving-skills

一个用于沉淀日常问题处理经验、故障排查流程和可复用操作方法的中文 Skill 仓库。

这个仓库的重点不是只记录结论，而是把处理问题时的判断路径、排查步骤、验证方式、回滚思路和复盘经验整理成可持续复用的 Skill，方便后续不断补充、统一管理和持续推送。

## 仓库定位

- 面向场景：日常开发、环境维护、工具排障、流程固化。
- 内容形式：每个问题整理为一个独立 Skill。
- 编写语言：全部使用中文。
- 目录规则：使用英文文件夹名，内容说明使用中文。
- 扩展方式：后续新增 Skill 统一按模板补充并推送到本仓库。

## 当前分类方案

当前建议按“一级分类 / 产品或场景 / Skill”分层组织，且目录名全部使用英文。

建议的一级分类如下：

1. `development-tools`
2. `version-control`
3. `operating-systems`
4. `environment-setup`
5. `network-and-proxy`
6. `build-and-dependencies`
7. `data-and-storage`
8. `deployment-and-ops`
9. `troubleshooting`
10. `automation-scripts`

说明：

- 一级分类解决仓库整体归档问题。
- 二级目录解决具体产品、平台或场景归类问题。
- 每个 Skill 自身再通过中文描述和标签补充检索能力。

## 当前已收录 Skill

### development-tools

- `skills/development-tools/jetbrains-idea/idea-loopback-recovery`
  - 主题：IntelliJ IDEA 中与 loopback、askpass、Git 交互相关的问题恢复流程。
  - 来源：整理自你的仓库 `idea-loopback-recovery`。
  - 标签：`IDEA`、`JetBrains`、`Git`、`askpass`、`loopback`、`Windows`

### deployment-and-ops

- `skills/deployment-and-ops/openclaw/openclaw-ubuntu-install`
  - 主题：Ubuntu 服务器上使用 `nvm + Node.js 22 + systemd` 安装和稳定运行 OpenClaw 的流程。
  - 来源：整理自 `E:/aitest/demo/OPENCLAW_UBUNTU_INSTALL.md`。
  - 标签：`OpenClaw`、`Ubuntu`、`nvm`、`Node.js`、`systemd`、`SSH`、`VPS`

## 目录结构

```text
problem-solving-skills/
├─ README.md
├─ templates/
│  └─ skill-template/
└─ skills/
   └─ development-tools/
      └─ jetbrains-idea/
         └─ idea-loopback-recovery/
            ├─ README.md
            ├─ SKILL.md
            ├─ references/
            └─ scripts/
```

## Skill 编写规范

每个 Skill 目录建议至少包含：

- `README.md`：说明适用场景、问题现象、使用方式和目录内容。
- `SKILL.md`：核心处理流程，适合直接执行或交给 AI 使用。
- `references/`：补充背景、原理、案例和验证记录。
- `scripts/`：自动化脚本或辅助命令。

## 后续新增 Skill 的建议流程

1. 先确定它属于哪个一级分类。
2. 再确定它对应的产品、平台或场景目录。
3. 复制 `templates/skill-template/` 作为新 Skill 的起点。
4. 统一使用中文编写说明内容。
5. 在根目录 `README.md` 中补充索引。

## 当前默认归类说明

本次已将 `idea-loopback-recovery` 放到：

- `development-tools / jetbrains-idea / idea-loopback-recovery`

这个归类适合后续继续沉淀 IDE、编辑器、插件和开发辅助工具相关的 Skill。
