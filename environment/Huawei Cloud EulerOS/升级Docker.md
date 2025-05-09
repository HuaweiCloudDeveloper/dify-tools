

官方默认安装的docker版本为``18.09.0``，如果需要升级较新的版本，可采用以下方式。

#### 如果之前安装过docker，要先卸载

```shell
sudo dnf remove docker docker-ce-cli docker-selinux docker-engine
```

#### 下载华为官方repo文件

```shell
wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo

# 替换
sudo sed -i 's+download.docker.com+mirrors.huaweicloud.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
sudo sed -i 's+$releasever+9.9+' /etc/yum.repos.d/docker-ce.repo
```

#### 安装1.28版本

```shell
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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