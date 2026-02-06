import 'package:flutter/material.dart';

/// Base scaffold widget with common app structure
class BaseScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showAppBar;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final VoidCallback? onLeadingPressed;
  final EdgeInsets bodyPadding;

  const BaseScaffold({
    Key? key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.actions,
    this.leading,
    this.showAppBar = true,
    this.centerTitle = false,
    this.bottom,
    this.backgroundColor,
    this.onLeadingPressed,
    this.bodyPadding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.background,
      appBar: showAppBar
          ? AppBar(
              title: title != null ? Text(title!) : null,
              centerTitle: centerTitle,
              actions: actions,
              leading: leading,
              bottom: bottom,
              elevation: 0,
            )
          : null,
      body: Padding(
        padding: bodyPadding,
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

