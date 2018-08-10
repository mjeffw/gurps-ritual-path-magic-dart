import 'path_component.dart';
import 'package:quiver/collection.dart';
import 'dart:async';

enum Action { Insert, Modify, Remove }

class ListChangeEvent {
  final int index;
  final Action action;
  final PathComponent component;

  ListChangeEvent(this.index, this.action, this.component);
}

class PathComponentList extends DelegatingList<PathComponent> {
  final List<PathComponent> _list = [];

  @override
  List<PathComponent> get delegate => _list;

  var changeController = new StreamController<ListChangeEvent>();
  Stream<ListChangeEvent> get onChange => changeController.stream;

  @override
  void add(PathComponent value) {
    super.add(value);
    changeController
        .add(new ListChangeEvent(this.indexOf(value), Action.Insert, value));
  }

  @override
  void addAll(Iterable<PathComponent> iterable) {
    iterable.forEach((f) => add(f));
  }

  @override
  bool remove(Object value) {
    var index = super.indexOf(value as PathComponent);
    var result = super.remove(value);
    if (result) {
      changeController
          .add(ListChangeEvent(index, Action.Remove, value as PathComponent));
    }
    return result;
  }
}
