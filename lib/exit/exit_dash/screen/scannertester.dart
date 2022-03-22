import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScannerTest extends StatefulWidget {
  const ScannerTest({Key? key}) : super(key: key);

  @override
  _ScannerTestState createState() => _ScannerTestState();
}

List<String> scannedTickets = [];
String qrCode = "";

class _ScannerTestState extends State<ScannerTest> {
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) async {
        if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
          setState(() {
            scannedTickets.add(qrCode);
            qrCodeScan(
              context: context,
              qrCode: qrCode.trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n"),
            );
          });
        } else {
          if (event.character != null) {
            log(event.character??'');
            qrCode = qrCode + event.character!;
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                Text("qr data"),
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height*0.8,
                  child: Column(
                    children: scannedTickets.map((e) => Text("code: $e")).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void qrCodeScan({required BuildContext context, required String qrCode}) {

  }
}
