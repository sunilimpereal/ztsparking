import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ztsparking/exit/exit_dash/data/model/ticket_detail.dart';
import 'package:ztsparking/repository/repositry.dart';

import '../../../../../main.dart';

class ScannerRepository {
  static Future<TicketDetail?> scanTicket(
      {required BuildContext context, required String ticketNumber}) async {
    try {
      // Map<String, String>? postheaders = {
      //   'Accept': 'application/json',
      //   'Authorization': 'Bearer ${sharedPref.token}',
      // };
      Map<String, String>? headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPref.token}',
      };

      final response = await API.get(
          url: 'qr_code/?uuid=$ticketNumber',
          apiRoot: config.API_ROOTV1,
          context: context,
          headers1: headers);
      if (response.statusCode == 200) {
        TicketDetail ticketDetail = ticketDetailFromJson(response.body)[0];
        if (!ticketDetail.isScanned) {
          log('is_scanned ${ticketDetail.isScanned}');
          final responsePatch = await API.patch(
              url: 'qr_code/${ticketDetail.id}/',
              context: context,
              apiRoot: config.API_ROOTV1,
              body: '{"is_scanned": true }');
          if (responsePatch.statusCode == 200) {
             TicketDetail ticketDetailPatch = ticketDetailSingleFromJson(responsePatch.body);
             ticketDetailPatch.isScanned = false;
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
          apiRoot: config.API_ROOTV1,
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
