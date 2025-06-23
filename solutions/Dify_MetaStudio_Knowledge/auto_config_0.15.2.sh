#!/bin/bash

STATE_CODE=1
EMAIL="super@dify.com"
PASSWORD="admin1234"
DEFAULT_LLM_MODEL="DeepSeek-V3"
DEFAULT_LLM_ENDPOINT_URL="https://api.modelarts-maas.com/v1/chat/completions"
DEFAULT_LLM_API_KEY="12345678"
DEFAULT_MODE_SERVER_HOST="127.0.0.1"

LLM_MODEL=${LLM_MODEL:-$DEFAULT_LLM_MODEL}
LLM_ENDPOINT_URL=${LLM_ENDPOINT_URL:-$DEFAULT_LLM_ENDPOINT_URL}
LLM_API_KEY=${LLM_API_KEY:-$DEFAULT_LLM_API_KEY}
MODE_SERVER_HOST=${MODE_SERVER_HOST:-$DEFAULT_MODE_SERVER_HOST}

# 获取本机IP
URL=$(ip -4 addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1)
echo "获取到的内网 IP：$URL"
echo "获取到的LLM_MODEL：$LLM_MODEL"
echo "获取到的LLM_ENDPOINT_URL：$LLM_ENDPOINT_URL"
echo "获取到的LLM_API_KEY：$LLM_API_KEY"
echo "获取到的MODE_SERVER_HOST：$MODE_SERVER_HOST"

# 登录
MAX_RETRY_NUM=20
RETRY_INTERVAL=5
login_attempt=0
access_token=""
while [ $login_attempt -lt $MAX_RETRY_NUM ]; do
    login_attempt=$((login_attempt + 1))
    echo "第 $login_attempt 次尝试登录..."
    
    login_response=$(curl -s -X POST "http://$URL/console/api/login" \
        -H "Content-Type: application/json" \
        -d '{
        "email": "'$EMAIL'",
        "password": "'$PASSWORD'",
        "remember_me": true,
        "language": "zh-Hans"
    }')

    if ! echo "$login_response" | grep -q '"result": "success"'; then
        echo "登录失败，剩余尝试次数：$((MAX_RETRY_NUM - login_attempt))"
        # 未达最大次数时等待重试
        if [ $login_attempt -lt $MAX_RETRY_NUM ]; then
            echo "等待 $RETRY_INTERVAL 秒后重试..."
            sleep $RETRY_INTERVAL
        else
            echo "登录失败，达到最大尝试次数，退出..."
            exit 1
        fi
    else
        access_token=$(echo "$login_response" | grep -o '"access_token": *"[^"]*"' | cut -d'"' -f4)
        echo "登录成功：  $access_token"
        break
    fi
done

if [ "$access_token" == "" ];then
    echo "登录失败"
    exit 1
fi

llm_attempt=0
llm_max_num=5
llm_retry_interval=10
while [ $llm_attempt -lt $llm_max_num ]; do
    llm_attempt=$((llm_attempt + 1))
    echo "第 $llm_attempt 次尝试配置llm模型..."

    # 配置llm模型
    llm_model_response=$(
        curl -s -X POST "http://$URL/console/api/workspaces/current/model-providers/openai_api_compatible/models" \
            -H "Authorization: Bearer $access_token" \
            -H "Content-Type: application/json" \
            -d '{
                    "model": "'$LLM_MODEL'",
                    "model_type": "llm",
                    "credentials": {
                        "mode": "chat",
                        "context_size": "32768",
                        "max_tokens_to_sample": "32768",
                        "agent_though_support": "not_supported",
                        "function_calling_type": "no_call",
                        "stream_function_calling": "not_supported",
                        "vision_support": "no_support",
                        "structured_output_support": "not_supported",
                        "stream_mode_delimiter": "\\n\\n",
                        "voices": "alloy",
                        "endpoint_url": "'$LLM_ENDPOINT_URL'",
                        "api_key": "'$LLM_API_KEY'"
                    },
                    "load_balancing": {
                        "enabled": false,
                        "configs": []
                    }
                }'
    )

    if ! echo "$llm_model_response" | grep -q '"result": "success"'; then
        echo "配置llm模型失败，剩余尝试次数：$((llm_max_num - llm_attempt))"
        # 未达最大次数时等待重试
        if [ $llm_attempt -lt $llm_max_num ]; then
            echo "等待 $llm_retry_interval 秒后重试..."
            sleep $llm_retry_interval
        else
            echo "配置llm模型失败，达到最大尝试次数，退出..."
            STATE_CODE=0
            break
        fi
    else
        echo "LLM模型供应商配置成功"
        break
    fi
