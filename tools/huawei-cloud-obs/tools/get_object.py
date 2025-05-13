from collections.abc import Generator
from typing import Any
import logging
from dify_plugin import Tool
from dify_plugin.entities.tool import ToolInvokeMessage,ToolRuntime
from dify_plugin.core.runtime import Session
from dify_plugin.file.file import File, FileType
from obs import ObsClient
from tools.base import HuaweiCloudObsTool

logger = logging.getLogger(__name__)

class HuaweiCloudObsGetObjectTool(Tool):

    def _invoke(self, tool_parameters: dict[str, Any]) -> Generator[ToolInvokeMessage]:
        try:
            obj_client:ObsClient = HuaweiCloudObsTool.crete_obs_client(self.runtime.credentials)
            bucket_name = tool_parameters.get("bucket_name")
            object_key:str = tool_parameters.get("object_key")
            download_path:str = tool_parameters.get("download_path")
            object_url = HuaweiCloudObsTool.get_object(obj_client, bucket_name,object_key,download_path)
            logger.info(f"get_object object_url:{object_url}")
            yield self.create_text_message(object_url)
        except Exception as e:
            logger.error(f"Failed to get_object:{e}")
            yield self.create_text_message("Failed to get_object")
