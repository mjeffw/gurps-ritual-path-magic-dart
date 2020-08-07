import 'package:test/test.dart';

import '../lib/src/ritual_modifier.dart';

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
