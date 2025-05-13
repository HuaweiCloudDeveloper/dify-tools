from collections.abc import Generator
from typing import Any
import os,logging,io
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
        obj_client:ObsClient = HuaweiCloudObsTool.crete_obs_client(self.runtime.credentials)
        bucket_name = tool_parameters.get("bucket_name")
        file:File | None = tool_parameters.get("file")
        file_url:str = tool_parameters.get("file_url")
        object_key:str = tool_parameters.get("object_key")
        if not file and not file_url:
            raise ValueError("file and file_url cannot be both empty")
        
        dify_url = os.getenv("DIFY_INNER_API_URL")
        object_url = ""
        if file_url:
            response = requests.get(file_url, stream=True, verify=False)
            response.raw.decode_content = True
            response.raise_for_status()
            object_url = HuaweiCloudObsTool.put_content(obj_client,bucket_name,object_key,response.raw)

        if file:
            # tmpFilePath = f"/dataset/{file.filename}"
            # with open(tmpFilePath, "wb") as f:
            #     f.write(file.blob)
            # os.remove(tmpFilePath)
            object_url = HuaweiCloudObsTool.put_content(obj_client,bucket_name,object_key,file.blob)
            
        if  object_url == "":
            raise ValueError("file object url is empty")

        print(f"Successfully put_object:{object_url}")
        yield self.create_text_message(str(object_url))
