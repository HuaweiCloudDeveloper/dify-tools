from fastapi import Request,HTTPException,status
import hmac
import hashlib
from chat_config import Config

async def chat_verify(request: Request):
    full_uri = f"{request.base_url}chat"

    query_params = dict(request.query_params)
    received_secret = query_params.get("secret")
    received_time_stamp = query_params.get("time_stamp")
    if not received_secret or not received_time_stamp:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing signature parameters (secret/time_stamp)"
        )
    input_str = f"{full_uri}{int(received_time_stamp, 16)}"
    app_key = Config.Dify_API_KEY
    expected_secret = hmac.new(
        key=app_key.encode("utf-8"),
        msg=input_str.encode("utf-8"),
        digestmod=hashlib.sha256
    ).hexdigest()

    if not hmac.compare_digest(expected_secret.lower(), received_secret.lower()):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid signature"
        )