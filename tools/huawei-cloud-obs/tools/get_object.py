from collections.abc import Generator
from typing import Any
from dify_plugin import Tool
from dify_plugin.entities.tool import ToolInvokeMessage
from tools.base import HuaweiCloudObsTool
from obs.model import ObjectStream
import time

class HuaweiCloudObsGetObjectTool(Tool):

    def _invoke(self, tool_parameters: dict[str, Any]) -> Generator[ToolInvokeMessage]:
        obs_tool = HuaweiCloudObsTool(self.runtime.credentials)
        bucket_name:str = tool_parameters.get("bucket_name")
        object_key:str = tool_parameters.get("object_key")
        # day_str = time.strftime("%Y%m%d")
        # download_Path = f'/tmp/{day_str}/{object_key}'
        # object_path = obs_tool.get_object(bucket_name,object_key,download_Path)
        # yield self.create_text_message(object_path)
        result:ObjectStream = obs_tool.get_object_bytes(bucket_name,object_key)
        yield self.create_blob_message(blob=result.buffer,meta={'mime_type': result.contentType})
