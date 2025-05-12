import jwt
import json
import logging

# 配置 logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # 或 logging.DEBUG

SECRET_KEY = "your-secret-key"

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    request = event['Records'][0]['cf']['request']
    headers = request['headers']

    # 获取 Authorization Header
    auth_header = headers.get('authorization')
    if not auth_header:
        logger.warning("Missing Authorization header")
        return _unauthorized("Missing Authorization header")

    token_parts = auth_header[0]['value'].split()
    if len(token_parts) != 2 or token_parts[0].lower() != 'bearer':
        logger.warning("Invalid Authorization header format")
        return _unauthorized("Invalid Authorization header format")

    token = token_parts[1]

    try:
        # 解码 JWT
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        logger.info("JWT decoded successfully: %s", payload)

        return {
            "status": "200",
            "statusDescription": "OK",
            "body": json.dumps({
                "message": "JWT valid",
                "user_id": payload.get("user_id"),
                "username": payload.get("username")
            }),
            "headers": {
                "content-type": [{"key": "Content-Type", "value": "application/json"}]
            }
        }

    except jwt.ExpiredSignatureError:
        logger.warning("Token has expired")
        return _unauthorized("Token has expired")
    except jwt.InvalidTokenError as e:
        logger.error("Invalid token: %s", str(e))
        return _unauthorized("Invalid token")

def _unauthorized(reason):
    logger.debug("Unauthorized reason: %s", reason)
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
