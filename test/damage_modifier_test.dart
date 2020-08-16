import 'package:gurps_dart/gurps_dart.dart';

import '../lib/src/damage_modifier.dart';
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
          expect(Damage.copyWith(t, dice: d1p1).energyCost, equals(2));
          expect(Damage.copyWith(t, dice: d1p2).energyCost, equals(4));
          expect(Damage.copyWith(t, dice: d2m1).energyCost, equals(6));
          expect(Damage.copyWith(t, dice: d2).energyCost, equals(8));
          expect(Damage.copyWith(t, dice: d2p1).energyCost, equals(10));
          expect(Damage.copyWith(t, dice: d2p2).energyCost, equals(12));
          expect(Damage.copyWith(t, dice: d3m1).energyCost, equals(14));
        }
      });
    });

    // If the spell will cause damage, whether directly or indirectly, consult
    // the Spell Modifiers Table (p. 18).
    //
    // |^^^^^^^^|^^^^^^^^^^^^^^|
    // | Damage | Added Energy |
    // // If the spell will cause damage, use (this table), based on whether the damage is direct or indirect, and
    // // on what type of damage is being done.
    // final List<String> values = [
    //   // |^^^^^^^^|^^^^^| cor,fat, | cr,burn, |^^^^^^^^^|
    //   // | direct | pi- | imp,pi++ | pi, tox .| cut,pi+ |
    //   // ---------------------------------------------------
    //   "        1d |   0 |        0 |        0 |       0 ", //
    //   "      1d+1 |   1 |        2 |        1 |       2 ", //
    //   "      1d+2 |   1 |        4 |        2 |       3 ", //
    //   "      2d-1 |   2 |        6 |        3 |       5 ", //
    //   "        2d |   2 |        8 |        4 |       6 ", //
    //   "      2d+1 |   3 |       10 |        5 |       8 ", //
    //   "      2d+2 |   3 |       12 |        6 |       9 ", //
    //   "      3d-1 |   4 |       14 |        7 |      11 ",
    // ];

    // void _testCost(DieRoll dice, DamageType type, int expectedCost) {
    //   m.vampiric = false;
    //   m.direct = true;
    //   m.type = type;
    //   m.value = 0;
    //   int adds = DieRoll.denormalize(dice);

    //   m.value = adds;
    //   expect(m.spellPoints, equals(expectedCost));

    //   m.vampiric = true;
    //   m.value = adds;
    //   expect(m.spellPoints, equals(expectedCost * 2));
    // }

    // void _testDice(DieRoll dice, DamageType type) {
    //   m.vampiric = false;
    //   m.direct = true;
    //   m.type = type;
    //   int adds = DieRoll.denormalize(dice);
    //   m.value = adds;

    //   expect(m.dice, equals(dice));

    //   m.direct = false;
    //   m.explosive = true;
    //   expect(m.dice, equals(dice * 2));

    //   m.explosive = false;
    //   expect(m.dice, equals(dice * 3));
    // }

    // test("has small piercing damage", () {
    //   for (String line in values) {
    //     var dice = new DieRoll.fromString(_colFromTable(line, 0));
    //     var cost = int.parse(_colFromTable(line, 1));
    //     _testCost(dice, DamageType.smallPiercing, cost);
    //     _testDice(dice, DamageType.smallPiercing);
    //   }
    // });

    // test("should have Cor Fat Imp HugePi damage", () {
    //   for (var type in impalingTypes) {
    //     for (String line in values) {
    //       var dice = new DieRoll.fromString(_colFromTable(line, 0));
    //       var cost = int.parse(_colFromTable(line, 2));
    //       _testCost(dice, type, cost);
    //       _testDice(dice, type);
    //     }
    //   }
    // });

    // test("should have Cr Burn Pi Tox damage", () {
    //   for (var type in crushingTypes) {
    //     for (String line in values) {
    //       var dice = new DieRoll.fromString(_colFromTable(line, 0));
    //       var cost = int.parse(_colFromTable(line, 3));
    //       _testCost(dice, type, cost);
    //       _testDice(dice, type);
    //     }
    //   }
    // });

    // test("should have Cut LargePi damage", () {
    //   for (var type in cuttingTypes) {
    //     for (String line in values) {
    //       var dice = new DieRoll.fromString(_colFromTable(line, 0));
    //       var cost = int.parse(_colFromTable(line, 4));
    //       _testCost(dice, type, cost);
    //       _testDice(dice, type);
    //     }
    //   }
    // });

    // // Each +5% adds 1 SP if the base cost for Damage is 20 SP or less.
    // test("should add 1 SP per 5 Percent of Enhancers", () {
    //   m.addTraitModifier(new TraitModifier("foo", null, 1));
    //   m.value = 10;
    //   expect(m.spellPoints, equals(11));
    //   m.value = 20;
    //   expect(m.spellPoints, equals(21));

    //   m.addTraitModifier(new TraitModifier("bar", null, 4));
    //   m.value = 10;
    //   expect(m.spellPoints, equals(11));
    //   m.value = 20;
    //   expect(m.spellPoints, equals(21));

    //   m.addTraitModifier(new TraitModifier("baz", null, 2));
    //   m.value = 10;
    //   expect(m.spellPoints, equals(12));
    //   m.value = 20;
    //   expect(m.spellPoints, equals(22));

    //   m.addTraitModifier(new TraitModifier("dum", null, 8));
    //   m.value = 10;
    //   expect(m.spellPoints, equals(13));
    //   m.value = 20;
    //   expect(m.spellPoints, equals(23));
    // });

    // // If Damage costs 21 SP or more, apply the enhancement percentage to the SP cost for Damage only (not to the cost
    // // of the whole spell); round up.
    // test("should Add 1 Point Per 1 Percent", () {
    //   m.addTraitModifier(new TraitModifier("foo", null, 1));
    //   m.value = 25;
    //   expect(m.spellPoints, equals(26));

    //   m.addTraitModifier(new TraitModifier("foo", null, 4));
    //   m.value = 30;
    //   expect(m.spellPoints, equals(35));

    //   m.addTraitModifier(new TraitModifier("foo", null, 2));
    //   m.value = 33;
    //   expect(m.spellPoints, equals(40));

    //   m.addTraitModifier(new TraitModifier("foo", null, 8));
    //   m.value = 50;
    //   expect(m.spellPoints, equals(65));
    // });

    // // Added limitations reduce this surcharge, but will never provide a net SP discount.
    // test("should Not Add 1 Point", () {
    //   m.addTraitModifier(new TraitModifier("foo", null, 10));
    //   m.addTraitModifier(new TraitModifier("bar", null, -5));
    //   m.value = 10;
    //   expect(m.spellPoints, equals(11));
    //   m.value = 30;
    //   expect(m.spellPoints, equals(35));

    //   m.addTraitModifier(new TraitModifier("baz", null, -10));
    //   m.value = 10;
    //   expect(m.spellPoints, equals(10));
    //   m.value = 30;
    //   expect(m.spellPoints, equals(30));
    // });
  });
}

String _colFromTable(String line, int index2) => line.split("|")[index2].trim();
