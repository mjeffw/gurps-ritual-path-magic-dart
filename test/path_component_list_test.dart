import 'package:test/test.dart';
import '../lib/src/path_component_list.dart';
import '../lib/src/path_component.dart';
import '../lib/src/path.dart';


void main() {
  group('PathComponentList', () {
    PathComponentList list = PathComponentList();
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

    test('should fire event when adding',(){
      list.onChange.listen((e) => print(e));
      list.add(body);
    });
  });
}
