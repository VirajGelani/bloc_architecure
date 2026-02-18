import 'package:flutter/material.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String login = '/login';

  static Map<String, Widget Function(BuildContext)> get routes => {
        home: (_) => const _PlaceholderScreen(title: 'Home'),
        login: (_) => const _PlaceholderScreen(title: 'Login'),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: builder,
      );
    }
    return null;
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
