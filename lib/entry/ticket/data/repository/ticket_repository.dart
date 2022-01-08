import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ztsparking/entry/entry_dash/data/models/generated_tickets.dart';
import 'package:ztsparking/entry/ticket/data/models/ticket_report_model.dart';
import 'package:ztsparking/repository/repositry.dart';
import 'package:ztsparking/utils/methods.dart';
import 'package:ztsparking/utils/shared_pref.dart';

import '../../../../main.dart';
import '../models/line_summary_model.dart';

class TicketRepository {
  Future<List<GeneratedTickets>> getRecentTickets(
      {required BuildContext context, required bool showonlyHour}) async {
    DateTime date = DateTime.now();
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    // ${date.day}
    final response = await API.get(
        url:
            'ticket/?issued_ts__year=${date.year}&issued_ts__month=${date.month}&issued_ts__day=${date.day}',
        context: context,
        headers1: headers);
    if (response.statusCode == 200) {
      List<GeneratedTickets> ticketList = generatedTicketsFromJson(response.body);
      ticketList.sort((b, a) {
        return a.issuedTs.compareTo(b.issuedTs);
      });
      getRole() != 'admin'
          ? ticketList = ticketList
              .where((element) => element.userEmail == "${sharedPrefs.userEmail}")
              .toList()
          : null;
      return ticketList;
    } else {
      return [];
    }
  }

  Future<List<TicketReportItem>> getTicketReport(
      {required BuildContext context, required bool showonlyHour}) async {
    DateTime date = DateTime.now();
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    // ${date.day}
    final response = await API.get(
        url:
            'ticket_report/?issued_ts__year=${date.year}&issued_ts__month=${date.month}&issued_ts__day=${date.day}${showonlyHour ? "&issued_ts__hour=${date.hour}" : ""}',
        context: context,
        headers1: headers);
    if (response.statusCode == 200) {
      List<TicketReportItem> ticketList = ticketReportItemFromJson(response.body);
      ticketList.sort((b, a) {
        return a.issuedTs.compareTo(b.issuedTs);
      });
      getRole() != 'admin'
          ? ticketList = ticketList
              .where((element) => element.userEmail == "${sharedPrefs.userEmail}")
              .toList()
          : null;
      return ticketList;
    } else {
      return [];
    }
  }

  Future<List<LineSumryItem>> getFiletredLineItems(BuildContext context, DateTime date) async {
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    final response = await API.get(
        headers1: headers,
        url: getRole() == 'admin' || getRole() == 'manager'
            ? 'get-lineitems/?start_date=${date.toString().substring(0, 10)}&end_date=${date.toString().substring(0, 10)}'
            : 'get-lineitems/?user_email=${sharedPrefs.userEmail}&start_date=${date.toString().substring(0, 10)}&end_date=${date.toString().substring(0, 10)}',
        context: context);
    if (response.statusCode == 200) {
      List<LineSumryItem> ticketList = lineSumryItemFromJson(response.body);
      return ticketList;
    } else {
      return [];
    }
  }

  Future<bool> getTicketQrData(BuildContext context, String ticketId) async {
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    final response = await API.get(
        headers1: headers, url: 'qr_code_ticket/?offline_ticket=$ticketId', context: context);
    if (response.statusCode == 200) {
      bool isScanned = json.decode(response.body)[0]['is_scanned'] ?? false;
      return isScanned;
    } else {
      return false;
    }
  }
}
