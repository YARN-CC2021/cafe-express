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
  const { depositAmount, bookedAt } = event.body;

  const params = {
    TableName: "booking",
    UpdateExpression: "set depositAmount = :n, bookedAt = :b",
    ExpressionAttributeValues: {
      ":n": depositAmount,
      ":b": bookedAt,
    },
    ReturnValues: "UPDATED_NEW",
  };

  // {  "address" : { "S" : "六本木３－１－１" },  "category" : { "S" : "Cafe" },  "id" : { "S" : "pk_XXXXXXXXX " },  "name" : { "S" : "CCbucks" },  "rating" : { "N" : "3.8" }}

  try {
    const data = await documentClient.update(params).promise();
    responseBody = data;
    statusCode = 204;
  } catch (err) {
    responseBody = "Unable to update user data";
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
