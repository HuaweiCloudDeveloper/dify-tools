# 				Dify-Tools

[English](./README_en.md)

## 仓库简介

本仓库提供了Dify中连接华为云商店产品的一些插件的源码以及一些相关的Workflow和Demo，供Dify用户和华为云用户参考借鉴。

## 前置条件

- [华为云账号](https://www.huaweicloud.com/)
- [Dify环境](https://marketplace.huaweicloud.com/)（可以通过华为云商店一键部署社区版）
- 基本的Linux环境使用经验
- [开发环境搭建](environment/development_environment_install.md)，可选，如果你有在鲲鹏服务器开发需求的话可安装

## 技术资源
<table style="width: 100%; table-layout: fixed">
  <tr>
    <th >类型</th>
    <th >名称</th>
    <th >描述</th>
    <th >作者</th>  
  </tr>
   <tr>
    <td rowspan="1">MCP Server</td>
    <td ><a href="https://github.com/HuaweiCloudDeveloper/mcp-server">华为云MCP工具</a></td>
    <td>支持全量华为云API的MCP工具集</td>
    <td><a href="https://github.com/zero295813128">zero295813128</a></td>
  </tr>
   <tr>
    <td rowspan="3">工作流</td>
    <td ><a href="workflow/obs_example/huawei_cloud_obs_upload_example.yml">华为云OBS上传</a></td>
    <td>提供华为云OBS上传的示例,前提:对象桶已创建</td>
    <td><a href="https://github.com/szlele">yuez</a></td>
  </tr>
  <tr>
    <td ><a href="workflow/obs_example/huawei_cloud_obs_download_example.yml">华为云OBS下载</a></td>
    <td>提供华为云OBS下载的示例,前提:对象桶已创建且ACL公共可读</td>
    <td><a href="https://github.com/szlele">yuez</a></td>
  </tr>
  <tr>
    <td ><a href="workflow/pdf2zh/pdf_document_translator.yml">PDF科研文献翻译助手</a></td>
    <td>在dify创建工作流使用PDFMathTranslate </td>
    <td><a href="https://github.com/szlele">yuez</a></td>
  </tr>
   <tr>
    <td rowspan="1">扩展工具</td>
    <td ><a href="tools/huawei-cloud-obs/README.md">Huawei-Cloud-OBS</a></td>
    <td>提供dify工作流中操作华为云OBS的基本操作工具</td>
    <td><a href="https://github.com/szlele">yuez</a></td>
  </tr>
  <tr>
    <td ><a href="tools/huawei-cloud-gaussdb/README.md">Huawei-Cloud-GaussDB</a></td>
    <td>提供dify工作流中操作华为云GaussDB的基本操作工具</td>
    <td><a href="https://github.com/szlele">yuez</a></td>
  </tr>
  <tr>
    <td rowspan="2">解决方案</td>
    <td ><a href="solutions/Dify_MetaStudio_Knowledge/README.md">数字人交互智能问答解决方案</a></td>
    <td>该解决方案基于华为云数字内容生产线 MetaStudio，ModelArts Studio大模型即服务平台和Dify快速部署数字人交互服务</td>
    <td><a href="https://github.com/szlele">yuez</a></td>
  </tr>
   <tr>
    <td ><a href="solutions/Dify_Deepseek/README.md">Dify DeepSeek单机版部署</a></td>
    <td>在华为云上通过零元镜像快速部署单机版本Dify社区版本与DeepSeek的推理服务，构建个人LLM应用开发平台</td>
    <td><a href="https://github.com/wdtzliu">wdtzliu</a></td>
  </tr>
  <tr>
    <td rowspan="1">模型供应商</td>
    <td ><a href="models/maas_deepseek/README.md">MaaS_deepseek</a></td>
    <td>华为云MaaS DeepSeek LLM模型提供商</td>
    <td><a href="https://github.com/szlele">yuez</a></td>
  </tr>
</table>

## 使用须知

#### 寻求帮助

- 在仓库Issue页面提出问题
- 华为云云商店指定商品的服务支持

#### 贡献方式

- Fork本仓库，发Merge Request
- 修改README.md，在表格中添加你的内容
