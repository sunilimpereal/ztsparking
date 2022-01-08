import 'package:flutter/material.dart';
import 'package:ztsparking/entry/entry_dash/dashboard_screen.dart';
import 'package:ztsparking/printer/screens/select_printer_2.dart';

class DrawerWidget extends StatefulWidget {
  String selectedScreen;
  DrawerWidget({Key? key, required this.selectedScreen}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text("Home"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DashBoardWrapper(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Select Printer"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SelectPrinter2(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
