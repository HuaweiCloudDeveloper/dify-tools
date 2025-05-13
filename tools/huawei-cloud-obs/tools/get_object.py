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
        obj_client:ObsClient = HuaweiCloudObsTool.crete_obs_client(self.runtime.credentials)
        bucket_name = tool_parameters.get("bucket_name")
        object_key:str = tool_parameters.get("object_key")
        object_bytes = HuaweiCloudObsTool.get_object_bytes(obj_client, bucket_name,object_key)
        yield self.create_blob_message(object_bytes,meta={"mime_type": "application/octet-stream",},)
