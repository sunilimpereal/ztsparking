import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ztsparking/entry/entry_dash/data/models/category.dart';
import 'package:ztsparking/entry/ticket/data/models/ticket.dart';
import 'package:ztsparking/utils/shared_pref.dart';
import '../main.dart';

getCurrentDateTime(DateTime date) {
  DateTime newDate = date;
  return newDate.add(const Duration(hours: 5, minutes: 30));
}

cleanQr(String qr) {
  String output = "";
  for (int i = 0; i < qr.length; i++) {
    if (RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(qr[i])) {
      output = output + qr[i];
    }
  }
  return output;
}

String getRole() {
  String yourToken = sharedPref.token ?? "";
  Map<String, dynamic> decodedToken = JwtDecoder.decode(yourToken);
  return decodedToken['role'];
}

Future<String> createFolderInAppDocDir(String folderName) async {
  //Get this App Document Directory

  final Directory _appDocDir = await getApplicationDocumentsDirectory();
  //App Document Directory + folder name
  log(_appDocDir.path);
  final Directory _appDocDirFolder = Directory('${_appDocDir.path}/zts/$folderName/');

  if (await _appDocDirFolder.exists()) {
    //if folder already exists return path
    return _appDocDirFolder.path;
  } else {
    //if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}

// printPdf({required File pdfFile, required Ticket ticket}) async {
//   final pdf = pdfFile.readAsBytes();
//   List<Printer> printerList = await Printing.listPrinters();
//   sharedPref.getPrinter.length > 2
//       ? await Printing.directPrintPdf(
//           printer: printerList.firstWhere((element) => element.name == sharedPrefs.getPrinter),
//           onLayout: (_) => pdf)
//       : await Printing.layoutPdf(onLayout: (_) => pdf);
//   String path = await createFolderInAppDocDir("bills");
//   //PdfApi.openFile(pdfFile.renameSync("$path/${ticket.number}.pdf"));
// }

Future<Uint8List> toQrImageData(String text) async {
  try {
    final image = await QrPainter(
      data: text,
      version: QrVersions.auto,
      gapless: false,
    ).toImage(300);
    final a = await image.toByteData(format: ImageByteFormat.png);
    return a!.buffer.asUint8List();
  } catch (e) {
    throw e;
  }
}

getTicketNumber() {
  DateTime currentDateTime = DateTime.now();
  final parms = [
    '${sharedPrefs.getTicketCode}',
    sharedPrefs.loginId,
    currentDateTime.month + 1,
    currentDateTime.day,
    currentDateTime.millisecond.toString().padLeft(3, '0')
  ];
  final ticketNumber = parms.join('');
  return ticketNumber;
}

Ticket getTicket(List<CategoryModel> list) {
  List<Lineitem> lineItemList = [];
  for (int i = 0; i < list.length; i++) {
    if (list[i].categoryQyantity != 0) {
      for (int si = 0; si < list[i].subcategories.length; si++) {
        if (list[i].subcategories[si].quantity != 0) {
          Subcategory subCat = list[i].subcategories[si];
          lineItemList.add(Lineitem(
            subcategoryName: subCat.name,
            type: subCat.type,
            subcategoryPrice: subCat.price,
            category: list[i].name,
            quantity: subCat.quantity,
            price: subCat.quantity * subCat.price,
            createdTs: DateTime.now(),
          ));
        }
      }
    }
  }
  return Ticket(
    number: getTicketNumber(),
    lineitems: lineItemList,
    price: getTotalCategory(list),
    issuedTs: DateTime.now(),
  );
}

getTotalCategory(List<CategoryModel> list) {
  double sum = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i].categoryQyantity != 0) {
      for (int si = 0; si < list[i].subcategories.length; si++) {
        if (list[i].subcategories[si].quantity != 0) {
          sum = sum + (list[i].subcategories[si].quantity * list[i].subcategories[si].price).ceil();
        }
      }
    }
  }
  return sum;
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

List<CategoryModel> convertCategorytoZero(List<CategoryModel> list) {
  List<CategoryModel> newList = list;
  for (CategoryModel categoryModel in newList) {
    categoryModel.categoryQyantity = 0;
    for (Subcategory subCategory in categoryModel.subcategories) {
      subCategory.quantity = 0;
    }
  }
  return newList;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
