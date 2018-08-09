import 'path_component.dart';
import 'package:quiver/collection.dart';
import 'dart:async';

enum Action {
  Insert, Modify, Remove
}

class ListChangeEvent {
  final int index;
  final Action action;
  final PathComponent component;

  ListChangeEvent(this.index, this.action, this.component);
}

class PathComponentList extends DelegatingList<PathComponent>{
  final List<PathComponent> _list = [];

  @override
  List<PathComponent> get delegate => _list;

  var changeController = new StreamController<ListChangeEvent>();
  Stream<ListChangeEvent> get onChange => changeController.stream;

  @override
  void add(PathComponent value) {
    super.add(value);
    changeController.add(new ListChangeEvent(this.indexOf(value), Action.Insert, value));
  }
}
