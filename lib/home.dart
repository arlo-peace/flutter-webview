import 'package:app_frame/config.dart';
import 'package:app_frame/webview.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
          appBar: null,
          body: MyWebViewWidget(initialUrl: webUrl),
        ),
    );
  }
}
