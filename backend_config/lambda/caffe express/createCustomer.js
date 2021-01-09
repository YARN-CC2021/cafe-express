const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();
const tableName = "customer";

function createCustomer(tableName, body) {
  const { id, createdAt } = body;

  const params = {
    TableName: tableName,
    Item: {
      id: id,
      createdAt: createdAt,
    },
  };

  return ddb.put(params).promise();
}

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')

  let responseBody = "";
  let statusCode = 0;
  let message = "";

  const body = event.body;

  try {
    await createCustomer(tableName, body);
    responseBody = body;
    statusCode = 201;
    message = "Customer data successfully inserted.";
  } catch (err) {
    message = `Failed to insert customer data. ERROR=${err}`;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message,
  };

  return response;
};
