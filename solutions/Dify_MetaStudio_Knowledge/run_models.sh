#!/bin/bash

RERANK_MODEL_PATH="/home/models/bge-reranker-v2-m3-GGUF/bge-reranker-v2-m3-Q8_0.gguf"
EMBED_MODEL_PATH="/home/models/bge-m3-GGUF/bge-m3-Q8_0.gguf"
RERANK_PORT=8083
EMBED_PORT=8084
RERANK_LOG="logs/rerank.log"
EMBED_LOG="logs/embed.log"

check_process_exists() {
    ps -ef | grep -q "llama-server.*--port $1"
}

kill_process_by_port() {
    local port=$1
    echo "检测到端口 ${port} 已有进程运行，尝试终止..."
    # 终止所有匹配的进程（-9 强制终止）
    pkill -9 -f "llama-server.*--port ${port}"

    # 等待进程完全终止（最多等待10秒）
    for _ in {1..10}; do
        if ! check_process_exists $port; then
            break
        fi
        sleep 1
    done

    # 检查是否终止成功
    if check_process_exists $port; then
        echo "错误：无法终止端口 ${port} 的进程，请手动检查！"
        exit 1
    fi
    echo "端口 ${port} 进程终止完成"
}

# 定义服务启动函数
start_llama_server() {
    local model_path=$1
    local port=$2
    local log_file=$3
    local cmd="/home/models/bin/llama-server -m ${model_path} -c 8192 -ub 1024 --no-warmup --host 0.0.0.0 --port ${port}"

    # 检查进程是否存在
    if check_process_exists $port; then
        kill_process_by_port $port
    fi

    # 后台启动并记录日志
    echo "启动端口 ${port} 的 llama-server..."
    nohup ${cmd} > ${log_file} 2>&1 &

    # 验证启动是否成功
    sleep 2  # 等待进程启动
    if check_process_exists $port; then
        echo "端口 ${port} 的 llama-server 启动成功，日志文件：${log_file}"
    else
        echo "错误：端口 ${port} 的 llama-server 启动失败！"
        exit 1
    fi
}

echo "===== 开始执行开机启动脚本 ====="
# 启动重排序服务（8083端口）
start_llama_server "${RERANK_MODEL_PATH}" ${RERANK_PORT} "${RERANK_LOG}"
# 启动嵌入服务（8084端口）
start_llama_server "${EMBED_MODEL_PATH}" ${EMBED_PORT} "${EMBED_LOG}"
echo "===== 所有服务启动完成 ====="