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
  let message = "";

  const { id } = event.params;

    try {
      if (id) {
      const data = await getStore(tableName, id);
      responseBody = data.Item;
      } else {
        const data = await getStoreAll(tableName);
      responseBody = data.Items;
      }
      statusCode = 200;
      message = `Successfully got ${id ? "data" : "all data" }.`
    } catch (err) {
      message = `Failed to get store data. ERROR=${err}`;
      statusCode = 403;
    }

    const response = {
      statusCode: statusCode,
      body: responseBody,
      message: message
    };

    return response;
  
};
