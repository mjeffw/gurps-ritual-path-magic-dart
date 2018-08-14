import 'package:test/test.dart';

import '../lib/src/effect.dart';
import '../lib/src/level.dart';
import '../lib/src/path.dart';
import '../lib/src/path_component.dart';

void main() {
  group('PathComponent', () {
    PathComponent p;

    setUp(() async {
      p = PathComponent(Path.Body);
    });

    test('has Path of Body', () {
      expect(p.path, equals(Path.Body));
    });

    test('has String representation', () {
      expect(p.toString(), equals('Lesser Sense Body'));

      p = p.withLevel(Level.Greater);
      expect(p.toString(), equals('Greater Sense Body'));

      p = p.withEffect(Effect.Restore);
      expect(p.toString(), equals('Greater Restore Body'));
    });

    test('has Path of Chance', () {
      PathComponent p = PathComponent(Path.Chance);
      expect(p.path, equals(Path.Chance));
      expect(p.toString(), equals('Lesser Sense Chance'));
    });

    test('has Effect default of Sense', () {
      expect(p.effect, equals(Effect.Sense));
    });

    test('can change Effecct', () {
      p = p.withEffect(Effect.Transform);
      expect(p.effect, equals(Effect.Transform));
    });

    test('has default Level of Lesser', () {
      expect(p.level, equals(Level.Lesser));
    });

    test('can change Level', () {
      p = p.withLevel(Level.Greater);
      expect(p.level, equals(Level.Greater));
    });

    test('has default inherent of false', () {
      expect(p.inherent, equals(false));
    });

    test('can change inherent', () {
      p = p.withInherent(true);
      expect(p.inherent, equals(true));
    });

    test('has blank notes by default', () {
      expect(p.notes, equals(''));
    });

    test('notes can be changed', () {
      p = p.withNotes('hello');
      expect(p.notes, equals('hello'));
    });

    test('notes should be trimmed of whitespace', () {
      p = p.withNotes(' world \t ');
      expect(p.notes, equals('world'));
    });

    test('lesser effects cost the same as the energy cost for the effect', () {
      expect(p.cost, equals(Effect.Sense.energyCost));

      p = p.withEffect(Effect.Transform);
      expect(p.cost, equals(Effect.Transform.energyCost));

      p = p.withEffect(Effect.Create);
      expect(p.cost, equals(Effect.Create.energyCost));

      p = p.withEffect(Effect.Destroy);
      expect(p.cost, equals(Effect.Destroy.energyCost));

      p = p.withEffect(Effect.Control);
      expect(p.cost, equals(Effect.Control.energyCost));

      p = p.withEffect(Effect.Restore);
      expect(p.cost, equals(Effect.Restore.energyCost));

      p = p.withEffect(Effect.Strengthen);
      expect(p.cost, equals(Effect.Strengthen.energyCost));
    });
  });
}
