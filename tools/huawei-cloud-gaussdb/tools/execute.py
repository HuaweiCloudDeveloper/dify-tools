from collections.abc import Generator
from typing import Any

from dify_plugin import Tool
from dify_plugin.entities.tool import ToolInvokeMessage
from tools.base import HuaweiCloudGaussdbTool


class Execute(Tool):
    def _invoke(self, tool_parameters: dict[str, Any]) -> Generator[ToolInvokeMessage]:
        sql_client = HuaweiCloudGaussdbTool(self.runtime.credentials)

        sql:str = tool_parameters.get("sql")
        value = tool_parameters.get("value")
        res = sql_client.execute(sql,value)
        yield self.create_text_message(res)
