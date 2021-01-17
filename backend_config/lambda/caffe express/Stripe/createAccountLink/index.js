const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

const Stripe = require("stripe");
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

const updateStripeId = (storeId, storeStripeId) => {
  console.log(
    "In updateStripeId, storeId and storeStripeId",
    storeId,
    storeStripeId
  );
  const params = {
    TableName: "store",
    Key: {
      id: storeId,
    },
    UpdateExpression: "set stripeId = :a",
    ExpressionAttributeValues: {
      ":a": storeStripeId,
    },
    ReturnValues: "UPDATED_NEW",
  };

  return ddb.update(params).promise();
};

const generateAccountLink = (accountId, origin) => {
  return stripe.accountLinks
    .create({
      type: "account_onboarding",
      account: accountId,
      refresh_url: `http://${origin}/onboard-user/refresh`,
      return_url: `http://${origin}/success.html`,
    })
    .then((link) => link.url);
};

exports.handler = async (event) => {
  // TODO implement

  let responseBody = "";
  let statusCode = 0;
  let message = "";
  let accountId;

  const { storeId, storeStripeId } = event.query;

  try {
    if (storeStripeId) {
      accountId = storeStripeId;
    } else {
      const account = await stripe.accounts.create({ type: "standard" });
      // req.session.accountID = account.id;
      accountId = account.id;
      await updateStripeId(storeId, storeStripeId);
    }

    const origin = `${event.headers.origin}`;
    console.log("ORIGIN", origin);
    const accountLinkURL = await generateAccountLink(accountId, origin);
    responseBody = JSON.stringify({
      accountLinkURL: accountLinkURL,
      stripeId: accountId,
    });
    statusCode = 200;
    message = "Successfully created account link.";
  } catch (error) {
    message = `Failed to create account link. ERROR=${error}`;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message,
  };

  return response;
};
