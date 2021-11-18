import 'dart:developer';

import 'package:flutter/material.dart';

import '../../services/printer.dart';

class SelectPrinter2 extends StatefulWidget {
  const SelectPrinter2({Key? key}) : super(key: key);

  @override
  _SelectPrinter2State createState() => _SelectPrinter2State();
}

class _SelectPrinter2State extends State<SelectPrinter2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await Printer().selectPrinter();
              },
              child: const Text(
                "check",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