done

# 配置embedding模型
embedding_model_response=$(
    curl -s -X POST "http://$URL/console/api/workspaces/current/model-providers/ollama/models" \
        -H "Authorization: Bearer $access_token" \
        -H "Content-Type: application/json" \
        -d '{
                "model": "bge-m3",
                "model_type": "text-embedding",
                "credentials": {
                    "context_size": "8192",
                    "base_url": "http://'"$MODE_SERVER_HOST"':11434"
                },
                "load_balancing": {
                    "enabled": false,
                    "configs": []
                }
            }'
)

if ! echo "$embedding_model_response" | grep -q '"result": "success"'; then
    echo "Embedding模型供应商配置失败"
    STATE_CODE=0
else
    echo "Embedding模型供应商配置成功"
fi

# 配置rerank模型
rerank_model_response=$(
    curl -s -X POST "http://$URL/console/api/workspaces/current/model-providers/xinference/models" \
        -H "Authorization: Bearer $access_token" \
        -H "Content-Type: application/json" \
        -d '{
                "model": "bge-reranker-v2-m3",
                "model_type": "rerank",
                "credentials": {
                    "invoke_timeout": "60",
                    "max_retries": "3",
                    "model_uid": "bge-reranker-v2-m3",
                    "server_url": "http://'$MODE_SERVER_HOST':9997"
                },
                "load_balancing": {
                    "enabled": false,
                    "configs": []
                }
            }'
)

if ! echo "$rerank_model_response" | grep -q '"result": "success"'; then
    echo "Rerank模型供应商配置失败"
    STATE_CODE=0
else
    echo "Rerank模型供应商配置成功"
fi

# 默认模型供应商配置
default_model_provider_response=$(
    curl -s -X POST "http://$URL/console/api/workspaces/current/default-model" \
        -H "Authorization: Bearer $access_token" \
        -H "Content-Type: application/json" \
        -d '{   
                "model_settings": [{ 
                        "model_type": "llm",
                        "provider": "openai_api_compatible",
                        "model": '"$LLM_MODEL"'
                    }, {
                        "model_type": "text-embedding",
                        "provider": "openai_api_compatible",
                        "model": "bge-m3"
                    }, {
                        "model_type": "rerank",
                        "provider": "openai_api_compatible",
                        "model": "bge-reranker-v2-m3"
                    }, {
                        "model_type": "speech2text"
                    }, {
                        "model_type": "tts"
                    }
                ]
            }'
)

if ! echo "$default_model_provider_response" | grep -q '"result": "success"'; then
    echo "默认模型供应商配置失败"
    STATE_CODE=0
else
    echo "默认模型供应商配置成功"
fi

# 配置联网搜索服务
searxng_response=$(
    curl -s -X POST "http://$URL/console/api/workspaces/current/tool-provider/builtin/searxng/update" \
        -H "Authorization: Bearer $access_token" \
        -H "Content-Type: application/json" \
        -d '{"credentials":{"searxng_base_url":"http://'"$URL"':8080"}}'
)

if ! echo "$searxng_response" | grep -q '"result": "success"'; then
    echo "联网搜索服务配置失败"
    STATE_CODE=0
else
    echo "联网搜索服务配置成功"
fi

if [ $STATE_CODE -eq 1 ]; then
    echo "[$(data)] 脚本执行成功,禁用下次开机触发"
    systemctl disable run_auto_config.timer
fi

# 手动开启 systemctl enable run_auto_config.timer