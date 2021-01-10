const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();
const tableName = "websocket";

function addConnection(connectionId, id, isCustomer) {
  return ddb
    .put({
      TableName: tableName,
      Item: {
        connectionId: connectionId,
        id: id,
        isCustomer: isCustomer,
      },
    })
    .promise();
}

exports.handler = async (event, context, sendResponse) => {
  const connectionId = event.requestContext.connectionId;
  const { id, isCustomer } = event.queryStringParameters;
  await addConnection(connectionId, id, isCustomer );
  sendResponse(null, {statusCode: 200});
};
