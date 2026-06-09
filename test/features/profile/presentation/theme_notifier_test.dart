import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:basic_board/features/profile/presentation/notifiers/theme_notifier.dart';
import 'package:basic_board/features/profile/presentation/providers/theme_provider.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences prefs;
  late ProviderContainer container;

  setUp(() {
    prefs = MockSharedPreferences();
    when(() => prefs.getInt(any())).thenReturn(null);
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('ThemeNotifier', () {
    test('initializes with system theme when no preference saved', () {
      final state = container.read(themeSelectorProvider);
      expect(state, equals(ThemeMode.system));
    });

    test('initializes with saved theme preference', () {
      when(() => prefs.getInt(any())).thenReturn(ThemeMode.dark.index);

      final customContainer = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      expect(customContainer.read(themeSelectorProvider), equals(ThemeMode.dark));
      customContainer.dispose();
    });

    test('changes and persists theme', () async {
      when(() => prefs.setInt(any(), any())).thenAnswer((_) async => true);

      final notifier = container.read(themeSelectorProvider.notifier);
      await notifier.changeAndSave(ThemeMode.dark);

      expect(container.read(themeSelectorProvider), equals(ThemeMode.dark));
      verify(() => prefs.setInt(any(), ThemeMode.dark.index)).called(1);
    });

    test('emits error when persistence fails', () async {
      when(() => prefs.setInt(any(), any())).thenThrow(Exception('Save failed'));

      final notifier = container.read(themeSelectorProvider.notifier);

      expect(
        () => notifier.changeAndSave(ThemeMode.dark),
        throwsA(isA<Exception>()),
      );
    });

    test('changes to light theme', () async {
      when(() => prefs.setInt(any(), any())).thenAnswer((_) async => true);

      final notifier = container.read(themeSelectorProvider.notifier);
      await notifier.changeAndSave(ThemeMode.light);

      expect(container.read(themeSelectorProvider), equals(ThemeMode.light));
      verify(() => prefs.setInt(any(), ThemeMode.light.index)).called(1);
    });
  });
}
