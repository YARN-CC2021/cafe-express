const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();
const tableName = "userCategory";

function setUserCategory(tableName, body) {
  const { id, isStore } = body;

  const params = {
    TableName: tableName,
    Item: {
      id: id,
      isStore: isStore,
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
    await setUserCategory(tableName, body);
    responseBody = body;
    statusCode = 201;
    message = "Successfully set user category.";
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
