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

function getCustomerConnectionId() {
  const params = {
    TableName: "websocket",
    FilterExpression: "#customer = :boolean",
    ExpressionAttributeNames: {
      "#customer": "isCustomer",
    },
    ExpressionAttributeValues: {
      ":boolean": true,
    },
  };
  return ddb.scan(params).promise();
}

function updateVacancy(bodyParsed) {
  const storeId = bodyParsed.storeId;
  const indexOfTable = bodyParsed.index;
  const vacancyType = bodyParsed.vacancyType;
  const isVacant = bodyParsed.isVacant;

  const params = {
    TableName: "store",
    Key: {
      id: storeId,
    },
    UpdateExpression: `set #vac.#type[${indexOfTable}].#isV = :isVacant`,
    ExpressionAttributeNames: {
      "#vac": "vacancy",
      "#type": vacancyType,
      "#isV": "isVacant",
    },
    ExpressionAttributeValues: {
      ":isVacant": isVacant,
    },
    ReturnValues: "UPDATED_NEW",
  };

  return ddb.update(params).promise();
}

exports.handler = async (event, context, sendResponse) => {
  initApiGatewayManagementApi(event);

  const bodyParsed = JSON.parse(event.body);
  delete bodyParsed.action;

  await updateVacancy(bodyParsed);

  const { index, storeId, vacancyType, isVacant } = bodyParsed;

  const customerResponseBody = JSON.stringify({
    storeId,
    index,
    vacancyType,
    isVacant,
  });

  const customers = await getCustomerConnectionId();

  customers.Items.forEach(function (connection) {
    if (connection.connectionId !== "dummy") {
      send(connection.connectionId, customerResponseBody);
    }
  });
  sendResponse(null, { statusCode: 200 });
};
