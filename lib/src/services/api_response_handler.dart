import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../flutter_squad.dart';

class DioResponseHandler {
  static SquadTransactionResponse parseResponse(Response res) {
    if (kDebugMode) {
      print("Response Code: ${res.statusCode}");
      print("Response Body: ${res.data}");
    }

    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 202) {
      try {
        final response = res.data;
        return squadTransactionResponseFromJson(json.encode(response));
      } catch (e) {
        return SquadTransactionResponse(
            status: 202, success: true, message: "Success");
      }
    } else {
      return SquadTransactionResponse(
          status: 202, success: true, message: "Success");
    }
  }

  static SquadTransactionResponse handleError(DioError e) {
    final dioError = e;
    switch (dioError.type) {
      case DioErrorType.badResponse:
        return SquadTransactionResponse(
            status: dioError.response?.statusCode ?? 400,
            success: false,
            message: dioError.response?.data["message"] ?? "");
      case DioErrorType.cancel:
        return _errorResponse("Request cancelled");
      default:
        return _errorResponse("Server error");
    }
  }

  static SquadTransactionResponse _errorResponse(String msg) {
    return SquadTransactionResponse(status: 500, success: false, message: msg);
  }
}
