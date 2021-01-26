const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();
const tableName = "booking";

function getStoreBookingList(tableName, storeId) {
  
  const params = {
    TableName: tableName,
    FilterExpression: "#store.#id = :id",
    ExpressionAttributeNames: {
      "#store": "storeInfo",
      "#id": "id",
    },
    ExpressionAttributeValues: {
      ":id": storeId,
    },
  };

  return ddb.scan(params).promise();
}

function getCustomerBookingList(tableName, customerId) {

  const params = {
    TableName: tableName,
    FilterExpression: "#customer.#id = :id",
    ExpressionAttributeNames: {
      "#customer": "customerInfo",
      "#id": "customerId",
    },
    ExpressionAttributeValues: {
      ":id": customerId,
    },
  };

  return ddb.scan(params).promise();
}

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')

  let responseBody = "";
  let statusCode = 0;
  let message = "";
  let data;
  
  const { storeId, customerId } = event.query;

  try {
    if (storeId){
      data = await getStoreBookingList(tableName, storeId);
    } else if (customerId){
      data = await getCustomerBookingList(tableName, customerId);
    }
    
    responseBody = data.Items;
    statusCode = 200;
    message = "Booking list has been successfully extracted.";
  } catch (err) {
    responseBody = `Failed to get booking list. Error = ${err}`;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message,
  };

  return response;
};
