import 'dart:math';

import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:quiver/core.dart';

import '../util/list_wrapper.dart';
import 'ritual_modifier.dart';

/// GURPS rpm.17: The spell will cause damage, whether directly or indirectly.
class Damage extends RitualModifier {
  const Damage(
      {DamageType type: DamageType.crushing,
      DieRoll dice: const DieRoll(dice: 1, adds: 0),
      List<TraitModifier> modifiers,
      bool direct: true,
      bool explosive: false})
      : dice = dice ?? const DieRoll(dice: 1, adds: 0),
        direct = direct ?? true,
        type = type ?? DamageType.crushing,
        _explosive = explosive ?? false,
        _modifiers = modifiers ?? const [],
        super(label);

  Damage copyWith(
      {DamageType type, DieRoll dice, bool direct, bool explosive}) {
    return Damage(
        type: type ?? this.type,
        dice: dice ?? this.dice,
        modifiers: this._modifiers,
        direct: direct ?? this.direct,
        explosive: explosive ?? this._explosive);
  }

  Damage addModifier(TraitModifier traitModifier) => Damage(
      type: this.type,
      dice: this.dice,
      direct: this.direct,
      explosive: this.explosive,
      modifiers: [...this._modifiers, traitModifier]);

  static const String label = 'Damage';

  /// GURPS rpm.17: If a spell lists “damage” without specifying whether it’s
  /// direct (internal) or indirect (external), assume direct (internal).
  final bool direct;

  final DieRoll dice;

  final DamageType type;

  final bool _explosive;

  final List<TraitModifier> _modifiers;

  List<TraitModifier> get modifiers => List.unmodifiable(_modifiers);

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

  int get _adjustForModifiers {
    var adjustment = (_baseEnergyCost > 20)
        ? _modifierPercent
        : (_modifierPercent / 5).ceil();
    return (adjustment == 0 && _modifiers.isNotEmpty) ? 1 : adjustment;
  }

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

  @override
  Damage incrementEffect(int value) {
    var addsFor1d = DieRoll.denormalize(dice + value);
    return Damage(
        dice: (addsFor1d < 0)
            ? const DieRoll(dice: 1, adds: 0)
            : this.dice + value,
        direct: this.direct,
        explosive: this.explosive,
        modifiers: this._modifiers,
        type: this.type);
  }

  @override
  String toStringShort() =>
      'Damage, ${direct ? 'Internal ' : 'External '}${type.label} '
      '${_modifiers.isEmpty ? '' : '($_traitModsToStringShort)'}';

  @override
  String toStringDetailed() {
    return 'Damage, ${direct ? 'Internal ' : 'External '}${type.label} '
        '$damageDice '
        '${_modifiers.isEmpty ? '' : '($_traitModsToStringDetailed) '}'
        '($energyCost)';
  }

  String get _traitModsToStringShort =>
      _modifiers.map((it) => it.name).reduce((a, b) => '$a; $b');

  String get _traitModsToStringDetailed => _modifiers
      .map(_traitToStringDetailed)
      .reduce((value, element) => '$value; $element');

  String _traitToStringDetailed(TraitModifier trait) => '${trait.name}, '
      '${trait.percent.isNegative ? '${trait.percent}' : '+${trait.percent}'}%';

  @override
  int get hashCode => hashObjects(
      <dynamic>[dice, direct, explosive, ListWrapper(_modifiers), type]);

  @override
  bool operator ==(Object other) {
    return other is Damage &&
        other.dice == dice &&
        other.direct == direct &&
        other.type == type &&
        other._explosive == _explosive &&
        ListWrapper(_modifiers).equals(other._modifiers);
  }
}
