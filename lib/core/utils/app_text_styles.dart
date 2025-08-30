import 'package:flutter/material.dart';

class AppTextStyles {
  static const String fontFamily = 'SF Pro Display';

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: Color(0xFF222222),
    letterSpacing: 0.2,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: Color(0xFF7A7A7A),
    letterSpacing: 0.1,
  );

  static const TextStyle field = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: Color(0xFF222222),
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: Colors.white,
    letterSpacing: 0.2,
  );
} 