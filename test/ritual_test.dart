import 'package:gurps_ritual_path_magic_model/ritual_path_magic.dart';
import 'package:gurps_ritual_path_magic_model/src/level.dart';
import 'package:gurps_ritual_path_magic_model/src/path.dart';
import 'package:gurps_ritual_path_magic_model/src/path_component.dart';
import 'package:gurps_ritual_path_magic_model/src/ritual.dart';
import 'package:test/test.dart';

void main() {
  test('has name', () {
    var list = <PathComponent>[];
    list.add(PathComponent(Path.undead,
        level: Level.greater, effect: Effect.control));
    list.add(PathComponent(Path.undead, effect: Effect.create));

    Ritual r = new Ritual(name: 'Bag of Bones', effects: list);
    expect(r.name, equals('Bag of Bones'));
    expect(
        r.effects,
        containsAll(<PathComponent>[
          PathComponent(Path.undead,
              level: Level.greater, effect: Effect.control),
          PathComponent(Path.undead, level: Level.lesser, effect: Effect.create)
        ]));

    expect(r.modifiers, isEmpty);

    // r.name = 'Bag of Bones';
    // r.paths.add(PathComponent(Path.undead,
    //     level: Level.greater, effect: Effect.control));
    // r.paths.add(
    //     PathComponent(Path.undead, level: Level.lesser, effect: Effect.create));
  });
}
