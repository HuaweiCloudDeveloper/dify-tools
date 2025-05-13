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
        try:
            obj_client:ObsClient = HuaweiCloudObsTool.crete_obs_client(self.runtime.credentials)
            bucket_name = tool_parameters.get("bucket_name")
            object_key:str = tool_parameters.get("object_key")
            HuaweiCloudObsTool.delete_object(obj_client, bucket_name,object_key)
            yield self.create_text_message("ok")
        except Exception as e:
            logger.error(f"Failed to delete_object:{e}")
            yield self.create_text_message("Failed to delete_object")
