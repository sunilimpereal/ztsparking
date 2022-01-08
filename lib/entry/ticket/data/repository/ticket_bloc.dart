import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ztsparking/entry/entry_dash/data/models/generated_tickets.dart';
import 'package:ztsparking/entry/ticket/data/models/line_summary_model.dart';
import 'package:ztsparking/entry/ticket/data/models/ticket_report_model.dart';
import 'package:ztsparking/entry/ticket/data/repository/ticket_repository.dart';
import 'package:ztsparking/utils/bloc.dart';


class RecentTicketBloc extends Bloc {
  BuildContext context;
  RecentTicketBloc(this.context) {
    getRecentTickets();
    getTicketReport();
    getLineItemSumry(DateTime.now());
  }
  final _recentTicektcontroller = BehaviorSubject<List<GeneratedTickets>>();
  final _ticektReportcontroller = BehaviorSubject<List<TicketReportItem>>();
  final _lineItemSumrycontroller = BehaviorSubject<List<LineSumryItem>>();
  DateTime selectedDate = DateTime.now();
  Stream<List<GeneratedTickets>> get recentTicketStream =>
      _recentTicektcontroller.stream.asBroadcastStream();
  Stream<List<TicketReportItem>> get ticketReportStream =>
      _ticektReportcontroller.stream.asBroadcastStream();
  Stream<List<LineSumryItem>> get lineItemSummary =>
      _lineItemSumrycontroller.stream.asBroadcastStream();

  Future<bool> getRecentTickets() async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getRecentTickets(context: context, showonlyHour: true);
    _recentTicektcontroller.sink.add(result);
    return true;
  }

  Future<Null> getTicketReport({bool? showonlyHour}) async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getTicketReport(
        context: context, showonlyHour: showonlyHour ?? true);
    _ticektReportcontroller.sink.add(result);
    return null;
  }

  void getLineItemSumry(DateTime date) async {
    TicketRepository ticketRepository = TicketRepository();
    final result = await ticketRepository.getFiletredLineItems(context, date);
    selectedDate = date;
    _lineItemSumrycontroller.sink.add(result);
  }

  @override
  void dispose() {
    _recentTicektcontroller.close();
    _ticektReportcontroller.close();
  }
}

class TicketProvider extends InheritedWidget {
  late RecentTicketBloc bloc;
  BuildContext context;
  TicketProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = RecentTicketBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static RecentTicketBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<TicketProvider>() as TicketProvider).bloc;
  }
}
