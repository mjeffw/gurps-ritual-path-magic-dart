import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:test/test.dart';

void main() {
  group('Affliction, Stun', () {
    AfflictionStun m;

    setUp(() async {
      m = AfflictionStun();
    });

    test('should have initial state', () {
      expect(m.name, equals('Affliction, Stunning'));
      expect(m.energyCost, equals(0));
    });

    test('implements == and hashCode', () {
      expect(m, equals(AfflictionStun()));
      expect(m.hashCode, equals(AfflictionStun().hashCode));
      expect(m, isNot(equals(Affliction())));
      expect(m.hashCode, isNot(equals(Affliction().hashCode)));
    });

    test('incrementValue does nothing',
        () => expect(m, same(m.incrementEffect(1))));
  });

  group('Afflictions', () {
    Affliction m;

    setUp(() async {
      m = Affliction(effect: 'Foo');
    });

    test('has initial state', () {
      expect(m.percent, equals(0));
      expect(m.effect, equals('Foo'));
      expect(m.name, equals('Affliction'));
      expect(m.energyCost, equals(0));
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

      aff = aff.incrementEffect(4);
      expect(aff.energyCost, equals(5));
      expect(aff.percent, equals(25));

      expect(aff.incrementEffect(-1).percent, equals(20));
    });

    test('implements == and hashCode', () {
      expect(m, equals(Affliction(effect: 'Foo')));
      expect(m.hashCode, equals(Affliction(effect: 'Foo').hashCode));
      expect(m, isNot(equals(m.copyWith(effect: 'Bar'))));
      expect(m, isNot(equals(m.copyWith(percent: 10))));
    });
  });
}
