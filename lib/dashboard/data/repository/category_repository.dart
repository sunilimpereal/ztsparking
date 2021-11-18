import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ztsparking/dashboard/data/models/category.dart';
import 'package:ztsparking/dashboard/data/models/ticket.dart';

import '../../../main.dart';
import '../../../repository/repositry.dart';
import '../../../services/printer.dart';
import '../../../utils/methods.dart';

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
    required List<CategoryModel> categorylist,
  }) async {
    Map<String, String>? postheaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPref.token}',
    };
    Ticket ticket = getTicket(categorylist);
    // final response = await API.post(
    //     url: 'ticket/',
    //     headers: postheaders,
    //     context: context,
    //     body: ticketToJson([ticket]),
    //     logs: true);
    await printticket(categorylist[0], ticket, context, "123466");
    return true;

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   try {
    //     List<PostTicketResponse> ticketResponse = postTicketResponseFromJson(response.body);

    //     await printticket(categorylist, ticket, context, ticketResponse);
    //     return true;
    //   } catch (e) {
    //     return false;
    //   }
    // } else {
    //   return false;
    // }
  }

  Future<void> printticket(
      CategoryModel category, Ticket ticket, BuildContext context, String qrCode) async {
    Printer printer = Printer();
    String violations = "";
    Map<String, dynamic> data = {
      'dateTime': "${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
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
    };
    final result = await printer.printReceipt(data);

    //TODO
    // final pdfFile = await ParkingPdf.parkingBill(
    //   listCategory: categorylist,
    //   ticketNumber: ticket.number,
    //   dateTime: ticket.issuedTs,
    //   total: getTotalCategory(categorylist),
    //   qrImage: await toQrImageData(ticketResponse[0].uuid),
    // );
    // final pdf = pdfFile.readAsBytes();
    // // List<Printer> printerList = await Printing.listPrinters();
    // // log("fxcgvhbj" + printerList.toString());

    // String path = await createFolderInAppDocDir("bills");
    // ParkingPdf.openFile(pdfFile.renameSync('$path/${ticket.number}.pdf'));
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
