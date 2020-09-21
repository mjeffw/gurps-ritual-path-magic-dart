import 'package:test/test.dart';

import '../lib/src/effect.dart';
import '../lib/src/level.dart';
import '../lib/src/path.dart';
import '../lib/src/spell_effect.dart';

void main() {
  group('SpellEffect', () {
    SpellEffect p;

    setUp(() async {
      p = SpellEffect(Path.body);
    });

    test('has Path of Body', () {
      expect(p.path, equals(Path.body));
    });

    test('has String representation', () {
      expect(p.toString(), equals('Lesser Sense Body'));

      p = p.withLevel(Level.greater);
      expect(p.toString(), equals('Greater Sense Body'));

      p = p.withEffect(Effect.restore);
      expect(p.toString(), equals('Greater Restore Body'));
    });

    test('has Path of Chance', () {
      SpellEffect p = SpellEffect(Path.chance);
      expect(p.path, equals(Path.chance));
      expect(p.toString(), equals('Lesser Sense Chance'));
    });

    test('has Effect default of Sense', () {
      expect(p.effect, equals(Effect.sense));
    });

    test('can change Effecct', () {
      p = p.withEffect(Effect.transform);
      expect(p.effect, equals(Effect.transform));
    });

    test('has default Level of Lesser', () {
      expect(p.level, equals(Level.lesser));
    });

    test('can change Level', () {
      p = p.withLevel(Level.greater);
      expect(p.level, equals(Level.greater));
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
      expect(p.cost, equals(Effect.sense.energyCost));

      p = p.withEffect(Effect.transform);
      expect(p.cost, equals(Effect.transform.energyCost));

      p = p.withEffect(Effect.create);
      expect(p.cost, equals(Effect.create.energyCost));

      p = p.withEffect(Effect.destroy);
      expect(p.cost, equals(Effect.destroy.energyCost));

      p = p.withEffect(Effect.control);
      expect(p.cost, equals(Effect.control.energyCost));

      p = p.withEffect(Effect.restore);
      expect(p.cost, equals(Effect.restore.energyCost));

      p = p.withEffect(Effect.strengthen);
      expect(p.cost, equals(Effect.strengthen.energyCost));
    });

    test('implements == and hashCode', () {
      expect(p, equals(SpellEffect(Path.body)));
      expect(p, isNot(equals(SpellEffect(Path.chance))));
      expect(p, isNot(equals(p.withEffect(Effect.create))));
      expect(p, isNot(equals(p.withInherent(true))));
      expect(p, isNot(equals(p.withLevel(Level.greater))));
      expect(p, isNot(equals(p.withNotes('Path.chance'))));

      expect(p.hashCode, equals(SpellEffect(Path.body).hashCode));
      expect(p.hashCode, isNot(equals(SpellEffect(Path.chance).hashCode)));
      expect(p.hashCode, isNot(equals(p.withEffect(Effect.create).hashCode)));
      expect(p.hashCode, isNot(equals(p.withInherent(true).hashCode)));
      expect(p.hashCode, isNot(equals(p.withLevel(Level.greater).hashCode)));
      expect(p.hashCode, isNot(equals(p.withNotes('Path.chance').hashCode)));
    });
  });
}
