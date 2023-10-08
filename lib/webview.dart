import 'package:app_frame/config.dart';
import 'package:app_frame/progressIcon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebViewWidget extends StatefulWidget {
  final String initialUrl;

  const MyWebViewWidget({
    Key? key,
    required this.initialUrl,
  }) : super(key: key);

  @override
  State<MyWebViewWidget> createState() => _MyWebViewWidgetState();
}

class _MyWebViewWidgetState extends State<MyWebViewWidget>
    with WidgetsBindingObserver {

  WebViewController _controller = WebViewController();
  bool isLoading = true;

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Do you want to exit'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              MaterialButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Yes'),
              ),
            ],
          ));
      return Future.value(true);
    }
  }

  Future<void> _reload() {
      return _controller.reload();
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if(progress==100){
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            print("onPageStarted {$url}");
            setState(() {
              isLoading = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            print("onPageFinished {$url}");
          },
          onWebResourceError: (WebResourceError error) {
            // print("MyWebViewWidget: ${error.errorType}");
            debugPrint('MyWebViewWidget:onWebResourceError(): ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    setState(() {});

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // remove listener
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // on portrait / landscape or other change, recalculate height
  }

  @override
  Widget build(context) {
    return isLoading? Container(
      color: loadBg,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const ProgressWithIcon(),
    ): SingleChildScrollView(
      primary: true,
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-30,
        child: WillPopScope(
          onWillPop: () => _goBack(context),
          child: Builder(
            builder: (context) => WebViewWidget(
              controller: _controller,
              gestureRecognizers: Set()
                ..add(Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer()
                      ..onDown = (DragDownDetails dragDownDetails) {
                        _controller.getScrollPosition().then((value) {
                              // print("Scroll PO: ${value.dy}");
                          if (value.dy == 0 && dragDownDetails.globalPosition.direction < 1) {
                            _controller.reload();
                          }
                        });
                      }
                ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}















































