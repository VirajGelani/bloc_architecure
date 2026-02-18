import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

// abstract class ConnectionAware {
//   NetworkState? networkState;
//   StreamSubscription? connectivitySubscription;
//
//   void onNetworkConnected();
//
//   void onNetworkDisconnected();
// }

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<List<ConnectivityResult>> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }
}
