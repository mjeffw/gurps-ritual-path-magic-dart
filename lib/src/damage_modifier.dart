import 'package:gurps_dart/gurps_dart.dart';

import 'ritual_modifier.dart';

/// GURPS rpm.17: The spell will cause damage, whether directly or indirectly.
class Damage extends RitualModifier {
  Damage(
      {DieRoll dice: const DieRoll(1, 0),
      bool direct: true,
      bool inherent: false})
      : dice = dice ?? const DieRoll(1, 0),
        direct = direct ?? true,
        super('Damage', inherent: inherent ?? false);

  /// GURPS rpm.17: If a spell lists “damage” without specifying whether it’s
  /// direct (internal) or indirect (external), assume direct (internal).
  final bool direct;

  final DieRoll dice;

  @override
  // TODO: implement energyCost
  int get energyCost => 0;
}
