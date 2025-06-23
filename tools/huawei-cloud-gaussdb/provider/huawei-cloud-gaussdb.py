from typing import Any

from dify_plugin import ToolProvider
from dify_plugin.errors.tool import ToolProviderCredentialValidationError
import psycopg2

class HuaweiCloudGaussdbProvider(ToolProvider):
    def _validate_credentials(self, credentials: dict[str, Any]) -> None:
        try:
            """
            IMPLEMENT YOUR VALIDATION HERE
            """
            if "ENDPOINT" not in credentials or not credentials.get("ENDPOINT"):
                raise ToolProviderCredentialValidationError("HuaweiCloud GaussDB ENDPOINT is required.")
            endpoint:str = credentials.get("ENDPOINT")
            host = endpoint.split(':')[0]
            port = endpoint.split(':')[1]
            if "USER_NAME" not in credentials or not credentials.get("USER_NAME"):
                raise ToolProviderCredentialValidationError("HuaweiCloud GaussDB USER_NAME is required.")
            user_name = credentials.get("USER_NAME")
            if "PASSWORD" not in credentials or not credentials.get("PASSWORD"):
                raise ToolProviderCredentialValidationError("HuaweiCloud GaussDB PASSWORD is required.")
            password = credentials.get("PASSWORD")
            if "DATABASE" not in credentials or not credentials.get("DATABASE"):
                raise ToolProviderCredentialValidationError("HuaweiCloud GaussDB DATABASE is required.")
            db = credentials.get("DATABASE")
            
            conn = psycopg2.connect(database=db, user=user_name, password=password, host=host, port=port)
            cur=conn.cursor() 
            cur.execute("select now()")
            cur.close()
            conn.close()
        except Exception as e:
            raise ToolProviderCredentialValidationError(str(e))       
