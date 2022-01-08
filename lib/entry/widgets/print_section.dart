import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ztsparking/entry/entry_dash/data/models/category.dart';
import 'package:ztsparking/entry/entry_dash/data/repository/category_repository.dart';
import 'package:ztsparking/entry/entry_dash/data/repository/category_repository_bloc.dart';

import 'package:ztsparking/utils/shared_pref.dart';

import '../../main.dart';
import '../../utils/methods.dart';

class PrintSection extends StatefulWidget {
  Function(bool a) onFocusChanged;
  PrintSection({Key? key, required this.onFocusChanged}) : super(key: key);

  @override
  _PrintSectionState createState() => _PrintSectionState();
}

class _PrintSectionState extends State<PrintSection> {
  bool loadingPrintButton = false;
  FocusNode vehicleNumberFocus = FocusNode();
  TextEditingController vehicleNumberController = TextEditingController();
  @override
  void initState() {
    vehicleNumberFocus.addListener(() {
      widget.onFocusChanged(vehicleNumberFocus.hasFocus);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 30,
        color: Colors.green,
        shadowColor: Colors.green,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width - 16,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // Text("Vechile Number: "),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                          width: 2,
                          color: vehicleNumberFocus.hasFocus
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent),
                    ),
                    child: Material(
                      elevation: vehicleNumberFocus.hasFocus ? 0 : 0,
                      color: Theme.of(context).colorScheme.background,
                      shape: appStyles.shapeBorder(5),
                      shadowColor: Colors.grey[100],
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: vehicleNumberController,
                          focusNode: vehicleNumberFocus,
                          textAlign: TextAlign.left,
                          obscureText: false,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontWeight: FontWeight.w600,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          onTap: () {},
                          onChanged: (value) {
                            // vehicleNumberController.text = value.toUpperCase();
                            sharedPrefs.setVehicleNumber(vehicleNumber: value);
                          },
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            // errorText: "${snapshot.error}",
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 10),
                            hintText: "Vehicle Number",
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 23, maxHeight: 20),
                            labelText: "Vehicle Number",
                            isDense: false,
                            hintStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline1!.color?.withOpacity(0.2),
                                fontSize: 16),
                            labelStyle: TextStyle(
                              height: 0.6,
                              fontSize: 16,
                              color: Theme.of(context).textTheme.headline1!.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontFamily: appFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<List<CategoryModel>>(
                        stream: CategoryProvider.of(context).categoryListStream,
                        builder: (context, snapshot) {
                          return Text(
                            '₹ ${getTotalCategory(snapshot.data ?? [])} /- ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24,
                              fontFamily: appFonts.notoSans,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        })
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 60,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        CategoryProvider.of(context).getCategoryList();
                      },
                      child: const Icon(Icons.delete),
                    ),
                  ),
                  StreamBuilder<List<CategoryModel>>(
                      stream: CategoryProvider.of(context).categoryListStream,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: 200,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: loadingPrintButton
                                ? () {}
                                : () async {
                                    setState(() {
                                      loadingPrintButton = true;
                                    });
                                    if (await hasNetwork()) {
                                      if ((getTotalCategory(snapshot.data ?? []) != 0)) {
                                        CategoryRepository categoryRepository =
                                            CategoryRepository();
                                        List<CategoryModel> categorylist = snapshot.data ?? [];
                                        log(categorylist.toString());

                                        await categoryRepository
                                            .generateTicket(
                                          context: context,
                                          category: categorylist[0],
                                          vehicleNumber: vehicleNumberController.text,
                                        )
                                            .then((value) {
                                          setState(() {
                                            vehicleNumberController.clear();
                                            loadingPrintButton = false;
                                            log('message loading');
                                            loadingPrintButton = !CategoryProvider.of(context)
                                                .updateCategorytZero(
                                                    convertCategorytoZero(snapshot.data ?? []));
                                          });
                                        });
                                      }
                                    }

                                    // TicketProvider.of(context).getRecentTickets();
                                  },
                            child: loadingPrintButton
                                ? const Center(
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    'PRINT',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: appFonts.notoSans,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
