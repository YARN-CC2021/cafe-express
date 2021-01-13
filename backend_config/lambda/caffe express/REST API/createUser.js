const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

function setUserCategory(body) {
  const { id, isCustomer } = body;

  const params = {
    TableName: "userCategory",
    Item: {
      id: id,
      isCustomer: isCustomer,
    },
  };

  return ddb.put(params).promise();
}

function createCustomer(body) {
  const { id, loginEmail, createdAt } = body;

  const params = {
    TableName: "customer",
    Item: {
      id: id,
      username: "",
      email: loginEmail,
      point: 0,
      createdAt: createdAt,
      updatedAt: createdAt,
    },
  };

  return ddb.put(params).promise();
}

const createStore = (body) => {
  const { id, loginEmail, createdAt } = body;
  const params = {
    TableName: "store",
    Item: {
      id: id,
      stripeId: "",
      createdAt: createdAt,
      updatedAt: createdAt,
      name: "",
      address: "",
      description: "",
      lat: 0,
      lng: 0,
      tel: "",
      loginEmail: loginEmail,
      contactEmail: "",
      storeURL: "",
      category: "",
      depositAmountPerPerson: 0,
      imagePaths: [],
      vacancyType: "strict",
      statistics: {
        rating: 0,
        category: {
            WithNoWait:0,
            With10minWait: 0,
            With30minWait: 0,
            Morethan1hourWait: 0,
            WasNotAbletoGetIn: 0
        },
        bookingCount: 0
    },
      hours: {
        Sun: {
          open: "0000",
          close: "0000",
          day_off: false,
          bookingStart: "0000",
          bookingEnd: "0000",
        },
        Mon: {
          open: "0000",
          close: "0000",
          day_off: false,
          bookingStart: "0000",
          bookingEnd: "0000",
        },
        Tue: {
          open: "0000",
          close: "0000",
          day_off: false,
          bookingStart: "0000",
          bookingEnd: "0000",
        },
        Wed: {
          open: "0000",
          close: "0000",
          day_off: false,
          bookingStart: "0000",
          bookingEnd: "0000",
        },
        Thu: {
          open: "0000",
          close: "0000",
          day_off: false,
          bookingStart: "0000",
          bookingEnd: "0000",
        },
        Fri: {
          open: "0000",
          close: "0000",
          day_off: false,
          bookingStart: "0000",
          bookingEnd: "0000",
        },
        Sat: {
          open: "0000",
          close: "0000",
          day_off: false,
          bookingStart: "0000",
          bookingEnd: "0000",
        },
        Holiday: {
          open: "0000",
          close: "0000",
          day_off: false,
          bookingStart: "0000",
          bookingEnd: "0000",
        },
      },
      vacancy: {
        strict: [
          {
            label: "1 Seat Table",
            Min: 1,
            Max: 1,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "2 Seat Table",
            Min: 2,
            Max: 2,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "3 Seat Table",
            Min: 3,
            Max: 3,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "4 Seat Table",
            Min: 4,
            Max: 4,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "5 Seat Table",
            Min: 5,
            Max: 5,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "6 Seat Table",
            Min: 6,
            Max: 6,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "7 Seat Table",
            Min: 7,
            Max: 7,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "8 Seat Table",
            Min: 8,
            Max: 8,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "9 Seat Table",
            Min: 9,
            Max: 9,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "10 Seat Table",
            Min: 10,
            Max: 10,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "11 Seat Table",
            Min: 11,
            Max: 11,
            isVacant: false,
            cancelFee: 0,
          },
          {
            label: "12 Seat Table",
            Min: 12,
            Max: 12,
            isVacant: false,
            cancelFee: 0,
          },
        ],
        flex: [
          {
            label: "1-2 Seat Table",
            Min: 1,
            Max: 2,
            isVacant: false,
            cancelFee: 0
          },
          {
            label: "3-4 Seat Table",
            Min: 3,
            Max: 4,
            isVacant: false,
            cancelFee: 0
          },
          {
            label: "5-6 Seat Table",
            Min: 5,
            Max: 6,
            isVacant: false,
            cancelFee: 0
          },
          {
            label: "7-8 Seat Table",
            Min: 7,
            Max: 8,
            isVacant: false,
            cancelFee: 0
          },
          {
            label: "9-10 Seat Table",
            Min: 9,
            Max: 10,
            isVacant: false,
            cancelFee: 0
          },
          {
            label: "11-12 Seat Table",
            Min: 11,
            Max: 12,
            isVacant: false,
            cancelFee: 0
          },
        ],
        custom: [
          {
            label: "1-5 Seat Table",
            Min: 1,
            Max: 5,
            isVacant: false,
            cancelFee: 0
          },
          {
            label: "1-5 Seat Table",
            Min: 1,
            Max: 5,
            isVacant: false,
            cancelFee: 0
          },
        ],
      },
    },
  };
  return ddb.put(params).promise();
};

exports.handler = async (event, context) => {
  // Lambda Code Here
  // context.succeed('Success!')
  // context.fail('Failed!')

  let responseBody = "";
  let statusCode = 0;
  let message = "";

  const body = event.body;
  const {isCustomer} = body;

  try {
    await setUserCategory(body);
  } catch (err) {
    message = `Failed to insert customer data. ERROR=${err}`;
    statusCode = 403;
  }

  if (isCustomer) {
    try {
      await createCustomer(body);
      message = "Successfully created customer.";
    } catch (err) {
      message = `Failed to create customer data. ERROR=${err}`;
      statusCode = 403;
    }
  } else {
    try {
      await createStore(body);
      message = "Successfully created store.";
    } catch (err) {
      message = `Failed to create store data. ERROR=${err}`;
      statusCode = 403;
    }
  }

  responseBody = body;
  statusCode = 201;

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message,
  };

  return response;
};
