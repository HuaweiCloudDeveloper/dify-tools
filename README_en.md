# 				Dify-Tools

[简体中文](./README_zh.md)

## Warehouse Introduction
This repository provides the source code of some plug-ins connected to HUAWEI CLOUD Store products in Dify, workflows, and demos for reference by Dify and HUAWEI CLOUD users.

## Prerequisites
- [HUAWEI CLOUD Account] (https://www.huaweicloud.com/)
- [Dify environment] (https://marketplace.huaweicloud.com/) (You can deploy the community edition in one-click mode on HUAWEI CLOUD Store.)
- Basic Linux environment experience
- [Development Environment Setup] (environment/development_environment_install.md). Optional. Install it if you have development requirements on Kunpeng servers.

## Technical Resources
<table style="width: 100%; table-layout: fixed">
<tr>
<th>Type</th>
<th>Name</th>
<th>Description</th>
<th>Author</th>
</tr>
<tr>
<td rowspan="1">MCP Server</td>
<td ><a href="https://github.com/HuaweiCloudDeveloper/mcp-server"> HUAWEI CLOUD MCP Tool</a></td>
<td>MCP tool set that supports all HUAWEI CLOUD APIs</td>
<td><a href="https://github.com/zero295813128">zero295813128</a></td>
</tr>
<tr>
<td rowspan="3">Workflow</td>
<td ><a href="workflow/obs_example/huawei_cloud_obs_upload_example.yml"> Upload to OBS on HUAWEI CLOUD</a></td>
<td>Provide an example of uploading an object to OBS on HUAWEI CLOUD. The prerequisite is that an object bucket has been created.</td>
<td><a href="https://github.com/szlele">yuez</a></td>
</tr>
<tr>
<td ><a href="workflow/obs_example/huawei_cloud_obs_download_example.yml"> Download from OBS on HUAWEI CLOUD</a></td>
<td>Provide an example of downloading OBS on HUAWEI CLOUD. The prerequisite is that an object bucket has been created and the ACL is public and readable.</td>
<td><a href="https://github.com/szlele">yuez</a></td>
</tr>
<tr>
<td ><a href="workflow/pdf2zh/pdf_document_translator.yml">PDF Scientific Literature Translation Assistant</a></td>
<td>Create a workflow in dify using PDFMathTranslate </td>
<td><a href="https://github.com/szlele">yuez</a></td>
</tr>
<tr>
<td rowspan="2">Extension Tools</td>
<td ><a href="tools/huawei-cloud-obs/README.md"> OBS Tool</a></td>
<td>Provides basic tools for performing operations on HUAWEI CLOUD OBS in the dify workflow.</td>
<td><a href="https://github.com/szlele">yuez</a></td>
</tr>
<tr>
<td ><a href="tools/huawei-cloud-gaussdb/README.md"> GaussDB Tool</a></td>
<td>Provides basic tools for performing operations on HUAWEI CLOUD GaussDB in the dify workflow.</td>
<td><a href="https://github.com/szlele">yuez</a></td>
</tr>
<tr>
<td rowspan="2">Solution</td>
<td ><a href="solutions/Dify_MetaStudio_Knowledge/README.md"> Digital Human Interactive Intelligent Q&A Solution</a></td>
<td>The solution is based on MetaStudio, the HUAWEI CLOUD digital content production line, ModelArts Studio, and Dify to quickly deploy digital human interaction services.</td>
<td><a href="https://github.com/szlele">yuez</a></td>
</tr>
<tr>
<td ><a href="solutions/Dify_Deepseek/README.md">Dify DeepSeek standalone deployment</a></td>
<td>Quickly deploy the single-node Dify community version and DeepSeek inference service on HUAWEI CLOUD using a zero-meta image to build a personal LLM application development platform</td>
<td><a href="https://github.com/wdtzliu">wdtzliu</a></td>
</tr>
<tr>
<td rowspan="1">Model Supplier</td>
<td ><a href="models/maas_deepseek/README.md">MaaS_deepseek</a></td>
<td>HUAWEI CLOUD MaaS DeepSeek LLM Model Provider</td>
<td><a href="https://github.com/szlele">yuez</a></td>
</tr>
</table>

## Instructions

#### Ask for help

- Raise a question on the Warehouse Issue page
- Service support for specified products in HUAWEI CLOUD Store

#### Contribution Method

- Fork the warehouse and send a Merge Request.
- Modify README.md to add your content to the table
