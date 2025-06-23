## huawei-cloud-gaussdb

**Author:** yuez
**Version:** 0.0.1
**Type:** tool

### Description

#### 安装步骤

1. 去 `https://support.huaweicloud.com/helppanel-gaussdb/gaussdb_help_01_0009.html`选择指定的版本下载
2. 根据dify服务器选择对应的包
    gaussdb服务：集中式
    服务器架构：ARM64
    操作系统：HCE2.0
    驱动语言：Python

    对应的包为：GaussDB_driver\Centralized\Hce2.0_arm_64\GaussDB-Kernel_505.2.1.SPC0300_Hce_64bit_Python.tar.gz

3. 将`GaussDB-Kernel_505.2.1.SPC0300_Hce_64bit_Python.tar.gz` 上传到dify服务器，如`/opt`目录，解压，得到`lib`和`psycopg2`

4. 将`lib`移动到 dify安装目录下 `docker/volumes`下面，重命名为 `psycopg2_libs`

5. 在 `docker/docker-compose.yml` 中进行配置

    - 在 plugin_daemon 下，添加一个变量
    ```
    environment:
        ......
        LD_LIBRARY_PATH: "/root/psycopg2_libs:$LD_LIBRARY_PATH"
    volumes:
        - ./volumes/psycopg2_libs:/root/psycopg2_libs
    ```
6. 重启 plugin_daemon
```shell
docker stop docker-plugin_daemon-1
docker compose up -d plugin_daemon
```