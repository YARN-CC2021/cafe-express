const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

function updateBookingStatus(bodyParsed) {
  const { bookingId, status, updatedAt } = bodyParsed;

  const params = {
    TableName: "booking",
    Key: {
      bookingId: bookingId,
    },
    UpdateExpression: `set #status = :status, #updatedAt = :updatedAt`,
    ExpressionAttributeNames: {
      "#status": "status",
      "#updatedAt": "updatedAt",
    },
    ExpressionAttributeValues: {
      ":status": status,
      ":updatedAt": updatedAt,
    },
    ReturnValues: "UPDATED_NEW",
  };

  return ddb.update(params).promise();
}

exports.handler = async (event, context, sendResponse) => {
  const bodyParsed = JSON.parse(event.body);

  delete bodyParsed.action;

  await updateBookingStatus(bodyParsed);

  sendResponse(null, { statusCode: 200 });
};
