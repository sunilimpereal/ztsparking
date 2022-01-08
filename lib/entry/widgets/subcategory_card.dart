import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ztsparking/entry/entry_dash/data/models/category.dart';
import 'package:ztsparking/entry/entry_dash/data/repository/category_repository_bloc.dart';

import '../../main.dart';
import '../../utils/svg_icon.dart';

class SubCategoryCard extends StatefulWidget {
  final Subcategory subCategory;
  final CategoryModel parentCategory;

  const SubCategoryCard({Key? key, required this.subCategory, required this.parentCategory})
      : super(key: key);

  @override
  _SubCategoryCardState createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {
  TextEditingController quantityController = TextEditingController();
  FocusNode quanityFocus = FocusNode();

  @override
  void initState() {
    quantityController.text = widget.subCategory.quantity.toString();
    quanityFocus.addListener(() {
      log("message listner");
      setState(() {
        quantityController.text = "";
      });
    });
    super.initState();
  }

  update() {
    if (!quanityFocus.hasFocus) {
      quantityController.text = widget.subCategory.quantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    update();
    return StreamBuilder<List<CategoryModel>>(
        stream: CategoryProvider.of(context).categoryListStream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 8,
            ),
            child: Material(
              elevation: 20,
              shadowColor: Colors.green.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(1),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.44,
                          child: Text(
                            widget.subCategory.name + " " + widget.subCategory.type,
                            style: TextStyle(
                                fontFamily: appFonts.poppins,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "₹ " + widget.subCategory.price.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: appFonts.notoSans,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    quantity()
                  ],
                ),
              ),
            ),
          );
        });
  }

  increment() {
    setState(() {
      int a = int.parse(quantityController.text) + 1;
      CategoryProvider.of(context).updateCategoryQuantity(
        categoryId: widget.parentCategory.id,
        subCategoryId: widget.subCategory.id,
        quantity: a,
      );
    });
  }

  decrement() {
    setState(() {
      if (quantityController.text != "0") {
        int a = int.parse(quantityController.text) - 1;
        CategoryProvider.of(context).updateCategoryQuantity(
          categoryId: widget.parentCategory.id,
          subCategoryId: widget.subCategory.id,
          quantity: a,
        );
      } else {}
    });
  }

  Widget quantity() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconCounter(
            icon: Icons.remove,
            ontap: () {
              decrement();
            },
          ),
          Container(
            width: 30,
            child: EditableText(
              maxLines: 1,
              textAlign: TextAlign.center,
              controller: quantityController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: (a) {
                CategoryProvider.of(context).updateCategoryQuantity(
                  categoryId: widget.parentCategory.id,
                  subCategoryId: widget.subCategory.id,
                  quantity: int.parse(quantityController.text),
                );
              },
              focusNode: quanityFocus,
              style: TextStyle(color: Colors.green, fontSize: 32),
              backgroundCursorColor: Colors.greenAccent,
              cursorColor: Colors.green,
            ),
          ),
          iconCounter(
            icon: Icons.add,
            ontap: () {
              increment();
            },
          ),
        ],
      ),
    );
  }

  Widget iconCounter({required IconData icon, required Function ontap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        child: InkWell(
          onTap: () {
            ontap();
          },
          child: Container(
            width: 36,
            height: 36,
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    quantityController.text = '0';
    super.dispose();
  }
}
