官方默认安装的docker版本为``3.9.9``，如果需要升级较新的版本，可采用以下方式。

#### 下载miniconda安装脚本

```shell
mkdir -p ~/.miniconda
# 这里基础版本为3.12
wget https://repo.anaconda.com/miniconda/Miniconda3-py312_25.3.1-1-Linux-aarch64.sh -O ~/.miniconda/miniconda.sh
```

#### 安装miniconda

```shell
bash ~/.miniconda/miniconda.sh -b -u -p ~/.miniconda && rm -f ~/.miniconda/miniconda.sh
source ~/.miniconda/bin/activate
conda init --all
```

**默认初始化一个python3.10版本的base环境**

#### 使用miniconda

```shell
# 创建指定python版本环境
conda create -n py312 -y python=3.12 
# 查看已安装虚拟环境列表
conda env list
# 进入指定虚拟环境
conda activate base
# 删除虚拟环境
conda env remove -n py312
# 查找某个库所有版本
conda search numpy
```

#### 设置pip软件源

设置为华为的仓库地址，可加速下载安装

```shell
pip config set global.index-url https://repo.huaweicloud.com/repository/pypi/simple
pip config set global.trusted-host mirrors.huaweicloud.com
```



