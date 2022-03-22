import 'package:flutter/material.dart';
import 'package:ztsparking/entry/entry_dash/dashboard_screen.dart';
import 'package:ztsparking/entry/entry_dash/data/repository/category_repository_bloc.dart';
import 'package:ztsparking/entry/ticket/data/repository/ticket_bloc.dart';
import 'package:ztsparking/exit/exit_dash/screen/dashboard_home.dart';


class ExitDashBoardWrapper extends StatefulWidget {
  const ExitDashBoardWrapper({Key? key}) : super(key: key);

  @override
  _ExitDashBoardWrapperState createState() => _ExitDashBoardWrapperState();
}

class _ExitDashBoardWrapperState extends State<ExitDashBoardWrapper> {
  @override
  Widget build(BuildContext context) {
    return CategoryProvider(
      context: context,
      child: TicketProvider(
        context: context,
        child: ExitDashboardScanScreen(),
      ),
    );
  }
}

