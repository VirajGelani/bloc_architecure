import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Singleton {
  static Singleton? _instance;

  Singleton._();

  static Singleton get instance => _instance ??= Singleton._();

  Stream<List<ConnectivityResult>>? connectivityStream;
  final isInternetAvailable = false.obs;
  final unReadNotificationCount = 0.obs;

  Future<void> startConnectivityObservation() async {
    final Connectivity connectivity = Connectivity();
    connectivityStream = connectivity.onConnectivityChanged;
    connectivityStream?.listen((connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet)) {
        debugPrint('Internet Available');
        isInternetAvailable.value = true;
      } else {
        debugPrint('Internet Disconnected');
        isInternetAvailable.value = false;
      }
    });
  }
}
