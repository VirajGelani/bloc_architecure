import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigation;
  final Color? backgroundColor;
  final bool absorbing;
  final bool safeAreaBottom;
  final bool? resizeToAvoidBottomInset;
  final bool safeAreaTop;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;

  const AppScaffold({
    super.key,
    required this.body,
    this.bottomNavigation,
    this.backgroundColor,
    this.appBar,
    this.safeAreaTop = true,
    this.absorbing = false,
    this.resizeToAvoidBottomInset,
    this.safeAreaBottom = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    // Set status bar style based on theme when scaffold is built
    final isDarkMode = isDark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDarkMode
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDarkMode
              ? Brightness.light
              : Brightness.dark,
        ),
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.white,
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: AbsorbPointer(
        absorbing: absorbing,
        child: SafeArea(top: safeAreaTop, bottom: safeAreaBottom, child: body),
      ),
      bottomNavigationBar: bottomNavigation,
      floatingActionButton: floatingActionButton,
    );
  }
}
