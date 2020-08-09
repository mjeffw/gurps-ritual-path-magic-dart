import 'package:gurps_dart/gurps_dart.dart';
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
      expect(m.percent, equals(0));
      expect(m.name, equals("Afflictions"));
      expect(m.energyCost, equals(0));
    });

    test("has inherent", () {
      Affliction m2 = Affliction("Bar", inherent: true);
      expect(m2.inherent, equals(true));
    });

    test("+1 SP for every +5% it’s worth as an enhancement to Affliction", () {
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

  group("Altered Traits", () {
    AlteredTraits m;

    setUp(() async {
      Trait trait = Trait(name: "foo");
      m = AlteredTraits(trait);
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.characterPoints, equals(0));
      expect(m.name, equals("Altered Traits"));
      expect(m.energyCost, equals(0));
    });

    test("has inherent", () {
      var alt = AlteredTraits.copyWith(m, inherent: true);
      expect(alt.inherent, equals(true));
    });

    test('adds +1 SP for every 5 cps removed', () {
      var alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: -1));
      print('${alt.energyCost}');
      expect(alt.energyCost, equals(1));
      alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: -5));
      expect(alt.energyCost, equals(1));
      alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: -6));
      expect(alt.energyCost, equals(2));
      alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: -10));
      expect(alt.energyCost, equals(2));
      alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: -11));
      expect(alt.energyCost, equals(3));
    });

    test("adds +1 SP for every cp added", () {
      var alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: 1));
      expect(alt.energyCost, equals(1));
      alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: 11));
      expect(alt.energyCost, equals(11));
      alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: 24));
      expect(alt.energyCost, equals(24));
      alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: 100));
      expect(alt.energyCost, equals(100));
    });

    test("allows for Limitations/Enhancements", () {
      var alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: 24));
      alt = AlteredTraits.addModifier(alt, TraitModifier(percent: 10));
      expect(alt.energyCost, equals(27));

      alt = AlteredTraits.addModifier(alt, TraitModifier(percent: 5));
      expect(alt.energyCost, equals(28));

      alt = AlteredTraits.addModifier(alt, TraitModifier(percent: -10));
      expect(alt.energyCost, equals(26));
    });

    test("another test for Limitations/Enhancements", () {
      var alt = AlteredTraits.addModifier(m, TraitModifier(percent: 35));
      alt = AlteredTraits.addModifier(alt, TraitModifier(percent: -10));

      expect(alt.energyCost, equals(0));

      alt = AlteredTraits.copyWith(alt, trait: Trait(baseCost: 30));
      expect(alt.energyCost, equals(38));
      alt = AlteredTraits.copyWith(alt, trait: Trait(baseCost: 100));
      expect(alt.energyCost, equals(125));
      alt = AlteredTraits.copyWith(alt, trait: Trait(baseCost: -10));
      expect(alt.energyCost, equals(3));
      alt = AlteredTraits.copyWith(alt, trait: Trait(baseCost: -40));
      expect(alt.energyCost, equals(10));
    });
  });

  group("Area of Effect", () {
    AreaOfEffect m;

    setUp(() async {
      m = AreaOfEffect();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.radius, equals(0));
      expect(m.name, equals("Area of Effect"));
      expect(m.energyCost, equals(0));
    });

    test("has inherent", () {
      var alt = AreaOfEffect.copyWith(m, inherent: true);
      expect(alt.inherent, equals(true));
    });

    test("radius calculation", () {
      var alt = AreaOfEffect.copyWith(m, radius: 1);
      expect(alt.energyCost, equals(2));
      alt = AreaOfEffect.copyWith(m, radius: 3);
      expect(alt.energyCost, equals(2));
      alt = AreaOfEffect.copyWith(m, radius: 4);
      expect(alt.energyCost, equals(4));
      alt = AreaOfEffect.copyWith(m, radius: 5);
      expect(alt.energyCost, equals(4));
      alt = AreaOfEffect.copyWith(m, radius: 6);
      expect(alt.energyCost, equals(6));
      alt = AreaOfEffect.copyWith(m, radius: 15);
      expect(alt.energyCost, equals(10));
      alt = AreaOfEffect.copyWith(m, radius: 20);
      expect(alt.energyCost, equals(12));
      alt = AreaOfEffect.copyWith(m, radius: 300);
      expect(alt.energyCost, equals(26));
    });

    test("add +1 SP for every two specific subjects not affected", () {
      fail('not implemented');
      // m.value = 4;
      // expect(m.spellPoints, equals(40));
      // m.setTargetInfo(2, false);
      // expect(m.spellPoints, equals(41));
      // m.setTargetInfo(6, false);
      // expect(m.spellPoints, equals(43));
      // m.setTargetInfo(7, true);
      // expect(m.spellPoints, equals(44));
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
