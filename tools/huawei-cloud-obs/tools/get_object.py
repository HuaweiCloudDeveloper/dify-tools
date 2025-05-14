from collections.abc import Generator
from typing import Any
from dify_plugin import Tool
from dify_plugin.entities.tool import ToolInvokeMessage
from tools.base import HuaweiCloudObsTool

class HuaweiCloudObsGetObjectTool(Tool):

    def _invoke(self, tool_parameters: dict[str, Any]) -> Generator[ToolInvokeMessage]:
        obs_tool = HuaweiCloudObsTool(self.runtime.credentials)
        bucket_name = tool_parameters.get("bucket_name")
        object_key:str = tool_parameters.get("object_key")
        download_Path = f'/tmp/{object_key}'
        object_path = obs_tool.get_object(bucket_name,object_key,download_Path)
        yield self.create_text_message(object_path)
