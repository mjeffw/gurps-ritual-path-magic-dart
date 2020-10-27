import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:gurps_rpm_model/src/exporter/casting_exporter.dart';
import 'package:test/test.dart';

void main() {
  group('Casting:', () {
    test('Air Jet', () {
      Ritual r = Ritual(
          name: 'Air Jet',
          modifiers: [
            Damage(
              dice: DieRoll(dice: 1),
              direct: false,
              modifiers: [
                TraitModifier(name: 'No Wounding', percent: -50),
                TraitModifier(name: 'Double Knockback', percent: 20),
                TraitModifier(name: 'Jet', percent: 0),
              ],
            ),
          ],
          effects: [
            SpellEffect(Path.matter,
                level: Level.greater, effect: Effect.control),
          ],
          notes:
              'This spell conjures a jet (p. B106) of air extending from the '
              'caster’s hand or an object that he is holding. The target takes '
              '3d crushing damage; this does no actual damage, but it does '
              'inflict blunt trauma and is doubled for knockback purposes.');

      Casting c = Casting(r);

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Air Jet\n'
              ' *  _Spell Effects:_ Greater Control Matter.\n'
              ' *  _Inherent Modifiers:_ Damage, External Crushing (Double '
              'Knockback; Jet; No Wounding).\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This spell conjures a jet (p. B106) of air extending from '
              'the caster’s hand or an object that he is holding. The target '
              'takes 3d crushing damage; this does no actual damage, but it '
              'does inflict blunt trauma and is doubled for knockback purposes.'
              '\n'
              '\n'
              ' *  _Typical Casting:_ Greater Control Matter (5) + Damage, '
              'External Crushing 3d (Double Knockback, +20%; Jet, +0%; No '
              'Wounding, -50%) (1). _18 energy (6×3)._\n'));
    });

    test('Alertness', () {
      Ritual r = Ritual(
          name: 'Alertness',
          modifiers: [
            Bestows('Sense rolls', range: BestowsRange.broad, value: 2)
          ],
          effects: [
            SpellEffect(Path.mind, effect: Effect.strengthen),
          ],
          notes: 'This spell temporarily boosts the subject’s '
              'ability to process incoming impressions, giving him +2 to all '
              'Sense rolls for the next 10 minutes.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(minutes: 10)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Alertness\n'
              ' *  _Spell Effects:_ Lesser Strengthen Mind.\n'
              ' *  _Inherent Modifiers:_ Bestows a Bonus, Sense rolls.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell temporarily boosts the subject’s ability to '
              'process incoming impressions, giving him +2 to all Sense rolls '
              'for the next 10 minutes.\n'
              '\n'
              ' *  _Typical Casting:_ Lesser Strengthen Mind (3) + Bestows a '
              'Bonus, +2 to Sense rolls (10) + Duration, 10 minutes (1). '
              '_14 energy (14×1)._\n'));
    });

    test('Amplify Injury', () {
      Ritual r = Ritual(
          name: 'Amplify Injury',
          modifiers: [
            AlteredTraits(
              Trait(
                  name: 'Vulnerability to Physical Attacks',
                  details: '×2',
                  baseCost: -40),
            ),
          ],
          effects: [
            SpellEffect(Path.body,
                level: Level.greater, effect: Effect.destroy),
          ],
          notes:
              'This spell causes the target to suffer double normal injury from '
              'physical attacks (those that use some sort of material substance '
              'to cause harm) for the next 10 minutes. This does not increase '
              'the damage from energy, mental attacks, etc. The target must be '
              'within 10 yards.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(minutes: 10)))
          .addModifier(Range(distance: GDistance(yards: 10)))
          .addModifier(SubjectWeight(weight: GWeight(pounds: 300)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Amplify Injury\n'
              ' *  _Spell Effects:_ Greater Destroy Body.\n'
              ' *  _Inherent Modifiers:_ Altered Trait, Vulnerability to '
              'Physical Attacks.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This spell causes the target to suffer double normal injury '
              'from physical attacks (those that use some sort of material '
              'substance to cause harm) for the next 10 minutes. This does not '
              'increase the damage from energy, mental attacks, etc. The '
              'target must be within 10 yards.\n'
              '\n'
              ' *  _Typical Casting:_ Greater Destroy Body (5) + Altered Trait, '
              'Vulnerability to Physical Attacks ×2 (8) + Duration, 10 minutes '
              '(1) + Range, 10 yards (4) + Subject Weight, 300 lbs. (3). '
              '_63 energy (21×3)._\n'));
    });

    test('Babble On', () {
      Ritual r = Ritual(
          name: 'Babble On',
          effects: [
            SpellEffect(Path.mind),
            SpellEffect(Path.mind, effect: Effect.strengthen)
          ],
          modifiers: [
            AreaOfEffect(radius: 3),
            AlteredTraits(Trait(
                name: 'Babel-Tongue', details: '(Native/None)', baseCost: 3)),
          ],
          notes: 'This spell grants the subjects (at least two) the ability to '
              'converse with one another in a mystically made-up language '
              'called “Babel-Tongue” – so called after the Biblical story of '
              'the Tower of Babel. All subjects who are to be affected must be '
              'within 3 yards of the caster. The “Babel-Tongue” language is '
              'created anew for each casting; it cannot be learned normally. '
              'Only those under the effects of this spell (or who have some '
              'other supernatural means to speak unknown and alien languages) '
              'can comprehend it.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(hours: 1)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Babble On\n'
              ' *  _Spell Effects:_ Lesser Sense Mind + Lesser Strengthen Mind.\n'
              ' *  _Inherent Modifiers:_ Area of Effect + Altered Trait, '
              'Babel-Tongue.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell grants the subjects (at least two) the ability to '
              'converse with one another in a mystically made-up language '
              'called “Babel-Tongue” – so called after the Biblical story of '
              'the Tower of Babel. All subjects who are to be affected must be '
              'within 3 yards of the caster. The “Babel-Tongue” language is '
              'created anew for each casting; it cannot be learned normally. '
              'Only those under the effects of this spell (or who have some '
              'other supernatural means to speak unknown and alien languages) '
              'can comprehend it.\n'
              '\n'
              ' *  _Typical Casting:_ Lesser Sense Mind (2) + Lesser Strengthen '
              'Mind (3) + Altered Trait, Babel-Tongue (Native/None) (3) + '
              'Area of Effect, 3 yards (2) + Duration, 1 hour (3). _13 energy '
              '(13×1)._\n'));
    });

    test('Bag of Bones', () {
      Ritual r = Ritual(
          name: 'Bag of Bones',
          effects: [
            SpellEffect(Path.undead, effect: Effect.create),
            SpellEffect(Path.undead,
                effect: Effect.control, level: Level.greater),
          ],
          modifiers: [],
          notes:
              'This spell is typically cast as a charm, which is then attached '
              'to a skeleton – normally a human one, though any skeleton '
              'weighing up to 100 lbs. will suffice. Once broken, the charm '
              'imbues dark magic into the bones, making them into an animated '
              'skeleton that follows the directions of the caster. After a '
              'day, the magic fades and the undead monster collapses into a '
              'heap. Statistics for animated skeletons can be found in several '
              'books, including on p. 152 of _**GURPS Magic**_; if you lack '
              'them, use ST 9, DX 12, IQ 8, HT 10, with DR 2, no skills, and '
              'other traits appropriate to an animated skeleton.');

      Casting c = Casting(r)
          .addEffect(SpellEffect(Path.magic, effect: Effect.control))
          .addModifier(SubjectWeight(weight: GWeight(pounds: 100)))
          .addModifier(DurationModifier(duration: GDuration(days: 1)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Bag of Bones\n'
              ' *  _Spell Effects:_ Greater Control Undead + Lesser Create Undead.\n'
              ' *  _Inherent Modifiers:_ None.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This spell is typically cast as a charm, which is then '
              'attached to a skeleton – normally a human one, though any '
              'skeleton weighing up to 100 lbs. will suffice. Once broken, the '
              'charm imbues dark magic into the bones, making them into an '
              'animated skeleton that follows the directions of the caster. '
              'After a day, the magic fades and the undead monster collapses '
              'into a heap. Statistics for animated skeletons can be found in '
              'several books, including on p. 152 of _**GURPS Magic**_; if you '
              'lack them, use ST 9, DX 12, IQ 8, HT 10, with DR 2, no skills, '
              'and other traits appropriate to an animated skeleton.\n'
              '\n'
              ' *  _Typical Casting:_ Greater Control Undead (5) + Lesser '
              'Create Undead (6) + Lesser Control Magic (5) + Duration, 1 day '
              '(7) + Subject Weight, 100 lbs. (2). _75 energy (25×3)._\n'));
    });

    test('Body of Shadow', () {
      Ritual r = Ritual(
          name: 'Body of Shadow',
          effects: [
            SpellEffect(Path.energy,
                effect: Effect.transform, level: Level.greater),
            SpellEffect(Path.body,
                effect: Effect.transform, level: Level.greater),
          ],
          modifiers: [AlteredTraits(Trait(name: 'Shadow Form', baseCost: 50))],
          notes:
              'The subject’s body fades away, leaving only his shadow behind. '
              'This gives him the Shadow Form advantage (p. B83) for the next '
              '10 minutes. His clothing, gear, etc., falls to the ground '
              'around him. Though the subject is now made of living darkness, '
              'he gains no special ability to see in the dark.');

      Casting c = Casting(r)
          .addModifier(SubjectWeight(weight: GWeight(pounds: 300)))
          .addModifier(DurationModifier(duration: GDuration(minutes: 10)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Body of Shadow\n'
              ' *  _Spell Effects:_ Greater Transform Body + Greater Transform Energy.\n'
              ' *  _Inherent Modifiers:_ Altered Trait, Shadow Form.\n'
              ' *  _Greater Effects:_ 2 (×5).\n'
              '\n'
              'The subject’s body fades away, leaving only his shadow behind. '
              'This gives him the Shadow Form advantage (p. B83) for the next '
              '10 minutes. His clothing, gear, etc., falls to the ground '
              'around him. Though the subject is now made of living darkness, '
              'he gains no special ability to see in the dark.\n'
              '\n'
              ' *  _Typical Casting:_ Greater Transform Body (8) + Greater '
              'Transform Energy (8) + Altered Trait, Shadow Form (50) + '
              'Duration, 10 minutes (1) + Subject Weight, 300 lbs. (3). '
              '_350 energy (70×5)._\n'));
    });

    test('Call Spirit', () {
      Ritual r = Ritual(
          name: 'Call Spirit',
          effects: [
            SpellEffect(Path.spirit,
                effect: Effect.control, level: Level.greater),
          ],
          modifiers: [],
          notes:
              'This ritual implants a compulsion in a specific subject spirit '
              'to travel at its greatest speed to the location of the caster '
              'at the time the ritual is cast. If the spirit is unable to '
              'reach that location within one day, the compulsion ends. The '
              'subject must be within 10 miles of the caster, but the magic '
              'will reach across the dimensional barrier into the spirit '
              'realm.\n\n'
              'Note that this ritual does not affect the spirit’s attitude '
              'toward the caster. Indeed, a spirit called this way likely will '
              'be quite hostile when it arrives!');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(days: 1)))
          .addModifier(Range(distance: GDistance(miles: 10)))
          .addModifier(RangeDimensional(numberDimensions: 1));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Call Spirit\n'
              ' *  _Spell Effects:_ Greater Control Spirit.\n'
              ' *  _Inherent Modifiers:_ None.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This ritual implants a compulsion in a specific subject spirit '
              'to travel at its greatest speed to the location of the caster '
              'at the time the ritual is cast. If the spirit is unable to '
              'reach that location within one day, the compulsion ends. The '
              'subject must be within 10 miles of the caster, but the magic '
              'will reach across the dimensional barrier into the spirit '
              'realm.\n\n'
              'Note that this ritual does not affect the spirit’s attitude '
              'toward the caster. Indeed, a spirit called this way likely will '
              'be quite hostile when it arrives!\n'
              '\n'
              ' *  _Typical Casting:_ Greater Control Spirit (5) + Duration, '
              '1 day (7) + Range, 10 miles (24) + Range, 1 dimension (10). '
              '_138 energy (46×3)._\n'));
    });

    test('Chill', () {
      Ritual r = Ritual(
          name: 'Chill',
          effects: [
            SpellEffect(Path.energy, effect: Effect.control),
          ],
          modifiers: [
            AreaOfEffect(radius: 3),
          ],
          notes:
              'This spell lowers the temperature in an area. It is typically '
              'used to reduce a 1- to 3-yard area down to freezing, creating a '
              'way for low-tech casters (or those wealthy enough to hire them) '
              'to preserve food. It can also be used to cool a room. It cannot '
              'be used to set a specific temperature; for that, a Greater '
              'Control Energy effect is required.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(months: 1)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Chill\n'
              ' *  _Spell Effects:_ Lesser Control Energy.\n'
              ' *  _Inherent Modifiers:_ Area of Effect.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell lowers the temperature in an area. It is typically '
              'used to reduce a 1- to 3-yard area down to freezing, creating a '
              'way for low-tech casters (or those wealthy enough to hire them) '
              'to preserve food. It can also be used to cool a room. It cannot '
              'be used to set a specific temperature; for that, a Greater '
              'Control Energy effect is required.\n'
              '\n'
              ' *  _Typical Casting:_ Lesser Control Energy (5) + Area of '
              'Effect, 3 yards (2) + Duration, 1 month (11). '
              '_18 energy (18×1)._\n'));
    });

    test('Cleanse Disease', () {
      Ritual r = Ritual(
          name: 'Cleanse Disease',
          effects: [
            SpellEffect(Path.body, effect: Effect.destroy),
          ],
          modifiers: [
            AreaOfEffect(radius: 3),
          ],
          notes: 'This ritual utterly eradicates any disease-giving bacteria, '
              'fungi, parasites, viruses, and so on within three yards, no '
              'matter how contagious or drug-resistant they might be. (The GM '
              'may always choose to give supernatural or otherwise “special” '
              'pathogens a resistance roll, of course.) This ritual only '
              'cleans an area of disease; it won’t actually cure anyone.');

      Casting c =
          Casting(r).addModifier(SubjectWeight(weight: GWeight(pounds: 10)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Cleanse Disease\n'
              ' *  _Spell Effects:_ Lesser Destroy Body.\n'
              ' *  _Inherent Modifiers:_ Area of Effect.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This ritual utterly eradicates any disease-giving bacteria, '
              'fungi, parasites, viruses, and so on within three yards, no '
              'matter how contagious or drug-resistant they might be. (The GM '
              'may always choose to give supernatural or otherwise “special” '
              'pathogens a resistance roll, of course.) This ritual only '
              'cleans an area of disease; it won’t actually cure anyone.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Destroy Body (5) + Area of Effect, 3 yards (2) + '
              'Subject Weight, 10 lbs. (0). '
              '_7 energy (7×1)._\n'));
    });

    test('Counterproductivity Curse', () {
      Ritual r = Ritual(
          name: 'Counterproductivity Curse',
          effects: [
            SpellEffect(Path.chance, effect: Effect.control),
          ],
          modifiers: [
            Bestows(
              'rolls to create, make, or repair',
              value: -2,
              range: BestowsRange.broad,
            )
          ],
          notes: 'The bane of the working man, this spell gives -2 to the '
              'target’s rolls to create, make, or repair things. Tools break, '
              'plans are lost, finances are frozen, etc. Job-related things '
              'just go completely wrong for the target while under the '
              'influence of this spell, though in a believable and plausible '
              'manner. This effect lasts for one week and can target anyone '
              'within 10 yards.');

      Casting c = Casting(r)
          .addModifier(Range(distance: GDistance(yards: 10)))
          .addModifier(DurationModifier(duration: GDuration(weeks: 1)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Counterproductivity Curse\n'
              ' *  _Spell Effects:_ Lesser Control Chance.\n'
              ' *  _Inherent Modifiers:_ Bestows a Penalty, rolls to create, '
              'make, or repair.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'The bane of the working man, this spell gives -2 to the '
              'target’s rolls to create, make, or repair things. Tools break, '
              'plans are lost, finances are frozen, etc. Job-related things '
              'just go completely wrong for the target while under the '
              'influence of this spell, though in a believable and plausible '
              'manner. This effect lasts for one week and can target anyone '
              'within 10 yards.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Control Chance (5) + Bestows a Penalty, -2 to rolls to '
              'create, make, or repair (10) + Duration, 1 week (9) + '
              'Range, 10 yards (4). '
              '_28 energy (28×1)._\n'));
    });
  });
}
