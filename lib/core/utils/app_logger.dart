import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(methodCount: 2),
  level: kDebugMode ? Level.debug : Level.warning,
);
