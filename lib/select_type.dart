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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => DashBoardWrapper()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Entry"),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => ExitDashBoardWrapper()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Exit "),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
