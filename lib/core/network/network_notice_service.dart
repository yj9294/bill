import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkNoticeService {
  NetworkNoticeService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> isOffline() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) {
      return true;
    }
    return results.every((result) => result == ConnectivityResult.none);
  }
}
