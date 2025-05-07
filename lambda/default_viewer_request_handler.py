import json

def lambda_handler(event, context):
    # 直接返回 Hello World 响应
    return {
        'status': '200',
        'statusDescription': 'OK',
        'headers': {
            'content-type': [{'key': 'Content-Type', 'value': 'application/json'}]
        },
        'body': json.dumps({"message": "Hello from default_viewer_request_handler!"})
    }