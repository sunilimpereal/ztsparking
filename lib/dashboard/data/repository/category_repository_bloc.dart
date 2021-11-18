import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ztsparking/dashboard/data/models/category.dart';
import 'package:ztsparking/dashboard/data/repository/category_repository.dart';
import 'package:ztsparking/utils/shared_pref.dart';

import '../../../utils/bloc.dart';

class CategoryBloc extends Bloc {
  BuildContext context;
  CategoryBloc(this.context) {
    getCategoryList();
  }
  final _controller = BehaviorSubject<List<CategoryModel>>();

  Stream<List<CategoryModel>> get categoryListStream => _controller.stream.asBroadcastStream();

  Future<bool> getCategoryList() async {
    CategoryRepository _categoryRepository = CategoryRepository();
    final result = await _categoryRepository.getCategory(context);
    _controller.sink.add(result);
    return result.isNotEmpty ? true : false;
  }

  void updateCategoryList(List<CategoryModel> updatedList) async {
    _controller.sink.add(updatedList);
  }

  bool updateCategorytZero(List<CategoryModel> updatedList) {
    sharedPrefs.setVehicleNumber(vehicleNumber: ''); // sets vehicle number to none after printing
    _controller.sink.add(updatedList);

    //to disable the loading button
    return true;
  }

  void updateCategoryQuantity(
      {required int categoryId, required int subCategoryId, required int quantity}) async {
    List<CategoryModel> list = _controller.value;
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == categoryId) {
        for (int si = 0; si < list[i].subcategories.length; si++) {
          if (list[i].subcategories[si].id == subCategoryId) {
            list[i].subcategories[si].quantity = quantity;
            list[i].subcategories[si].subCategoryTotalPrice =
                (quantity * list[i].subcategories[si].price).floor();
          }
        }
        list[i].categoryQyantity =
            list[i].subcategories.map((e) => e.quantity).toList().reduce((a, b) => a + b);
        _controller.sink.add(list);
      }
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}

class CategoryProvider extends InheritedWidget {
  late CategoryBloc bloc;
  BuildContext context;
  CategoryProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = CategoryBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CategoryBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CategoryProvider>() as CategoryProvider)
        .bloc;
  }
}
