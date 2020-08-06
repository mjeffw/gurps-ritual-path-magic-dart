import 'package:meta/meta.dart';

import 'level.dart';
import 'modifier_component.dart';
import 'path_component.dart';

@immutable
class Ritual {
  const Ritual({this.name, this.effects, List<ModifierComponent> modifiers})
      : this.modifiers = modifiers ?? const <ModifierComponent>[];

  final String name;

  final List<PathComponent> effects;

  final List<ModifierComponent> modifiers;

  int get greaterEffects =>
      effects.where((it) => it.level == Level.greater).length;

  int get effectsMultiplier => 1 + (greaterEffects * 2);

  // void addPathComponent(PathComponent pathComponent) {}
}
