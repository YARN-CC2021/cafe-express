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

function getStoreConnectionId(bodyParsed) {
  const { id } = bodyParsed.storeInfo;

  const params = {
    TableName: "websocket",
    FilterExpression: "#id = :id",
    ExpressionAttributeNames: {
      "#id": "id",
    },
    ExpressionAttributeValues: {
      ":id": id,
    },
  };
  return ddb.scan(params).promise();
}

function insertBooking(bodyParsed) {
  const params = {
    TableName: "booking",
    Item: bodyParsed,
  };

  return ddb.put(params).promise();
}

function updateVacancy(bodyParsed) {
  const storeId = bodyParsed.storeInfo.id;
  const indexOfTable = bodyParsed.index;
  const vacancyType = bodyParsed.vacancyType;

  const params = {
    TableName: "store",
    Key: {
      id: storeId,
    },
    UpdateExpression: `set #vac.#type[${indexOfTable}].#isV = :false`,
    ExpressionAttributeNames: {
      "#vac": "vacancy",
      "#type": vacancyType,
      "#isV": "isVacant",
    },
    ExpressionAttributeValues: {
      ":false": false,
    },
    ReturnValues: "UPDATED_NEW",
  };

  return ddb.update(params).promise();
}

exports.handler = async (event, context, sendResponse) => {
  initApiGatewayManagementApi(event);

  const bodyParsed = JSON.parse(event.body);
  delete bodyParsed.action;

  await insertBooking(bodyParsed);
  await updateVacancy(bodyParsed);

  const {
    bookName,
    vacancyType,
    index,
    partySize,
    depositAmount,
    bookedAt,
    expiredAt,
    bookingId
  } = bodyParsed;
  const { id } = bodyParsed.storeInfo;
  const { customerId } = bodyParsed.customerInfo;
  const isVacant = false;

  const customerResponseBody = JSON.stringify({
    id,
    index,
    isVacant,
  });

  // const storeResponseBody = JSON.stringify({
  //   bookingId,
  //   customerId,
  //   bookName,
  //   vacancyType,
  //   index,
  //   partySize,
  //   depositAmount,
  //   bookedAt,
  //   expiredAt,
  // });

  const customers = await getCustomerConnectionId();
  const stores = await getStoreConnectionId(bodyParsed);

  customers.Items.forEach(function (connection) {
    if (connection.connectionId !== "dummy") {
      send(connection.connectionId, customerResponseBody);
    }
  });
  stores.Items.forEach(function (connection) {
    if (connection.connectionId !== "dummy") {
      send(connection.connectionId, event.body);
    }
  });
  sendResponse(null, { statusCode: 200 });
};