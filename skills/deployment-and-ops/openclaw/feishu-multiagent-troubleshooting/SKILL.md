---
name: feishu-multiagent-troubleshooting
description: 当你在 OpenClaw 中接入飞书多 Agent 体系，并遇到多机器人绑定、配对或白名单异常、私聊或群聊不回复、以及日志出现 `did not mention bot` 等问题时，使用本 Skill。
---

# 飞书多 Agent 排障 Skill

当你在处理以下场景时，使用这个 skill：
- 1 个 orchestrator（总控）+ 多个角色 agent
- 不同 agent 使用不同模型
- 多个飞书机器人分别映射到不同 agent
- agent2agent 协作
- 私聊能用，但群聊不回复
- 飞书日志里出现 `did not mention bot`

## 快速排查流程

1. **确认 Agent 拓扑**
   - 执行 `openclaw agents list --bindings`
   - 确认每个 agent 都有独立的 `workspace` 和 `agentDir`
   - 确认 `~/.openclaw/openclaw.json` 里的模型分配是否正确

2. **确认协作能力已开启**
   - `tools.agentToAgent.enabled` 必须是 `true`
   - allowlist 里应包含 `main`、`orchestrator` 以及各角色 agent
   - orchestrator 应具备 `sessions_send` 和/或 `sessions_spawn`

3. **确认飞书账号绑定正确**
   - 每个机器人都要有 `channels.feishu.accounts.<accountId>`
   - `bindings` 应正确把 `channel=feishu + accountId` 映射到对应 `agentId`
   - 如果不想影响当前主机器人，保留旧的 `default` 账号

4. **如果私聊不回复**
   - 检查 pairing：`openclaw pairing list feishu`
   - 如有需要，批准：`openclaw pairing approve feishu <CODE>`
   - 如果要长期测试，建议改成 `channels.feishu.dmPolicy = "allowlist"`
   - 把所有 app 维度下的用户 open_id 都加进 `channels.feishu.allowFrom`

5. **如果群聊不回复**
   - 检查飞书应用权限和事件订阅
   - 实时看日志：`openclaw logs --follow`
   - 先区分到底是哪一类问题：
     - **群消息根本没进来**
     - **群消息进来了，但日志显示 `did not mention bot`**

## 经过验证的多 Agent 结构

推荐角色：
- `orchestrator`
- `pm_product`
- `pm_project`
- `dev`
- `qa`

当当前环境只有 3 个可用模型时，推荐的模型分配：
- `orchestrator` -> `openai-relay/gpt-5.4`
- `pm_product` -> `zhipu-cn/glm-4.7`
- `pm_project` -> `minimax-cn/MiniMax-M2.5`
- `dev` -> `openai-relay/gpt-5.4`
- `qa` -> `zhipu-cn/glm-4.7`

## 常见故障模式

### 1. 机器人存在，但私聊提示 access not configured
原因：
- 飞书私聊策略仍然是 pairing，或者发送者不在 allowlist 中。

解决：
- 先批准一次 pairing code，或者改成 allowlist 模式。
- 注意：**飞书的 open_id 是按应用隔离的**。同一个真人，在不同机器人 app 下可能有不同的 open_id。

### 2. 群聊不回复，日志里也没有群事件
常见原因：
- 飞书应用改完权限后没有发布版本
- 群消息权限未开启
- 事件订阅缺失，或者没有使用 websocket/长连接模式
- 配置改了，但当前连接还是旧状态，未刷新

优先检查以下项：
- `im.message.receive_v1`
- `im:message.group_msg`
- `im:message.group_at_msg:readonly`
- 机器人能力已开启
- 应用版本已发布
- 事件订阅模式为长连接 / websocket

必要时重启 gateway。

### 3. 群消息已进入，但日志显示 `did not mention bot`
这是一个非常具体的问题。

OpenClaw 的飞书 mention 检测会校验：
- mention 的 open_id 是否等于 bot 的 open_id
- 如果配置了 `botName`，mention 的显示名也必须和 `botName` 一致

典型错误场景：
- 飞书群里机器人真实显示名：`AI_总控调度官`
- 配置里的 `botName`：`总控调度官`

结果：
- 群消息进入了系统
- 但 mention 被判定为不匹配
- 日志打印 `did not mention bot`

解决：
- 把 `channels.feishu.accounts.<accountId>.botName` 改成飞书里真实显示的机器人名称
- 改完后重启 gateway

### 4. orchestrator 没有把任务分派给其他角色 agent
原因：
- agent2agent 已开启，但 orchestrator 只是“**具备调度能力**”，不是“**必须调度**”
- 简单任务通常会被 orchestrator 自己直接回答

解决：
- 强化 orchestrator 的角色说明
- 定义强制路由规则，例如：
  - 代码类任务 -> 必须给 `dev`
  - 测试/验证类任务 -> 必须给 `qa`
  - 需求分析类任务 -> 必须给 `pm_product`
  - 项目规划类任务 -> 必须给 `pm_project`
- orchestrator 自己只做协调、汇总、回传

## 实操检查方法

### 检查消息有没有到正确的 agent
- 查看 `~/.openclaw/agents/<agent>/sessions/`
- 检查是否生成类似 `agent:orchestrator:feishu:group:<chat_id>` 这样的群会话

### 检查是否 mention 识别失败
重点看日志里是否出现：
- `received message ... (group)`
- `message in group ... did not mention bot`

如果有，说明：
- 权限和事件订阅已经通了
- 当前要重点查 mention 匹配逻辑，而不是权限问题

### 检查 orchestrator 是否真的做了分派
查看 orchestrator 对应的 session JSONL，是否有工具调用：
- `sessions_send`
- `sessions_spawn`

如果没有，说明它是自己处理了任务，而不是走多 agent 协作。

## 参考文件
- 具体踩坑案例：见 `references/cases.md`
- 常用配置片段：见 `references/config-patterns.md`
