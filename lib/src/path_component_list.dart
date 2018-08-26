import 'dart:async';

import 'path_component.dart';

enum Action { insert, modify, remove }

class ListChangeEvent {
  final int index;
  final Action action;
  final PathComponent oldValue;
  final PathComponent newValue;

  ListChangeEvent(this.index, this.action, this.oldValue, this.newValue);
}

class PathComponentList {
  final List<PathComponent> _list = [];

  int get length => _list.length;

  var changeController = new StreamController<ListChangeEvent>.broadcast();

  Stream<ListChangeEvent> get onChange => changeController.stream;

  // -- List-like methods --

  PathComponent operator [](int index) => _list[index];

  void operator []=(int index, PathComponent p) {
    var event = ListChangeEvent(index, Action.modify, _list[index], p);
    _list[index] = p;
    changeController.add(event);
  }

  void add(PathComponent value) {
    _list.add(value);
    changeController.add(
        new ListChangeEvent(_list.indexOf(value), Action.insert, null, value));
  }

  void addAll(Iterable<PathComponent> iterable) {
    iterable.forEach((f) => add(f));
  }

  bool remove(Object value) {
    var index = _list.indexOf(value as PathComponent);
    var result = _list.remove(value);
    if (result) {
      changeController.add(
          ListChangeEvent(index, Action.remove, value as PathComponent, null));
    }
    return result;
  }

  void clear() {
    var events = <ListChangeEvent>[];
    _list.forEach((f) =>
        events.add(ListChangeEvent(_list.indexOf(f), Action.remove, f, null)));

    events.forEach((event) => _removeComponent(event));
  }

  void _removeComponent(ListChangeEvent f) {
    _list.remove(f.oldValue);
    changeController.add(f);
  }

  void removeByBoolIndex(List<bool> deleteIndex) {
    var events = <ListChangeEvent>[];

    for (var i = 0; i < deleteIndex.length; i++) {
      if (deleteIndex[i]) {
        events.add(ListChangeEvent(i, Action.remove, _list.elementAt(i), null));
      }
    }

    events.forEach((event) => _removeComponent(event));
  }
}
