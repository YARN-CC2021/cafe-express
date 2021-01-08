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

  const {
    id,
    bookedAt,
    createdAt,
    depositAmount,
    storeInfo,
    status,
  } = event.body;

  const params = {
    TableName: "booking",
    Item: {
      id: id,
      bookedAt: bookedAt,
      createdAt: createdAt,
      depositAmount: depositAmount,
      storeInfo: storeInfo,
      status: status,
    },
  };

  try {
    const data = await documentClient.put(params).promise();
    responseBody = data;
    statusCode = 201;
  } catch (err) {
    responseBody = "Unable to put user data";
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
  };

  return response;
};
