import 'dart:async';

import 'package:test/test.dart';

import '../lib/src/path.dart';
import '../lib/src/path_component.dart';
import '../lib/src/path_component_list.dart';

void main() {
  PathComponentList emptyList;
  PathComponentList filledList;
  var body = PathComponent(Path.Body);
  var chance = PathComponent(Path.Chance);
  var crossroads = PathComponent(Path.Crossroads);

  setUp(() async {
    emptyList = PathComponentList();
    filledList = PathComponentList();
    filledList..add(body)..add(chance)..add(crossroads);
    await filledList.onChange.take(3);
  });

  group('List methods', () {
    test('should allow adding components', () {
      expect(emptyList.length, equals(0));

      emptyList.add(crossroads);
      emptyList.add(body);
      emptyList.add(chance);

      expect(emptyList.length, equals(3));

      expect(emptyList[0], equals(crossroads));
      expect(emptyList[1], equals(body));
      expect(emptyList[2], equals(chance));
    });

    test('should allow removing components', () {
      expect(filledList.length, equals(3));

      expect(filledList[0], equals(body));
      expect(filledList[1], equals(chance));
      expect(filledList[2], equals(crossroads));

      filledList.remove(chance);

      expect(filledList.length, equals(2));
      expect(filledList[0], equals(body));
      expect(filledList[1], equals(crossroads));
    });

    test('remove by bool index', () {
      filledList.removeByBoolIndex(<bool>[true, true, false]);

      expect(filledList.length, equals(1));
      expect(filledList[0], equals(crossroads));
    });
  });

  group('change notification', () {
    test('should fire event when adding', () async {
      Timer.run(() {
        emptyList..add(body)..add(chance)..add(crossroads);
      });

      List<ListChangeEvent> events = await emptyList.onChange.take(3).toList();

      verifyEvent(events[0], Action.Insert, 0, body);
      verifyEvent(events[1], Action.Insert, 1, chance);
      verifyEvent(events[2], Action.Insert, 2, crossroads);
    });

    test('should fire event when removing component', () async {
      Timer.run(() {
        filledList.remove(chance);
      });

      ListChangeEvent event = await filledList.onChange.first;

      verifyEvent(event, Action.Remove, 1, chance);

      expect(event.action, equals(Action.Remove));
      expect(event.component, equals(chance));
      expect(event.index, equals(1));
    });

    test('should fire event for each component on clear', () async {
      Timer.run(() => filledList.clear());

      List<ListChangeEvent> events = await filledList.onChange.take(3).toList();

      verifyEvent(events[0], Action.Remove, 0, body);
      verifyEvent(events[1], Action.Remove, 1, chance);
      verifyEvent(events[2], Action.Remove, 2, crossroads);
    });

    test('should fire event when remove by bool index', () async {
      Timer.run(() => filledList.removeByBoolIndex(<bool>[true, true, false]));

      List<ListChangeEvent> events = await filledList.onChange.take(2).toList();

      verifyEvent(events[0], Action.Remove, 0, body);
      verifyEvent(events[1], Action.Remove, 1, chance);
    });
  });
}

void verifyEvent(ListChangeEvent event, Action action, int index,
    PathComponent pathComponent) {
  expect(event.action, equals(action));
  expect(event.index, equals(index));
  expect(event.component, equals(pathComponent));
}
