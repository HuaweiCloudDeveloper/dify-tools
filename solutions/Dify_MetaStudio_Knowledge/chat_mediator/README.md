# 连接 MetaStudio 智能交互 和 Dify 工作流API的 中间服务

### 流程图

![流程图](../.assets/20250625_104155.png)

### 功能

- 支持流式输出和非流式输出
- 支持多轮对话


### 启动

**配置参数(环境变量)**

```
REDIS_HOST：redis地址
REDIS_PORT：redis端口,默认6379
REDIS_PASSWORD：redis密码，默认difyai123456
CACHE_TTL：缓存有效期（秒），默认3600
Dify_HOST：Dify服务地址
Dify_API_KEY：Dify工作流API密钥
```

**启动项目**

```
cd chat_mediator
uv venv
source .venv/bin/activate
uv pip install -r pyproject.toml
# 使用默认8000端口，host是0.0.0.0
uv run main.py

# 自定义端口启动
uvicorn main:app --host 0.0.0.0 --port 8080
```

