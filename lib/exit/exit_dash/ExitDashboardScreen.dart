import 'package:flutter/material.dart';
import 'package:ztsparking/entry/entry_dash/dashboard_screen.dart';
import 'package:ztsparking/entry/entry_dash/data/repository/category_repository_bloc.dart';
import 'package:ztsparking/entry/ticket/data/repository/ticket_bloc.dart';


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
        child: DashboardScreen(),
      ),
    );
  }
}

class ExitDashboardScreen extends StatefulWidget {
  const ExitDashboardScreen({Key? key}) : super(key: key);

  @override
  _ExitDashboardScreenState createState() => _ExitDashboardScreenState();
}

class _ExitDashboardScreenState extends State<ExitDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
