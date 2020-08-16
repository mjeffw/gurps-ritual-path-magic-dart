import 'dart:math';

import 'package:gurps_dart/gurps_dart.dart';

import 'ritual_modifier.dart';

/// GURPS rpm.17: The spell will cause damage, whether directly or indirectly.
class Damage extends RitualModifier {
  Damage(
      {DamageType type: DamageType.crushing,
      DieRoll dice: const DieRoll(1, 0),
      List<TraitModifier> modifiers,
      bool direct: true,
      bool explosive: false,
      bool inherent: false})
      : dice = dice ?? const DieRoll(1, 0),
        direct = direct ?? true,
        type = type ?? DamageType.crushing,
        _explosive = explosive ?? false,
        super('Damage', inherent: inherent ?? false) {
    _modifiers.addAll([if (modifiers != null) ...modifiers]);
  }

  factory Damage.copyWith(Damage src,
      {DamageType type,
      DieRoll dice,
      bool direct,
      bool explosive,
      bool inherent}) {
    return Damage(
        type: type ?? src.type,
        dice: dice ?? src.dice,
        modifiers: src._modifiers,
        direct: direct ?? src.direct,
        explosive: explosive ?? src._explosive,
        inherent: inherent ?? src.inherent);
  }

  factory Damage.addModifier(Damage src, TraitModifier traitModifier) => Damage(
      type: src.type,
      dice: src.dice,
      direct: src.direct,
      explosive: src.explosive,
      inherent: src.inherent,
      modifiers: [...src._modifiers, traitModifier]);

  /// GURPS rpm.17: If a spell lists “damage” without specifying whether it’s
  /// direct (internal) or indirect (external), assume direct (internal).
  final bool direct;

  final DieRoll dice;

  final DamageType type;

  final bool _explosive;

  final List<TraitModifier> _modifiers = [];

  bool get explosive => direct ? false : _explosive;

  DieRoll get damageDice => dice * _diceMultiplier;

  int get _baseEnergyCost =>
      (DieRoll.denormalize(dice) * _damageMultiplier[type]).ceil();

  int get _diceMultiplier => (direct) ? 1 : (explosive) ? 2 : 3;

  int get _modifierPercent => max(
      0,
      _modifiers
          .map((it) => it.percent)
          .fold(0, (previous, element) => previous + element));

  int get _adjustForModifiers =>
      (_baseEnergyCost > 20) ? _modifierPercent : (_modifierPercent / 5).ceil();

  @override
  int get energyCost => _baseEnergyCost + _adjustForModifiers;

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
