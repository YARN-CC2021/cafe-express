const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

const updateStore = (event) => {
    const {
        id,
        stripeId,
        name,
        address,
        description,
        lat,
        lng,
        tel,
        email,
        storeURL,
        category,
        depositAmountPerPerson,
        vacancyType,
        createdAt,
        updatedAt,
        imagePaths,
        hours,
        vacancy
      } = event.body;
    
    const params = {
        TableName: "store",
        Item: {
            id: id,
            stripeId: stripeId,
            name: name,
            address: address,
            description: description,
            lat: lat,
            lng: lng,
            tel: tel,
            email: email,
            storeURL: storeURL,
            category: category,
            depositAmountPerPerson: depositAmountPerPerson,
            vacancyType: vacancyType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            imagePaths: imagePaths,
            hours: hours,
            vacancy: vacancy
        },
    };

    return ddb.put(params).promise();

    
}

exports.handler = async (event, context) => {
 
  let responseBody = "";
  let statusCode = 0;
  let message = "";

  
  try {
        await updateStore(event);
    responseBody = event.body;
    statusCode = 201;
    message = `Store data successfully ${Object.keys(responseBody) > 2? "updated" : "created" }.`;
  } catch (err) {
    message = `Failed to ${Object.keys(responseBody) > 2? "update" : "create" } store data. ERROR=${err}`;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message
  };

  return response;
};
