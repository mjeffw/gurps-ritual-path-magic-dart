import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_ritual_path_magic_model/src/effect.dart';
import 'package:gurps_ritual_path_magic_model/src/level.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier/damage_modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier/ritual_modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/path.dart';
import 'package:gurps_ritual_path_magic_model/src/spell_effect.dart';
import 'package:gurps_ritual_path_magic_model/src/ritual.dart';
import 'package:test/test.dart';

void main() {
  test('Bag of Bones', () {
    Ritual r = new Ritual(name: 'Bag of Bones', effects: [
      SpellEffect(Path.undead,
          level: Level.greater, effect: Effect.control, inherent: true),
      SpellEffect(Path.undead, effect: Effect.create, inherent: true)
    ]);

    expect(r.energyCost, equals(33));

    r = r.addPathEffect(SpellEffect(Path.magic, effect: Effect.control));
    expect(r.energyCost, equals(48));

    r = r.addModifier(DurationModifier(duration: GDuration(days: 1)));
    expect(r.energyCost, equals(69));

    r = r.addModifier(SubjectWeight(weight: GWeight(pounds: 100)));

    expect(
        r.effects,
        containsAll(<SpellEffect>[
          SpellEffect(Path.undead,
              level: Level.greater, effect: Effect.control, inherent: true),
          SpellEffect(Path.undead, effect: Effect.create, inherent: true),
          SpellEffect(Path.magic, effect: Effect.control)
        ]));

    expect(r.name, equals('Bag of Bones'));
    expect(r.energyCost, equals(75));
    expect(r.greaterEffects, equals(1));
    expect(r.effectsMultiplier, equals(3));

    expect(
        r.modifiers,
        containsAll(<RitualModifier>[
          DurationModifier(duration: GDuration(days: 1)),
          SubjectWeight(weight: GWeight(pounds: 100))
        ]));
  });

  test('Alertness', () {
    Ritual r = new Ritual(
      name: 'Alertness',
      effects: [
        SpellEffect(Path.mind, effect: Effect.strengthen, inherent: true)
      ],
      modifiers: [
        Bestows('Sense rolls',
            inherent: true, range: BestowsRange.broad, value: 2),
      ],
    );

    expect(r.name, equals('Alertness'));
    expect(r.effectsMultiplier, equals(1));
    expect(r.greaterEffects, equals(0));
    expect(r.energyCost, equals(13));

    r = r.addModifier(DurationModifier(duration: GDuration(minutes: 10)));
    expect(r.energyCost, equals(14));
  });

  test('Air Jet', () {
    Ritual r = Ritual(
      name: 'Air Jet',
      effects: [
        SpellEffect(Path.matter,
            effect: Effect.control, level: Level.greater, inherent: true)
      ],
      modifiers: [
        Damage(inherent: true, direct: false, modifiers: <TraitModifier>[
          TraitModifier(name: 'Double Knockback', percent: 20),
          TraitModifier(name: 'Jet', percent: 0),
          TraitModifier(name: 'No Wounding', percent: -50),
        ]),
      ],
    );

    expect(r.name, equals('Air Jet'));
    expect(r.greaterEffects, 1);
    expect(r.effectsMultiplier, 3);
    expect(r.energyCost, 15);
  });

  test('Amplify Injury', () {
    Ritual r = Ritual(name: 'Amplify Injury', effects: [
      SpellEffect(Path.body,
          level: Level.greater, effect: Effect.destroy, inherent: true)
    ]);
  });
}
