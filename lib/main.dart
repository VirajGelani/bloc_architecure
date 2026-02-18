import 'dart:async';

import 'package:bloc_architecure/core/auth/auth_session_manager.dart';
import 'package:bloc_architecure/core/constants/app_labels.dart';
import 'package:bloc_architecure/di/feature_di.dart';
import 'package:bloc_architecure/routes/app_routes.dart';
import 'package:bloc_architecure/core/theme/app_theme.dart';
import 'package:bloc_architecure/services/hive_storage_service.dart';
import 'package:bloc_architecure/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await GetStorage.init();
  registerFeatures(getIt);
  await getIt<HiveStorageService>().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<void>? _sessionSubscription;

  @override
  void initState() {
    super.initState();
    _sessionSubscription = getIt<AuthSessionManager>().onSessionExpired.listen(
      (_) {
        _navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (_) => false,
        );
        final context = _navigatorKey.currentContext;
        if (context != null && context.mounted) {
          SnackBarWidget.showSnackBar(
            context,
            AppLabels.unauthorizedAccessMsg,
            isError: true,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'BLoC Architecture',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
