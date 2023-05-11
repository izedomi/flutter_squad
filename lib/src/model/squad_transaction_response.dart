import 'dart:convert';

SquadTransactionResponse squadTransactionResponseFromJson(String str) =>
    SquadTransactionResponse.fromJson(json.decode(str));

String squadTransactionResponseToJson(SquadTransactionResponse data) =>
    json.encode(data.toJson());

class SquadTransactionResponse {
  int? status;
  bool? success;
  String? message;
  Data? data;

  SquadTransactionResponse({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory SquadTransactionResponse.fromJson(Map<String, dynamic> json) =>
      SquadTransactionResponse(
        status: json["status"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
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

  Data({
    this.transactionAmount,
    this.transactionRef,
    this.email,
    this.transactionStatus,
    this.transactionCurrencyId,
    this.createdAt,
    this.transactionType,
    this.merchantName,
    this.merchantBusinessName,
    this.gatewayTransactionRef,
    this.merchantEmail,
    this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactionAmount: json["transaction_amount"],
        transactionRef: json["transaction_ref"],
        email: json["email"],
        transactionStatus: json["transaction_status"],
        transactionCurrencyId: json["transaction_currency_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        transactionType: json["transaction_type"],
        merchantName: json["merchant_name"],
        merchantBusinessName: json["merchant_business_name"],
        gatewayTransactionRef: json["gateway_transaction_ref"],
        merchantEmail: json["merchant_email"],
        meta: json["meta"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_amount": transactionAmount,
        "transaction_ref": transactionRef,
        "email": email,
        "transaction_status": transactionStatus,
        "transaction_currency_id": transactionCurrencyId,
        "created_at": createdAt?.toIso8601String(),
        "transaction_type": transactionType,
        "merchant_name": merchantName,
        "merchant_business_name": merchantBusinessName,
        "gateway_transaction_ref": gatewayTransactionRef,
        "merchant_email": merchantEmail,
        "meta": meta,
      };
}
