import 'package:gurps_dart/gurps_dart.dart';

import 'ritual_modifier.dart';

/// GURPS rpm.17: The spell will cause damage, whether directly or indirectly.
class Damage extends RitualModifier {
  Damage(
      {DamageType type: DamageType.crushing,
      DieRoll dice: const DieRoll(1, 0),
      bool direct: true,
      bool explosive: false,
      bool inherent: false})
      : dice = dice ?? const DieRoll(1, 0),
        direct = direct ?? true,
        type = type ?? DamageType.crushing,
        _explosive = explosive ?? false,
        super('Damage', inherent: inherent ?? false);

  factory Damage.copyWith(Damage src,
      {DamageType type,
      DieRoll dice,
      bool direct,
      bool explosive,
      bool inherent}) {
    return Damage(
        type: type ?? src.type,
        dice: dice ?? src.dice,
        direct: direct ?? src.direct,
        explosive: explosive ?? src._explosive,
        inherent: inherent ?? src.inherent);
  }

  /// GURPS rpm.17: If a spell lists “damage” without specifying whether it’s
  /// direct (internal) or indirect (external), assume direct (internal).
  final bool direct;

  final DieRoll dice;

  final DamageType type;

  final bool _explosive;

  bool get explosive => direct ? false : _explosive;

  DieRoll get damageDice => dice * _diceMultiplier;

  int get _diceMultiplier => (direct) ? 1 : (explosive) ? 2 : 3;

  @override
  int get energyCost =>
      (DieRoll.denormalize(dice) * _damageMultiplier[type]).ceil();

  static Map<DamageType, num> _damageMultiplier = {
    DamageType.burning: 1,
    DamageType.corrosive: 2,
    DamageType.crushing: 1,
    DamageType.cutting: 1.5,
    DamageType.fatigue: 2,
    DamageType.hugePiercing: 2,
    DamageType.impaling: 2,
    DamageType.largePiercing: 1.5,
    DamageType.piercing: 1,
    DamageType.smallPiercing: 0.5,
    DamageType.toxic: 1,
  };
}
