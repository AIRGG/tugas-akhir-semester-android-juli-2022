import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project4_adblock_android/screens/list-news.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomepageScreen extends StatefulWidget {
  HomepageScreen({Key? key}) : super(key: key);

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  // late final Future<WebViewController> controller;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    // var appDir = (await getTemporaryDirectory()).path;
    // new Directory(appDir).delete(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     // This is the theme of your application.
    //     //
    //     // Try running your application with "flutter run". You'll see the
    //     // application has a blue toolbar. Then, without quitting the app, try
    //     // changing the primarySwatch below to Colors.green and then invoke
    //     // "hot reload" (press "r" in the console where you ran "flutter run",
    //     // or simply save your changes to "hot reload" in a Flutter IDE).
    //     // Notice that the counter didn't reset back to zero; the application
    //     // is not restarted.
    //     primarySwatch: Colors.blue,
    //   ),
    //   // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    //   home: WebView(
    //     onWebViewCreated: (webViewController) {
    //       _controller.complete(webViewController);
    //       webViewController.clearCache();
    //       final cookieManager = CookieManager();
    //       cookieManager.clearCookies();
    //     },
    //     initialUrl: 'http://192.168.1.19:809/Project4-Adblock-integration/',
    //     javascriptMode: JavascriptMode.unrestricted,
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                // print('Hi');
                // _controller.future(
                //     'http://192.168.1.19:809/Project4-Adblock-integration/');
                // _onReload(controller, context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomepageScreen()),
                );
              }),
          IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                // print('Hi');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListNewsScreen()),
                );
              }),
        ],
      ),
      body: WebView(
        onWebViewCreated: (webViewController) {
          _controller.complete(webViewController);
          webViewController.clearCache();
          final cookieManager = CookieManager();
          cookieManager.clearCookies();
        },
        initialUrl:
            'http://${dotenv.env['api_host'].toString()}/Project4-Adblock-integration/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  Future<void> _onReload(
      WebViewController controller, BuildContext context) async {
    // final String contentBase64 =
    //     base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    // await controller.loadUrl('data:text/html;base64,$contentBase64');
    await controller.loadUrl(
        'http://${dotenv.env['api_host'].toString()}/Project4-Adblock-integration/');
  }
}
