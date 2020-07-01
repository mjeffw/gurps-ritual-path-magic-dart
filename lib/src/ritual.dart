import 'package:meta/meta.dart';

import 'modifier_component.dart';
import 'path_component.dart';
import 'util/list_events.dart';

@immutable
class Ritual {
  const Ritual({this.name, this.effects, List<ModifierComponent> mods})
      : this.modifiers = mods ?? const <ModifierComponent>[];

  final String name;

  final List<PathComponent> effects;

  final List<ModifierComponent> modifiers;

  // void addPathComponent(PathComponent pathComponent) {}
}
