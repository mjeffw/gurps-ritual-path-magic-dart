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
  });
}
