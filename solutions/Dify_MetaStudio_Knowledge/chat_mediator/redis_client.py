from typing import Optional
import redis

class RedisClient:

    def __init__(self,host,port,password):
        self.redis = redis.StrictRedis(
            host=host, 
            port=port,
            password=password, 
            ssl=False,
            decode_responses=True
        )
    
    def set_conversation_id(self, app_id: str, user: str, session_id: str, conversation_id: str):
        cache_key = f"{app_id}:{user}:{session_id}"
        self.redis.set(cache_key, conversation_id, ex=3600)

    def get_conversation_id(self, app_id: str, user: str, session_id: str) -> Optional[str]:
        cache_key = f"{app_id}:{user}:{session_id}"
        val = self.redis.get(cache_key)
        return val if val else ""
    
    def close(self):
        self.redis.close()