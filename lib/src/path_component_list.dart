import 'dart:async';

import 'path_component.dart';

enum Action { insert, modify, remove }

class ListChangeEvent {
  final int index;
  final Action action;
  final PathComponent component;

  ListChangeEvent(this.index, this.action, this.component);
}

class PathComponentList {
  final List<PathComponent> _list = [];

  int get length => _list.length;

  var changeController = new StreamController<ListChangeEvent>.broadcast();

  Stream<ListChangeEvent> get onChange => changeController.stream;

  // -- List-like methods --

  PathComponent operator [](int index) => _list[index];

  void operator []=(int index, PathComponent p) {
    _list[index] = p;
    changeController.add(ListChangeEvent(index, Action.modify, p));
  }

  void add(PathComponent value) {
    _list.add(value);
    changeController
        .add(new ListChangeEvent(_list.indexOf(value), Action.insert, value));
  }

  void addAll(Iterable<PathComponent> iterable) {
    iterable.forEach((f) => add(f));
  }

  bool remove(Object value) {
    var index = _list.indexOf(value as PathComponent);
    var result = _list.remove(value);
    if (result) {
      changeController
          .add(ListChangeEvent(index, Action.remove, value as PathComponent));
    }
    return result;
  }

  void clear() {
    var events = <ListChangeEvent>[];
    _list.forEach(
            (f) =>
            events.add(ListChangeEvent(_list.indexOf(f), Action.remove, f)));

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
        events.add(ListChangeEvent(i, Action.remove, _list.elementAt(i)));
      }
    }

    events.forEach((event) => removeComponent(event));
  }
}
