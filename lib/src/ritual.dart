import 'modifier_component.dart';
import 'path_component.dart';
import 'util/list_events.dart';

class Ritual {
  String name;
  ObservableList<PathComponent> paths = ObservableList<PathComponent>();

  ModifierComponent modifiers;

  void addPathComponent(PathComponent pathComponent) {}
}
