import 'package:gurps_dart/gurps_dart.dart';

import '../../lib/src/modifier/damage_modifier.dart';
import "package:test/test.dart";

void main() {
  group('Damage:', () {
    const d1 = DieRoll(1, 0);
    const d1p1 = DieRoll(1, 1);
    const d1p2 = DieRoll(1, 2);
    const d2m1 = DieRoll(2, -1);
    const d2 = DieRoll(2, 0);
    const d2p1 = DieRoll(2, 1);
    const d2p2 = DieRoll(2, 2);
    const d3m1 = DieRoll(3, -1);
    const d3 = DieRoll(3, 0);
    const d3p2 = DieRoll(3, 2);
    const d4m1 = DieRoll(4, -1);
    const d4 = DieRoll(4, 0);
    const d4p2 = DieRoll(4, 2);
    const d5 = DieRoll(5, 0);
    const d5p1 = DieRoll(5, 1);
    const d5p2 = DieRoll(5, 2);
    const d6 = DieRoll(6, 0);
    const d7m1 = DieRoll(7, -1);
    const d7p2 = DieRoll(7, 2);
    const d8p1 = DieRoll(8, 1);

    Damage m;

    setUp(() async {
      m = Damage();
    });

    test('has initial state', () {
      expect(m.inherent, equals(false));
      expect(m.dice, equals(d1));
      expect(m.name, equals('Damage'));
      expect(m.energyCost, equals(0));

      expect(m.type, equals((DamageType.crushing)));
      expect(m.direct, equals((true)));
      expect(m.explosive, equals((false)));
    });

    test('has inherent', () {
      expect(Damage.copyWith(m, inherent: true).inherent, equals(true));
    });

    test('has type', () {
      expect(Damage.copyWith(m, type: DamageType.cutting).type,
          equals(DamageType.cutting));
    });

    test("has direct", () {
      expect(Damage.copyWith(m, direct: false).direct, equals(false));
    });

    test('has explosive', () {
      // setting explosive to true when direct is also true has no effect
      expect(Damage.copyWith(m, explosive: true).explosive, equals(false));

      expect(Damage.copyWith(m, direct: false, explosive: true).explosive,
          equals(true));
    });

    test('has damage dice', () {
      expect(m.damageDice, equals(DieRoll.fromString('1d')));
      expect(Damage.copyWith(m, dice: d1p1).damageDice, equals(d1p1));
      expect(Damage.copyWith(m, dice: d1p2).damageDice, equals(d1p2));
      expect(Damage.copyWith(m, dice: d2m1).damageDice, equals(d2m1));
    });

    group('damage for burn, cr, pi, tox', () {
      const types = [
        DamageType.burning,
        DamageType.crushing,
        DamageType.piercing,
        DamageType.toxic
      ];

      test('has energy costs and damage', () {
        for (var type in types) {
          var t = Damage.copyWith(m, type: type);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d1));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(1));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d1p1));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d1p2));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(3));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d2m1));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(4));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d2));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(5));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d2p1));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d2p2));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(7));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d3m1));
        }
      });

      test('triple damage for indirect damage', () {
        for (var type in types) {
          var t = Damage.copyWith(m, type: type, direct: false);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(DieRoll(3, 0)));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(1));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d4m1));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d4p2));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(3));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d5p1));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(4));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d6));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(5));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d7m1));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d7p2));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(7));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d8p1));
        }
      });

      test('double damage for indirect, explosive damage', () {
        for (var type in types) {
          var t =
              Damage.copyWith(m, type: type, direct: false, explosive: true);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d2));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(1));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d2p2));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d3));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(3));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d3p2));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(4));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d4));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(5));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d4p2));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d5));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(7));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d5p2));
        }
      });
    });

    group('damage for pi-', () {
      Damage t;

      setUp(() async {
        t = Damage.copyWith(m, type: DamageType.smallPiercing);
      });

      test('has energy costs', () {
        expect(t.energyCost, equals(0));
        expect(t.damageDice, equals(d1));

        expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(1));
        expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d1p1));

        expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(1));
        expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d1p2));

        expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(2));
        expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d2m1));

        expect(Damage.copyWith(t, dice: d2).energyCost, equals(2));
        expect(Damage.copyWith(t, dice: d2).damageDice, equals(d2));

        expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(3));
        expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d2p1));

        expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(3));
        expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d2p2));

        expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(4));
        expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d3m1));
      });

      test('triple damage for indirect damage', () {
        t = Damage.copyWith(t, direct: false);

        expect(t.energyCost, equals(0));
        expect(t.damageDice, equals(DieRoll(3, 0)));

        expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(1));
        expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d4m1));

        expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(1));
        expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d4p2));

        expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(2));
        expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d5p1));

        expect(Damage.copyWith(t, dice: d2).energyCost, equals(2));
        expect(Damage.copyWith(t, dice: d2).damageDice, equals(d6));

        expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(3));
        expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d7m1));

        expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(3));
        expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d7p2));

        expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(4));
        expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d8p1));
      });

      test('double damage for indirect, explosive damage', () {
        t = Damage.copyWith(t, direct: false, explosive: true);

        expect(t.energyCost, equals(0));
        expect(t.damageDice, equals(d2));

        expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(1));
        expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d2p2));

        expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(1));
        expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d3));

        expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(2));
        expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d3p2));

        expect(Damage.copyWith(t, dice: d2).energyCost, equals(2));
        expect(Damage.copyWith(t, dice: d2).damageDice, equals(d4));

        expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(3));
        expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d4p2));

        expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(3));
        expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d5));

        expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(4));
        expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d5p2));
      });
    });

    group('damage for cut, pi+', () {
      const types = [DamageType.cutting, DamageType.largePiercing];

      test('has energy costs', () {
        for (var type in types) {
          var t = Damage.copyWith(m, type: type);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d1));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d1p1));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(3));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d1p2));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(5));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d2m1));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d2));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(8));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d2p1));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(9));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d2p2));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(11));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d3m1));
        }
      });

      test('triple damage for indirect damage', () {
        for (var type in types) {
          var t = Damage.copyWith(m, type: type, direct: false);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(DieRoll(3, 0)));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d4m1));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(3));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d4p2));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(5));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d5p1));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d6));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(8));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d7m1));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(9));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d7p2));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(11));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d8p1));
        }
      });

      test('double damage for indirect, explosive damage', () {
        for (var type in types) {
          var t =
              Damage.copyWith(m, type: type, direct: false, explosive: true);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d2));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d2p2));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(3));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d3));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(5));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d3p2));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d4));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(8));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d4p2));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(9));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d5));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(11));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d5p2));
        }
      });
    });

    group('damage for cor, fat, pi++, imp', () {
      const types = [
        DamageType.corrosive,
        DamageType.fatigue,
        DamageType.hugePiercing,
        DamageType.impaling
      ];

      test('has energy costs', () {
        for (var type in types) {
          var t = Damage.copyWith(m, type: type);
          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d1));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d1p1));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(4));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d1p2));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d2m1));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(8));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d2));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(10));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d2p1));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(12));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d2p2));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(14));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d3m1));
        }
      });

      test('triple damage for indirect damage', () {
        for (var type in types) {
          var t = Damage.copyWith(m, type: type, direct: false);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(DieRoll(3, 0)));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d4m1));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(4));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d4p2));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d5p1));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(8));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d6));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(10));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d7m1));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(12));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d7p2));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(14));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d8p1));
        }
      });

      test('double damage for indirect, explosive damage', () {
        for (var type in types) {
          var t =
              Damage.copyWith(m, type: type, direct: false, explosive: true);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d2));

          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p1).damageDice, equals(d2p2));

          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(4));
          expect(Damage.copyWith(t, dice: d1p2).damageDice, equals(d3));

          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2m1).damageDice, equals(d3p2));

          expect(Damage.copyWith(t, dice: d2).energyCost, equals(8));
          expect(Damage.copyWith(t, dice: d2).damageDice, equals(d4));

          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(10));
          expect(Damage.copyWith(t, dice: d2p1).damageDice, equals(d4p2));

          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(12));
          expect(Damage.copyWith(t, dice: d2p2).damageDice, equals(d5));

          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(14));
          expect(Damage.copyWith(t, dice: d3m1).damageDice, equals(d5p2));
        }
      });
    });

    // Each +5% adds 1 SP if the base cost for Damage is 20 SP or less.
    test('should add 1 energy per 5 Percent of Enhancers', () {
      var t1 = Damage.copyWith(m, dice: (DieRoll(1, 10)));
      expect(t1.energyCost, equals(10));

      t1 = Damage.addModifier(t1, TraitModifier(name: 'foo', percent: 1));
      expect(t1.energyCost, equals(11));
      t1 = Damage.addModifier(t1, TraitModifier(name: 'bar', percent: 4));
      expect(t1.energyCost, equals(11));
      t1 = Damage.addModifier(t1, TraitModifier(name: 'baz', percent: 2));
      expect(t1.energyCost, equals(12));
      t1 = Damage.addModifier(t1, TraitModifier(name: 'qux', percent: 8));
      expect(t1.energyCost, equals(13));

      var t2 = Damage.copyWith(m, dice: (DieRoll(1, 20)));
      expect(t2.energyCost, equals(20));

      t2 = Damage.addModifier(t2, TraitModifier(name: 'foo', percent: 1));
      expect(t2.energyCost, equals(21));
      t2 = Damage.addModifier(t2, TraitModifier(name: 'bar', percent: 4));
      expect(t2.energyCost, equals(21));
      t2 = Damage.addModifier(t2, TraitModifier(name: 'baz', percent: 2));
      expect(t2.energyCost, equals(22));
      t2 = Damage.addModifier(t2, TraitModifier(name: 'qux', percent: 8));
      expect(t2.energyCost, equals(23));
    });

    // If Damage costs 21 SP or more, apply the enhancement percentage to the
    // SP cost for Damage only (not to the cost of the whole spell); round up.
    test("should Add 1 energy cost Per 1 Percent", () {
      var t1 = Damage.copyWith(m, dice: (DieRoll(1, 21)));
      expect(t1.energyCost, equals(21));

      t1 = Damage.addModifier(t1, TraitModifier(name: 'foo', percent: 1));
      expect(t1.energyCost, equals(22));
      t1 = Damage.addModifier(t1, TraitModifier(name: 'bar', percent: 4));
      expect(t1.energyCost, equals(26));
      t1 = Damage.addModifier(t1, TraitModifier(name: 'baz', percent: 2));
      expect(t1.energyCost, equals(28));
    });

    // Added limitations reduce this surcharge, but will never provide a net SP
    // discount.
    test("should Not Add 1 Point", () {
      var t1 = Damage.copyWith(m, dice: (DieRoll(1, 10)));
      t1 = Damage.addModifier(t1, TraitModifier(name: 'foo', percent: 10));
      t1 = Damage.addModifier(t1, TraitModifier(name: 'bar', percent: -5));
      expect(t1.energyCost, equals(11));

      t1 = Damage.copyWith(t1, dice: (DieRoll(1, 30)));
      expect(t1.energyCost, equals(35));

      t1 = Damage.addModifier(t1, TraitModifier(name: 'baz', percent: -10));
      expect(t1.energyCost, equals(30));

      t1 = Damage.copyWith(m, dice: (DieRoll(1, 10)));
      expect(t1.energyCost, equals(10));
    });
  });
}
