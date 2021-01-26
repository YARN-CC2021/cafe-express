const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

const updateStore = (event, id) => {
  const params = {
    TableName: "store",
    Key: {
      id: id,
    },
    UpdateExpression:
      "set stripeId = :a, #str = :b, address = :c, description = :d, lat = :e, lng = :f, tel = :g, loginEmail = :h, storeURL = :i, category = :j, vacancyType = :l, updatedAt = :n, imageUrl = :o, hours = :p, vacancy = :q, statistics = :r, contactEmail = :s, zipCode = :z",
    ExpressionAttributeNames: {
      "#str": "name",
    },
    ExpressionAttributeValues: {
      ":a": event.body.stripeId,
      ":b": event.body.name,
      ":c": event.body.address,
      ":d": event.body.description,
      ":e": event.body.lat,
      ":f": event.body.lng,
      ":g": event.body.tel,
      ":h": event.body.loginEmail,
      ":i": event.body.storeURL,
      ":j": event.body.category,
      ":l": event.body.vacancyType,
      ":n": event.body.updatedAt,
      ":o": event.body.imageUrl,
      ":p": event.body.hours,
      ":q": event.body.vacancy,
      ":r": event.body.statistics,
      ":s": event.body.contactEmail,
      ":z": event.body.zipCode
    },
    ReturnValues: "UPDATED_NEW",
  };

  return ddb.update(params).promise();
};

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')
  let responseBody = "";
  let statusCode = 0;
  let message = "";
  const { id } = event.params;
  try {
    await updateStore(event, id);
    responseBody = event.body;
    statusCode = 201;
    message = "Store data successfully updated";
  } catch (err) {
    message = "Failed to update store data. ERROR=${err}";
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message,
  };

  return response;
};
