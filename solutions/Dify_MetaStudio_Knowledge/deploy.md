# 部署指南



### 启动Embedding&Rerank服务
进入``/home/models``

启动命令：``docker compose up -d``


### 启动SearxNG服务

```shell
docker run -d -p 8083:8080 \
    -v /home/searxng:/etc/searxng \
    -e "BASE_URL=http://0.0.0.0:8083" \
    -e "INSTANCE_NAME=dify-searxng"
    --restart always
    --name searxng-dify-server
    searxng/searxng
```


### 启动Dify服务

```shell
cd dify/docker
docker compose up -d
```

### 启动延迟服务

```shell
sudo systemctl enable run_auto_config.timer

systemctl daemon-reload

# 验证
journalctl -u run_auto_config.service -ef
```