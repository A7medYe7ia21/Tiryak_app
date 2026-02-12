
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<List<ConnectivityResult>> get connectivityResult async =>
      await _connectivity.checkConnectivity();

  Future<bool> get isConnected async => !(await _connectivity.checkConnectivity()).contains(ConnectivityResult.none);

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  // Optional: Check if connected via WiFi, Mobile, or VPN
  Future<String> get connectionType async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile';
    } else if (results.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else {
      return 'None';
    }
  }

  @override
  bool operator ==(covariant ConnectivityService other) {
    if (identical(this, other)) return true;

    return
      other.connectivityResult == connectivityResult;
  }

  @override
  int get hashCode => ConnectivityResult.none.hashCode;
}

