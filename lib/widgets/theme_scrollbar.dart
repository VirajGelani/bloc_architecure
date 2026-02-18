import 'package:flutter/material.dart';

class ThemedScrollbar extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final bool isDark;
  final EdgeInsetsGeometry? padding;

  const ThemedScrollbar({
    super.key,
    required this.child,
    required this.isDark,
    this.controller,
    this.padding,
  });

  @override
  State<ThemedScrollbar> createState() => _ThemedScrollbarState();
}

class _ThemedScrollbarState extends State<ThemedScrollbar> {
  late final ScrollController _internalController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = ScrollController();
      _ownsController = true;
    }
  }

  ScrollController get _controller => widget.controller ?? _internalController;

  @override
  void dispose() {
    if (_ownsController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbColor = widget.isDark
        ? Colors.white.withOpacity(0.85)
        : Colors.brown.withOpacity(0.65);

    final thickness = widget.isDark ? 5.0 : 4.0;

    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(thumbColor),
          thickness: WidgetStateProperty.all(thickness),
          radius: const Radius.circular(10),
          trackColor: WidgetStateProperty.all(Colors.transparent),
          crossAxisMargin: 2.0,
          minThumbLength: 48.0,
          thumbVisibility: WidgetStateProperty.all(true),
        ),
      ),
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        interactive: true,
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: SingleChildScrollView(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
