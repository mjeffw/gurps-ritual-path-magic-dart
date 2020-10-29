import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:gurps_rpm_model/src/exporter/casting_exporter.dart';
import 'package:test/test.dart';

void main() {
  group('Casting:', () {
    test('Nothing', () {
      Casting c = Casting(Ritual());
      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## \n'
              ' *  _Spell Effects:_ None.\n'
              ' *  _Inherent Modifiers:_ None.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              '\n'
              '\n'
              ' *  _Typical Casting:_ None. _0 energy (0×1)._\n'));
    });

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

    test('Babble On (Except You!)', () {
      Ritual r = Ritual(
          name: 'Babble On (Except You!)',
          effects: [
            SpellEffect(Path.mind),
            SpellEffect(Path.mind, effect: Effect.strengthen)
          ],
          modifiers: [
            AreaOfEffect(radius: 3, excludes: true, numberTargets: 1),
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
          equals('## Babble On (Except You!)\n'
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
              'Area of Effect, 3 yards excluding 1 target (3) + '
              'Duration, 1 hour (3). _14 energy '
              '(14×1)._\n'));
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

    test('Chill (With Meta-Magic)', () {
      Ritual r = Ritual(
          name: 'Chill (With Meta-Magic)',
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
          .addModifier(DurationModifier(duration: GDuration(months: 1)))
          .addModifier(MetaMagic(energy: 12));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Chill (With Meta-Magic)\n'
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
              'Effect, 3 yards (2) + Duration, 1 month (11) + '
              'Meta-Magic, 12 (12). '
              '_30 energy (30×1)._\n'));
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

    test('Create Pocket Dimension', () {
      Ritual r = Ritual(
          name: 'Create Pocket Dimension',
          effects: [
            SpellEffect(Path.matter, effect: Effect.create),
            SpellEffect(Path.crossroads,
                effect: Effect.create, level: Level.greater)
          ],
          modifiers: [AreaOfEffect(radius: 5)],
          notes:
              'This spell creates a pocket dimension about the size of a small '
              'studio apartment (700 square feet). The caster and any being he '
              'brings along can access it. It functions identically to '
              '“normal” reality in all respects and has its own self-renewing '
              'supply of air, but nothing else (no furniture, food, water, '
              'etc.). It lasts for a month, though most casters will regularly '
              'renew it; the fate of anything left in the pocket when the '
              'spell lapses or is canceled is up to the GM.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(months: 1)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Create Pocket Dimension\n'
              ' *  _Spell Effects:_ Greater Create Crossroads + Lesser Create Matter.\n'
              ' *  _Inherent Modifiers:_ Area of Effect.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This spell creates a pocket dimension about the size of a small '
              'studio apartment (700 square feet). The caster and any being he '
              'brings along can access it. It functions identically to '
              '“normal” reality in all respects and has its own self-renewing '
              'supply of air, but nothing else (no furniture, food, water, '
              'etc.). It lasts for a month, though most casters will regularly '
              'renew it; the fate of anything left in the pocket when the '
              'spell lapses or is canceled is up to the GM.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Greater Create Crossroads (6) + Lesser Create Matter (6) + Area '
              'of Effect, 5 yards (4) + Duration, 1 month (11). '
              '_81 energy (27×3)._\n'));
    });

    test('Death Touch', () {
      Ritual r = Ritual(
          name: 'Death Touch',
          effects: [
            SpellEffect(Path.body, effect: Effect.destroy, level: Level.greater)
          ],
          modifiers: [
            Damage(dice: DieRoll(dice: 3), type: DamageType.toxic),
          ],
          notes:
              'This spell allows the caster to momentarily channel the energy '
              'of death itself into any living being, with a touch. If the '
              'subject fails to resist, he takes 3d toxic damage (bypassing '
              'DR).');

      Casting c =
          Casting(r).addModifier(SubjectWeight(weight: GWeight(pounds: 300)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Death Touch\n'
              ' *  _Spell Effects:_ Greater Destroy Body.\n'
              ' *  _Inherent Modifiers:_ Damage, Internal Toxic.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This spell allows the caster to momentarily channel the energy '
              'of death itself into any living being, with a touch. If the '
              'subject fails to resist, he takes 3d toxic damage (bypassing '
              'DR).\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Greater Destroy Body (5) + Damage, Internal Toxic 3d (8) + '
              'Subject Weight, 300 lbs. (3). '
              '_48 energy (16×3)._\n'));
    });

    test('Death Vision', () {
      Ritual r = Ritual(
          name: 'Death Vision',
          effects: [
            SpellEffect(Path.chance, level: Level.greater),
            SpellEffect(Path.mind, effect: Effect.destroy)
          ],
          modifiers: [AfflictionStun()],
          notes: 'If the subject of this spell (who must be within 10 yards of '
              'the caster) does not or chooses not to resist, he sees a vivid '
              'hallucination of his own death. If he has a disadvantageous '
              'Destiny, this may be a preordained death – otherwise, it’s one '
              'possible death. Regardless, he is mentally stunned until he can '
              'make a Will roll to recover.');

      Casting c = Casting(r).addModifier(Range(distance: GDistance(yards: 10)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Death Vision\n'
              ' *  _Spell Effects:_ Greater Sense Chance + Lesser Destroy Mind.\n'
              ' *  _Inherent Modifiers:_ Affliction, Stunning.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'If the subject of this spell (who must be within 10 yards of '
              'the caster) does not or chooses not to resist, he sees a vivid '
              'hallucination of his own death. If he has a disadvantageous '
              'Destiny, this may be a preordained death – otherwise, it’s one '
              'possible death. Regardless, he is mentally stunned until he can '
              'make a Will roll to recover.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Greater Sense Chance (2) + Lesser Destroy Mind (5) + '
              'Affliction, Stunning (0) + Range, 10 yards (4). '
              '_33 energy (11×3)._\n'));
    });

    test('Destruction', () {
      Ritual r = Ritual(
          name: 'Destruction',
          effects: [
            SpellEffect(Path.energy,
                level: Level.greater, effect: Effect.create),
          ],
          modifiers: [
            Damage(dice: DieRoll(dice: 20), type: DamageType.burning)
          ],
          notes: 'This is typically cast as a charm. By breaking the atomic '
              'bonds that hold a person or thing together, this ritual turns '
              'its target (who must be within 15 yards and weigh 1.5 tons or '
              'less) into a cloud of fine ash. If the target fails to resist, '
              'he or it takes 20d burning damage immediately, ignoring DR. '
              'With an average of 70 points of damage, most people and things '
              'will be immediately eradicated.');

      Casting c = Casting(r)
          .addModifier(Range(distance: GDistance(yards: 15)))
          .addModifier(SubjectWeight(weight: GWeight(pounds: 3000)))
          .addEffect(SpellEffect(Path.magic, effect: Effect.control));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Destruction\n'
              ' *  _Spell Effects:_ Greater Create Energy.\n'
              ' *  _Inherent Modifiers:_ Damage, Internal Burning.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This is typically cast as a charm. By breaking the atomic '
              'bonds that hold a person or thing together, this ritual turns '
              'its target (who must be within 15 yards and weigh 1.5 tons or '
              'less) into a cloud of fine ash. If the target fails to resist, '
              'he or it takes 20d burning damage immediately, ignoring DR. '
              'With an average of 70 points of damage, most people and things '
              'will be immediately eradicated.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Greater Create Energy (6) + Lesser Control Magic (5) + Damage, '
              'Internal Burning 20d (76) + Range, 15 yards (5) + Subject '
              'Weight, 1.5 tons (5). '
              '_291 energy (97×3)._\n'));
    });

    test('Diamond Mind', () {
      Ritual r = Ritual(
          name: 'Diamond Mind',
          effects: [
            SpellEffect(Path.mind,
                level: Level.greater, effect: Effect.strengthen),
            SpellEffect(Path.mind, effect: Effect.strengthen)
          ],
          modifiers: [
            AlteredTraits(
                Trait(name: 'Indomitable and Unfazeable', baseCost: 30)),
            AlteredTraits(Trait(
                name: 'Mind Shield',
                costPerLevel: 4,
                levels: 5,
                hasLevels: true)),
          ],
          notes: 'This is typically cast as a charm. This ritual perfects the '
              'subject’s mind, driving away all fear, doubt, and possibility '
              'of being socially influenced by others (unless they possess '
              'Empathy, of course). It even protects the mind from '
              'supernatural intrusions, adding +5 to resistance rolls against '
              'psi powers and the like.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(hours: 1)))
          .addEffect(SpellEffect(Path.magic, effect: Effect.control));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Diamond Mind\n'
              ' *  _Spell Effects:_ Greater Strengthen Mind + '
              'Lesser Strengthen Mind.\n'
              ' *  _Inherent Modifiers:_ '
              'Altered Trait, Indomitable and Unfazeable + '
              'Altered Trait, Mind Shield.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This is typically cast as a charm. This ritual perfects the '
              'subject’s mind, driving away all fear, doubt, and possibility '
              'of being socially influenced by others (unless they possess '
              'Empathy, of course). It even protects the mind from '
              'supernatural intrusions, adding +5 to resistance rolls against '
              'psi powers and the like.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Greater Strengthen Mind (3) + Lesser Strengthen Mind (3) + '
              'Lesser Control Magic (5) + Altered Trait, Indomitable and '
              'Unfazeable (30) + Altered Trait, Mind Shield 5 (20) + Duration, '
              '1 hour (3). '
              '_192 energy (64×3)._\n'));
    });

    test('Dreamcatcher', () {
      Ritual r = Ritual(
          name: 'Dreamcatcher',
          effects: [
            SpellEffect(Path.body, effect: Effect.strengthen),
            SpellEffect(Path.mind, effect: Effect.strengthen),
            SpellEffect(Path.mind, effect: Effect.strengthen),
          ],
          modifiers: [
            AlteredTraits(Trait(
                name: 'Less Sleep',
                levels: 4,
                costPerLevel: 2,
                hasLevels: true)),
            AlteredTraits(Trait(
                name: 'Remove Nightmares, Light Sleeper, and Insomnia',
                baseCost: 30)),
            Bestows('Resistence against sleeping and dreaming attacks',
                range: BestowsRange.moderate, value: 5)
          ],
          notes: 'This is almost always cast as a charm, usually (but not '
              'always) on an actual dreamcatcher. The target finds his slumber '
              'especially restful and needs four fewer hours of sleep (to a '
              'minimum of one). If he suffers from Nightmares, Light Sleep, or '
              'Insomnia, those disadvantages are suspended for the duration. '
              'Additionally, he has +5 to resist all supernatural attacks that '
              'involve his dreams or that attack his mind while he is '
              'sleeping.\n'
              '\n'
              'Once activated, this charm lasts for one week. For longer '
              'protection, the duration may be increased at the time of '
              'casting or reinforced with later castings (see _After Casting_, '
              'p. 22).');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(weeks: 1)))
          .addEffect(SpellEffect(Path.magic, effect: Effect.control));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Dreamcatcher\n'
              ' *  _Spell Effects:_ Lesser Strengthen Body + '
              'Lesser Strengthen Mind ×2.\n'
              ' *  _Inherent Modifiers:_ '
              'Altered Trait, Less Sleep + '
              'Altered Trait, Remove Nightmares, Light Sleeper, and Insomnia + '
              'Bestows a Bonus, Resistence against sleeping and dreaming attacks.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This is almost always cast as a charm, usually (but not '
              'always) on an actual dreamcatcher. The target finds his slumber '
              'especially restful and needs four fewer hours of sleep (to a '
              'minimum of one). If he suffers from Nightmares, Light Sleep, or '
              'Insomnia, those disadvantages are suspended for the duration. '
              'Additionally, he has +5 to resist all supernatural attacks that '
              'involve his dreams or that attack his mind while he is '
              'sleeping.\n'
              '\n'
              'Once activated, this charm lasts for one week. For longer '
              'protection, the duration may be increased at the time of '
              'casting or reinforced with later castings (see _After Casting_, '
              'p. 22).\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Strengthen Body (3) + Lesser Strengthen Mind (3) + '
              'Lesser Strengthen Mind (3) + Lesser Control Magic (5) + '
              'Altered Trait, Less Sleep 4 (8) + '
              'Altered Trait, Remove Nightmares, Light Sleeper, and Insomnia (30) + '
              'Bestows a Bonus, +5 to Resistence against sleeping and dreaming attacks (32) + '
              'Duration, 1 week (9). '
              '_93 energy (93×1)._\n'));
    });

    test('Gift of Gab', () {
      Ritual r = Ritual(
          name: 'Gift of Gab',
          effects: [
            SpellEffect(Path.body, effect: Effect.strengthen),
            SpellEffect(Path.mind, effect: Effect.strengthen),
            SpellEffect(Path.mind, effect: Effect.strengthen),
          ],
          modifiers: [
            AlteredTraits(
              Trait(
                name: 'Voice',
                baseCost: 10,
              ),
            ),
            Bestows(
              'Fast-Talk',
              range: BestowsRange.narrow,
              value: 2,
            ),
            Bestows(
              'detect subject’s lies',
              value: -2,
              range: BestowsRange.moderate,
            ),
          ],
          notes:
              'For the next hour, this spell makes whatever the subject says '
              'seem to be the absolute truth, even if it’s not. While under '
              'the effects of the spell, the subject temporarily gains the '
              'Voice advantage, with an _extra_ +2 (net +4) to Fast-Talk! As '
              'well, any rolls to determine whether the subject is lying '
              '(e.g., for Body Language, Detect Lies, or Empathy) are at -2.\n'
              '\n'
              'Note that these bonuses do not violate _Stacking Spells_ (p. '
              '15) because they’re all incorporated into a single ritual.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(hours: 1)))
          .addModifier(SubjectWeight(weight: GWeight(pounds: 300)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Gift of Gab\n'
              ' *  _Spell Effects:_ Lesser Strengthen Body + '
              'Lesser Strengthen Mind ×2.\n'
              ' *  _Inherent Modifiers:_ '
              'Altered Trait, Voice + '
              'Bestows a Bonus, Fast-Talk + '
              'Bestows a Penalty, detect subject’s lies.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'For the next hour, this spell makes whatever the subject says '
              'seem to be the absolute truth, even if it’s not. While under '
              'the effects of the spell, the subject temporarily gains the '
              'Voice advantage, with an _extra_ +2 (net +4) to Fast-Talk! As '
              'well, any rolls to determine whether the subject is lying '
              '(e.g., for Body Language, Detect Lies, or Empathy) are at -2.\n'
              '\n'
              'Note that these bonuses do not violate _Stacking Spells_ (p. '
              '15) because they’re all incorporated into a single ritual.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Strengthen Body (3) + Lesser Strengthen Mind (3) + '
              'Lesser Strengthen Mind (3) + '
              'Altered Trait, Voice (10) + '
              'Bestows a Bonus, +2 to Fast-Talk (2) + '
              'Bestows a Penalty, -2 to detect subject’s lies (4) + '
              'Duration, 1 hour (3) + '
              'Subject Weight, 300 lbs. (3). '
              '_31 energy (31×1)._\n'));
    });

    test('Halt', () {
      Ritual r = Ritual(
          name: 'Halt',
          effects: [
            SpellEffect(Path.energy,
                level: Level.greater, effect: Effect.destroy),
          ],
          modifiers: [
            Speed(yardsPerSecond: GDistance(yards: 20)),
          ],
          notes: 'This spell brings a target within 10 yards to a sudden, '
              'harmless stop. The target can be as heavy and fast as a '
              'charging rhinoceros or accelerating pickup truck. The spell '
              'works by instantly canceling out the subject’s momentum. '
              'Falling objects stop safely, and then immediately start falling '
              'again.\n'
              '\n'
              'Assuming a typical casting, a subject weighing more than five '
              'tons is completely unaffected. A target moving faster than 20 '
              'yards/second does not stop completely; instead, its velocity is '
              'slowed by 20 yards/second. (If this spell is being cast on the '
              'fly, it can easily be varied to match the mass and speed of the '
              'specific subject.)');

      Casting c = Casting(r)
          .addModifier(Range(distance: GDistance(yards: 10)))
          .addModifier(SubjectWeight(weight: GWeight(tons: 5)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Halt\n'
              ' *  _Spell Effects:_ Greater Destroy Energy.\n'
              ' *  _Inherent Modifiers:_ Speed.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'This spell brings a target within 10 yards to a sudden, '
              'harmless stop. The target can be as heavy and fast as a '
              'charging rhinoceros or accelerating pickup truck. The spell '
              'works by instantly canceling out the subject’s momentum. '
              'Falling objects stop safely, and then immediately start falling '
              'again.\n'
              '\n'
              'Assuming a typical casting, a subject weighing more than five '
              'tons is completely unaffected. A target moving faster than 20 '
              'yards/second does not stop completely; instead, its velocity is '
              'slowed by 20 yards/second. (If this spell is being cast on the '
              'fly, it can easily be varied to match the mass and speed of the '
              'specific subject.)\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Greater Destroy Energy (5) + '
              'Range, 10 yards (4) + '
              'Speed, 20 yards/second (6) + '
              'Subject Weight, 5 tons (6). '
              '_63 energy (21×3)._\n'));
    });

    test('Haste', () {
      Ritual r = Ritual(
          name: 'Haste',
          effects: [
            SpellEffect(Path.body, effect: Effect.strengthen),
          ],
          modifiers: [
            AlteredTraits(
                Trait(name: 'Basic Speed', baseCost: 20, details: '+1.00')),
          ],
          notes:
              'This spell temporarily raises the subject’s Speed (and thus his '
              'Move and Dodge) by 1 for the next 10 minutes.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(minutes: 10)))
          .addModifier(SubjectWeight(weight: GWeight(pounds: 300)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Haste\n'
              ' *  _Spell Effects:_ Lesser Strengthen Body.\n'
              ' *  _Inherent Modifiers:_ Altered Trait, Basic Speed.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell temporarily raises the subject’s Speed (and thus his '
              'Move and Dodge) by 1 for the next 10 minutes.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Strengthen Body (3) + '
              'Altered Trait, Basic Speed +1.00 (20) + '
              'Duration, 10 minutes (1) + '
              'Subject Weight, 300 lbs. (3). '
              '_27 energy (27×1)._\n'));
    });

    test('Hunger', () {
      Ritual r = Ritual(
          name: 'Hunger',
          effects: [
            SpellEffect(Path.body, effect: Effect.destroy),
          ],
          modifiers: [
            Damage(
              dice: DieRoll(dice: 1),
              type: DamageType.fatigue,
              modifiers: [TraitModifier(name: 'Starvation', percent: 40)],
            ),
          ],
          notes:
              'This spell inflicts 1d FP of starvation damage on anyone within '
              '10 yards. On average, this is the equivalent of a full day of '
              'missed meals. Fatigue taken in this fashion can only be '
              'recovered by a day of rest and adequate nourishment (see '
              '_Starvation_, p. B426).');

      Casting c = Casting(r)
          .addModifier(Range(distance: GDistance(yards: 10)))
          .addModifier(SubjectWeight(weight: GWeight(pounds: 300)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Hunger\n'
              ' *  _Spell Effects:_ Lesser Destroy Body.\n'
              ' *  _Inherent Modifiers:_ Damage, Internal Fatigue (Starvation).\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell inflicts 1d FP of starvation damage on anyone within '
              '10 yards. On average, this is the equivalent of a full day of '
              'missed meals. Fatigue taken in this fashion can only be '
              'recovered by a day of rest and adequate nourishment (see '
              '_Starvation_, p. B426).\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Destroy Body (5) + '
              'Damage, Internal Fatigue 1d (Starvation, +40%) (8) + '
              'Range, 10 yards (4) + '
              'Subject Weight, 300 lbs. (3). '
              '_20 energy (20×1)._\n'));
    });

    test('Intercom', () {
      Ritual r = Ritual(
          name: 'Intercom',
          effects: [
            SpellEffect(Path.mind),
          ],
          notes:
              'This spell allows the subject to mentally communicate with the '
              'caster as long as both stay within 100 yards of each other. The '
              'effect lasts for one hour.');

      Casting c = Casting(r)
          .addModifier(Range(distance: GDistance(yards: 100)))
          .addModifier(DurationModifier(duration: GDuration(hours: 1)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Intercom\n'
              ' *  _Spell Effects:_ Lesser Sense Mind.\n'
              ' *  _Inherent Modifiers:_ None.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell allows the subject to mentally communicate with the '
              'caster as long as both stay within 100 yards of each other. The '
              'effect lasts for one hour.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Sense Mind (2) + '
              'Duration, 1 hour (3) + '
              'Range, 100 yards (10). '
              '_15 energy (15×1)._\n'));
    });

    test('Itch', () {
      Ritual r = Ritual(
          name: 'Itch',
          effects: [
            SpellEffect(Path.body, effect: Effect.control),
          ],
          modifiers: [
            Affliction(effect: 'Itching', percent: 10),
          ],
          notes:
              'This spell causes the subject (who must be within 10 yards) to '
              'develop a fierce and irritating itch. This causes the subject '
              'to suffer a -2 to DX for the next 10 minutes or until he takes '
              'one full second to scratch the itch. He can do nothing else '
              'while scratching. (Itching is a +10% Affliction enhancement '
              'found in _**GURPS Power-Ups 4: Enhancements.**_)');

      Casting c = Casting(r)
          .addModifier(Range(distance: GDistance(yards: 10)))
          .addModifier(DurationModifier(duration: GDuration(minutes: 10)))
          .addModifier(SubjectWeight(weight: GWeight(pounds: 300)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Itch\n'
              ' *  _Spell Effects:_ Lesser Control Body.\n'
              ' *  _Inherent Modifiers:_ Affliction, Itching.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell causes the subject (who must be within 10 yards) to '
              'develop a fierce and irritating itch. This causes the subject '
              'to suffer a -2 to DX for the next 10 minutes or until he takes '
              'one full second to scratch the itch. He can do nothing else '
              'while scratching. (Itching is a +10% Affliction enhancement '
              'found in _**GURPS Power-Ups 4: Enhancements.**_)\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Control Body (5) + '
              'Affliction, Itching (2) + '
              'Duration, 10 minutes (1) + '
              'Range, 10 yards (4) + '
              'Subject Weight, 300 lbs. (3). '
              '_15 energy (15×1)._\n'));
    });

    test('Minor Healing', () {
      Ritual r = Ritual(
          name: 'Minor Healing',
          effects: [
            SpellEffect(Path.body, effect: Effect.restore),
          ],
          modifiers: [Healing(dice: DieRoll(dice: 1))],
          notes:
              'This spell heals any living being, restoring 1d HP. It does not '
              'eliminate disease or poison. The level of healing can be '
              'varied, as usual, without this counting as a different ritual. '
              'See _Restore Body_ (p. 7) for more on how much Healing you can '
              'add before this becomes a Greater effect (and thus a different '
              'ritual).');

      Casting c =
          Casting(r).addModifier(SubjectWeight(weight: GWeight(pounds: 300)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Minor Healing\n'
              ' *  _Spell Effects:_ Lesser Restore Body.\n'
              ' *  _Inherent Modifiers:_ Healing.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell heals any living being, restoring 1d HP. It does not '
              'eliminate disease or poison. The level of healing can be '
              'varied, as usual, without this counting as a different ritual. '
              'See _Restore Body_ (p. 7) for more on how much Healing you can '
              'add before this becomes a Greater effect (and thus a different '
              'ritual).\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Restore Body (4) + Healing, 1d (0) + '
              'Subject Weight, 300 lbs. (3). '
              '_7 energy (7×1)._\n'));
    });

    test('Minor Recovery', () {
      Ritual r = Ritual(
          name: 'Minor Recovery',
          effects: [
            SpellEffect(Path.body, effect: Effect.restore),
          ],
          modifiers: [Healing(dice: DieRoll(dice: 1), type: HealingType.fp)],
          notes:
              'This spell heals any living being, restoring 1d FP. It does not '
              'eliminate disease or poison. The level of healing can be '
              'varied, as usual, without this counting as a different ritual. '
              'See _Restore Body_ (p. 7) for more on how much Healing you can '
              'add before this becomes a Greater effect (and thus a different '
              'ritual).');

      Casting c =
          Casting(r).addModifier(SubjectWeight(weight: GWeight(pounds: 300)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Minor Recovery\n'
              ' *  _Spell Effects:_ Lesser Restore Body.\n'
              ' *  _Inherent Modifiers:_ Healing, FP.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'This spell heals any living being, restoring 1d FP. It does not '
              'eliminate disease or poison. The level of healing can be '
              'varied, as usual, without this counting as a different ritual. '
              'See _Restore Body_ (p. 7) for more on how much Healing you can '
              'add before this becomes a Greater effect (and thus a different '
              'ritual).\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Restore Body (4) + Healing, 1d FP (0) + '
              'Subject Weight, 300 lbs. (3). '
              '_7 energy (7×1)._\n'));
    });

    test('Path of Energy Botch', () {
      Ritual r = Ritual(
          name: 'Path of Energy Botch',
          effects: [
            SpellEffect(Path.energy,
                effect: Effect.create, level: Level.greater),
          ],
          modifiers: [
            Damage(
              dice: DieRoll(dice: 2),
              direct: false,
              explosive: true,
              type: DamageType.burning,
            )
          ],
          notes: 'The spell blows up! The caster takes 4d burning damage (DR '
              'protects normally); see _Explosions_ (p. B414) for everyone '
              'else in the area.');

      Casting c = Casting(r);
      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Path of Energy Botch\n'
              ' *  _Spell Effects:_ Greater Create Energy.\n'
              ' *  _Inherent Modifiers:_ Damage, External Explosive Burning.\n'
              ' *  _Greater Effects:_ 1 (×3).\n'
              '\n'
              'The spell blows up! The caster takes 4d burning damage (DR '
              'protects normally); see _Explosions_ (p. B414) for everyone '
              'else in the area.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Greater Create Energy (6) + '
              'Damage, External Explosive Burning 4d (4). '
              '_30 energy (10×3)._\n'));
    });

    test('Seek Person', () {
      Ritual r = Ritual(
          name: 'Seek Person',
          effects: [
            SpellEffect(Path.body),
          ],
          notes: 'Gives the caster an instantaneous flash of knowledge, '
              'revealing the direction and distance to the subject of this '
              'spell. The subject must be within 100 miles.');

      Casting c =
          Casting(r).addModifier(RangeInfo(distance: GDistance(miles: 100)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Seek Person\n'
              ' *  _Spell Effects:_ Lesser Sense Body.\n'
              ' *  _Inherent Modifiers:_ None.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'Gives the caster an instantaneous flash of knowledge, '
              'revealing the direction and distance to the subject of this '
              'spell. The subject must be within 100 miles.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Sense Body (2) + '
              'Range, 100 miles (6). '
              '_8 energy (8×1)._\n'));
    });

    test('Seek Person (Extra Energy)', () {
      Ritual r = Ritual(
          name: 'Seek Person',
          effects: [
            SpellEffect(Path.body),
          ],
          notes: 'Gives the caster an instantaneous flash of knowledge, '
              'revealing the direction and distance to the subject of this '
              'spell. The subject must be within 100 miles.');

      Casting c = Casting(r)
          .addModifier(RangeInfo(distance: GDistance(miles: 100)))
          .addModifier(ExtraEnergy(energy: 20));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Seek Person\n'
              ' *  _Spell Effects:_ Lesser Sense Body.\n'
              ' *  _Inherent Modifiers:_ None.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'Gives the caster an instantaneous flash of knowledge, '
              'revealing the direction and distance to the subject of this '
              'spell. The subject must be within 100 miles.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Sense Body (2) + '
              'Extra Energy, 20 (20) + '
              'Range, 100 miles (6). '
              '_28 energy (28×1)._\n'));
    });

    test('Track Traveler', () {
      Ritual r = Ritual(
          name: 'Track Traveler',
          effects: [
            SpellEffect(Path.crossroads),
          ],
          notes: 'If a particular gate was used within the past day, this '
              'ritual will reveal the origin or destination of the last being '
              'to make the trip. That is, the caster sees a brief flash of the '
              '“other side” of the gate at the moment the traveler went '
              'through it. The caster must be within arm’s reach of the gate, '
              'although he need not physically touch it.');

      Casting c =
          Casting(r).addModifier(RangeCrossTime(duration: GDuration(days: 1)));

      CastingExporter exporter = MarkdownCastingExporter();
      c.exportTo(exporter);

      expect(
          exporter.toString(),
          equals('## Track Traveler\n'
              ' *  _Spell Effects:_ Lesser Sense Crossroads.\n'
              ' *  _Inherent Modifiers:_ None.\n'
              ' *  _Greater Effects:_ 0 (×1).\n'
              '\n'
              'If a particular gate was used within the past day, this '
              'ritual will reveal the origin or destination of the last being '
              'to make the trip. That is, the caster sees a brief flash of the '
              '“other side” of the gate at the moment the traveler went '
              'through it. The caster must be within arm’s reach of the gate, '
              'although he need not physically touch it.\n'
              '\n'
              ' *  _Typical Casting:_ '
              'Lesser Sense Crossroads (2) + '
              'Range, 1 day (2). '
              '_4 energy (4×1)._\n'));
    });
  });
}
