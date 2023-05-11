import 'dart:async';
import 'package:dio/dio.dart';
import '../../flutter_squad.dart';
import '../model/env.dart';
import '../model/mode.dart';
import 'api_response_handler.dart';

class ApiService {
  int timeOutDurationInSeconds = 30;
  late Dio dio;

  String transactionRef;
  String secretKey;
  Mode? env = Env.sandbox;

  ApiService(
      {required this.transactionRef, required this.secretKey, this.env}) {
    dio = Dio();
    dio.options.headers = {
      "content-type": "application/json",
      "Authorization": "Bearer $secretKey"
    };
  }
  Future<SquadTransactionResponse> verifyTransaction(
      {String? verifyUrl}) async {
    try {
      Response response = await dio
          .get(verifyUrl ?? "${_getUrl()}/transaction/verify/$transactionRef")
          .timeout(Duration(seconds: timeOutDurationInSeconds));
      return DioResponseHandler.parseResponse(response);
    } on DioError catch (e) {
      return DioResponseHandler.handleError(e);
    }
  }

  String _getUrl() {
    return env == Env.sandbox ? Env.sandbox.url : Env.live.url;
  }
}
