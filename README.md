## Android
<p float="left">
  <img src="https://raw.githubusercontent.com/izedomi/flutter_squad/main/example/screenshots/android1.png" width="250">
  <img src="https://raw.githubusercontent.com/izedomi/flutter_squad/example/main/screenshots/android2.png" width="250">
  <img src="https://raw.githubusercontent.com/izedomi/flutter_squad/example/main/screenshots/android3.png" width="250">
</p>

## IOS
<p float="left">
  <img src="https://raw.githubusercontent.com/izedomi/flutter-monnify/main/example/screenshots/ios1.png" width="250">
  <img src="https://raw.githubusercontent.com/izedomi/flutter-monnify/main/example/screenshots/ios2.png" width="250">
  <img src="https://raw.githubusercontent.com/izedomi/flutter-monnify/main/example/screenshots/ios3.png" width="250">
</p>

## Flutter Squad Package
A Flutter package for making payments via Squad Payment Gateway. Android and iOS supported.

## Getting Started
To use this package, add `flutter_squad` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## How to use

``` dart
import 'package:flutter_squad/flutter_squad.dart';

SquadTransactionResponse? response = await Squad.checkout(context, charge(), isSandbox: true);

 Charge charge() {
    return Charge(
        amount: 10000,
        publicKey: [Your Public Key], // e.g "sandbox_pk_a7ce8374b818a8e2b67444440027f256b7d53ec0645dc7a3b",
        secretKey: [Your Secret Key], // e.g  "sandbox_sk_a7ce8374b818a8e2b67444440127f5f6f7133f30a25a50d3d"
        email: "customer@gmail.com",
        currencyCode: "NGN",
        transactionRef: [Your Transaction Ref], // e.g "SQUAD-PYM-JIKW1223_"
        paymentChannels: ["card", "bank", "ussd", "transfer"],
        customerName: "Customer Name",
        callbackUrl: null,
        metadata: {"deviceType": "ios"},
        passCharge: false);
  }
 
```
No other configuration required&mdash;the plugin works out of the box.

## Parameters
To initialize a transaction, you need to pass details such as email, first name, last name, amount, transaction reference, etc to the Squad.checkout() method. The Email, amount, and currency are required. You can also pass any other additional information in the metadata field.

To Customize the appbar to suit your project's theme color use the `AppConfig` object on the Squad.checkout() method.

## Example
``` dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_squad/flutter_squad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Squad Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SquadExample());
  }
}

class SquadExample extends StatefulWidget {
  const SquadExample({super.key});

  @override
  State<SquadExample> createState() => _SquadExampleState();
}

class _SquadExampleState extends State<SquadExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text("Pay With Squad"),
              onPressed: () async {
                SquadTransactionResponse? response =
                    await Squad().checkout(context, charge(), isSandbox: true);
                print(
                    "Squad transaction completed======>${response?.toJson().toString()}");
              },
            ),
          ],
        ),
      ),
    ));
  }

  Charge charge() {
    return Charge(
        amount: 10000,
        publicKey:
            "sandbox_pk_a7ce8374b818a8e2b67444440027f256b7d53ec0645dc7a3b",
        secretKey:
            "sandbox_sk_a7ce8374b818a8e2b67444440127f5f6f7133f30a25a50d3d",
        email: "emma@yopmail.com",
        currencyCode: "NGN",
        transactionRef: "SQUAD-PYM-${generateRandomString(10)}",
        paymentChannels: ["card", "bank", "ussd", "transfer"],
        customerName: "Emmanuel Izedomi",
        callbackUrl: null,
        metadata: {"name": "Damilare", "age": 45},
        passCharge: false);
  }

  String generateRandomString(int len) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}

```

The `Squad.checkout()` method returns a `SquadTransactionResponse` object for a successful transaction with the following properties:

``` dart
  int? status;
  bool? success;
  String? message;
  Data? data;
```

The transaction is successful if `status` is `200` or `202`. 200 represents a `verified` successful transaction. 202 represents an `unverified` successful transaction.

More on verifying a transaction, [see docs](https://squadinc.gitbook.io/squad/payments/accept-payments-1)

For a verified successful transaction (i.e status is 200) the data property on the SquadTransactionResponse contains a Data object with the transaction details:

``` dart
  int? transactionAmount;
  String? transactionRef;
  String? email;
  String? transactionStatus;
  String? transactionCurrencyId;
  DateTime? createdAt;
  String? transactionType;
  String? merchantName;
  String? merchantBusinessName;
  String? gatewayTransactionRef;
  String? merchantEmail;
  dynamic meta;

```

For an unverified successful transaction (i.e status is 202) the data property on the SquadTransactionResponse is null

It is recommended to verify the transaction status with the backend before providing value. By default, the package does not verify your transactions. To allow the `flutter_squad` package verify your transaction after successful payment, add the `secretKey` to the charge object.


For a failed transaction, the `Squad.checkout()` method returns null.

## Contributing, Issues and Bug Reports

The project is open to public contribution. Please feel very free to contribute.
Experienced an issue or want to report a bug? Please, [report it here](https://github.com/izedomi/flutter_squad/issues). Remember to be as descriptive as possible.


## Need More Information?

For further info about Squad Payment, including transaction response types, see [Squad API Documentation](https://squadinc.gitbook.io/squad/)



