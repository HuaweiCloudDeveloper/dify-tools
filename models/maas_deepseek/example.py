# coding=utf-8

import requests
import json,codecs

if __name__ == '__main__':
    url = "https://maas-cn-southwest-2.modelarts-maas.com/v1/infers/271c9332-4aa6-4ff5-95b3-0cf8bd94c394/v1/chat/completions"
    api_key = "SkhAZSFYtA_Q7w_a_qETWuk8PjpG1ngGTdYowpN_i2gJrz8ZVIwY14ijbsH_0SSJzfYbaRR5A7yW5OQgDPFwaw" 
    
    # Send request.
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {api_key}' 
    }
    data = {
        "model":"DeepSeek-V3", # 模型名称
        "messages": [
            # {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "你好"}
        ],
        # 是否开启流式推理, 默认为False, 表示不开启流式推理
        "stream": True,
        # 在流式输出时是否展示使用的token数目。只有当stream为True时改参数才会生效。
        # "stream_options": { "include_usage": True },
        # 控制采样随机性的浮点数，值较低时模型更具确定性，值较高时模型更具创造性。"0"表示贪婪取样。默认为0.6。
        "temperature": 0.6
    }
    response = requests.post(url, headers=headers, data=json.dumps(data), verify=False)

    # Print result.
    full_assistant_content = ""
    delimiter = codecs.decode("\n\n", "unicode_escape")
    for chunk in response.iter_lines(decode_unicode=True, delimiter=delimiter):
        chunk = chunk.strip()
        if chunk:
            if chunk.startswith(":"):
                continue
            decoded_chunk = chunk.removeprefix("data:").lstrip()
            if decoded_chunk == "[DONE]":
                continue

            try:
                chunk_json: dict = json.loads(decoded_chunk)
            # stream ended
            except json.JSONDecodeError as e:
                break

            if chunk_json.get("error") and chunk_json.get("choices") is None:
                raise ValueError(chunk_json.get("error"))
            if not chunk_json or len(chunk_json["choices"]) == 0:
                continue
            choice = chunk_json["choices"][0]
            if "delta" in choice:
                delta = choice["delta"]
                full_assistant_content += delta.get("content") or ""

    print(full_assistant_content)
