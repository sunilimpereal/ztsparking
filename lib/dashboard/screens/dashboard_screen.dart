import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ztsparking/dashboard/data/models/category.dart';
import 'package:ztsparking/dashboard/data/repository/category_repository_bloc.dart';
import 'package:ztsparking/dashboard/widgets/drawer_widget.dart';
import 'package:ztsparking/dashboard/widgets/subcategory_card.dart';

import '../widgets/print_section.dart';

class DashBoardWrapper extends StatefulWidget {
  const DashBoardWrapper({Key? key}) : super(key: key);

  @override
  _DashBoardWrapperState createState() => _DashBoardWrapperState();
}

class _DashBoardWrapperState extends State<DashBoardWrapper> {
  @override
  Widget build(BuildContext context) {
    return CategoryProvider(
      context: context,
      child: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CategoryBloc categoryBloc = CategoryProvider.of(context);

    return StreamBuilder<List<CategoryModel>>(
        stream: categoryBloc.categoryListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          CategoryModel category = snapshot.data![0];
          return Scaffold(
            appBar: AppBar(
              title: Text(
                category.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            drawer: DrawerWidget(
              selectedScreen: "Home",
            ),
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ),
                          Column(
                              children: category.subcategories
                                  .map((e) =>
                                      SubCategoryCard(subCategory: e, parentCategory: category))
                                  .toList()),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: PrintSection(),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
