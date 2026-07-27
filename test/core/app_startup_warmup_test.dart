import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/core/startup/app_startup_warmup.dart';

void main() {
  group('AppStartupResult', () {
    test('reports a failed startup without crashing', () {
      final result = AppStartupResult.failed(
        Exception('database init failed'),
        StackTrace.current,
      );

      expect(result.initialized, isFalse);
      expect(result.error, isA<Exception>());
      expect(result.isar, isNull);
    });

    test('reports a successful startup with an initialized database', () {
      final result = AppStartupResult.ready(Object());

      expect(result.initialized, isTrue);
      expect(result.error, isNull);
      expect(result.database, isNotNull);
    });
  });
}
