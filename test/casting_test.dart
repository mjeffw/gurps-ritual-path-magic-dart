import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';
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
                TraitModifier(name: 'Double Knockback', percent: 20),
                TraitModifier(name: 'Jet', percent: 0),
                TraitModifier(name: 'No Wounding', percent: -50)
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

      expect(
          c.formattedText(),
          equals('##Air Jet\n'
              '   _Spell Effects:_ Greater Control Matter.\n'
              '   _Inherent Modifiers:_ Damage, External Crushing (Double '
              'Knockback; Jet; No Wounding).\n'
              '   _Greater Effects:_ 1 (×3).\n'
              '\n'
              '   This spell conjures a jet (p. B106) of air extending from '
              'the caster’s hand or an object that he is holding. The target '
              'takes 3d crushing damage; this does no actual damage, but it '
              'does inflict blunt trauma and is doubled for knockback purposes.'
              '\n'
              '\n'
              '   _Typical Casting:_ Greater Control Matter (5) + Damage, '
              'External Crushing 3d (Double Knockback, +20%; Jet, +0%; No '
              'Wounding, -50%) (1). _18 energy (6×3)._'));
    });

    test('Alertness', () {
      Ritual r = Ritual(name: 'Alertness', modifiers: [
        Bestows('Sense rolls', range: BestowsRange.broad, value: 2)
      ]);

      r = r.addSpellEffect(SpellEffect(Path.mind, effect: Effect.strengthen));
      r = r.copyWith(
          notes: 'This spell temporarily boosts the subject’s '
              'ability to process incoming impressions, giving him +2 to all '
              'Sense rolls for the next 10 minutes.');

      Casting c = Casting(r)
          .addModifier(DurationModifier(duration: GDuration(minutes: 10)));

      expect(
          c.formattedText(),
          equals('##Alertness\n'
              '   _Spell Effects:_ Lesser Strengthen Mind.\n'
              '   _Inherent Modifiers:_ Bestows a Bonus, Sense rolls.\n'
              '   _Greater Effects:_ 0 (×1).\n'
              '\n'
              '   This spell temporarily boosts the subject’s ability to '
              'process incoming impressions, giving him +2 to all Sense rolls '
              'for the next 10 minutes.\n'
              '\n'
              '   _Typical Casting:_ Lesser Strengthen Mind (3) + Bestows a '
              'Bonus, +2 to Sense rolls (10) + Duration, 10 minutes (1). '
              '_14 energy (14×1)._'));
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

      expect(
          c.formattedText(),
          equals('##Amplify Injury\n'
              '   _Spell Effects:_ Greater Destroy Body.\n'
              '   _Inherent Modifiers:_ Altered Trait, Vulnerability to '
              'Physical Attacks.\n'
              '   _Greater Effects:_ 1 (×3).\n'
              '\n'
              '   This spell causes the target to suffer double normal injury '
              'from physical attacks (those that use some sort of material '
              'substance to cause harm) for the next 10 minutes. This does not '
              'increase the damage from energy, mental attacks, etc. The '
              'target must be within 10 yards.\n'
              '\n'
              '   _Typical Casting:_ Greater Destroy Body (5) + Altered Trait, '
              'Vulnerability to Physical Attacks ×2 (8) + Duration, 10 minutes '
              '(1) + Range, 10 yards (4) + Subject Weight, 300 lbs. (3). '
              '_63 energy (21×3)._'));
    });
  });
}
