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

  List<SpellEffect> get effects => [...ritual.effects, ..._effects];

  List<RitualModifier> get modifiers => [...ritual.modifiers, ..._modifiers];

  List<SpellEffect> get additionalEffects => _effects;

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

  Casting addModifier(RitualModifier modifier) => this.copyWith(
      modifiers: [...this._modifiers, if (modifier != null) modifier]);

  Casting addEffect(SpellEffect effect) =>
      this.copyWith(effects: [...this._effects, if (effect != null) effect]);

  Casting updateEffect(int index, SpellEffect value) =>
      this.copyWith(effects: List.from(_effects)..[index] = value);

  Casting removeEffect(int index) =>
      copyWith(effects: List.from(_effects)..removeAt(index));
}
