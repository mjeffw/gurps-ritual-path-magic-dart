import 'package:gurps_ritual_path_magic_model/src/modifier/ritual_modifier.dart';
import 'package:gurps_ritual_path_magic_model/src/ritual.dart';
import 'package:gurps_ritual_path_magic_model/src/spell_effect.dart';
import 'package:meta/meta.dart';

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

  int get _castingCost =>
      _effects.fold<int>(0, (p, e) => p + e.cost) +
      _modifiers.fold<int>(0, (p, e) => p + e.energyCost);

  int get energyCost =>
      (_castingCost + ritual.baseEnergyCost) * ritual.effectsMultiplier;
}
