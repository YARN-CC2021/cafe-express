const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();
const tableName = "booking";

function getFilteredBookingList(tableName, event) {
  const { id } = event.params;

  const params = {
    TableName: tableName,
    FilterExpression: "#store.#id = :id",
    ExpressionAttributeNames: {
      "#store": "storeInfo",
      "#id": "id",
    },
    ExpressionAttributeValues: {
      ":id": id,
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

  try {
    const data = await getFilteredBookingList(tableName, event);
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
