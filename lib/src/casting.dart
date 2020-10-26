import 'package:meta/meta.dart';

import 'modifier/ritual_modifier.dart';
import 'ritual.dart';
import 'spell_effect.dart';

@immutable
class Casting {
  const Casting(this.ritual,
      {List<SpellEffect> effects, List<RitualModifier> modifiers})
      : _effects = effects ?? const <SpellEffect>[],
        _modifiers = modifiers ?? const <RitualModifier>[];

  final Ritual ritual;
  final List<SpellEffect> _effects;
  final List<RitualModifier> _modifiers;

  List<SpellEffect> get allEffects => [...ritual.effects, ..._effects];

  List<RitualModifier> get allModifiers => [...ritual.modifiers, ..._modifiers];

  List<SpellEffect> get additionalEffects => _effects;

  List<RitualModifier> get additionalModifiers => _modifiers;

  int get _castingCost =>
      _effects.fold<int>(0, (p, e) => p + e.cost) +
      _modifiers.fold<int>(0, (p, e) => p + e.energyCost);

  int get energyCost =>
      (_castingCost + ritual.baseEnergyCost) * ritual.effectsMultiplier;

  Casting copyWith(
          {Ritual ritual,
          List<SpellEffect> effects,
          List<RitualModifier> modifiers}) =>
      Casting(ritual ?? this.ritual,
          effects: effects ?? this._effects,
          modifiers: modifiers ?? this._modifiers);

  Casting addModifier(RitualModifier value) =>
      copyWith(modifiers: [...this._modifiers, if (value != null) value]);

  Casting updateModifier(int index, RitualModifier value) =>
      copyWith(modifiers: List.from(_modifiers)..[index] = value);

  Casting removeModifier(int index) =>
      copyWith(effects: List.from(_modifiers)..removeAt(index));

  Casting addEffect(SpellEffect value) =>
      this.copyWith(effects: [...this._effects, if (value != null) value]);

  Casting updateEffect(int index, SpellEffect value) =>
      this.copyWith(effects: List.from(_effects)..[index] = value);

  Casting removeEffect(int index) =>
      copyWith(effects: List.from(_effects)..removeAt(index));
}
