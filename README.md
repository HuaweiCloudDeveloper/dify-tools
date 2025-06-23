# 				Dify-Tools

## 仓库简介

本仓库提供了Dify中连接华为云商店产品的一些插件的源码以及一些相关的Workflow和Demo，供Dify用户和华为云用户参考借鉴。

## 前置条件

- [华为云账号](https://www.huaweicloud.com/)
- [Dify环境](https://marketplace.huaweicloud.com/)（可以通过华为云商店一键部署社区版）
- 基本的Linux环境使用经验
- [开发环境搭建](environment/development_environment_install.md)，可选，如果你有在鲲鹏服务器开发需求的话可安装

## 技术资源

#### 工作流示例

| 案例名称            | 描述                                                         | 链接 | 依赖                                                         | 作者 |
| ------------------- | ------------------------------------------------------------ | ---- | ------------------------------------------------------------ | :--: |
| 华为云OBS上传示例 | 提供华为云OBS上传的示例,前提:对象桶已创建 | [DSL](workflow/obs_example/huawei_cloud_obs_upload_example.yml)    | huawei-cloud-obs | yuez |
| 华为云OBS下载示例 | 提供华为云OBS下载的示例,前提:对象桶已创建且ACL公共可读 | [DSL](workflow/obs_example/huawei_cloud_obs_download_example.yml)    | huawei-cloud-obs | yuez |
| PDF科研文献翻译助手 | 在dify创建工作流使用PDFMathTranslate | [DSL](workflow/pdf2zh/pdf_document_translator.yml)     | [PDFMathTranslate](https://github.com/Byaidu/PDFMathTranslate) | yuez |


#### 扩展工具

| 工具名称                | 工具类型 | 描述                                             | 部署文档                           | 作者 |
| ----------------------- | -------- | ------------------------------------------------ | ---------------------------------- | ---- |
| 华为云对象存储(OBS)工具 | 工具     | 提供dify工作流中操作华为云对象存储的基本操作工具 | [插件源码](tools/huawei-cloud-obs) | yuez |




#### 模型提供商

| 模型名称           | 模型类型  | 描述                                   | 部署文档                              | 作者 |
| ------------------ | --------- | -------------------------------------- | ------------------------------------- | ---- |
| modelarts_deepseek | LLM       | 华为云ModelArts DeepSeek LLM模型提供商 | [插件源码](models/modelarts_deepseek) | yuez |

#### 解决方案

| 方案名称           | 描述                                   | 文档                              | 作者 |
| ------------------| -------------------------------------- | --------------------------------- | ---- |
| 数字人交互智能问答解决方案   | 该解决方案基于华为云MetaStudio，ModelArts Studio和Dify快速部署数字人交互服务，部署后用户只需简单配置几项关键参数即可直接使用数字人交互服务。 | [详情](solutions/Dify_MetaStudio_Knowledge/README.md) | yuez |


## 使用须知

#### 寻求帮助

- 在仓库Issue页面提出问题
- 华为云云商店指定商品的服务支持

#### 贡献方式

- Fork本仓库，发Merge Request
- 修改README.md，在表格中添加你的内容
