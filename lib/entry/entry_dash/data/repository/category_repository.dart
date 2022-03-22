import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ztsparking/entry/entry_dash/data/models/category.dart';
import 'package:ztsparking/entry/entry_dash/data/models/post_ticekt_response.dart';
import 'package:ztsparking/entry/ticket/data/models/ticket.dart';


import 'package:ztsparking/repository/repositry.dart';
import 'package:ztsparking/services/printer.dart';
import 'package:ztsparking/utils/methods.dart';

import '../../../../main.dart';



class CategoryRepository {
  Future<List<CategoryModel>> getCategory(BuildContext context) async {
    Map<String, String>? headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    final response = await API.get(url: 'category/', context: context, headers1: headers);
    if (response.statusCode == 200) {
      List<CategoryModel> categoryList = categoryModelFromJson(response.body);
      return categoryList;
    } else {
      return [];
    }
  }

  Future<bool> generateTicket({
    required BuildContext context,
    required CategoryModel category,
    required String vehicleNumber,
  }) async {
    Map<String, String>? postheaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    Ticket ticket = getTicket([category]);
    final response = await API.post(
      url: 'ticket/',
      headers: postheaders,
      context: context,
      body: ticketToJson([ticket]),
      logs: true,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        List<PostTicketResponse> ticketResponse = postTicketResponseFromJson(response.body);

        await printticket(
          category: category,
          context: context,
          qrCode: ticketResponse[0].uuid,
          ticket: ticket,
          vehicleNumber: vehicleNumber,
        );
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> printticket(
      {required CategoryModel category,
      required Ticket ticket,
      required BuildContext context,
      required String qrCode,
      required String vehicleNumber}) async {
    Printer printer = Printer();
    String violations = "";
    Map<String, dynamic> data = {
      'dateTime': "${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())}",
      'categoryName': category.name,
      'lineItems': category.subcategories
          .where((element) => element.quantity != 0)
          .toList()
          .map((e) => "${e.name} ${e.type}")
          .toList(),
      'lineitemQty': category.subcategories
          .where((element) => element.quantity != 0)
          .toList()
          .map((e) => e.quantity.toString())
          .toList(),
      'lineitemTotal': category.subcategories
          .where((element) => element.quantity != 0)
          .toList()
          .map((e) => "${e.quantity * e.price}")
          .toList(),
      'ticketTotal': getTotalCategory([category]).toString(),
      'ticketNumber': ticket.number,
      "qrCode": qrCode,
      "vehicleNumber": vehicleNumber,
      "isExitTicket": false
    };
    final result = await printer.printReceipt(data);
    log(result.toString());

    return result;
  }

  Future<bool> bottleScan({required BuildContext context, required String barcode}) async {
    //  final response =
    //     await API.post(url: 'ticket/', context: context, body: ticketToJson([ticket]), logs: true);
    bool a = await Future.delayed(const Duration(seconds: 1)).then((value) {
      if (barcode == '11111') {
        return true;
      } else {
        return false;
      }
    });

    return a;
  }
}
