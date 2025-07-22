import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    REDIS_HOST = os.getenv("REDIS_HOST", os.getenv("Dify_HOST"))
    REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
    REDIS_PASSWORD = os.getenv("REDIS_PASSWORD", "difyai123456") 
    CACHE_TTL = 3600  # 缓存有效期（秒）
    Dify_HOST = os.getenv("Dify_HOST", "192.168.0.160")
    Dify_API_KEY = os.getenv("Dify_API_KEY", "app-U4yvhJ43m05GeWyP6xziRaIe")