import 'package:test/test.dart';

import '../lib/src/level.dart';

void main() {
  group('Greater', () {
    Level greater = Level.greater;

    test('has name', () {
      expect('Greater', equals(greater.name));
    });

    test('can be constructed by name', () {
      expect(Level.fromString('Greater'), equals(greater));
    });
  });

  group('Lesser', () {
    Level lesser = Level.lesser;

    test('has name', () {
      expect('Lesser', equals(lesser.name));
    });

    test('can be constructed by name', () {
      expect(Level.fromString('Lesser'), equals(lesser));
    });
  });
}
