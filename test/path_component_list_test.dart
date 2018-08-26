import 'dart:async';

import 'package:test/test.dart';

import '../lib/src/effect.dart';
import '../lib/src/level.dart';
import '../lib/src/path.dart';
import '../lib/src/path_component.dart';
import '../lib/src/path_component_list.dart';

void main() {
  PathComponentList emptyList;
  PathComponentList filledList;
  var body = PathComponent(Path.body);
  var chance = PathComponent(Path.chance);
  var crossroads = PathComponent(Path.crossroads);

  setUp(() async {
    emptyList = PathComponentList();
    filledList = PathComponentList();
    filledList.addAll([body, chance, crossroads]);
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

    test('should allow replacing', () {
      PathComponent p = filledList[0];

      expect(p.path, equals(Path.body));
      expect(p.effect, equals(Effect.sense));
      expect(p.level, equals(Level.lesser));

      filledList[0] = p.withLevel(Level.greater);
      p = filledList[0];

      expect(p.path, equals(Path.body));
      expect(p.effect, equals(Effect.sense));
      expect(p.level, equals(Level.greater));

      filledList[0] = p.withEffect(Effect.control);
      p = filledList[0];

      expect(p.path, equals(Path.body));
      expect(p.effect, equals(Effect.control));
      expect(p.level, equals(Level.greater));

      filledList[0] =
          PathComponent(Path.energy, level: p.level, effect: p.effect);
      p = filledList[0];

      expect(p.path, equals(Path.energy));
      expect(p.effect, equals(Effect.control));
      expect(p.level, equals(Level.greater));
    });

    test('should allow iteration', () {});
  });

  group('change notification', () {
    test('should fire event when adding', () async {
      Timer.run(() {
        emptyList..add(body)..add(chance)..add(crossroads);
      });

      List<ListChangeEvent> events = await emptyList.onChange.take(3).toList();

      verifyEvent(events[0], Action.insert, 0, null, body);
      verifyEvent(events[1], Action.insert, 1, null, chance);
      verifyEvent(events[2], Action.insert, 2, null, crossroads);
    });

    test('should fire event when removing component', () async {
      Timer.run(() {
        filledList.remove(chance);
      });

      ListChangeEvent event = await filledList.onChange.first;

      verifyEvent(event, Action.remove, 1, chance, null);
    });

    test('should fire event for each component on clear', () async {
      Timer.run(() => filledList.clear());

      List<ListChangeEvent> events = await filledList.onChange.take(3).toList();

      verifyEvent(events[0], Action.remove, 0, body, null);
      verifyEvent(events[1], Action.remove, 1, chance, null);
      verifyEvent(events[2], Action.remove, 2, crossroads, null);
    });

    test('should fire event when remove by bool index', () async {
      Timer.run(() => filledList.removeByBoolIndex(<bool>[true, true, false]));

      List<ListChangeEvent> events = await filledList.onChange.take(2).toList();

      verifyEvent(events[0], Action.remove, 0, body, null);
      verifyEvent(events[1], Action.remove, 1, chance, null);
    });

    test('should fire event when replacing', () async {
      var pathComponent = PathComponent(Path.magic,
          level: Level.greater, effect: Effect.destroy);

      Timer.run(() {
        filledList[1] = pathComponent;
      });

      ListChangeEvent event = await filledList.onChange.first;
      verifyEvent(event, Action.modify, 1, chance, pathComponent);
    });
  });
}

void verifyEvent(ListChangeEvent event, Action action, int index,
    PathComponent oldValue, PathComponent newValue) {
  expect(event.action, equals(action));
  expect(event.index, equals(index));
  expect(event.oldValue, equals(oldValue));
  expect(event.newValue, equals(newValue));
}
