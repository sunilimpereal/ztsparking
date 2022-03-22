import 'package:ztsparking/utils/shared_pref.dart';

class Config {
  String API_ROOT =  sharedPrefs.getbaseUrl + 'api/v1/';
  String API_ROOTV1 = sharedPrefs.getbaseUrl + 'api/v1/';
  String ICON_ROOT = 'https://zts.afroaves.com/icons/';
  
  //  String API_ROOT = 'http://zts.afroaves.com:8080/api/v1/';
  //  String ICON_ROOT = 'https://zts.afroaves.com/icons/';

}
