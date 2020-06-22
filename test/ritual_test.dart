import 'package:gurps_ritual_path_magic_model/ritual_path_magic.dart';
import 'package:gurps_ritual_path_magic_model/src/level.dart';
import 'package:gurps_ritual_path_magic_model/src/path.dart';
import 'package:gurps_ritual_path_magic_model/src/path_component.dart';
import 'package:gurps_ritual_path_magic_model/src/ritual.dart';
import 'package:test/test.dart';

void main() {
  test('has name', () {
    Ritual r = new Ritual();
    r.name = 'Air Jet';
    r.paths.add(PathComponent(Path.matter,
        level: Level.greater, effect: Effect.control));
    r.modifiers;
  });
}
