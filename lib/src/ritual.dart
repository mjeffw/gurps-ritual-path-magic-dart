import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import 'level.dart';
import 'modifier/ritual_modifier.dart';
import 'spell_effect.dart';
import 'util/list_wrapper.dart';

@immutable
class Ritual {
  const Ritual(
      {this.name,
      List<SpellEffect> effects,
      List<RitualModifier> modifiers,
      this.notes})
      : this.modifiers = modifiers ?? const <RitualModifier>[],
        this.effects = effects ?? const <SpellEffect>[];

  final String name;

  final List<SpellEffect> effects;

  final List<RitualModifier> modifiers;

  final String notes;

  int get greaterEffects =>
      effects.where((it) => it.level == Level.greater).length;

  int get effectsMultiplier => 1 + (greaterEffects * 2);

  int get energyCost => baseEnergyCost * effectsMultiplier;

  int get baseEnergyCost =>
      effects.fold<int>(0, (previous, element) => previous + element.cost) +
      modifiers.fold<int>(
          0, (previous, element) => previous + element.energyCost);

  Ritual addModifier(RitualModifier modifier) => Ritual(
      name: this.name,
      effects: this.effects,
      modifiers: [...modifiers, if (modifier != null) modifier]);

  Ritual addSpellEffect(SpellEffect effect) => Ritual(
      name: this.name,
      effects: [...this.effects, if (effect != null) effect],
      modifiers: this.modifiers);

  Ritual copyWith(
          {String name,
          List<SpellEffect> effects,
          List<RitualModifier> modifiers,
          String notes}) =>
      Ritual(
          name: name ?? this.name,
          effects: effects ?? this.effects,
          modifiers: modifiers ?? this.modifiers,
          notes: notes ?? this.notes);

  @override
  int get hashCode =>
      hash4(name, ListWrapper(effects), ListWrapper(modifiers), notes);

  @override
  bool operator ==(Object other) =>
      other is Ritual &&
      other.name == name &&
      ListWrapper(effects).equals(other.effects) &&
      ListWrapper(modifiers).equals(other.modifiers) &&
      other.notes == notes;
}
