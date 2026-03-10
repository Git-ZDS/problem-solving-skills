# 案例汇总

## 案例 1：5 Agent + 5 个独立飞书机器人
结构：
- orchestrator
- pm_product
- pm_project
- dev
- qa

关键配置思路：
- 每个机器人一个独立 Feishu account
- 每个 `accountId` 独立绑定到对应 `agentId`
- 如果当前已有主机器人在使用，保留旧的 `default` account
- 开启 `tools.agentToAgent`
- 给 orchestrator 开 `sessions_send` / `sessions_spawn`

## 案例 2：一个机器人配对通过，另一个机器人还要重新配对
现象：
- 同一个人，在不同机器人 app 下出现不同的 `open_id`
- 已经批准某个 pairing code，但换另一个机器人还是提示未配置访问

原因：
- Feishu `open_id` 是按 app 隔离的

解决：
- 每个 app 分别批准 pairing
- 或者改成 `dmPolicy: "allowlist"`，并把所有 app 下的 open_id 都加入 `channels.feishu.allowFrom`

## 案例 3：私聊正常，群聊完全没反应
现象：
- 没有群会话生成
- 日志中看不到群消息事件

排查顺序：
1. 是否添加了 `im.message.receive_v1`
2. 是否开启群消息权限：
   - `im:message.group_msg`
   - `im:message.group_at_msg:readonly`
3. 是否发布了新版本
4. 是否使用长连接 / websocket 模式
5. 必要时重启 gateway，刷新飞书连接

## 案例 4：群消息已到，但日志显示 `did not mention bot`
现象：
- 日志能看到群消息到达
- 紧接着打印 `did not mention bot`

已确认的根因：
- OpenClaw Feishu 插件会同时校验 mention open_id 和 mention name
- 如果配置中的 `botName` 和飞书里真实显示名不一致，会被判定为未提及

示例：
- 配置里：`总控调度官`
- 实际显示：`AI_总控调度官`

解决：
- 把所有机器人的 `botName` 改成飞书中实际显示的名字
- 然后重启 gateway

## 案例 5：orchestrator 没有把简单代码任务分派出去
现象：
- 用户要求写 Python 冒泡排序
- orchestrator 自己直接回复了代码
- session 日志里没有 `sessions_send` 或 `sessions_spawn`

原因：
- orchestrator 有调度能力，但没有被要求“必须调度”

解决：
- 给 orchestrator 加“严格调度模式”规则
- 例如：
  - 代码 -> 必须给 `dev`
  - 验证 -> 必须给 `qa`
  - 需求 -> 必须给 `pm_product`
  - 规划 -> 必须给 `pm_project`

## 常用命令

```bash
openclaw agents list --bindings
openclaw pairing list feishu
openclaw pairing approve feishu <CODE>
openclaw status --deep
openclaw channels status --probe
openclaw logs --follow
```
