import 'package:flutter/material.dart';

class AppColors {
  static Color foregroundOnDark({bool isBuild = false}) {
    if (isBuild) return Colors.black87;
    return Colors.white;
  }

  static Color foregroundOnLight({bool isBuild = false}) {
    if (isBuild) return Colors.white;
    return Colors.black87;
  }

  static Color backgroundOnDark({bool isBuild = false}) {
    if (isBuild) return Colors.white;
    return Colors.black87;
  }

  static Color backgroundOnLight({bool isBuild = false}) {
    if (isBuild) return Colors.black87;
    return Colors.white;
  }

  static const Color danger = Colors.red;
  static const Color go = Colors.green;
  static const Color grey = Colors.grey;
  static Color lightGrey = Colors.grey.shade300;
  static const Color white = Colors.white;
  static const Color button = Colors.blue;
  static const Color black = Colors.black;
  static const Color fadedBlack = Colors.black87;
  static const Color transparent = Colors.transparent;
}
