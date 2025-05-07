import jwt
import json
import base64

SECRET_KEY = "your-secret-key"

def lambda_handler(event, context):
    request = event['Records'][0]['cf']['request']
    headers = request['headers']

    # 获取 Authorization Header
    auth_header = headers.get('authorization')
    if not auth_header:
        return _unauthorized("Missing Authorization header")

    token_parts = auth_header[0]['value'].split()
    if len(token_parts) != 2 or token_parts[0].lower() != 'bearer':
        return _unauthorized("Invalid Authorization header format")

    token = token_parts[1]

    try:
        # 解码 JWT
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        # 返回成功信息
        return {
            "status": "200",
            "statusDescription": "OK",
            "body": json.dumps({
                "message": "JWT valid",
                "user": payload.get("user", "unknown")
            }),
            "headers": {
                "content-type": [{"key": "Content-Type", "value": "application/json"}]
            }
        }

    except jwt.ExpiredSignatureError:
        return _unauthorized("Token has expired")
    except jwt.InvalidTokenError:
        return _unauthorized("Invalid token")

def _unauthorized(reason):
    return {
        "status": "401",
        "statusDescription": "Unauthorized",
        "body": json.dumps({
            "message": f"JWT validation failed: {reason}"
        }),
        "headers": {
            "content-type": [{"key": "Content-Type", "value": "application/json"}]
        }
    }

# def lambda_handler(event, context):
#     return {
#         'status': '200',
#         'statusDescription': 'OK',
#         'headers': {
#             'content-type': [{'key': 'Content-Type', 'value': 'text/plain'}],
#         },
#         'body': 'Hello from Lambda@Edge!'
#     }