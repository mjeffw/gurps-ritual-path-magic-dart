import 'package:gurps_ritual_path_magic_model/ritual_path_magic.dart';
import 'package:gurps_ritual_path_magic_model/src/level.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier_component.dart';
import 'package:gurps_ritual_path_magic_model/src/path.dart';
import 'package:gurps_ritual_path_magic_model/src/path_component.dart';
import 'package:gurps_ritual_path_magic_model/src/ritual.dart';
import 'package:test/test.dart';

void main() {
  test('Bag of Bones', () {
    Ritual r = new Ritual(name: 'Bag of Bones', effects: <PathComponent>[
      PathComponent(Path.undead, level: Level.greater, effect: Effect.control),
      PathComponent(Path.undead, effect: Effect.create)
    ]);

    expect(r.name, equals('Bag of Bones'));
    expect(
        r.effects,
        containsAll(<PathComponent>[
          PathComponent(Path.undead,
              level: Level.greater, effect: Effect.control),
          PathComponent(Path.undead, level: Level.lesser, effect: Effect.create)
        ]));

    expect(r.modifiers, isEmpty);
    expect(r.greaterEffects, equals(1));
    expect(r.effectsMultiplier, equals(3));
  });

  test('Alertness', () {
    Ritual r = new Ritual(name: 'Alertness', effects: <PathComponent>[
      PathComponent(Path.mind, effect: Effect.strengthen)
    ], modifiers: <ModifierComponent>[
      ModifierComponent(Modifier.bestowsBonus,
          level: 2, variation: 'Moderate', detail: 'Sense rolls')
    ]);

    expect(r.name, 'Alertness');
  });
}
