import 'package:test/test.dart';

import '../lib/src/modifier.dart';

void main() {
  test('should have label', () {
    expect(Modifier.affliction.name, equals('Affliction'));
    expect(Modifier.alteredTrait.name, equals('Altered Traits'));
    expect(Modifier.areaOfEffect.name, equals('Area of Effect'));
    expect(Modifier.bestowsBonus.name, equals('Bestows a Bonus'));
    expect(Modifier.bestowsPenalty.name, equals('Bestows a Penalty'));
    expect(Modifier.damage.name, equals('Damage'));
    expect(Modifier.duration.name, equals('Duration'));
    expect(Modifier.extraEnergy.name, equals('Extra Energy'));
    expect(Modifier.healing.name, equals('Healing'));
    expect(Modifier.metaMagic.name, equals('Meta-Magic'));
    expect(Modifier.range.name, equals('Range'));
    expect(Modifier.speed.name, equals('Speed'));
    expect(Modifier.subjectWeight.name, equals('Subject Weight'));
    expect(Modifier.traditionalTrappings.name, equals('Traditional Trappings'));
  });

  test('should allow lookup by name', () {
    expect(Modifier.fromString('Affliction'), same(Modifier.affliction));
    expect(Modifier.fromString('Altered Traits'), same(Modifier.alteredTrait));
    expect(Modifier.fromString('Area of Effect'), same(Modifier.areaOfEffect));
    expect(Modifier.fromString('Bestows a Bonus'), same(Modifier.bestowsBonus));
    expect(Modifier.fromString('Bestows a Penalty'),
        same(Modifier.bestowsPenalty));
    expect(Modifier.fromString('Damage'), same(Modifier.damage));
    expect(Modifier.fromString('Duration'), same(Modifier.duration));
    expect(Modifier.fromString('Extra Energy'), same(Modifier.extraEnergy));
    expect(Modifier.fromString('Healing'), same(Modifier.healing));
    expect(Modifier.fromString('Meta-Magic'), same(Modifier.metaMagic));
    expect(Modifier.fromString('Range'), same(Modifier.range));
    expect(Modifier.fromString('Speed'), same(Modifier.speed));
    expect(Modifier.fromString('Subject Weight'), same(Modifier.subjectWeight));
    expect(Modifier.fromString('Traditional Trappings'),
        same(Modifier.traditionalTrappings));
  });

  test('toString', () {
    expect(Modifier.affliction.toString(), equals('Affliction'));
    expect(Modifier.alteredTrait.toString(), equals('Altered Traits'));
    expect(Modifier.areaOfEffect.toString(), equals('Area of Effect'));
    expect(Modifier.bestowsBonus.toString(), equals('Bestows a Bonus'));
    expect(Modifier.bestowsPenalty.toString(), equals('Bestows a Penalty'));
    expect(Modifier.damage.toString(), equals('Damage'));
    expect(Modifier.duration.toString(), equals('Duration'));
    expect(Modifier.extraEnergy.toString(), equals('Extra Energy'));
    expect(Modifier.healing.toString(), equals('Healing'));
    expect(Modifier.metaMagic.toString(), equals('Meta-Magic'));
    expect(Modifier.range.toString(), equals('Range'));
    expect(Modifier.speed.toString(), equals('Speed'));
    expect(Modifier.subjectWeight.toString(), equals('Subject Weight'));
    expect(
        Modifier.traditionalTrappings.toString(),
        equals('Traditional '
            'Trappings'));
  });

  test('default level', () {
    expect(Modifier.affliction.defaultLevel, equals(0));
    expect(Modifier.alteredTrait.defaultLevel, equals(0));
    expect(Modifier.areaOfEffect.defaultLevel, equals(1));
    expect(Modifier.bestowsBonus.defaultLevel, equals(0));
    expect(Modifier.bestowsPenalty.defaultLevel, equals(0));
    expect(Modifier.damage.defaultLevel, equals(0));
    expect(Modifier.duration.defaultLevel, equals(0));
    expect(Modifier.extraEnergy.defaultLevel, equals(0));
    expect(Modifier.healing.defaultLevel, equals(0));
    expect(Modifier.metaMagic.defaultLevel, equals(0));
    expect(Modifier.range.defaultLevel, equals(0));
    expect(Modifier.speed.defaultLevel, equals(0));
    expect(Modifier.subjectWeight.defaultLevel, equals(0));
    expect(Modifier.traditionalTrappings.defaultLevel, equals(0));
  });

  test('should publish labels', () {
    expect(Modifier.labels.length, equals(14));
    expect(
        Modifier.labels,
        containsAll(<String>[
          "Affliction",
          'Altered Traits',
          'Area of Effect',
          'Bestows a Bonus',
          'Bestows a Penalty',
          'Damage',
          'Duration',
          'Extra Energy',
          'Healing',
          'Meta-Magic',
          'Range',
          'Speed',
          'Subject Weight',
          'Traditional Trappings',
        ]));
  });
}
