const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();
const tableName = "store";

function getStoreAll(tableName) {
  return ddb
    .scan({
      TableName: tableName,
    })
    .promise();
}

function getStore(tableName, id) {
  return ddb
    .get({
      TableName: tableName,
      Key: {
        id: id,
      },
    })
    .promise();
}

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')

  let responseBody = "";
  let statusCode = 0;

  const { id } = event.params;

  if (id) {
    try {
      const data = await getStore(tableName, id);
      responseBody = data.Item;
      statusCode = 200;
    } catch (err) {
      responseBody = "Unable to get store data";
      statusCode = 403;
    }

    const response = {
      statusCode: statusCode,
      body: responseBody,
    };

    return response;
  } else {
    try {
      const data = await getStoreAll(tableName);
      responseBody = data.Items;
      statusCode = 200;
    } catch (err) {
      responseBody = "Unable to get all store data";
      statusCode = 403;
    }

    const response = {
      statusCode: statusCode,
      body: responseBody,
    };

    return response;
  }
};
