import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvConfig {
  EnvConfig._();

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api.example.com';
  static String get appName => dotenv.env['APP_NAME'] ?? 'Bloom';

  static Future<void> load() async {
    final env = kReleaseMode ? '.env.prod' : '.env.dev';
    await dotenv.load(fileName: env);
  }
}

final envConfigProvider = Provider<EnvConfig>((ref) => EnvConfig._());
