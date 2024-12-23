import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  debugPrint("Flutter app started");
  print("Flutter app started");
   WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FlutterChannel(),
    );
  }
}

class FlutterChannel extends StatefulWidget {
  const FlutterChannel({super.key});

  @override
  _FlutterChannelState createState() => _FlutterChannelState();
}

class _FlutterChannelState extends State<FlutterChannel> {
  static const platform = MethodChannel('com.example.testaar/native');
  String _receivedData = 'No data yet';

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    try {
      if (call.method == 'sendData') {
        final receivedData = call.arguments as String?;
        if (receivedData != null) {
          setState(() {
            _receivedData = receivedData;
          });
        } else {
          print("Received null data from Android.");
        }
      } else {
        print("Unknown method called: ${call.method}");
      }
    } catch (e) {
      print("Error handling method call: $e");
    }
  }

  @override
  void dispose() {
    platform.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Module')),
      body: Center(
        child: Text('Received: $_receivedData'),
      ),
    );
  }
}

