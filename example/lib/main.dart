import 'package:flutter/material.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String status = 'none';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text('Show dialog'),
                onPressed: () {
                  GdprDialog.instance.resetDecision();
                  GdprDialog.instance
                      .showDialog(isForTest: false, testDeviceId: '')
                      .then((onValue) {
                    setState(() => status = 'dialog result == $onValue');
                  });
                },
              ),
              ElevatedButton(
                child: Text('Get consent status'),
                onPressed: () => GdprDialog.instance.getConsentStatus().then(
                    (value) =>
                        setState(() => status = 'consent status == $value')),
              ),
              Container(height: 50),
              Text(status),
            ],
          ),
        ),
      ),
    );
  }
}
