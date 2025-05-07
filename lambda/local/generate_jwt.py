import jwt
import datetime

# 密钥（仅自己使用，勿泄露）
secret_key = "your-secret-key"

# 创建 payload（负载信息）
payload = {
    "user_id": 123,
    "username": "alice",
    "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)  # 1 小时后过期
}

# 编码生成 token
token = jwt.encode(payload, secret_key, algorithm="HS256")

print("生成的 JWT:")
print(token)
