from fastapi import FastAPI, Request, HTTPException,Depends
from fastapi.responses import StreamingResponse
from fastapi.concurrency import asynccontextmanager
import aiohttp
import json
import logging
from chat_models import MetaReq,MetaRespChunk
from redis_client import RedisClient
from chat_config import Config
from chat_verify import chat_verify

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@asynccontextmanager
async def lifespan(app:FastAPI):
    """生命周期"""
    app.state.redis_client = RedisClient(Config.REDIS_HOST, Config.REDIS_PORT, Config.REDIS_PASSWORD)
    logger.info("应用初始化成功")
    yield
    app.state.redis_client.close()
    logger.info("应用正常停止")

app = FastAPI(
    title="meta studio mediator",
    root_path="/digital-human",
    lifespan=lifespan
)

async def to_streaming(meta_req: MetaReq):
    """将dify流式响应转换成meta流式响应"""
    conversation_id = app.state.redis_client.get_conversation_id(meta_req.app_id,meta_req.user,meta_req.session_id)
    dify_req = {
        "inputs": {},
        "query": meta_req.messages[-1].content,
        "response_mode": "streaming",
        "user": meta_req.user,
        "conversation_id": conversation_id
    }
    async with aiohttp.ClientSession() as session:
        async with session.post(
            url=f"http://{Config.Dify_HOST}/v1/chat-messages",
            headers={
                "Authorization": f"Bearer {Config.Dify_API_KEY}",
                "Content-Type": "application/json"
            },
            json=dify_req
        ) as resp:
            if resp.status != 200:
                raise HTTPException(
                    status_code=resp.status,
                    detail=resp.reason
                )

            async for line in resp.content.iter_any():
                if not line.startswith(b"data: "):
                    continue
                data_str = line[6:].decode().strip()
                if not data_str:
                    continue
                try:
                    data = json.loads(data_str)
                except json.JSONDecodeError:
                    continue
                event = data.get("event")
                if event == "message":
                    chunk = MetaRespChunk(
                        id=data.get("message_id", ""),
                        created=data.get("created_at", 0),
                        choices=[{"message": {"content": data.get("answer", "")}}]
                    )
                    yield f"data: {chunk.model_dump_json()}\n\n".encode()
                elif event == "message_end":
                    yield "data: [DONE]\n\n"
                    new_cid = data.get("conversation_id")
                    if new_cid:
                        app.state.redis_client.set_conversation_id(meta_req.app_id,meta_req.user,meta_req.session_id,new_cid)
                    break

async def to_blocking(meta_req: MetaReq):
    """请求dify(非流式输出)"""
    conversation_id = app.state.redis_client.get_conversation_id(meta_req.app_id,meta_req.user,meta_req.session_id)
    dify_req = {
        "inputs": {},
        "query": meta_req.messages[-1].content,
        "response_mode": "blocking",
        "user": meta_req.user,
        "conversation_id": conversation_id
    }
    async with aiohttp.ClientSession() as session:
        async with session.post(
            url=f"http://{Config.Dify_HOST}/v1/chat-messages",
            headers={
                "Authorization": f"Bearer {Config.Dify_API_KEY}",
                "Content-Type": "application/json"
            },
            json=dify_req
        ) as resp:
            if resp.status != 200:
                raise HTTPException(
                    status_code=resp.status,
                    detail=resp.reason
                )
            data = await resp.json()
            new_cid = data.get("conversation_id")
            if new_cid:
                app.state.redis_client.set_conversation_id(meta_req.app_id,meta_req.user,meta_req.session_id,new_cid)
            return  {
                "id": data.get("message_id", ""),
                "created": data.get("created_at", 0),
                "choices": [
                    {
                        "index": 0,
                        "message": {"content": data.get("answer", "")}
                    }
                ]
            }

@app.post("/chat",dependencies=[Depends(chat_verify)])
async def chat(meta_req: MetaReq,request: Request):
    """处理MetaStudio系统请求"""
    try:
        # 流式输出
        if meta_req.is_stream:
            return StreamingResponse(
                content=to_streaming(meta_req),
                media_type="text/event-stream",
                headers={
                    "Cache-Control": "no-cache",
                    "Connection": "keep-alive"
                }
            )
        # 非流式输出
        return await to_blocking(meta_req)
    except Exception as e:
        logger.error(f"处理请求失败：{str(e)}")
        raise HTTPException(
            status_code=500,
            detail={
                "error_code": "INTERNAL_ERROR",
                "error_msg": str(e)
            }
        )

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app=app,host="0.0.0.0",port=8000)