import 'package:flutter/material.dart';
import 'package:twin_finder/core/utils/app_colors.dart';

class BackgroundWidget extends StatefulWidget {
  final Widget child;
  const BackgroundWidget({super.key, required this.child});

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
        ),
      ),
      child: SafeArea(top: true, bottom: true, child: widget.child),
    );
  }
}
