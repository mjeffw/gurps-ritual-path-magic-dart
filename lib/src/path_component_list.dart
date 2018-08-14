import 'dart:async';

import 'path_component.dart';

enum Action { Insert, Modify, Remove }

class ListChangeEvent {
  final int index;
  final Action action;
  final PathComponent component;

  ListChangeEvent(this.index, this.action, this.component);
}

class PathComponentList {
  final List<PathComponent> _list = [];

  @override
  List<PathComponent> get delegate => _list;

  int get length => _list.length;

  PathComponent operator [](int index) => _list[index];

  var changeController = new StreamController<ListChangeEvent>.broadcast();
  Stream<ListChangeEvent> get onChange => changeController.stream;

  @override
  void add(PathComponent value) {
    _list.add(value);
    changeController
        .add(new ListChangeEvent(_list.indexOf(value), Action.Insert, value));
  }

  @override
  void addAll(Iterable<PathComponent> iterable) {
    iterable.forEach((f) => add(f));
  }

  @override
  bool remove(Object value) {
    var index = _list.indexOf(value as PathComponent);
    var result = _list.remove(value);
    if (result) {
      changeController
          .add(ListChangeEvent(index, Action.Remove, value as PathComponent));
    }
    return result;
  }

  @override
  void clear() {
    var events = <ListChangeEvent>[];
    _list.forEach(
            (f) =>
            events.add(ListChangeEvent(_list.indexOf(f), Action.Remove, f)));

    events.forEach((event) => removeComponent(event));
  }

  void removeComponent(ListChangeEvent f) {
    _list.remove(f.component);
    changeController.add(f);
  }

  void removeByBoolIndex(List<bool> deleteIndex) {
    var events = <ListChangeEvent>[];

    for (var i = 0; i < deleteIndex.length; i++) {
      if (deleteIndex[i]) {
        events.add(ListChangeEvent(i, Action.Remove, _list.elementAt(i)));
      }
    }

    events.forEach((event) => removeComponent(event));
  }
}
