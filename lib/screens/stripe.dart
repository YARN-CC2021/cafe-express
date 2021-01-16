import "package:flutter/material.dart";
import '../app.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:convert';

class StripePage extends StatefulWidget {
  // final String id;
  // StripePage(this.id);

  @override
  _StripePageState createState() => _StripePageState();
}

class _StripePageState extends State<StripePage> {
  Token _token;
  PaymentMethod _paymentMethod;
  Source _source;
  final String _secretKey =
      'sk_test_51HyWlgCAUqx4BaPLaYK2zzqxSIBPmCoPm8xYN1fUfcoBsd9GsaAlls7UrrlESjvO0ezNcEfEocGB0FbQbT8JwLu7000X4pNdEr';
  PaymentIntentResult _paymentIntentResult;
  final CreditCard creditCard =
      CreditCard(number: "4242424242424242", expMonth: 02, expYear: 24);
  String _error;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  void getError(dynamic error) {
    _globalKey.currentState.showSnackBar(SnackBar(
      content: Text(error.toString()),
    ));
    setState(() {
      _error = error;
    });
  }

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            'pk_test_51HyWlgCAUqx4BaPL7KcmY0WevZG6TpmlW5uLGJ4FVmrkFZU0Bprspo9tqwQGf9K77CpJtQHNu8mfQgYPQdmvRQkR00OuElpR8r',
        androidPayMode: 'test',
        merchantId: 'test'));
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafe Express"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                MaterialButton(
                  child: Text("Initialize Source"),
                  onPressed: () {
                    StripePayment.createSourceWithParams(SourceParams(
                            returnURL: 'example://stripe-redirect',
                            amount: 8000,
                            currency: 'yen',
                            type: 'ideal'))
                        .then((source) {
                      setState(() {
                        _source = source;
                      });
                    }).catchError(getError);
                  },
                ),
                Row(
                  children: [
                    MaterialButton(
                      child: Text('Token with Card Form'),
                      onPressed: () {
                        StripePayment.paymentRequestWithCardForm(
                                CardFormPaymentRequest())
                            .then((paymentMethod) {
                          setState(() {
                            _paymentMethod = paymentMethod;
                          });
                        }).catchError(getError);
                      },
                    ),
                    MaterialButton(
                      child: Text('Token with Card'),
                      onPressed: () {
                        StripePayment.createTokenWithCard(creditCard)
                            .then((token) {
                          setState(() {
                            _token = token;
                          });
                        }).catchError(getError);
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      child: Text('Payment Method'),
                      onPressed: () {
                        StripePayment.createPaymentMethod(
                                PaymentMethodRequest(card: creditCard))
                            .then((paymentMethod) {
                          setState(() {
                            _paymentMethod = paymentMethod;
                          });
                        }).catchError(getError);
                      },
                    ),
                    MaterialButton(
                      child: Text('Payment Method with token'),
                      onPressed: _token == null
                          ? null
                          : () {
                              StripePayment.createPaymentMethod(
                                      PaymentMethodRequest(
                                          card: CreditCard(
                                              token: _token.tokenId)))
                                  .then((paymentMethod) {
                                setState(() {
                                  _paymentMethod = paymentMethod;
                                });
                              }).catchError(getError);
                            },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      child: Text('Get Payment Intent'),
                      onPressed: _paymentMethod == null || _secretKey == null
                          ? null
                          : () {
                              StripePayment.confirmPaymentIntent(PaymentIntent(
                                      clientSecret: _secretKey,
                                      paymentMethodId: _paymentMethod.id))
                                  .then((paymentIntent) {
                                setState(() {
                                  _paymentIntentResult = paymentIntent;
                                });
                              }).catchError(getError);
                            },
                    ),
                    MaterialButton(
                      child: Text('Autheticate Payment Intent'),
                      onPressed: _paymentMethod == null || _secretKey == null
                          ? null
                          : () {
                              StripePayment.authenticatePaymentIntent(
                                clientSecret: _secretKey,
                              ).then((paymentIntent) {
                                setState(() {
                                  _paymentIntentResult = paymentIntent;
                                });
                              }).catchError(getError);
                            },
                    ),
                  ],
                ),
                Text('Source:'),
                Text(JsonEncoder.withIndent(' ')
                    .convert(_source?.toJson() ?? {})),
                Text('Token:'),
                Text(JsonEncoder.withIndent(' ')
                    .convert(_token?.toJson() ?? {})),
                Text('Payment Method:'),
                Text(JsonEncoder.withIndent(' ')
                    .convert(_paymentMethod?.toJson() ?? {})),
                Text('Payment Intent:'),
                Text(JsonEncoder.withIndent(' ')
                    .convert(_paymentIntentResult?.toJson() ?? {})),
                Text('Error'),
                Text(_error.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goTimerPage(BuildContext context) {
    Navigator.pushNamed(context, TimerRoute);
    print("goTimerPage was triggered");
  }
}
