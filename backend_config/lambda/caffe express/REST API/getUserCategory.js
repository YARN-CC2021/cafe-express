const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();
const tableName = "userCategory";

function getUserCategory(tableName, id) {

  const params = {
    TableName: tableName,
    Key: {
      id: id,
    },
  };

  return ddb.get(params).promise();
}

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')

  let responseBody = "";
  let statusCode = 0;
  let message = "";

  const {id} = event.params;

  try {
    const data = await getUserCategory(tableName, id);
    responseBody = data.Item;
    statusCode = 200;
    message = "Successfully received user category.";
  } catch (err) {
    message = `Failed to retrieve user category. ERROR=${err}`;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message,
  };

  return response;
};
