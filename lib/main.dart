import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Webview Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: WebViewSample(title: 'Flutter Webview Demo'),
    );
  }
}

class WebViewSample extends StatefulWidget {
  WebViewSample({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StatefulWidget> createState() => _WebViewSampleState();
}

class _WebViewSampleState extends State<WebViewSample> {
  WebViewController _controller;
  bool _canGoBack = false;
  bool _canGoForward = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview Demo'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _controller.reload();
              },
          ),
          IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(title: Text('webviewの上に表示'),);
                });
              },
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'https://youtube.com/',
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {
          JavascriptChannel(
            name: 'Print',
            onMessageReceived: (message) {
              print(message.message);
            },
          ),
        },
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
        onPageFinished: (value) async {
          _canGoBack = await _controller.canGoBack();
          _canGoForward = await _controller.canGoForward();
          setState(() {});
        },
        onWebResourceError: (error) {
          print('onWebResourceError : $error');
        },
      ),
      persistentFooterButtons: [
        IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _canGoBack ? _controller.goBack : null,
        ),
        IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _canGoForward ? _controller.goForward: null,
        )
      ],
    );
  }
}
