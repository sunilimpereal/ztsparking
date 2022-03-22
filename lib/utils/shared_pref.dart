import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPref;
  init() async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }
  }

  //gettter
  bool get loggedIn => _sharedPref!.getBool('loggedIn') ?? false;
  String get loginId => _sharedPref!.getString('loginId') ?? "";
  String get userId => _sharedPref!.getString('userId') ?? "";
  String get userEmail => _sharedPref!.getString('userEmail') ?? "";
  String get organizationName => _sharedPref!.getString('organizationName') ?? "";
  String get organizationLogo => _sharedPref!.getString('organizationLogo') ?? "";
  String get getPrinter => _sharedPref!.getString('printer') ?? "";
  String get getVehicleNumber => _sharedPref!.getString('vehicleNumber') ?? "";
  String get getbaseUrl => _sharedPref!.getString('baseUrl') ?? "http://zts.afroaves.com:8080/";
  String get getTicketCode => _sharedPref!.getString('ticketCode') ?? 'MYS';

  String? get token => _sharedPref!.getString('authToken');

  ///Set as logged in
  setLoggedIn() {
    _sharedPref!.setBool('loggedIn', true);
  }

  /// Set as logged out
  setLoggedOut() {
    _sharedPref!.setBool('loggedIn', false);
    setAuthToken(token: "");
    // _sharedPref!.remove('authToken');
  }

  /// Set uuid for the user
  setUserDetailsEntry({
    required String loginId,
    required String userEmail,
    required String organizationName,
    required String organizationLogo,
  }) {
    _sharedPref!.setString('loginId', loginId);
    _sharedPref!.setString('userEmail', userEmail);
    _sharedPref!.setString('organizationName', organizationName);
    _sharedPref!.setString('organizationLogo', organizationLogo);
  }

  /// Set uuid for the user
  setUserDetailsExit({
    required String userId,
    required String userMobile,
  }) {
    _sharedPref!.setString('userId', loginId);
    _sharedPref!.setString('userMobile', userMobile);
  }

  ///set Auth token for the app
  setAuthToken({required String token}) {
    _sharedPref!.setString('authToken', token);
  }

  setPrinter({required String printer}) {
    _sharedPref!.setString('printer', printer);
  }

  setVehicleNumber({required String vehicleNumber}) {
    _sharedPref!.setString('vehicleNumber', vehicleNumber);
  }

  setbaseUrl({required String baseUrl}) {
    _sharedPref!.setString('baseUrl', baseUrl);
  }

  setTicketCode({required String baseUrl}) {
    _sharedPref!.setString('ticketCode', baseUrl);
  }
}

final sharedPrefs = SharedPref();
