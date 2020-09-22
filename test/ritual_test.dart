import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_ritual_path_magic_model/src/casting.dart';
import 'package:gurps_ritual_path_magic_model/src/effect.dart';
import 'package:gurps_ritual_path_magic_model/src/level.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier/damage_modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier/range_modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier/ritual_modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/path.dart';
import 'package:gurps_ritual_path_magic_model/src/spell_effect.dart';
import 'package:gurps_ritual_path_magic_model/src/ritual.dart';
import 'package:gurps_ritual_path_magic_model/src/trait.dart';
import 'package:test/test.dart';

void main() {
  test('has == and hashCode', () {
    Ritual r1 = Ritual();
    r1 = r1.copyWith(name: 'Alertness');
    r1 = r1
        .copyWith(effects: [SpellEffect(Path.mind, effect: Effect.strengthen)]);
    r1 = r1.copyWith(
      modifiers: [Bestows('Sense rolls', range: BestowsRange.broad, value: 2)],
    );

    Ritual r2 = Ritual(
      name: 'Alertness',
      effects: [SpellEffect(Path.mind, effect: Effect.strengthen)],
      modifiers: [Bestows('Sense rolls', range: BestowsRange.broad, value: 2)],
    );

    expect(r1, equals(r2));
    expect(r1.hashCode, equals(r2.hashCode));

    r2 = r2.copyWith(notes: 'grekk tesdts fas ot dfk');

    expect(r1, isNot(equals(r2)));
    expect(r1.hashCode, isNot(equals(r2.hashCode)));
  });

  test('Air Jet', () {
    Ritual r = Ritual(name: 'Air Jet');
    r = r.copyWith(effects: [
      SpellEffect(Path.matter, effect: Effect.control, level: Level.greater)
    ]);

    r = r.copyWith(modifiers: [
      Damage(direct: false, modifiers: <TraitModifier>[
        TraitModifier(name: 'Double Knockback', percent: 20),
        TraitModifier(name: 'Jet', percent: 0),
        TraitModifier(name: 'No Wounding', percent: -50),
      ]),
    ]);

    r = r.copyWith(notes: '''
This spell conjures a jet (p. B106) of air extending from the caster’s hand or 
an object that he is holding. The target takes 3d crushing damage; this does no 
actual damage, but it does inflict blunt trauma and is doubled for knockback 
purposes.''');

    expect(r.name, equals('Air Jet'));
    expect(r.greaterEffects, 1);
    expect(r.effectsMultiplier, 3);
    expect(r.energyCost, 15);
  });

  test('Alertness', () {
    Ritual r = Ritual(name: 'Alertness', modifiers: [
      Bestows('Sense rolls', range: BestowsRange.broad, value: 2)
    ]);

    r = r.addSpellEffect(SpellEffect(Path.mind, effect: Effect.strengthen));
    r = r.copyWith(notes: '''
This spell temporarily boosts the subject’s ability to process incoming 
impressions, giving him +2 to all Sense rolls for the next 10 minutes.''');

    expect(r.name, equals('Alertness'));
    expect(r.effectsMultiplier, equals(1));
    expect(r.greaterEffects, equals(0));
    expect(r.energyCost, equals(13));

    Casting typical = Casting(r,
        modifiers: [DurationModifier(duration: GDuration(minutes: 10))]);

    expect(typical.energyCost, equals(14));
  });

  test('Amplify Injury', () {
    Ritual r = Ritual(name: 'Amplify Injury', effects: [
      SpellEffect(Path.body, level: Level.greater, effect: Effect.destroy)
    ], modifiers: [
      AlteredTraits(
          Trait(name: 'Vulnerability to Physical Attacks, x2', baseCost: -40)),
    ], notes: '''
This spell causes the target to suffer double normal injury from physical 
attacks (those that use some sort of material substance to cause harm) for 
the next 10 minutes. This does not increase the damage from energy, mental 
attacks, etc. The target must be within 10 yards.''');

    expect(r.name, equals('Amplify Injury'));
    expect(r.energyCost, equals(39));
    expect(r.greaterEffects, equals(1));

    Casting typical = Casting(r, modifiers: [
      DurationModifier(duration: GDuration(minutes: 10)),
      Range(distance: GDistance(yards: 10)),
      SubjectWeight(weight: GWeight(pounds: 300)),
    ]);

    expect(typical.energyCost, equals(63));
  });

  test('Babble On', () {
    Ritual babbleOn = Ritual(
      name: 'Babble On',
      effects: [
        SpellEffect(Path.mind, effect: Effect.sense),
        SpellEffect(Path.mind, effect: Effect.strengthen),
      ],
      modifiers: [
        AreaOfEffect(radius: 3),
        AlteredTraits(
          Trait(name: 'Babel-Tongue (Native/None)', baseCost: 3),
        )
      ],
      notes: '''
This spell grants the subjects (at least two) the ability to converse with one 
another in a mystically made-up language called "Babel-Tongue" – so called 
after the Biblical story of the Tower of Babel. All subjects who are to be 
affected must be within 3 yards of the caster. The “Babel-Tongue” language is 
created anew for each casting; it cannot be learned normally. Only those under 
the effects of this spell (or who have some other supernatural means to speak 
unknown and alien languages) can comprehend it.''',
    );

    expect(babbleOn.name, equals('Babble On'));
    expect(babbleOn.effectsMultiplier, equals(1));
    expect(babbleOn.greaterEffects, equals(0));
    expect(babbleOn.energyCost, equals(10));

    Casting typical = Casting(babbleOn, modifiers: [
      DurationModifier(duration: GDuration(hours: 1)),
    ]);
    expect(typical.energyCost, equals(13));
  });

  test('Bag of Bones', () {
    Ritual ritual = new Ritual(name: 'Bag of Bones', effects: [
      SpellEffect(Path.undead, level: Level.greater, effect: Effect.control),
      SpellEffect(Path.undead, effect: Effect.create),
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
              level: Level.greater, effect: Effect.control),
          SpellEffect(Path.undead, effect: Effect.create),
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

  test('Body of Shadow', () {
    Ritual ritual = Ritual(name: 'Body of Shadow', effects: [
      SpellEffect(Path.body, level: Level.greater, effect: Effect.transform),
      SpellEffect(Path.energy, level: Level.greater, effect: Effect.transform)
    ], modifiers: [
      AlteredTraits(Trait(name: 'Shadow Form', baseCost: 50))
    ], notes: '''
The subject’s body fades away, leaving only his shadow behind. This gives him 
the Shadow Form advantage (p. B83) for the next 10 minutes. His clothing, gear, 
etc., falls to the ground around him. Though the subject is now made of living 
darkness, he gains no special ability to **see** in the dark.
      ''');

    expect(ritual.name, equals('Body of Shadow'));
    expect(ritual.greaterEffects, equals(2));
    expect(ritual.effectsMultiplier, equals(5));
    expect(ritual.baseEnergyCost, equals(66));
    expect(ritual.energyCost, equals(330));

    Casting typical = Casting(ritual, modifiers: [
      DurationModifier(duration: GDuration(minutes: 10)),
      SubjectWeight(weight: GWeight(pounds: 300))
    ]);

    expect(typical.energyCost, equals(350));
  });

  test('Call Spirit', () {
    Ritual ritual = Ritual(name: 'Call Spirit', effects: [
      SpellEffect(Path.spirit, effect: Effect.control, level: Level.greater)
    ], notes: '''
This ritual implants a compulsion in a specific subject spirit to travel at its 
greatest speed to the location of the caster at the time the ritual is cast. If 
the spirit is unable to reach that location within one day, the compulsion ends. 
The subject must be within 10 miles of the caster, but the magic will reach 
across the dimensional barrier into the spirit realm.

Note that this ritual does not affect the spirit’s attitude toward the caster. 
Indeed, a spirit called this way likely will be quite hostile when it arrives!
    ''');

    expect(ritual.name, equals('Call Spirit'));
    expect(ritual.baseEnergyCost, equals(5));
    expect(ritual.greaterEffects, equals(1));
    expect(ritual.effectsMultiplier, equals(3));
    expect(ritual.modifiers, isEmpty);
  });
}
