
from typing import Any
from obs import ObsClient
from obs import CreateBucketHeader, HeadPermission
import logging

logger = logging.getLogger(__name__)

class HuaweiCloudObsTool:

    @staticmethod
    def crete_obs_client(credentials: dict[str, Any]) -> ObsClient:
        ak = credentials.get("access_key_id")
        sk = credentials.get("secret_access_key")
        server = credentials.get("server_url")
        return ObsClient(access_key_id=ak, secret_access_key=sk, server=server)
    
    @staticmethod
    def head_bucket(obs_client:ObsClient, bucket_name:str) -> bool:
        """检查桶是否存在"""
        resp = obs_client.headBucket(bucket_name)
        if resp.status < 300:
            print(f"Bucket {bucket_name} already exists")
            return True
        elif resp.status == 404:
            return False
        else:
            print(f"Failed to check bucket existence: {resp}")
            raise Exception("Failed to check bucket existence,errorMessage:{resp.errorMessage}")
    @staticmethod 
    def create_bucket(obs_client:ObsClient, bucket_name:str) -> bool:
        """创建桶"""
        location = obs_client.server.replace("obs.","").replace(".myhuaweicloud.com","")
        header = CreateBucketHeader(aclControl=HeadPermission.PRIVATE, storageClass="STANDARD", availableZone="3az")
        resp = obs_client.createBucket(bucket_name,header,location)
        if resp.status < 300:
            print(f"Bucket {bucket_name} created succeeded")
            return True
        else: 
            print(f"Failed to create bucket,resp:{resp}")
            raise Exception(f"Failed to create bucket:{bucket_name},errorMessage:{resp.errorMessage}")
        
    @staticmethod 
    def delete_bucket(obs_client:ObsClient, bucket_name:str) -> bool:
        """删除桶"""
        resp = obs_client.deleteBucket(bucket_name)
        if resp.status < 300:
            print(f"delete Bucket {bucket_name} created succeeded")
            return True
        else: 
            raise Exception(f"Failed to delete bucket:{bucket_name},errorMessage:{resp.errorMessage}")

    @staticmethod  
    def put_content(obs_client:ObsClient, bucket_name:str,object_key,content) -> str:
        """
        上传对象(文本或流)
        返回对象url
        """
        resp = obs_client.putContent(bucket_name,object_key,content)
        if resp.status < 300:
            print(f"Put Content object_key:{object_key} succeeded")
            return resp.body.objectUrl
        else: 
            raise Exception(f"Failed to Put Content object_key:{object_key},errorMessage:{resp.errorMessage}")

    @staticmethod 
    def put_file(obs_client:ObsClient, bucket_name:str,object_key,file_path) -> str:
        """
        上传对象(文件)
        返回对象url
        """
        resp = obs_client.putFile(bucket_name,object_key,file_path)
        if resp.status < 300:
            print(f"Put File object_key:{object_key} succeeded")
            return resp.body.objectUrl
        else: 
            raise Exception(f"Failed to Put File object_key:{object_key},errorMessage:{resp.errorMessage}")
        
    @staticmethod 
    def get_object(obs_client:ObsClient, bucket_name:str,object_key,download_Path) -> str:
        """下载对象(文件)"""
        resp = obs_client.getObject(bucket_name,object_key,download_Path)
        if resp.status < 300:
            print(f"Get Object object_key:{object_key},download_Path:{download_Path} succeeded")
            return resp.body.url
        else: 
            raise Exception(f"Failed to Get Object object_key:{object_key},errorMessage:{resp.errorMessage}")
        
    @staticmethod 
    def get_object_bytes(obs_client:ObsClient, bucket_name:str,object_key) -> bytes:
        """下载对象(二进制)"""
        resp = obs_client.getObject(bucket_name = bucket_name,object_key = object_key,loadStreamInMemory=True)
        if resp.status < 300:
            print(f"Get Object object_key:{object_key} succeeded")
            return resp.body.buffer
        else: 
            raise Exception(f"Failed to Get Object object_key:{object_key},errorMessage:{resp.errorMessage}")
    
    @staticmethod 
    def delete_object(obs_client:ObsClient, bucket_name:str,object_key) -> bool:
        """删除对象"""
        resp = obs_client.deleteObject(bucket_name,object_key)
        if resp.status < 300:
            print(f"Get Object object_key:{object_key} succeeded")
            return True
        else: 
            raise Exception(f"Failed to Delete Object object_key:{object_key},errorMessage:{resp.errorMessage}")
        
