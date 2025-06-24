# 构建指南

### 构建环境
 
#### 模型服务器
- CPU：16C 鲲鹏920 内存：32G 硬盘：40G
- 操作系统：HCE2.0
- Embedding模型：bge-m3
- Reranker模型：bge-reranker-v2-m3
- 推理框架：llama.cpp

#### Dify服务器
- CPU：8C 鲲鹏920 内存：16G 硬盘：40G
- 操作系统：HCE2.0
- Dify版本：1.4.2


### 构建模型服务

1. 下载模型

这里从modelscope下载,下载前需要安装``modelscope``

```shell
pip config set global.index-url https://repo.huaweicloud.com/repository/pypi/simple
mkdir /home/models
cd /home/models
pip install modelscope

modelscope download --model gpustack/bge-m3-GGUF bge-m3-Q8_0.gguf --local_dir ./bge-m3-GGUF
modelscope download --model gpustack/bge-reranker-v2-m3-GGUF bge-reranker-v2-m3-Q8_0.gguf --local_dir ./bge-reranker-v2-m3-GGUF
```

2. 编译llama.cpp

这里选择从源码编译，能更好的适配当前的环境

```shell
dnf install -y cmake libcurl-devel
git clone https://github.com/ggml-org/llama.cpp.git
cd llama.cpp
cmake -B build
cmake --build build --config Release -j 8
```
经过上面的编译，在``llama.cpp/build/bin``下就是编译好的文件。这里选择``llama-server``制作成镜像，用于部署embedding和rerank模型。

3. 构建llama.cpp Docker 镜像

```shell
cd llama.cpp/build
mkdir docker
cd docker
cp ../build/bin/*.so ./lib
cp ../build/bin/llama-server .
```
在``docker``目录下创建``Dockerfile``,内容如下：

```yaml
FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y libgomp1 curl \
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /tmp/* /var/tmp/* \
    && find /var/cache/apt/archives /var/lib/apt/lists -not -name lock -type f -delete \
    && find /var/cache -type f -delete

COPY lib/ /app
COPY llama-server /app

ENV LLAMA_ARG_HOST=0.0.0.0

WORKDIR /app

ENTRYPOINT ["/app/llama-server"]

```

构建命令：``docker build -t llama.cpp-arm64:server .``

4. 创建docker_compose文件

同时启动rerank和embedding模型，选择docker compose方式最方便，在``/home/models``下创建``docker_compose.yaml``,内容如下:

```yaml
services:
  llamacpp-embedding-server:
    image: llama.cpp-arm64:server
    container_name: llamacpp-embedding-server
    command: --embedding --pooling mean
    restart: always
    ports:
      - 8081:8080
    volumes:
      - /home/models/bge-m3-GGUF:/models
    environment:
      LLAMA_ARG_MODEL: /models/bge-m3-Q8_0.gguf
      LLAMA_ARG_CTX_SIZE: 65536
      LLAMA_ARG_N_PARALLEL: 8
      LLAMA_ARG_PORT: 8080
      LLAMA_ARG_UBATCH: 8192
      LLAMA_ARG_UBATCH: 8192
      LLAMA_ARG_N_GPU_LAYERS_DRAFT: 0

  llamacpp-rerank-server:
    image: llama.cpp-arm64:server
    container_name: llamacpp-rerank-server
    command: --reranking --pooling rank
    restart: always
    ports:
      - 8082:8080
    volumes:
      - /home/models/bge-reranker-v2-m3-GGUF:/models
    environment:
      LLAMA_ARG_MODEL: /models/bge-reranker-v2-m3-Q8_0.gguf
      LLAMA_ARG_CTX_SIZE: 65536
      LLAMA_ARG_N_PARALLEL: 8
      LLAMA_ARG_PORT: 8080
      LLAMA_ARG_BATCH: 8192
      LLAMA_ARG_UBATCH: 8192
      LLAMA_ARG_FLASH_ATTN: enable
      LLAMA_ARG_N_GPU_LAYERS_DRAFT: 0
```

### 构建Dify服务

```shell
git clone https://github.com/langgenius/dify.git
cd dify/docker
cp .env.example .env
```

修改``.env``中的``VECTOR_STORE:opensearch``

### 构建SearxNG服务

首先在``/home``下创建``searxng``目录，在该目录下创建``settings.yml``，内容如下：

