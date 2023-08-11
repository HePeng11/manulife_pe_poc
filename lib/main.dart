import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String filePath = 'static/index.html';
  static String jsPath = 'static/script.js';

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadFlutterAsset(filePath)
    ..runJavaScript(jsPath);

  @override
  Widget build(BuildContext context) {
    rootBundle
        .loadString(jsPath)
        .then((value) => controller.runJavaScript(value));

    controller.addJavaScriptChannel(
      "getData",
      onMessageReceived: (msg) {
        String mes = msg.message;
        debugPrint('Flutter got js request { $mes } ');
        rootBundle.loadString(msg.message).then(
            (value) => {
              controller.runJavaScript('setFlutterData($value)')
            });
      },
    );

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'PE POC',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      )),
      body: WebViewWidget(controller: controller),
    );
  }

// int _counter = 0;

// void _incrementCounter() {
//   setState(() {
//     _counter++;
//   });
// }

//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       title: Text(widget.title),
//     ),
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           const Text(
//             'You have pushed the button this many times:',
//           ),
//           Text(
//             '$_counter',
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//         ],
//       ),
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed: _incrementCounter,
//       tooltip: 'Increment',
//       child: const Icon(Icons.add),
//     ),
//   );
// }
}
