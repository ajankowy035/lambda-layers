import { APIGatewayProxyHandler } from 'aws-lambda';
import { getMessage } from '../../layers/util-layer/utils';

export const handler: APIGatewayProxyHandler = async (
  event,
  context,
  callback,
) => {
  console.log({ event, context, callback });
  const message = getMessage();
  return {
    statusCode: 200,
    body: JSON.stringify({ message }),
  };
};
