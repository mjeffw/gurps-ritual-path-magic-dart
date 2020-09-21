import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_ritual_path_magic_model/src/casting.dart';
import 'package:gurps_ritual_path_magic_model/src/effect.dart';
import 'package:gurps_ritual_path_magic_model/src/level.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier/damage_modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier/ritual_modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/path.dart';
import 'package:gurps_ritual_path_magic_model/src/spell_effect.dart';
import 'package:gurps_ritual_path_magic_model/src/ritual.dart';
import 'package:gurps_ritual_path_magic_model/src/trait.dart';
import 'package:test/test.dart';

void main() {
  test('Air Jet', () {
    Ritual r = Ritual(
      name: 'Air Jet',
      effects: [
        SpellEffect(Path.matter,
            effect: Effect.control, level: Level.greater, inherent: true)
      ],
      modifiers: [
        Damage(direct: false, modifiers: <TraitModifier>[
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

  test('Alertness', () {
    Ritual r = new Ritual(
      name: 'Alertness',
      effects: [
        SpellEffect(Path.mind, effect: Effect.strengthen, inherent: true)
      ],
      modifiers: [
        Bestows('Sense rolls', range: BestowsRange.broad, value: 2),
      ],
    );

    expect(r.name, equals('Alertness'));
    expect(r.effectsMultiplier, equals(1));
    expect(r.greaterEffects, equals(0));
    expect(r.energyCost, equals(13));

    r = r.addModifier(DurationModifier(duration: GDuration(minutes: 10)));
    expect(r.energyCost, equals(14));
  });

  test('Amplify Injury', () {
    Ritual r = Ritual(name: 'Amplify Injury', effects: [
      SpellEffect(Path.body,
          level: Level.greater, effect: Effect.destroy, inherent: true)
    ], modifiers: [
      AlteredTraits(
          Trait(name: 'Vulnerability to Physical Attacks, x2', baseCost: -40)),
    ]);

    expect(r.name, equals('Amplify Injury'));
    expect(r.energyCost, equals(39));
    expect(r.greaterEffects, equals(1));
  });

  test('Bag of Bones', () {
    Ritual ritual = new Ritual(name: 'Bag of Bones', effects: [
      SpellEffect(Path.undead,
          level: Level.greater, effect: Effect.control, inherent: true),
      SpellEffect(Path.undead, effect: Effect.create, inherent: true)
    ]);

    ritual = ritual.copyWith(notes: '''
This spell is typically cast as a charm, which is then attached to a skeleton – 
normally a human one, though any skeleton weighing up to 100 lbs. will suffice. 
Once broken, the charm imbues dark magic into the bones, making them into an 
animated skeleton that follows the directions of the caster. After a day, the 
magic fades and the undead monster collapses into a heap. Statistics for 
animated skeletons can be found in several books, including on p. 152 of 
***GURPS Magic***; if you lack them, use ST 9, DX 12, IQ 8, HT 10, with DR 2, 
no skills, and other traits appropriate to an animated skeleton.
''');

    expect(ritual.energyCost, equals(33));
    expect(ritual.name, equals('Bag of Bones'));
    expect(ritual.greaterEffects, equals(1));
    expect(ritual.effectsMultiplier, equals(3));

    Casting typical = Casting(ritual, effects: [
      SpellEffect(Path.magic, effect: Effect.control),
    ], modifiers: [
      DurationModifier(duration: GDuration(days: 1)),
      SubjectWeight(weight: GWeight(pounds: 100)),
    ]);

    expect(
        typical.effects,
        containsAll(<SpellEffect>[
          SpellEffect(Path.undead,
              level: Level.greater, effect: Effect.control, inherent: true),
          SpellEffect(Path.undead, effect: Effect.create, inherent: true),
          SpellEffect(Path.magic, effect: Effect.control),
        ]));

    expect(typical.energyCost, equals(75));

    expect(
        typical.modifiers,
        containsAll(<RitualModifier>[
          DurationModifier(duration: GDuration(days: 1)),
          SubjectWeight(weight: GWeight(pounds: 100))
        ]));
  });
}
