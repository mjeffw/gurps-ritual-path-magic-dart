import 'package:test/test.dart';
import '../lib/src/path_component.dart';
import '../lib/src/path.dart';
import '../lib/src/level.dart';
import '../lib/src/effect.dart';

void main() {
  group('PathComponent', () {
    PathComponent p;

    setUp(() async {
      p = PathComponent(Path.Body);
    });

    test('has Path of Body', () {
      expect(p.path, equals(Path.Body));
    });

    test('has String representation', (){
      expect(p.toString(), equals('Lesser Sense Body'));
    });

    test('has Path of Chance', () {
      PathComponent p = PathComponent(Path.Chance);
      expect(p.path, equals(Path.Chance));
    });

    test('has Effect default of Sense', () {
      expect(p.effect, equals(Effect.Sense));
    });

    test('can change Effecct', () {
      p.effect = Effect.Transform;
      expect(p.effect, equals(Effect.Transform));
    });

    test('has default Level of Lesser', () {
      expect(p.level, equals(Level.Lesser));
    });

    test('can change Level', () {
      p.level = Level.Greater;
      expect(p.level, equals(Level.Greater));
    });

    test('has default inherent of false', () {
      expect(p.inherent, equals(false));
    });

    test('can change inherent', () {
      p.inherent = true;
      expect(p.inherent, equals(true));
    });

    test('has blank notes by default', () {
      expect(p.notes, equals(''));
    });

    test('notes can be changed', () {
      p.notes = 'hello';
      expect(p.notes, equals('hello'));
    });

    test('notes should be trimmed of whitespace', () {
      p.notes = ' world \t ';
      expect(p.notes, equals('world'));
    });

    test('lesser effects cost are the same as the energy cost for the effect',
        () {
      expect(p.cost, equals(Effect.Sense.energyCost));

      p.effect = Effect.Transform;
      expect(p.cost, equals(Effect.Transform.energyCost));

      p.effect = Effect.Create;
      expect(p.cost, equals(Effect.Create.energyCost));

      p.effect = Effect.Destroy;
      expect(p.cost, equals(Effect.Destroy.energyCost));

      p.effect = Effect.Control;
      expect(p.cost, equals(Effect.Control.energyCost));

      p.effect = Effect.Restore;
      expect(p.cost, equals(Effect.Restore.energyCost));

      p.effect = Effect.Strengthen;
      expect(p.cost, equals(Effect.Strengthen.energyCost));
    });
  });
}
