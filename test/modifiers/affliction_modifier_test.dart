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
      expect(m.name, equals('Afflictions'));
      expect(m.energyCost, equals(0));
    });

    test('has inherent', () {
      Affliction m2 = Affliction(effect: 'Bar', inherent: true);
      expect(m2.inherent, equals(true));
    });

    test('+1 energy for every +5% it’s worth as an enhancement to Affliction',
        () {
      var aff = Affliction.copyWith(m, percent: 10);

      expect(aff.percent, equals(10));
      expect(aff.energyCost, equals(2));

      aff = Affliction.copyWith(m, percent: 9);
      expect(aff.percent, equals(9));
      expect(aff.energyCost, equals(2));

      aff = Affliction.copyWith(m, percent: 11);
      expect(aff.percent, equals(11));
      expect(aff.energyCost, equals(3));
    });
  });
}
