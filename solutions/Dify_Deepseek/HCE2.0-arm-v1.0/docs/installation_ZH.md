# DeepSeek_Dify部署指南

## 安装 Dify
### 安装 docker & docker compose
```shell
dnf remove docker docker-ce-cli docker-selinux docker-engine

wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
sed -i 's+download.docker.com+mirrors.huaweicloud.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
sed -i 's+$releasever+9.9+' /etc/yum.repos.d/docker-ce.repo

dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker
```

### 配置Dockers加速器
```shell
# 用户需要查找可用的Docker加速器进行配置
cat > /etc/docker/daemon.json << 'EOF'
{
    "registry-mirrors": [ "https://XXXXXXXXXXXX.mirror.swr.myhuaweicloud.com" ]
}
EOF
systemctl restart docker
``` 


### 下载 dify 源码
```shell
cd ${HOME}
git clone https://github.com/langgenius/dify.git --branch 1.4.1 dify

cd dify/docker
cp .env.example .env
docker compose up -d
```

## 安装 Deepseek
```shell
### 安装 ollama
curl -fsSL https://ollama.com/install.sh | sh

### 下载 deepseek
ollama pull deepseek-r1:7b-qwen-distill-q8_0
```
