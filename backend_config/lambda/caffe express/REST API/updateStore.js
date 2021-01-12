const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

const updateStore = (event, id) => {
  console.log("Im Here inside the updatesStore Function!!!!!!");

  const params = {
    TableName: "store",
    Key: {
      id: id,
    },
    UpdateExpression:
      "set stripeId = :a, #str = :b, address = :c, description = :d, lat = :e, lng = :f, tel = :g, loginEmail = :h, storeURL = :i, category = :j, depositAmountPerPerson = :k, vacancyType = :l, updatedAt = :n, imagePaths = :o, hours = :p, vacancy = :q, statistics = :r, contactEmail = :s",
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
      ":k": event.body.depositAmountPerPerson,
      ":l": event.body.vacancyType,
      ":n": event.body.updatedAt,
      ":o": event.body.imagePaths,
      ":p": event.body.hours,
      ":q": event.body.vacancy,
      ":r": event.body.statistics,
      ":s": event.body.contactEmail,
    },
    ReturnValues: "UPDATED_NEW",
  };

  console.log("Params to be updated", params);
  
  return ddb.update(params).promise();
};

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')
  console.log("Im Here!!!!!!");
  console.log("event body", event.body);
  console.log("event params", event.params);
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
