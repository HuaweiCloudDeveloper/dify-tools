from typing import Any
import psycopg2

class HuaweiCloudGaussdbTool:

    def __init__(self,credentials: dict[str, Any]):
        endpoint:str = credentials.get("ENDPOINT")
        host = endpoint.split(':')[0]
        port = endpoint.split(':')[1]
        user_name = credentials.get("USER_NAME")
        password = credentials.get("PASSWORD")
        db = credentials.get("DATABASE")
        self.conn = psycopg2.connect(database=db, user=user_name, password=password, host=host, port=port)

    def getConnect(self):
        cursor = self.conn.cursor()
        return self.conn, cursor
    
    def closeConnect(self, conn, cursor):
        cursor.close()
        conn.close()

    def execute(self, sql, value=None):
        '''执行增删改'''
        conn, cursor = self.getConnect()
        try:
            res = cursor.execute(sql, value)
            conn.commit(conn, cursor)
            self.closeConnect(conn, cursor)
            return res
        except Exception as e:
            conn.rollock()
            raise e
    
    def executemany(self, sql, value):
        '''批量执行增删改'''
        conn, cursor = self.getConnect()
        try:
            res = cursor.executemany(sql, value)
            conn.commit(conn, cursor)
            self.closeConnect(conn, cursor)
            return res
        except Exception as e:
            conn.rollock()
            raise e
        
    def selectOne(self, sql):
        '''查询单个'''
        conn, cursor = self.getConnect()
        cursor.execute(sql)
        result = cursor.fetchone()
        self.closeConnect(conn, cursor)
        return result

    def selectAll(self, sql):
        '''批量查询'''
        conn, cursor = self.getConnect()
        cursor.execute(sql)
        result = cursor.fetchall()
        self.closeConnect(conn, cursor)
        return result