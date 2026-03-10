# 配置片段参考

## 开启 agent2agent

```json5
{
  "tools": {
    "agentToAgent": {
      "enabled": true,
      "allow": ["main", "orchestrator", "pm_product", "pm_project", "dev", "qa"]
    }
  }
}
```

## 飞书多账号绑定

```json5
{
  "channels": {
    "feishu": {
      "enabled": true,
      "defaultAccount": "default",
      "accounts": {
        "orchestrator": {
          "appId": "cli_xxx",
          "appSecret": "xxx",
          "botName": "AI_总控调度官"
        }
      }
    }
  },
  "bindings": [
    {
      "agentId": "orchestrator",
      "match": {
        "channel": "feishu",
        "accountId": "orchestrator"
      }
    }
  ]
}
```

## 私聊测试推荐：allowlist 模式

```json5
{
  "channels": {
    "feishu": {
      "dmPolicy": "allowlist",
      "allowFrom": [
        "ou_app1_user",
        "ou_app2_user",
        "ou_app3_user"
      ]
    }
  }
}
```

## 针对某个群关闭 @ 提及要求（仅作为兜底方案）
只有在你明确希望某个群无需 @ 也能回复时才使用。

```json5
{
  "channels": {
    "feishu": {
      "groups": {
        "oc_xxx": {
          "requireMention": false
        }
      }
    }
  }
}
```

## 严格总控路由思路
这部分更适合写进 orchestrator 的 prompt / 角色文件，而不只是写配置：
- 代码任务必须给 `dev`
- 测试/验收任务必须给 `qa`
- 需求分析任务必须给 `pm_product`
- 项目规划任务必须给 `pm_project`
- orchestrator 自己只做协调、汇总和最终回传
