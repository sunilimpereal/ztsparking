import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ztsparking/authentication/login/login_page.dart';

import 'package:ztsparking/entry/entry_dash/data/repository/category_repository_bloc.dart';
import 'package:ztsparking/entry/ticket/data/repository/ticket_bloc.dart';
import 'package:ztsparking/entry/widgets/menu.dart';
import 'package:ztsparking/entry/widgets/print_section.dart';
import 'package:ztsparking/entry/widgets/subcategory_card.dart';

import 'data/models/category.dart';

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
      child: TicketProvider(
        context: context,
        child: DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool blur = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CategoryBloc categoryBloc = CategoryProvider.of(context);

    return Container(
      color: Colors.white,
      child: StreamBuilder<List<CategoryModel>>(
          stream: categoryBloc.categoryListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            CategoryModel category = snapshot.data![0];
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.green.withOpacity(0.1),
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Container(
                          child: Column(
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
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            height: MediaQuery.of(context).size.height * 0.06,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: AssetImage("assets/images/logo.png"),
                                              fit: BoxFit.fitWidth,
                                            )),
                                          ),
                                          Text(
                                            category.name,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      MenuDropDown(
                                        logout: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LoginPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                        //
                        //     ? BackdropFilter(
                        //         filter: ImageFilter.blur(
                        //           sigmaX: 3.0,
                        //           sigmaY: 3.0,
                        //           tileMode: TileMode.mirror,
                        //         ),
                        //         child: Container(
                        //           // color: Colors.green.withOpacity(0.05),
                        //           height: MediaQuery.of(context).size.height,
                        //           width: MediaQuery.of(context).size.width,
                        //         ),
                        //       )
                        //     : Container(),
                        Positioned(
                          bottom: 0,
                          child: PrintSection(
                            onFocusChanged: (a) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
