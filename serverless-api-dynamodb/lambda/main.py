import json
import boto3
import os
import decimal

# Helper class to convert a DynamoDB item to JSON.
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)

dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('TABLE_NAME')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    print("Received event:", json.dumps(event, indent=2))
    
    http_method = event['requestContext']['http']['method']
    path = event['requestContext']['http']['path']
    
    # Simple routing based on Method
    try:
        if http_method == 'GET':
            if path == '/':
                return {
                    'statusCode': 200,
                    'body': json.dumps({'message': 'Welcome to the Serverless API v1767202592'}),
                    'headers': {'Content-Type': 'application/json'}
                }
            if path == '/items':
                response = table.scan()
                return {
                    'statusCode': 200,
                    'body': json.dumps(response.get('Items', []), cls=DecimalEncoder),
                    'headers': {'Content-Type': 'application/json'}
                }
            elif path.startswith('/items/'):
                item_id = path.split('/')[-1]
                response = table.get_item(Key={'id': item_id})
                item = response.get('Item')
                if item:
                    return {
                        'statusCode': 200,
                        'body': json.dumps(item, cls=DecimalEncoder),
                        'headers': {'Content-Type': 'application/json'}
                    }
                else:
                    return {
                        'statusCode': 404,
                        'body': json.dumps({'error': 'Item not found'}),
                        'headers': {'Content-Type': 'application/json'}
                    }
        
        elif http_method == 'POST':
            if path == '/items':
                body = json.loads(event.get('body', '{}'))
                if 'id' not in body:
                     return {
                        'statusCode': 400,
                        'body': json.dumps({'error': 'id is required'}),
                        'headers': {'Content-Type': 'application/json'}
                    }
                table.put_item(Item=body)
                return {
                    'statusCode': 201,
                    'body': json.dumps({'message': 'Item created', 'item': body}, cls=DecimalEncoder),
                    'headers': {'Content-Type': 'application/json'}
                }

        elif http_method == 'DELETE':
             if path.startswith('/items/'):
                item_id = path.split('/')[-1]
                table.delete_item(Key={'id': item_id})
                return {
                    'statusCode': 200,
                    'body': json.dumps({'message': 'Item deleted'}),
                    'headers': {'Content-Type': 'application/json'}
                }

        return {
            'statusCode': 404,
            'body': json.dumps({'error': 'Route not found'}),
            'headers': {'Content-Type': 'application/json'}
        }

    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)}),
            'headers': {'Content-Type': 'application/json'}
        }

# Updated at Wed Dec 31 11:06:32 PM IST 2025
