import 'package:gurps_rpm_model/gurps_rpm_model.dart';
import 'package:test/test.dart';

void main() {
  group('Body', () {
    Path body = Path.body;

    test('has name', () {
      expect(body.name, equals('Body'));
    });

    test('can be constructed by name', () {
      expect(body, equals(Path.fromString('Body')));
    });

    test('has aspect', () {
      expect(body.aspect,
          equals('Targets the tissues and fluids of living things.'));
    });
  });

  group('Chance', () {
    Path chance = Path.chance;

    test('has name', () {
      expect(chance.name, equals('Chance'));
    });

    test('can be constructed by name', () {
      expect(chance, equals(Path.fromString('Chance')));
    });

    test('has aspect', () {
      expect(chance.aspect, equals('Affects luck, odds, and entropy.'));
    });
  });

  group('Crossroads', () {
    Path roads = Path.crossroads;

    test('has name', () {
      expect(roads.name, equals('Crossroads'));
    });

    test('can be constructed by name', () {
      expect(roads, equals(Path.fromString('Crossroads')));
    });

    test('has aspect', () {
      expect(
          roads.aspect,
          equals(
              'Targets or creates the connections between locations, times, and planes of existence.'));
    });
  });

  group('Energy', () {
    Path energy = Path.energy;

    test('has name', () {
      expect(energy.name, equals('Energy'));
    });

    test('can be constructed by name', () {
      expect(energy, equals(Path.fromString('Energy')));
    });

    test('has aspect', () {
      expect(
          energy.aspect,
          equals(
              'Energy includes fire, electricity, kinetic energy, light, sound, and more.'));
    });
  });

  group('Magic', () {
    Path magic = Path.magic;

    test('has name', () {
      expect(magic.name, equals('Magic'));
    });

    test('has aspect', () {
      expect(magic.aspect,
          equals('Governs spells, magical energy, and the act of casting.'));
    });

    test('can be constructed by name', () {
      expect(magic, equals(Path.fromString('Magic')));
    });
  });

  group('Matter', () {
    Path matter = Path.matter;

    test('has name', () {
      expect(matter.name, equals('Matter'));
    });

    test('has aspect', () {
      expect(matter.aspect,
          equals('Governs tangible, unliving, inanimate objects.'));
    });

    test('can be constructed by name', () {
      expect(matter, equals(Path.fromString('Matter')));
    });
  });

  group('Mind', () {
    Path mind = Path.mind;

    test('has name', () {
      expect(mind.name, equals('Mind'));
    });

    test('has aspect', () {
      expect(mind.aspect,
          equals('Governs the thought processes of sentient, living beings.'));
    });

    test('can be constructed by name', () {
      expect(mind, equals(Path.fromString('Mind')));
    });
  });

  group('Spirit', () {
    Path spirit = Path.spirit;

    test('has name', () {
      expect(spirit.name, equals('Spirit'));
    });

    test('has aspect', () {
      expect(
          spirit.aspect,
          equals(
              'Governs any being whose spirit and body are one, and who was never "alive" in the sense that we know it.'));
    });

    test('can be constructed by name', () {
      expect(spirit, equals(Path.fromString('Spirit')));
    });
  });

  group('Undead', () {
    Path undead = Path.undead;

    test('has name', () {
      expect(undead.name, equals('Undead'));
    });

    test('has aspect', () {
      expect(
          undead.aspect,
          equals(
              'Governs any being who lived, then died, but is still hanging around for some reason.'));
    });

    test('can be constructed by name', () {
      expect(undead, equals(Path.fromString('Undead')));
    });
  });
}
