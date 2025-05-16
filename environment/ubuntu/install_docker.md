基于华为云镜像仓库，快速便捷安装Docker,下面是详细安装流程

#####  若安装过docker，需要先删掉

```shell
sudo apt-get remove docker docker-engine docker.io
```

##### 安装依赖

```shell
sudo apt-get update
sudo apt-get install -y install ca-certificates curl
```

##### 下载gpg密钥

```shell
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

##### 创建软件源文件

```shell
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.huaweicloud.com/docker-ce/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

##### 安装Docker服务

```shell
sudo apt-get update
sudo apt-get install -y docker-ce 
```

#### 启动并设置开启启动

```shell
sudo systemctl enable --now docker
```

#### 配置镜像加速器

```shell
vi /etc/docker/daemon.json
# 粘贴以下配置,保存退出
{
    "registry-mirrors": [ "https://7046a839d8b94ca190169bc6f8b55644.mirror.swr.myhuaweicloud.com"]
}
```

#### 重新启动

```shell
systemctl restart docker
```

#### 查看docker信息

```shell
docker info
```

可以看到docker版本和镜像加速器都已经生效。
