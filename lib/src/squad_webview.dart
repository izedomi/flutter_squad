import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_squad/src/services/api_service.dart';
import 'package:flutter_squad/src/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../flutter_squad.dart';
import 'model/env.dart';

class SquadWebview extends StatefulWidget {
  ///Transaction payload
  final Charge charge;

  ///display toast to user based on sdk state
  final bool displayToast;

  ///dev environment
  final bool sandbox;

  ///dev environment
  final bool showAppbar;

  /// Customize how toast is displayed
  final ToastConfig? toast;

  /// Customize look of the appbar
  final AppBarConfig? appBar;

  const SquadWebview(this.charge,
      {Key? key,
      this.displayToast = true,
      this.sandbox = true,
      this.showAppbar = true,
      this.toast,
      this.appBar})
      : super(key: key);
  @override
  State<SquadWebview> createState() => _SquadWebviewState();
}

class _SquadWebviewState extends State<SquadWebview>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _start = 0;
  late WebViewPlusController _controller;
  double loadProgress = 0;
  late Map<String, dynamic> payload;
  String url = 'https://squad-web-two.vercel.app';
  bool verifyingTransaction = false;
  bool sdkReturnedSuccess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    payload = widget.charge.toJson();
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      show: verifyingTransaction,
      child: Scaffold(
        appBar: widget.showAppbar
            ? AppBar(
                title: Text(widget.appBar?.title ?? "Squad"),
                elevation: 0,
                backgroundColor: widget.appBar?.color,
                leading: widget.appBar?.leadingIcon ??
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        // color: baseBlack,
                      ),
                    ),
                actions: [
                  IconButton(
                    onPressed: () {
                      _controller.loadUrl(url);
                    },
                    icon: const Icon(Icons.refresh
                        // color: baseBlack,
                        ),
                  ),
                ],
              )
            : null,
        body: SafeArea(
          child: SizedBox(
              width: deviceWidth(context),
              height: deviceHeight(context),
              child: Column(
                children: [
                  loadProgress < 1.0
                      ? Expanded(
                          flex: loadProgress < 1.0 ? 10 : 0,
                          child: _loadingView())
                      : Container(),
                  Expanded(flex: 1, child: _mainView()),
                ],
              )),
        ),
        bottomSheet: _start > 0
            ? Container(
                width: double.infinity,
                height: 80,
                alignment: Alignment.center,
                child: Text("Returning to merchant in $_start"),
              )
            : null,
      ),
    );
  }

  Widget _loadingView() {
    return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: const Center(child: CircularProgressIndicator.adaptive()));
  }

  Widget _mainView() {
    return WebViewPlus(
      initialUrl: "about:blank",
      onWebViewCreated: (WebViewPlusController controller) {
        _controller = controller;
        controller.loadUrl(url);
      },
      onPageFinished: (String url) async {
        // print('Page finished loading: $url');

        await _controller.webViewController
            .runJavascript('showpaymentModal(${json.encode(payload)})');
      },
      onProgress: (int progress) {
        setState(() {
          loadProgress = progress / 100;
        });
      },
      debuggingEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>{
        _squadJavascriptChannel(),
      },
    );
  }

  JavascriptChannel _squadJavascriptChannel() {
    return JavascriptChannel(
        name: 'flutterClient',
        onMessageReceived: (JavascriptMessage message) {
          Map<String, dynamic> response = json.decode(message.message);
          if (kDebugMode) {
            print(response["message"]);
            print(response["data"]);
            print(response.toString());
            print("========");
          }
          returnTransactionStatus(response);
        });
  }

  returnTransactionStatus(Map<String, dynamic> response) {
    String toastMessage = response["message"] ?? "";

    //returns to the calling screen if "returnToCaller" is true
    if (response.containsKey("returnToClient") && response["returnToClient"]) {
      //show toast message
      if (widget.displayToast) {
        showToast(toastMessage);
      }

      //return transaction response
      if (response["message"].toLowerCase().contains("success")) {
        startTimer(5);
        sdkReturnedSuccess = true;
      } else {
        if (!sdkReturnedSuccess) {
          _leavePaymentPage();
        }
      }
    } else {
      if (widget.displayToast) {
        showToast(toastMessage);
      }
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: widget.toast?.length ?? Toast.LENGTH_LONG,
        gravity: widget.toast?.position ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: widget.toast?.backgroundColor ?? Colors.grey,
        textColor: widget.toast?.color ?? Colors.black,
        fontSize: widget.toast?.fontSize ?? 16.0);
  }

  void startTimer(int seconds) {
    setState(() => _start = seconds);
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          verifyTransaction(widget.charge);
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  verifyTransaction(Charge charge) async {
    if (_canVerifyTransaction(charge)) {
      setState(() => verifyingTransaction = true);
      SquadTransactionResponse response = await ApiService(
              transactionRef: widget.charge.transactionRef!,
              secretKey: widget.charge.secretKey!,
              env: Env.sandbox)
          .verifyTransaction();
      setState(() => verifyingTransaction = false);
      _leavePaymentPage(response: response);
    }
    _leavePaymentPage(
        response: SquadTransactionResponse(
            success: true, status: 202, message: "Success"));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _canVerifyTransaction(Charge charge) {
    return widget.charge.transactionRef != null &&
        widget.charge.transactionRef!.isNotEmpty &&
        widget.charge.secretKey != null &&
        widget.charge.secretKey!.isNotEmpty;
  }

  _leavePaymentPage({SquadTransactionResponse? response}) {
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context, response);
    }
  }
}
