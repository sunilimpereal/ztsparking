import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ztsparking/constants/app_fonts.dart';
import 'package:ztsparking/constants/appstyles.dart';
import 'package:ztsparking/constants/config_.dart';
import 'package:ztsparking/constants/themes/theme.dart';
import 'package:ztsparking/entry/authentication/login/bloc/login_bloc.dart';
import 'package:ztsparking/entry/authentication/login/bloc/login_stream.dart';
import 'package:ztsparking/entry/authentication/login/login_page.dart';
import 'package:ztsparking/entry/ticket/data/repository/ticket_bloc.dart';
import 'package:ztsparking/utils/shared_pref.dart';

import 'entry/entry_dash/dashboard_screen.dart';


AppStyles appStyles = AppStyles();
AppFonts appFonts = AppFonts();
Config config = Config();
SharedPref sharedPref = SharedPref();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPref.init();
  runApp(AppWrapperProvider());
}

bool isDeviceOnline = false;
ValueNotifier<bool> isOnline = ValueNotifier<bool>(false);
late int printerStatus;

class AppWrapperProvider extends StatelessWidget {
  const AppWrapperProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckLoginProvider(
      child: TicketProvider(
        context: context,
        child: LoginProvider(
          child: MyApp(),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription subscription;
  late StreamSubscription printStatusSubscribtion;
  @override
  void initState() {
    super.initState();

    const EventChannel _stream = EventChannel('printingStatus');
    _stream.receiveBroadcastStream().listen((event) {
      printerStatus = event;
      print("Printer status: $event");
    });

    // subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    //   if (result != ConnectivityResult.none) {
    //     isDeviceOnline = await DataConnectionChecker().hasConnection;
    //   } else {
    //     isDeviceOnline = false;
    //   }
    // });
  }

  @override
  void dispose() {
    subscription.cancel();
    printStatusSubscribtion.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'ZTS Parking',
      initialRoute: sharedPref.loggedIn ? '/dashboard' : '/login',
      onGenerateRoute: onGeneratedRoute,
    );
  }

  Route onGeneratedRoute(RouteSettings routeSettings) {
    if (routeSettings.name == '/login') {
      return MaterialPageRoute(builder: (_) => const LoginPage());
    }
    if (routeSettings.name == '/dashboard') {
      return MaterialPageRoute(builder: (_) => const DashBoardWrapper());
    }
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }
}