```shell
search:
  safe_search: 1
  max_results: 50
  results_per_page: 20   # 默认每页结果数（API 的 count 可覆盖）
  request_timeout: 4
  max_page: 2            # 允许的最大页码（API 的 pageno 不可超过此值）
  time_range:
    - month
  formats:
    - html
    - json

server:
  limiter: false
  secret_key: "772ba36386fb56d0f8fe818941552dabbe69220d4c0eb4a385a5729cdbc20c2d" 

# 请求指纹核心配置块
request_fingerprint:
  enabled: true               # 总开关
  tls:
    version: "TLSv1.3"        # 强制协议版本
    cipher_suite: "RANDOM"    # 随机选择密码套件
    extensions: ["GREASE"]     # 启用 GREASE 扩展混淆
  http:
    header_rotation: true      # 随机化 HTTP 头顺序
    user_agents:               # User-Agent 池
      # Windows 桌面端
      - "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.58 Safari/537.36 Edg/123.0.2420.81"
      - "Mozilla/5.0 (Windows NT 11.0; WOW64; Trident/7.0; rv:11.0) like Gecko"  # IE 兼容模式
      - "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0"

      # macOS 桌面端
      - "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15"
      - "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.105 Safari/537.36"

      # Linux 桌面端
      - "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.105 Safari/537.36"
      - "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:120.0) Gecko/20100101 Firefox/120.0"

      # iOS 移动端
      - "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1"
      - "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/123.0.6312.52 Mobile/15E148 Safari/604.1"  # iOS Chrome

      # Android 移动端
      - "Mozilla/5.0 (Linux; Android 14; SM-G998B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.105 Mobile Safari/537.36"
      - "Mozilla/5.0 (Linux; Android 14; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.105 Mobile Safari/537.36"

      # 特殊设备
      - "Mozilla/5.0 (Nintendo Switch; WebApplet) AppleWebKit/609.4 (KHTML, like Gecko) NF/6.0.3.2 NintendoBrowser/5.1.0.24436"  # Switch 浏览器
      - "Mozilla/5.0 (Web0S; Linux/SmartTV) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.89 Safari/537.36 WebAppManager"  # LG WebOS 电视

    accept_language:           # 语言头随机化规则
      base: "en-US,en;q=0.9"
      variance: 3              # 允许最多3个附加区域变体
  behavior:
    mouse_jitter: 0.2          # 光标移动抖动率（0-1）
    request_delay:             # 请求间隔动态分布
      min: 1.5                 # 最小延迟（秒）
      max: 4.0                 # 最大延迟（秒）
      distribution: "normal"   # 延迟分布模型（normal/exponential）
  dynamic_generation:
    enabled: true
    model: "lstm"                  # 使用 LSTM 网络生成特征
    update_interval: 3600          # 每小时更新指纹库
    blacklist_threshold: 0.85      # 当特征匹配黑名单概率>85%时自动重置
  caching:
    enabled: true
    max_size: 1000         # 最大缓存指纹数
    ttl: 86400             # 缓存有效期（秒）
    whitelist_strategy: "lru"
hardware_fingerprint:
  webgl:
    precision: "highp"             # 渲染精度设置
    hash_algorithm: "sha256"        # 指纹哈希算法
  audio_context: true               # 启用音频上下文指纹
performance:
  pregenerate_pool: 20      # 保持 20 个就绪指纹待用
  generation_threads: 4     # 使用 4 个后台生成线程

engines:
  - name: baidu
    engine: baidu
    categories: general
    shortcut: bd
    enabled: true
    weight: 1
    
  - name: sogou
    engine: sogou
    shortcut: sg
    enabled: true
    weight: 0.3

  - name: 360search
    engine: 360search
    shortcut: s360
    enabled: true
    weight: 0.5

  - name: presearch
    engine: presearch
    search_type: search
    categories: [general, web]
    shortcut: ps
    timeout: 4.0
    enabled: false
    weight: 0.5

  - name: bing
    engine: bing
    shortcut: bi
    enabled: true
    weight: 0.3

doi_resolvers:
  oadoi.org: 'https://oadoi.org/'

default_doi_resolver: 'oadoi.org'
```

### 创建延迟服务

将脚本``auto_config_1.4.2.sh`` 复制到 ``/home/dify``目录下,并执行``chmod +x auto_config.sh``

创建``/etc/systemd/system/run_auto_config.service``，内容如下：
```shell
[Unit]
Description=Run /home/dify/auto_config.sh after boot

[Service]
Type=oneshot
ExecStart=/home/dify/auto_config.sh
```

创建``/etc/systemd/system/run_auto_config.timer``，内容如下：
```shell
[Unit]
Description=Timer to trigger run_auto_config.service 300s after boot

[Timer]
OnBootSec=300s
Persistent=true

[Install]
WantedBy=timers.target
```