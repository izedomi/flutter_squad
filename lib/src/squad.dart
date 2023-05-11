import 'package:flutter/material.dart';
import 'package:flutter_squad/src/squad_webview.dart';

import '../flutter_squad.dart';
import 'model/charge.dart';
import 'model/config.dart';

class Squad {
  Future<SquadTransactionResponse?> checkout(
    BuildContext context,
    Charge payload, {
    bool displayToast = true,
    bool isSandbox = true,
    ToastConfig? toast,
    AppBarConfig? appBar,
  }) async {
    SquadTransactionResponse? transactionResponse = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SquadWebview(
                payload,
              )),
    );
    return transactionResponse;
  }
}
