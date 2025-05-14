from collections.abc import Generator
from typing import Any
import logging
from dify_plugin import Tool
from dify_plugin.entities.tool import ToolInvokeMessage
from obs import ObsClient
from tools.base import HuaweiCloudObsTool

class HuaweiCloudObsCreateBucketTool(Tool):
        
    def _invoke(self, tool_parameters: dict[str, Any]) -> Generator[ToolInvokeMessage]:
        bucket_name = tool_parameters.get("bucket_name")
        obs_tool = HuaweiCloudObsTool(self.runtime.credentials)
        if not obs_tool.head_bucket(bucket_name):
            obs_tool.create_bucket(bucket_name)
        yield self.create_text_message("ok")
