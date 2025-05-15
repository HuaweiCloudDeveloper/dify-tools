from typing import Any
import logging
from dify_plugin import ToolProvider
from dify_plugin.errors.tool import ToolProviderCredentialValidationError
from obs import ObsClient

logger = logging.getLogger(__name__)

class HuaweiCloudObsProvider(ToolProvider):
    def _validate_credentials(self, credentials: dict[str, Any]) -> None:
        try:
            """
            IMPLEMENT YOUR VALIDATION HERE
            """
            if "access_key_id" not in credentials or not credentials.get("access_key_id"):
                raise ToolProviderCredentialValidationError("HuaweiCloud OBS AccessKeyID is required.")
            ak = credentials.get("access_key_id")
            if "secret_access_key" not in credentials or not credentials.get("secret_access_key"):
                raise ToolProviderCredentialValidationError("HuaweiCloud OBS SecretAccessKey is required.")
            sk = credentials.get("secret_access_key")
            if "server_url" not in credentials or not credentials.get("server_url"):
                raise ToolProviderCredentialValidationError("HuaweiCloud OBS ServerUrl is required.")
            server = credentials.get("server_url")
            obsClient = ObsClient(access_key_id=ak, secret_access_key=sk, server=server)
            obsClient.close()
        except Exception as e:
            raise ToolProviderCredentialValidationError(str(e))
