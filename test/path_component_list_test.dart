import 'dart:async';
import 'package:test/test.dart';
import '../lib/src/path_component_list.dart';
import '../lib/src/path_component.dart';
import '../lib/src/path.dart';

void main() {
  group('PathComponentList', () {
    PathComponentList list;
    var body = PathComponent(Path.Body);
    var chance = PathComponent(Path.Chance);
    var crossroads = PathComponent(Path.Crossroads);

    setUp(() async {
      list = PathComponentList();
    });

    test('should Allow Adding Path Components', () {
      expect(list.length, equals(0));

      list.add(body);
      list.add(chance);
      list.add(crossroads);

      expect(list.length, equals(3));

      expect(list[0], equals(body));
      expect(list[1], equals(chance));
      expect(list[2], equals(crossroads));
    });

    test('should fire event when adding', () async {
      Timer.run(() {
        list.add(body);
        list.add(chance);
        list.add(crossroads);
      });

      List<ListChangeEvent> events = await list.onChange.take(3).toList();

      expect(events[0].action, equals(Action.Insert));
      expect(events[0].index, equals(0));
      expect(events[0].component, equals(body));

      expect(events[1].action, equals(Action.Insert));
      expect(events[1].index, equals(1));
      expect(events[1].component, equals(chance));

      expect(events[2].action, equals(Action.Insert));
      expect(events[2].index, equals(2));
      expect(events[2].component, equals(crossroads));
    });

    test('should allow removing components', () {
      list.add(body);
      list.add(chance);
      list.add(crossroads);

      list.remove(chance);
      expect(list.length, equals(2));
      expect(list[0], equals(body));
      expect(list[1], equals(crossroads));
    });

    test('should notify listeners when removing components', () async {
      Timer.run(() {
        list.add(body);
        list.add(chance);
        list.add(crossroads);

        list.remove(chance);
      });

      ListChangeEvent event = await list.onChange.skip(3).first;

      expect(event.action, equals(Action.Remove));
      expect(event.component, equals(chance));
      expect(event.index, equals(1));
    });
  });
}
