### 简介

一款用 Rust 编写的极快的 Python包和项目管理工具。有如下特性：

- 一款能替代pip、pip - tools、pipx、poetry、pyenv、twine、virtualenv 等工具的单一工具。
- 比pip快10 - 100倍。
- 提供全面的项目管理，并配备通用uv.lock。
- 磁盘空间利用高效，并具备全局缓存以实现依赖项去重
- 无需借助Rust或Python，可通过curl或pip进行安装。

### 安装

这里以Huawei Cloud EulerOS 2.0操作系统为例，演示安装流程。该操作系统会默认安装Python3.9.9版本，uv官网推荐使用``curl -LsSf https://astral.sh/uv/install.sh | sh``，但在国内可能无法成功，所以推荐使用``pip``的方式。

```shell
# pip配置华为安装源
pip config set global.index-url https://repo.huaweicloud.com/repository/pypi/simple
# 安装uv
pip install uv
# 验证
uv version
```

#### uv python 换源

```shell
export UV_PYTHON_INSTALL_MIRROR="https://mirror.nju.edu.cn/github-release/indygreg/python-build-standalone/"
```

#### uv pip 换源

```shell
# 配置华为安装源
mkdir ~/.config/uv
vi ~/.config/uv/uv.toml
# 输入以下内容
index-url="https://repo.huaweicloud.com/repository/pypi/simple"
cache-dir="/mnt/uv/cache"
```

#### 常用操作
```shell
# 创建虚拟环境（在项目目录下）
uv venv
# 安装 python 版本
uv python install 3.12
# 切换python环境
uv venv --python 3.10
# 运行脚本
uv run example.py
# 安装依赖
uv pip install requirements.txt
# 创建一个新的Python项目
uv init hello-world

```