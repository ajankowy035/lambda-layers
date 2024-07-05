import { APIGatewayProxyEvent, Context } from 'aws-lambda';
import { handler } from './index';

describe('sample lambda', () => {
  it('should return the correct message', async () => {
    const event = {} as APIGatewayProxyEvent;
    const context = {} as Context;
    const result = await handler(event, context, () => null);

    expect(result?.statusCode).toBe(200);
    expect(JSON.parse(result?.body as string).message).toBe(
      'Hello from the utility layer!',
    );
  });
});
