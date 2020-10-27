import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:test/test.dart';

void main() {
  group('Critical Failure', () {
    ResultType result = ResultType.criticalFailure;

    test('has name', () {
      expect(result.name, equals('Critical Failure'));
    });

    test('can be constructed by name', () {
      expect(result, equals(ResultType.fromString('Critical Failure')));
    });
  });

  group('Failure', () {
    ResultType result = ResultType.failure;

    test('has name', () {
      expect(result.name, equals('Failure'));
    });

    test('can be constructed by name', () {
      expect(result, equals(ResultType.fromString('Failure')));
    });
  });

  group('Success', () {
    ResultType result = ResultType.success;

    test('has name', () {
      expect(result.name, equals('Success'));
    });

    test('can be constructed by name', () {
      expect(result, equals(ResultType.fromString('Success')));
    });
  });

  group('Critical Success', () {
    ResultType result = ResultType.criticalSuccess;

    test('has name', () {
      expect(result.name, equals('Critical Success'));
    });

    test('can be constructed by name', () {
      expect(result, equals(ResultType.fromString('Critical Success')));
    });
  });
}
