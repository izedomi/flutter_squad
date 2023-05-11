import 'package:flutter/material.dart';
import '../flutter_squad.dart';

class Squad {
  static Future<SquadTransactionResponse?> checkout(
    BuildContext context,
    Charge payload, {
    bool displayToast = true,
    bool sandbox = true,
    bool showAppbar = true,
    ToastConfig? toast,
    AppBarConfig? appBar,
  }) async {
    SquadTransactionResponse? transactionResponse = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SquadWebview(
                payload,
                sandbox: sandbox,
                displayToast: displayToast,
                toast: toast,
                showAppbar: showAppbar,
                appBar: appBar,
              )),
    );
    return transactionResponse;
  }
}
