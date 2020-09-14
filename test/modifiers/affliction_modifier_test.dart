import 'package:test/test.dart';

import '../../lib/src/modifier/affliction_modifier.dart';

void main() {
  group('Affliction, Stun', () {
    AfflictionStun m;

    setUp(() async {
      m = AfflictionStun();
    });

    test('should have initial state', () {
      expect(m.inherent, equals(false));
      expect(m.name, equals('Affliction, Stunning'));
      expect(m.energyCost, equals(0));
    });

    test('should allow inherent to be set', () {
      AfflictionStun m2 = AfflictionStun(inherent: true);
      expect(m2.inherent, equals(true));
    });
  });

  group('Afflictions', () {
    Affliction m;

    setUp(() async {
      m = Affliction(effect: 'Foo');
    });

    test('has initial state', () {
      expect(m.inherent, equals(false));
      expect(m.percent, equals(0));
      expect(m.effect, equals('Foo'));
      expect(m.name, equals('Afflictions'));
      expect(m.energyCost, equals(0));
    });

    test('has inherent', () {
      expect(m.copyWith(inherent: true).inherent, equals(true));
    });

    test('+1 energy for every +5% worth as an enhancement to Affliction', () {
      var aff = m.copyWith(percent: 10);

      expect(aff.percent, equals(10));
      expect(aff.energyCost, equals(2));

      aff = m.copyWith(percent: 9);
      expect(aff.percent, equals(9));
      expect(aff.energyCost, equals(2));

      aff = m.copyWith(percent: 11);
      expect(aff.percent, equals(11));
      expect(aff.energyCost, equals(3));
    });

    test('increment effect', () {
      var aff = m.incrementEffect(1);
      expect(aff.energyCost, equals(1));
      expect(aff.percent, equals(5));
      expect(aff.effect, equals('undefined'));

      aff = aff.incrementEffect(4);
      expect(aff.energyCost, equals(5));
      expect(aff.percent, equals(25));

      expect(aff.incrementEffect(-1).percent, equals(20));
    });
  });
}
