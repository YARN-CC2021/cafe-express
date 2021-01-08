const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

const createStore = (event) => {
  const {
      id,
      // stripeId,
      // name,
      // address,
      // description,
      // lat,
      // lng,
      // tel,
      // email,
      // storeURL,
      // category,
      // depositAmountPerPerson,
      // vacancyType,
      createdAt,
      // updatedAt,
      // imagePaths,
      // hours,
      // vacancy,
      // statistics
    } = event.body;
  
  const params = {
      TableName: "store",
      Item: {
          id: id,
          // stripeId: stripeId,
          // name: name,
          // address: address,
          // description: description,
          // lat: lat,
          // lng: lng,
          // tel: tel,
          // email: email,
          // storeURL: storeURL,
          // category: category,
          // depositAmountPerPerson: depositAmountPerPerson,
          // vacancyType: vacancyType,
          createdAt: createdAt,
          // updatedAt: updatedAt,
          // imagePaths: imagePaths,
          // hours: hours,
          // vacancy: vacancy,
          // statistics: statistics
      },
  };
  return ddb.put(params).promise();
}

const updateStore = (event, id) => {
    const {
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
        vacancy,
        statistics
      } = event.body;
    
      const params = {
        TableName: "store",
        Key: {
          id: id,
        },
        UpdateExpression: "set stripeId = :a, #str = :b, address = :c, description = :d, lat = :e, lng = :f, tel = :g, email = :h, storeURL = :i, category = :j, depositAmountPerPerson = k, vacancyType = :l, createdAt = :m, updatedAt = :n, imagePaths = :o, hours = :p, vacancy = :q, statistics = :r",
        ExpressionAttributeNames : {
          '#str' : 'name'
        },
        ExpressionAttributeValues: {
          ":a": stripeId,
          ":b": name,
          ":c": address,
          ":d": description,
          ":e": lat,
          ":f": lng,
          ":g": tel,
          ":h": email,
          ":i": storeURL,
          ":j": category,
          ":k": depositAmountPerPerson,
          ":l": vacancyType,
          ":m": createdAt,
          ":n": updatedAt,
          ":o": imagePaths,
          ":p": hours,
          ":q": vacancy,
          ":r": statistics
        },
        ReturnValues: "UPDATED_NEW",
      };

          ":p": hours,
          ":q": vacancy
        },
        ReturnValues: "UPDATED_NEW",
      };

    const params = {
        TableName: "store",
        Key: {
          id: id,
        },
        Item: {
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
    return ddb.update(params).promise();
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
    if (id){
      await updateStore(event, id);
    } else {
      await createStore(event);
    }
    responseBody = event.body;
    statusCode = 201;
    message = `Store data successfully ${id ? "updated" : "created" }.`;
  } catch (err) {
    message = `Failed to ${id ? "update" : "create" } store data. ERROR=${err}`;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message
  };

  return response;
};
