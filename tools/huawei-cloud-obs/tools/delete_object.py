from collections.abc import Generator
from typing import Any
import logging
from dify_plugin import Tool
from dify_plugin.entities.tool import ToolInvokeMessage
from obs import ObsClient
from tools.base import HuaweiCloudObsTool

logger = logging.getLogger(__name__)

class HuaweiCloudObsDeleteObjectTool(Tool):

    def _invoke(self, tool_parameters: dict[str, Any]) -> Generator[ToolInvokeMessage]:
        obs_tool = HuaweiCloudObsTool(self.runtime.credentials)
        bucket_name = tool_parameters.get("bucket_name")
        object_key:str = tool_parameters.get("object_key")
        obs_tool.delete_object(bucket_name,object_key)
        yield self.create_text_message("ok")
