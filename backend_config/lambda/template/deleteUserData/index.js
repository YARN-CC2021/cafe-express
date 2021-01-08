"use strict";
const AWS = require("aws-sdk");

AWS.config.update({ regions: "us-west-1" });

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')
  const ddb = new AWS.DynamoDB({ apiVersion: "2012-08-10" });
  const documentClient = new AWS.DynamoDB.DocumentClient({
    regions: "us-west-1",
  });

  let responseBody = "";
  let statusCode = 0;

  const { id } = event.params;

  const params = {
    TableName: "Users",
    Key: {
      id: id,
    },
  };

  try {
    const data = await documentClient.delete(params).promise();
    responseBody = data;
    statusCode = 204;
  } catch (err) {
    responseBody = "Unable to put user data";
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    headers: {
      myHeader: "test",
    },
    body: responseBody,
  };

  return response;
};
