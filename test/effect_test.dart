import 'package:test/test.dart';
import '../lib/src/effect.dart';

void main() {
  //
  group('RPMp7. There are seven spell effects for each path:', () {
    group('Sense:', () {
      Effect sense = Effect.fromString('Sense');

      test('has name', () {
        expect(sense.name, equals('Sense'));
      });

      test('has description', () {
        expect(sense.description,
            equals('Learn something about, or communicate with, the subject.'));
      });

      test('has Energy Cost', () {
        expect(sense.energyCost, equals(2));
      });

      test('can be constructed by name', () {
        expect(sense, equals(Effect.sense));
      });
    });

    group('Strengthen:', () {
      Effect sense = Effect.fromString('Strengthen');

      test('has name', () {
        expect(sense.name, equals('Strengthen'));
      });

      test('has description', () {
        expect(sense.description,
            equals('Protect, enhance, or otherwise augment the subject.'));
      });

      test('has Energy Cost', () {
        expect(sense.energyCost, equals(3));
      });

      test('can be constructed by name', () {
        expect(sense, equals(Effect.strengthen));
      });
    });

    group('Restore:', () {
      Effect sense = Effect.fromString('Restore');

      test('has name', () {
        expect(sense.name, equals('Restore'));
      });

      test('has description', () {
        expect(sense.description,
            equals('Heal or repair subject or undo a transformation.'));
      });

      test('has Energy Cost', () {
        expect(sense.energyCost, equals(4));
      });

      test('can be constructed by name', () {
        expect(sense, equals(Effect.restore));
      });
    });

    group('Control:', () {
      Effect control = Effect.fromString('Control');

      test('can be constructed by name', () {
        expect(control, equals(Effect.control));
      });

      test('has name', () {
        expect(control.name, equals('Control'));
      });

      test('has description', () {
        expect(
            control.description,
            equals(
                'Direct or move the subject without changing it fundamentally.'));
      });

      test('has Energy Cost', () {
        expect(control.energyCost, equals(5));
      });
    });

    group('Destroy:', () {
      Effect destroy = Effect.fromString('Destroy');

      test('can be constructed by name', () {
        expect(destroy, equals(Effect.destroy));
      });

      test('has name', () {
        expect(destroy.name, equals('Destroy'));
      });

      test('has description', () {
        expect(destroy.description, equals('Damage or weaken the subject.'));
      });

      test('has Energy Cost', () {
        expect(destroy.energyCost, equals(5));
      });
    });

    group('Create:', () {
      Effect create = Effect.fromString('Create');

      test('can be constructed by name', () {
        expect(create, equals(Effect.create));
      });

      test('has name', () {
        expect(create.name, equals('Create'));
      });

      test('has description', () {
        expect(create.description,
            equals('Bring subject into being from nothing.'));
      });

      test('has Energy Cost', () {
        expect(create.energyCost, equals(6));
      });
    });

    group('Transform:', () {
      Effect transform = Effect.fromString('Transform');

      test('can be constructed by name', () {
        expect(transform, equals(Effect.transform));
      });

      test('has name', () {
        expect(transform.name, equals('Transform'));
      });

      test('has description', () {
        expect(
            transform.description, equals('Significantly alter the subject.'));
      });

      test('has Energy Cost', () {
        expect(transform.energyCost, equals(8));
      });
    });
  });
}
