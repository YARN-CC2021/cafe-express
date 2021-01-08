const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

let apiGatewayManagementApi;
const tableName = "booking";
const apiVersion = "2018-11-29";

// send booking info

// update vacant status

function initApiGatewayManagementApi(event) {
  apiGatewayManagementApi = new AWS.ApiGatewayManagementApi({
    apiVersion,
    endpoint: event.requestContext.domainName + "/" + event.requestContext.stage,
  });
}

async function send(connectionId, data) {
  if (apiGatewayManagementApi) {
    await apiGatewayManagementApi
      .postToConnection({
        ConnectionId: connectionId,
        Data: data,
      })
      .promise();
  }
}

function getUserConnectionId() {
  const params = {
    TableName: "websocket",
    Key: {
      isCustomer: true,
    },
  };

  return ddb.get(params).promise();
}

exports.handler = (event, context, callback) => {
  initApiGatewayManagementApi(event);
  let message = JSON.stringify({ message: JSON.parse(event.body).message });
  getConnections().then((data) => {
    data.Items.forEach(function (connection) {
      send(connection.connectionId, message);
    });
    callback(null, { statusCode: 200 });
  });
};
