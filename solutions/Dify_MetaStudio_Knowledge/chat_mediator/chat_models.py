from pydantic import BaseModel
from typing import List, Optional

class MetaMsg(BaseModel):
    content: str

class MetaReq(BaseModel):
    messages: List[MetaMsg]
    app_id: str
    user: str
    session_id: str
    is_stream: bool = True
    extend_param: Optional[dict] = None


class MetaRespChunk(BaseModel):
    id: str
    created: int
    choices: List[dict]  # 格式: [{"message": {"content": str}}]


class MetaRespEnd(BaseModel):
    data: str = "[DONE]"
