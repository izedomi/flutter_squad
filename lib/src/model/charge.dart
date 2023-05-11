import 'dart:convert';

Charge chargeFromJson(String str) => Charge.fromJson(json.decode(str));
String chargeToJson(Charge data) => json.encode(data.toJson());

class Charge {
  String publicKey;
  String email;
  int amount;
  String currencyCode;
  String? secretKey;
  String? transactionRef;
  List<String> paymentChannels;
  String? customerName;
  String? callbackUrl;
  dynamic metadata;
  bool? passCharge;

  Charge({
    required this.publicKey,
    required this.email,
    required this.amount,
    required this.currencyCode,
    this.secretKey,
    this.transactionRef,
    this.paymentChannels = const [],
    this.customerName,
    this.callbackUrl,
    this.metadata,
    this.passCharge,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
        publicKey: json["publicKey"],
        secretKey: json["secretKey"],
        email: json["email"],
        amount: json["amount"],
        transactionRef: json["transactionRef"],
        currencyCode: json["currencyCode"],
        paymentChannels:
            List<String>.from(json["paymentChannels"].map((x) => x)),
        customerName: json["customerName"],
        callbackUrl: json["callbackUrl"],
        metadata: json["metadata"],
        passCharge: json["passCharge"],
      );

  Map<String, dynamic> toJson() => {
        "key": publicKey,
        "email": email,
        "amount": amount,
        "transactionRef": transactionRef,
        "currencyCode": currencyCode,
        "paymentChannels": List<dynamic>.from(paymentChannels.map((x) => x)),
        "customerName": customerName,
        "callbackUrl": callbackUrl,
        "metadata": metadata,
        "passCharge": passCharge,
      };
}
