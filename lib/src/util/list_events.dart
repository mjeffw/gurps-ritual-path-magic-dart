import 'dart:async';

enum Action { insert, modify, remove }

class ListChangeEvent<T> {
  ListChangeEvent(this.index, this.action, this.oldValue, this.newValue);

  final int index;
  final Action action;
  final T oldValue;
  final T newValue;
}

class ObservableList<T> {
  final List<T> _list = [];

  int get length => _list.length;

  var changeController = new StreamController<ListChangeEvent<T>>.broadcast();

  Stream<ListChangeEvent<T>> get onChange => changeController.stream;

  // -- List-like methods --

  T operator [](int index) => _list[index];

  void operator []=(int index, T p) {
    var event = ListChangeEvent<T>(index, Action.modify, _list[index], p);
    _list[index] = p;
    changeController.add(event);
  }

  void add(T value) {
    _list.add(value);
    changeController.add(new ListChangeEvent<T>(
        _list.indexOf(value), Action.insert, null, value));
  }

  void addAll(Iterable<T> iterable) {
    iterable.forEach((f) => add(f));
  }

  bool remove(Object value) {
    var index = _list.indexOf(value as T);
    var result = _list.remove(value);
    if (result) {
      changeController
          .add(ListChangeEvent<T>(index, Action.remove, value as T, null));
    }
    return result;
  }

  void clear() {
    var events = <ListChangeEvent<T>>[];
    _list.forEach((f) => events
        .add(ListChangeEvent<T>(_list.indexOf(f), Action.remove, f, null)));

    events.forEach((event) => _removeComponent(event));
  }

  void _removeComponent(ListChangeEvent<T> f) {
    _list.remove(f.oldValue);
    changeController.add(f);
  }

  void removeByBoolIndex(List<bool> deleteIndex) {
    var events = <ListChangeEvent<T>>[];

    for (var i = 0; i < deleteIndex.length; i++) {
      if (deleteIndex[i]) {
        events.add(
            ListChangeEvent<T>(i, Action.remove, _list.elementAt(i), null));
      }
    }

    events.forEach((event) => _removeComponent(event));
  }
}
