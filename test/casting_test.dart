import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:test/test.dart';

void main() {
  group('Casting:', () {
    test('Alertness', () {
      Ritual r = Ritual(name: 'Alertness', modifiers: [
        Bestows('Sense rolls', range: BestowsRange.broad, value: 2)
      ]);

      r = r.addSpellEffect(SpellEffect(Path.mind, effect: Effect.strengthen));
      r = r.copyWith(
          notes: 'This spell temporarily boosts the subject’s '
              'ability to process incoming impressions, giving him +2 to all '
              'Sense rolls for the next 10 minutes.');

      Casting c = Casting(r);

      expect(c.formattedText(), equals('''
##Alertness
   _Spell Effects:_ Lesser Strengthen Mind.
   _Inherent Modifiers:_ Bestows a Bonus, Sense rolls.
   _Greater Effects:_ 0 (×1).

   This spell temporarily boosts the subject’s ability to process incoming impressions, giving him +2 to all Sense rolls for the next 10 minutes.

   _Typical Casting:_ Lesser Strengthen Mind (3) + Bestows a Bonus, +2 to Sense rolls (10). _13 energy (13×1)._
'''));
    });
  });
}
