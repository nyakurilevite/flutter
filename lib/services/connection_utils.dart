import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';


class ConnectionUtil {

  static Future<bool> hasInternetInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }
}