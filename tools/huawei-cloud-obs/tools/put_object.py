from collections.abc import Generator
from typing import Any
import os,logging,time,uuid
from dify_plugin import Tool
from dify_plugin.entities.tool import ToolInvokeMessage,ToolRuntime
from dify_plugin.core.runtime import Session
from dify_plugin.file.file import File, FileType
from obs import ObsClient
from tools.base import HuaweiCloudObsTool
import requests

logger = logging.getLogger(__name__)

class HuaweiCloudObsPutObjectTool(Tool):

    def _invoke(self, tool_parameters: dict[str, Any]) -> Generator[ToolInvokeMessage]:
        obs_tool = HuaweiCloudObsTool(self.runtime.credentials)
        bucket_name = tool_parameters.get("bucket_name")
        file:File | None = tool_parameters.get("file")
        file_url:str = tool_parameters.get("file_url")
        object_key:str = tool_parameters.get("object_key","")
        if not file and not file_url:
            raise ValueError("file and file_url cannot be both empty")
        file_extension = ""
        if not file_url:
            # 本地文件上传
            file_url = file.url
            file_extension = file.extension
        else:
            # 远程文件地址
            filename = os.path.basename(file_url)
            _, file_extension = os.path.splitext(filename)

        if not file_url.startswith("http"):
            file_url = self.runtime.credentials["dify_endpoint"] + file.url

        response = requests.get(file_url, stream=True, verify=False)
        response.raw.decode_content = True
        response.raise_for_status() 
        # 生成object_key
        if not object_key:
            object_key = time.strftime("%Y%m%d%H%M%S") + "-" + str(uuid.uuid4()) + file_extension        
        object_url = obs_tool.put_content(bucket_name,object_key,response.raw)
        yield self.create_json_message({"object_url":object_url,"object_key":object_key})