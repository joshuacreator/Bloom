import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get defaultSize =>
      MediaQuery.of(this).orientation == Orientation.landscape
          ? screenHeight * 0.1
          : screenWidth * 0.1;
}
