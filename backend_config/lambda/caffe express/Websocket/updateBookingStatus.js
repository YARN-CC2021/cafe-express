const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

let apiGatewayManagementApi;
const apiVersion = "2018-11-29";

function initApiGatewayManagementApi(event) {
  apiGatewayManagementApi = new AWS.ApiGatewayManagementApi({
    apiVersion,
    endpoint:
      event.requestContext.domainName + "/" + event.requestContext.stage,
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

function updateBookingStatus(bodyParsed) {
  const { bookingId, status, updatedAt } = bodyParsed;
  console.log("bookingId, status, updatedAt", bookingId, status, updatedAt);

  const params = {
    TableName: "booking",
    Key: {
      bookingId: bookingId,
    },
    UpdateExpression: `set #status = :status, #updatedAt = :updatedAt`,
    ExpressionAttributeNames: {
      "#status": "status",
      "#updatedAt": "updatedAt",
    },
    ExpressionAttributeValues: {
      ":status": status,
      ":updatedAt": updatedAt,
    },
    ReturnValues: "UPDATED_NEW",
  };

  return ddb.update(params).promise();
}


function getCustomerConnectionId(bodyParsed) {
  const { customerId } = bodyParsed;

  const params = {
    TableName: "websocket",
    FilterExpression: "#id = :id",
    ExpressionAttributeNames: {
      "#id": "id",
    },
    ExpressionAttributeValues: {
      ":id": customerId,
    },
  }
  return ddb.scan(params).promise();
}


exports.handler = async (event, context, sendResponse) => {
  initApiGatewayManagementApi(event);
  const bodyParsed = JSON.parse(event.body);

  delete bodyParsed.action;

  await updateBookingStatus(bodyParsed);
  const customers = await getCustomerConnectionId(bodyParsed);

  customers.Items.forEach(function (connection) {
    if (connection.connectionId !== "dummy") {
      send(connection.connectionId, event.body);
    }
  });

  sendResponse(null, { statusCode: 200 });
};
