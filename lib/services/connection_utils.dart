import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class ConnectionUtil {

  static Future<bool> hasInternetInternetConnection() async {
    bool hasConnection = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    //Check if device is just connect with mobile network or wifi
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //Check there is actual internet connection with a mobile network or wifi
      if (await DataConnectionChecker().hasConnection) {
        // Network data detected & internet connection confirmed.
        hasConnection = true;
      } else {
        // Network data detected but no internet connection found.
        hasConnection = false;
      }
    }
    // device has no mobile network and wifi connection at all
    else {
      hasConnection = false;
    }
    return hasConnection;
  }
}