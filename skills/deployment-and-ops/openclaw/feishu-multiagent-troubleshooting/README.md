# feishu-multiagent-troubleshooting

用于排查 OpenClaw 接入飞书后的多 Agent 协作、机器人绑定、私聊或群聊不回复、以及 mention 识别失败等问题的中文 Skill。

## 适用场景

当你已经搭好了 OpenClaw，并准备把它接入飞书多机器人或多角色 Agent 体系时，如果遇到下面这些问题，可以使用这个 Skill：

- 需要搭建 `orchestrator + 多角色 agent` 的协作结构。
- 不同 agent 需要绑定不同模型。
- 多个飞书机器人需要分别映射到不同 agent。
- 私聊可以使用，但群聊没有响应。
- 日志里出现 `did not mention bot`。
- orchestrator 具备调度能力，但没有把任务派发给其他角色 agent。

## 这个 Skill 的核心结论

这份 Skill 最重要的结论有 4 个：

1. 先确认 Agent 拓扑、模型分配、`bindings` 和 `agent2agent` 开关是否一致，再去看渠道问题。
2. 飞书私聊不回复和群聊不回复通常不是同一类故障，需要分别排查 pairing / allowlist、权限事件订阅和 mention 识别。
3. 如果日志里出现 `did not mention bot`，优先检查 `botName` 是否与飞书中机器人的真实显示名完全一致。
4. orchestrator “可以调度”不等于“会主动调度”，需要在角色说明或规则中明确强制路由。

## 目录说明

- `SKILL.md`：飞书多 Agent 体系的主排查流程。
- `references/cases.md`：典型问题案例和排查顺序。
- `references/config-patterns.md`：常用配置片段和推荐模式。

## 推荐标签

- `OpenClaw`
- `Feishu`
- `多 Agent`
- `Agent2Agent`
- `渠道接入`
- `群聊`
- `机器人绑定`
- `故障排查`

## 当前归类

本 Skill 当前放在：

- `deployment-and-ops / openclaw / feishu-multiagent-troubleshooting`

这个归类适合后续继续收纳 OpenClaw 的渠道接入、多 Agent 编排和线上排障类 Skill。
