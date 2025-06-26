import aiohttp
import asyncio
import json
from redis_client import RedisClient
from aiohttp import StreamReader
from chat_models import MetaRespChunk

async def dify_to_meta(content: StreamReader):
    async for line in content.iter_any():
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
            yield b"data: [DONE]\n\n"

async def test1():
    dify_req = {
        "inputs": {},
        "query": "大豆油的营养成分有哪些？",
        "response_mode": "streaming",
        "user": "abc-123",
        "conversation_id": ""
    }
    
    async with aiohttp.ClientSession() as session:
        async with session.post(
            "http://192.168.0.160/v1/chat-messages",
            headers={
                "Authorization": "Bearer app-U4yvhJ43m05GeWyP6xziRaIe",
                "Content-Type": "application/json"
            },
            json=dify_req
        ) as resp:            
            content = dify_to_meta(resp)
            print(content)

          
async def test2():
    redis_client = RedisClient("192.168.0.160",6379,"difyai123456")     
    # redis_client.set_conversation_id('app-123', 'user-456',"session-789","123456789")
    value = redis_client.get_conversation_id('app-1234', 'user-456',"session-789")
    print(value)   

async def test3():
    req = {
        "messages": [{
            "content": "大豆油的营养成分有哪些？"
        }],
        "app_id": "app-1111",
        "user": "user-2222",
        "session_id": "session-3333",
        "is_stream": True,
        "extend_param": {}
    }

    async with aiohttp.ClientSession() as session:
        async with session.post(
            "http://192.168.0.160:8000/digital-human/chat",
            headers={
                "Content-Type": "application/json"
            },
            json=req
        ) as resp:       
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
                print(data)


async def test4():
    req = {
        "messages": [{
            "content": "大豆油的营养成分有哪些？"
        }],
        "app_id": "app-1111",
        "user": "user-2222",
        "session_id": "session-3333",
        "is_stream": False,
        "extend_param": {}
    }

    async with aiohttp.ClientSession() as session:
        async with session.post(
            "http://192.168.0.160:8000/digital-human/chat",
            headers={
                "Content-Type": "application/json"
            },
            json=req
        ) as resp:       
            print(await resp.json())


if __name__ == "__main__":
    asyncio.run(test4())