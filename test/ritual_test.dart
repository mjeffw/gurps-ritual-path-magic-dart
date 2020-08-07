import 'package:gurps_ritual_path_magic_model/ritual_path_magic.dart';
import 'package:gurps_ritual_path_magic_model/src/level.dart';
import 'package:gurps_ritual_path_magic_model/src/path.dart';
import 'package:gurps_ritual_path_magic_model/src/path_effect.dart';
import 'package:gurps_ritual_path_magic_model/src/ritual.dart';
import 'package:test/test.dart';

void main() {
  test('Bag of Bones', () {
    Ritual r = new Ritual(name: 'Bag of Bones', effects: <PathEffect>[
      PathEffect(Path.undead, level: Level.greater, effect: Effect.control),
      PathEffect(Path.undead, effect: Effect.create)
    ]);

    expect(r.name, equals('Bag of Bones'));
    expect(
        r.effects,
        containsAll(<PathEffect>[
          PathEffect(Path.undead, level: Level.greater, effect: Effect.control),
          PathEffect(Path.undead, level: Level.lesser, effect: Effect.create)
        ]));

    expect(r.modifiers, isEmpty);
    expect(r.greaterEffects, equals(1));
    expect(r.effectsMultiplier, equals(3));
  });

  test('Alertness', () {
    // Ritual r = new Ritual(name: 'Alertness', effects: <PathEffect>[
    //   PathEffect(Path.mind, effect: Effect.strengthen)
    // ], modifiers: <ModifierComponent>[
    //   ModifierComponent(RitualModifier.bestowsBonus,
    //       level: 2, variation: 'Moderate', detail: 'Sense rolls')
    // ]);

    // expect(r.name, 'Alertness');
  });
}
