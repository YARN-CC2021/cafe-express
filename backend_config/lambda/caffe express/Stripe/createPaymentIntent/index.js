const Stripe = require("stripe");
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

exports.handler = async (event) => {
  // TODO implement

  let responseBody = "";
  let statusCode = 0;
  let message = "";

  const { storeStripeId, amount, payMethod } = event.query;
  const fee = amount / 100 || 0;
  let paymentMethod;

  // try {
  //   paymentMethod = stripe.paymentMethods.create(
  //     {
  //       payment_method: payMethod,
  //     },
  //     {
  //       stripeAccount: storeStripeId,
  //     }
  //   );
  // } catch (error) {
  //   message = `Failed to create payment method. ERROR=${error}`;
  //   statusCode = 403;
  // }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      // payment_method: paymentMethod.id,
      payment_method_types: ["card"],
      amount: amount,
      currency: "jpy",
      // confirmation_method: "automatic",
      // confirm: true,
      application_fee_amount: fee,
      transfer_data: {
        destination: storeStripeId,
      },
    });
    responseBody = JSON.stringify({
      paymentIntent: paymentIntent,
      storeStripeId: storeStripeId,
    });
    statusCode = 200;
    message = "Successfully created payment intent.";
  } catch (error) {
    message = `Failed to create payment intent. ERROR=${error}`;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
    message: message,
  };

  return response;
};
