"use strict";
const AWS = require("aws-sdk");

AWS.config.update({ regions: "ap-northeast-1" });

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')
  const documentClient = new AWS.DynamoDB.DocumentClient({
    regions: "ap-northeast-1",
  });

  let responseBody = "";
  let statusCode = 0;

  const { id } = event.params;

  if (id) {
    const params = {
      TableName: "booking",
      Key: {
        id: id,
      },
    };

    try {
      const data = await documentClient.get(params).promise();
      responseBody = data.Item;
      statusCode = 200;
    } catch (err) {
      responseBody = "Unable to get booking data";
      statusCode = 403;
    }

    const response = {
      body: responseBody,
    };

    return response;
  } else {
    const params = {
      TableName: "booking",
    };

    try {
      const data = await documentClient.scan(params).promise();
      responseBody = data.Items;
      statusCode = 200;
    } catch (err) {
      responseBody = "Unable to get all booking data";
      statusCode = 403;
    }

    const response = {
      body: responseBody,
    };

    return response;
  }
};
