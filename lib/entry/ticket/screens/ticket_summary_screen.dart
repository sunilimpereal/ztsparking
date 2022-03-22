import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ztsparking/entry/ticket/data/models/line_summary_model.dart';
import 'package:ztsparking/entry/ticket/data/repository/ticket_bloc.dart';
import 'package:ztsparking/entry/ticket/widgets/date_picker.dart';
import 'package:ztsparking/main.dart';
import 'package:ztsparking/services/printer.dart';


class TicketSummaryScreenWrapper extends StatelessWidget {
  const TicketSummaryScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TicketProvider(
      context: context,
      child: TicketSummaryScreen(),
    );
  }
}

class TicketSummaryScreen extends StatefulWidget {
  const TicketSummaryScreen({Key? key}) : super(key: key);

  @override
  _TicketSummaryScreenState createState() => _TicketSummaryScreenState();
}

class _TicketSummaryScreenState extends State<TicketSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: StreamBuilder<List<LineSumryItem>>(
              stream: TicketProvider.of(context).lineItemSummary,
              builder: (context, snapshot) {
                List<LineSumryItem> lineItems = snapshot.data ?? [];
                return Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Text(
                                  "Tikcet Summary",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ZTSDatePicker(
                                  onSelectionChanged: (value) {
                                    TicketProvider.of(context).getLineItemSumry(value);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        heading(),
                        data(),
                      ],
                    )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Total :',
                                style: TextStyle(fontSize: 24, color: Colors.green),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              StreamBuilder<List<LineSumryItem>>(
                                  stream: TicketProvider.of(context).lineItemSummary,
                                  builder: (context, snapshot) {
                                    return Text(
                                      '${total(snapshot.data ?? [])}',
                                      style: TextStyle(fontSize: 24, color: Colors.green),
                                    );
                                  })
                            ],
                          ),
                          StreamBuilder<List<LineSumryItem>>(
                              stream: TicketProvider.of(context).lineItemSummary,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    //Print Summary
                                    printSummary(
                                        lineItemList: snapshot.data ?? [],
                                        context: context,
                                        userEmail: sharedPref.userEmail,
                                        summaryDate: TicketProvider.of(context).selectedDate,
                                        printDate: DateTime.now());
                                  },
                                  child: const Text('Print Summary'),
                                );
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                );
              }),
        ));
  }

  Future<bool> printSummary({
    required List<LineSumryItem> lineItemList,
    required BuildContext context,
    required String userEmail,
    required DateTime summaryDate,
    required DateTime printDate,
  }) async {
    Printer printer = Printer();
    Map<String, dynamic> data = {
      'userEmail': userEmail,
      'summaryDate': "${DateFormat('dd/MM/yyyy').format(summaryDate)}",
      'printDate': "${DateFormat('dd/MM/yyyy hh:mm').format(printDate)}",
      'sumLineItemNames': lineItemList.map((e) => "${e.subcategory} ${e.type}").toList(),
      'sumLineItemQty': lineItemList.map((e) => "${e.count}").toList(),
      'sumLineItemTotal': lineItemList.map((e) => "${e.count * e.subcategoryPrice}").toList(),
      'summaryTotal': total(lineItemList).toString(),
    };
    final result = await printer.printSummary(data);
    log(result.toString());

    return result;
  }

  double total(List<LineSumryItem> line) {
    double total = 0;
    for (LineSumryItem item in line) {
      total = total + item.lineitemPrice;
    }
    return total;
  }

  Widget heading() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        height: 30,
        child: Row(
          children: [
            cell(flex: 6, text: 'Name'),
            cell(flex: 3, text: 'Quantity'),
            cell(flex: 3, text: 'Total'),
          ],
        ),
      ),
    );
  }

  Widget data() {
    return StreamBuilder<List<LineSumryItem>>(
        stream: TicketProvider.of(context).lineItemSummary,
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: getTicketRows(snapshot.data ?? []),
                    ),
                  ),
          );
        });
  }

  List<Widget> getTicketRows(List<LineSumryItem> list) {
    int a = 1;
    List<Widget> widgetList = list.map((e) {
      a++;
      double total = e.lineitemPrice * e.count;
      return Container(
        height: 30,
        child: Row(
          children: [
            cell(flex: 6, text: '${e.subcategory} ${e.type}', even: a.isEven),
            cell(flex: 3, text: '${e.count}', even: a.isEven),
            cell(flex: 3, text: '${e.lineitemPrice}', even: a.isEven),
          ],
        ),
      );
    }).toList();
    return widgetList;
  }

  Widget cell({required int flex, required String text, bool? even}) {
    var withOpacity = Colors.green[50]?.withOpacity(0.5);
    return Container(
      child: Flexible(
        flex: flex,
        child: Container(
          color: even ?? false ? withOpacity : Colors.white,
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 4,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
