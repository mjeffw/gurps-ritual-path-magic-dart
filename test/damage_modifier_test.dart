import 'package:gurps_dart/gurps_dart.dart';

import '../lib/src/damage_modifier.dart';
import "package:test/test.dart";

void main() {
  group("Damage:", () {
    Damage m;

    setUp(() async {
      m = new Damage();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.dice, equals(const DieRoll(1, 0)));
      expect(m.name, equals("Damage"));
      expect(m.energyCost, equals(0));

      // expect(m.type, equals((DamageType.crushing)));
      expect(m.direct, equals((true)));
      // expect(m.explosive, equals((false)));
      // expect(m.vampiric, equals((false)));
    });

    // test("should throw exception if negative", () {
    //   expect(() => m.value = -1, throwsException);
    // });

    // test("has inherent", () {
    //   m.inherent = true;
    //   expect(m.inherent, equals(true));
    // });

    // test("has type", () {
    //   m.type = DamageType.cutting;
    //   expect(m.type, equals(DamageType.cutting));
    // });

    // test("has direct", () {
    //   m.direct = false;
    //   expect(m.direct, equals(false));
    // });

    // test("has explosive", () {
    //   // setting explosive to true when direct is also true has no effect
    //   m.explosive = true;
    //   expect(m.explosive, equals(false));

    //   m.direct = false;
    //   m.explosive = true;
    //   expect(m.explosive, equals(true));

    //   // setting direct to true will set explosive to false
    //   m.direct = true;
    //   expect(m.explosive, equals(false));
    // });

    // test("has vampiric", () {
    //   m.vampiric = true;
    //   expect(m.vampiric, equals(true));
    // });

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
