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
        obj_client:ObsClient = HuaweiCloudObsTool.crete_obs_client(self.runtime.credentials)
        if not HuaweiCloudObsTool.head_bucket(obj_client,bucket_name):
            HuaweiCloudObsTool.create_bucket(obj_client,bucket_name)
        yield self.create_text_message("success")
