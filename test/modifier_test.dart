import 'package:test/test.dart';

import '../lib/src/ritual_modifier.dart';
import '../lib/src/trait.dart';

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
      expect(m.value, equals(0));
    });

    test("should allow inherent to be set", () {
      AfflictionStun m2 = AfflictionStun(inherent: true);
      expect(m2.inherent, equals(true));
    });
  });

  group('Afflictions', () {
    Affliction m;

    setUp(() async {
      m = Affliction("Foo");
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Afflictions"));
      expect(m.energyCost, equals(0));
    });

    test("has inherent", () {
      Affliction m2 = Affliction("Bar", inherent: true);
      expect(m2.inherent, equals(true));
    });

    test("+1 SP for every +5% it’s worth as an enhancement to Affliction", () {
      var aff = Affliction.copyWith(m, value: 10);

      expect(aff.value, equals(10));
      expect(aff.energyCost, equals(2));

      aff = Affliction.copyWith(m, value: 9);
      expect(aff.value, equals(9));
      expect(aff.energyCost, equals(2));

      aff = Affliction.copyWith(m, value: 11);
      expect(aff.value, equals(11));
      expect(aff.energyCost, equals(3));
    });
  });

  group("Altered Traits", () {
    AlteredTraits m;

    setUp(() async {
      Trait trait = Trait(name: "foo");
      m = AlteredTraits(trait);
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.value, equals(0));
      expect(m.name, equals("Altered Traits"));
      expect(m.energyCost, equals(0));
    });

    test("has inherent", () {
      var alt = AlteredTraits.copyWith(m, inherent: true);
      expect(alt.inherent, equals(true));
    });

    test("adds +1 SP for every five character points removed", () {
      var alt = AlteredTraits.copyWith(m, value: -1);
      expect(alt.energyCost, equals(1));
      alt = AlteredTraits.copyWith(m, value: -5);
      expect(alt.energyCost, equals(1));
      alt = AlteredTraits.copyWith(m, value: -6);
      expect(m.energyCost, equals(2));
      alt = AlteredTraits.copyWith(m, value: -10);
      expect(m.energyCost, equals(2));
      alt = AlteredTraits.copyWith(m, value: -11);
      expect(m.energyCost, equals(3));
    });

    test("adds +1 SP for every character point added", () {
      var alt = AlteredTraits.copyWith(m, value: 1);
      expect(m.energyCost, equals(1));
      alt = AlteredTraits.copyWith(m, value: 11);
      expect(m.energyCost, equals(11));
      alt = AlteredTraits.copyWith(m, value: 24);
      expect(m.energyCost, equals(24));
      alt = AlteredTraits.copyWith(m, value: 100);
      expect(m.energyCost, equals(100));
    });

    test("allows for Limitations/Enhancements", () {
      // m.value = 24;
      // m.addTraitModifier(TraitModifier(name: "Ten percent", percent: 10));
      // expect(m.spellPoints, equals(27));

      // m.addTraitModifier(TraitModifier(name: "Another enhancer", percent: 5));
      // expect(m.spellPoints, equals(28));

      // m.addTraitModifier(TraitModifier(name: "Limitation", percent: -10));
      // expect(m.spellPoints, equals(26));
    });

    test("another test for Limitations/Enhancements", () {
      // m.addTraitModifier(TraitModifier(name: "foo", percent: 35));
      // m.addTraitModifier(
      //     TraitModifier(name: "bar", detail: "detail", percent: -10));

      // m.value = 0;
      // expect(m.spellPoints, equals(0));
      // m.value = 30;
      // expect(m.spellPoints, equals(38));
      // m.value = 100;
      // expect(m.spellPoints, equals(125));
      // m.value = -10;
      // expect(m.spellPoints, equals(3));
      // m.value = -40;
      // expect(m.spellPoints, equals(10));
    });
  });

  // test('should have label', () {
  //   expect(RitualModifier.affliction.name, equals('Affliction'));
  //   expect(RitualModifier.alteredTrait.name, equals('Altered Traits'));
  //   expect(RitualModifier.areaOfEffect.name, equals('Area of Effect'));
  //   expect(RitualModifier.bestowsBonus.name, equals('Bestows a Bonus'));
  //   expect(RitualModifier.bestowsPenalty.name, equals('Bestows a Penalty'));
  //   expect(RitualModifier.damage.name, equals('Damage'));
  //   expect(RitualModifier.duration.name, equals('Duration'));
  //   expect(RitualModifier.extraEnergy.name, equals('Extra Energy'));
  //   expect(RitualModifier.healing.name, equals('Healing'));
  //   expect(RitualModifier.metaMagic.name, equals('Meta-Magic'));
  //   expect(RitualModifier.range.name, equals('Range'));
  //   expect(RitualModifier.speed.name, equals('Speed'));
  //   expect(RitualModifier.subjectWeight.name, equals('Subject Weight'));
  //   expect(RitualModifier.traditionalTrappings.name,
  //       equals('Traditional Trappings'));
  // });

  // test('should allow lookup by name', () {
  //   expect(RitualModifier.fromString('Affliction'),
  //       same(RitualModifier.affliction));
  //   expect(RitualModifier.fromString('Altered Traits'),
  //       same(RitualModifier.alteredTrait));
  //   expect(RitualModifier.fromString('Area of Effect'),
  //       same(RitualModifier.areaOfEffect));
  //   expect(RitualModifier.fromString('Bestows a Bonus'),
  //       same(RitualModifier.bestowsBonus));
  //   expect(RitualModifier.fromString('Bestows a Penalty'),
  //       same(RitualModifier.bestowsPenalty));
  //   expect(RitualModifier.fromString('Damage'), same(RitualModifier.damage));
  //   expect(
  //       RitualModifier.fromString('Duration'), same(RitualModifier.duration));
  //   expect(RitualModifier.fromString('Extra Energy'),
  //       same(RitualModifier.extraEnergy));
  //   expect(RitualModifier.fromString('Healing'), same(RitualModifier.healing));
  //   expect(RitualModifier.fromString('Meta-Magic'),
  //       same(RitualModifier.metaMagic));
  //   expect(RitualModifier.fromString('Range'), same(RitualModifier.range));
  //   expect(RitualModifier.fromString('Speed'), same(RitualModifier.speed));
  //   expect(RitualModifier.fromString('Subject Weight'),
  //       same(RitualModifier.subjectWeight));
  //   expect(RitualModifier.fromString('Traditional Trappings'),
  //       same(RitualModifier.traditionalTrappings));
  // });

  // test('toString', () {
  //   expect(RitualModifier.affliction.toString(), equals('Affliction'));
  //   expect(RitualModifier.alteredTrait.toString(), equals('Altered Traits'));
  //   expect(RitualModifier.areaOfEffect.toString(), equals('Area of Effect'));
  //   expect(RitualModifier.bestowsBonus.toString(), equals('Bestows a Bonus'));
  //   expect(
  //       RitualModifier.bestowsPenalty.toString(), equals('Bestows a Penalty'));
  //   expect(RitualModifier.damage.toString(), equals('Damage'));
  //   expect(RitualModifier.duration.toString(), equals('Duration'));
  //   expect(RitualModifier.extraEnergy.toString(), equals('Extra Energy'));
  //   expect(RitualModifier.healing.toString(), equals('Healing'));
  //   expect(RitualModifier.metaMagic.toString(), equals('Meta-Magic'));
  //   expect(RitualModifier.range.toString(), equals('Range'));
  //   expect(RitualModifier.speed.toString(), equals('Speed'));
  //   expect(RitualModifier.subjectWeight.toString(), equals('Subject Weight'));
  //   expect(
  //       RitualModifier.traditionalTrappings.toString(),
  //       equals('Traditional '
  //           'Trappings'));
  // });

  // test('default level', () {
  //   expect(RitualModifier.affliction.defaultLevel, equals(0));
  //   expect(RitualModifier.alteredTrait.defaultLevel, equals(0));
  //   expect(RitualModifier.areaOfEffect.defaultLevel, equals(1));
  //   expect(RitualModifier.bestowsBonus.defaultLevel, equals(0));
  //   expect(RitualModifier.bestowsPenalty.defaultLevel, equals(0));
  //   expect(RitualModifier.damage.defaultLevel, equals(0));
  //   expect(RitualModifier.duration.defaultLevel, equals(0));
  //   expect(RitualModifier.extraEnergy.defaultLevel, equals(0));
  //   expect(RitualModifier.healing.defaultLevel, equals(0));
  //   expect(RitualModifier.metaMagic.defaultLevel, equals(0));
  //   expect(RitualModifier.range.defaultLevel, equals(0));
  //   expect(RitualModifier.speed.defaultLevel, equals(0));
  //   expect(RitualModifier.subjectWeight.defaultLevel, equals(0));
  //   expect(RitualModifier.traditionalTrappings.defaultLevel, equals(0));
  // });

  // test('should publish labels', () {
  //   expect(RitualModifier.labels.length, equals(14));
  //   expect(
  //       RitualModifier.labels,
  //       containsAll(<String>[
  //         "Affliction",
  //         'Altered Traits',
  //         'Area of Effect',
  //         'Bestows a Bonus',
  //         'Bestows a Penalty',
  //         'Damage',
  //         'Duration',
  //         'Extra Energy',
  //         'Healing',
  //         'Meta-Magic',
  //         'Range',
  //         'Speed',
  //         'Subject Weight',
  //         'Traditional Trappings',
  //       ]));
  // });
}
