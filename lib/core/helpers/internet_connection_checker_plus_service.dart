import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionCheckerPlusService {
  InternetConnectionCheckerPlusService._();

  static Future<bool> get isConnected async => await InternetConnection().hasInternetAccess;

  static Stream<bool> get onStatusChange =>
      InternetConnection().onStatusChange.map((status) => status == InternetStatus.connected);
}
