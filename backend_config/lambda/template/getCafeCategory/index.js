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

  const { category } = event.params;

  const params = {
    TableName: "booking",
    FilterExpression: "#keyone.#keytwo = :keyone",
    ExpressionAttributeNames: {
      "#keyone": "storeInfo",
      "#keytwo": "category",
    },
    ExpressionAttributeValues: {
      ":keyone": category,
    },
  };

  // {  "address" : { "S" : "六本木３－１－１" },  "category" : { "S" : "Cafe" },  "id" : { "S" : "pk_XXXXXXXXX " },  "name" : { "S" : "CCbucks" },  "rating" : { "N" : "3.8" }}

  try {
    const data = await documentClient.scan(params).promise();
    responseBody = data.Items;
    statusCode = 200;
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
