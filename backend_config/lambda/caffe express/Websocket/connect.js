const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

function addConnection(connectionId, id, isCustomer) {
  return ddb
    .put({
      TableName: "websocket",
      Item: {
        connectionId: connectionId,
        id: id,
        isCustomer: isCustomer,
      },
    })
    .promise();
}

function getUserCategory(id) {
  return ddb
    .get({
      TableName: "userCategory",
      Key: {
        id: id,
      },
    })
    .promise();
}

exports.handler = async (event, context, sendResponse) => {
  const connectionId = event.requestContext.connectionId;
  const { id } = event.queryStringParameters;

  const userData = await getUserCategory(id);
  const { isCustomer } = userData.Item;

  await addConnection(connectionId, id, isCustomer);
  sendResponse(null, { statusCode: 200 });
};
