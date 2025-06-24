# DeepSeek_Dify installation script

## install Dify
### install docker & docker compose
```shell
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove -y $pkg; done

apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### config docker mirror
```shell
# config available docker mirror
cat > /etc/docker/daemon.json << 'EOF'
{
    "registry-mirrors": [ "https://XXXXXXXXXXXX.mirror.swr.myhuaweicloud.com" ]
}
EOF
systemctl restart docker
``` 


### download dify
```shell
cd ${HOME}
git clone https://github.com/langgenius/dify.git --branch 1.4.1 dify

cd dify/docker
cp .env.example .env
docker compose up -d
```

## install deepseek

```shell
### install ollama， install path: /usr/local/bin/ollama
curl -fsSL https://ollama.com/install.sh | sh

#### pull deepseek
ollama pull deepseek-r1:7b-qwen-distill-q8_0
```