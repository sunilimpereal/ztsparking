import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:ztsparking/constants/config_.dart';
import 'package:ztsparking/entry/entry_dash/data/models/category.dart';
import 'package:ztsparking/exit/exit_dash/data/model/ticket_detail.dart';
import 'package:ztsparking/repository/repositry.dart';
import 'package:ztsparking/services/printer.dart';
import 'package:ztsparking/utils/methods.dart';

import '../../../../main.dart';

class ScannerRepository {
  Future<bool> printticket({
    required TicketDetail ticketDetail,
    required BuildContext context,
  }) async {
    Printer printer = Printer();
    String violations = "";
    double total = ticketDetail.offlineTicket.price;
    List<String> lineItems =
        ticketDetail.offlineTicket.lineitems.map((e) => "${e.subcategoryName} ${e.type}").toList();

    List<String> lineitemQty =
        ticketDetail.offlineTicket.lineitems.map((e) => e.quantity.toString()).toList();
    List<String> lineitemTotal =
        ticketDetail.offlineTicket.lineitems.map((e) => e.price.toString()).toList();
    if (ticketDetail.offlineTicket.fine > 0) {
      lineItems.add("Overstay Charges");
      lineitemQty.add("");
      lineitemTotal.add("${ticketDetail.offlineTicket.fine}");
      total = total + ticketDetail.offlineTicket.fine;
    }

    Map<String, dynamic> data = {
      'isExitTicket': true,
      'date': "${DateFormat('dd/MM/yyyy').format(ticketDetail.offlineTicket.issuedTs)}",
      'entryTime': "${DateFormat.jm().format(ticketDetail.offlineTicket.issuedTs)}",
      'exitTime':
          "${DateFormat.jm().format(getCurrentDateTime(ticketDetail.offlineTicket.modifiedTs))}",
      'categoryName': "Parking Exit",
      'lineItems': lineItems,
      'lineitemQty': lineitemQty,
      'lineitemTotal': lineitemTotal,
      'ticketTotal': total.toString(),
      'ticketNumber': ticketDetail.offlineTicket.number,
      "qrCode": "0",
      "vehicleNumber": "",
    };
    final result = await printer.printReceipt(data);
    log(result.toString());

    return result;
  }

  Future<TicketDetail?> scanTicket(
      {required BuildContext context, required String ticketNumber}) async {
    try {
      Map<String, String>? headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPref.token}',
      };

      final response = await API.get(
          url: 'qr_code_park/?uuid=$ticketNumber',
          apiRoot: Config().API_ROOTV1,
          context: context,
          headers1: headers);
      if (response.statusCode == 200) {
        TicketDetail ticketDetail = ticketDetailFromJson(response.body)[0];
        if (!ticketDetail.isScanned) {
          log('is_scanned ${ticketDetail.isScanned}');
          final responsePatch = await API.patch(
              url: 'qr_code_park/${ticketDetail.id}/',
              context: context,
              apiRoot: Config().API_ROOTV1,
              body: '{"is_scanned": true }');
          if (responsePatch.statusCode == 200) {
            TicketDetail ticketDetailPatch = ticketDetailSingleFromJson(responsePatch.body);
            ticketDetailPatch.isScanned = false;
            if (ticketDetail.offlineTicket.lineitems[0].category
                .toLowerCase()
                .contains("parking")) {
              printticket(
                ticketDetail: ticketDetailPatch,
                context: context,
              );
            }
            log("post ticket responce : ${responsePatch.body}");
            return ticketDetailPatch;
          }
        } else {
          return ticketDetail;
        }
      } else {
        log('filaed 2');
        return null;
      }
    } catch (e) {
      showToast('Invalid Ticket',
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.top,
          animDuration: Duration(seconds: 1),
          duration: Duration(seconds: 4),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
          backgroundColor: Colors.green);
      log('filaed 3 $e');
      return null;
    }
  }

  Future<bool> scanPass({required BuildContext context, required String qrCode}) async {
    try {
      Map<String, String>? postheaders = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPref.token}',
      };
      final response = await API.post(
          url: 'validate_adoption_pass/',
          apiRoot: Config().API_ROOTV1,
          headers: postheaders,
          context: context,
          body: "{'qr_code': '$qrCode'}");
      if (response.statusCode == 200) {
        return true;
      } else {
        log('filaed 2');
        return false;
      }
    } catch (e) {
      log('filaed 3 $e');
      return false;
    }
  }
}
