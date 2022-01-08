import 'package:flutter/material.dart';
import 'package:ztsparking/entry/entry_dash/dashboard_screen.dart';
import 'package:ztsparking/exit/exit_dash/ExitDashboardScreen.dart';

class SelectType extends StatefulWidget {
  const SelectType({Key? key}) : super(key: key);

  @override
  _SelectTypeState createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => DashBoardWrapper()));
                },
                child: Text("Entry")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => ExitDashBoardWrapper()));
                },
                child: Text("Exit"))
          ],
        ),
      ),
    );
  }
}
