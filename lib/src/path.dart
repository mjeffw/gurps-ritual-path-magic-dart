import 'package:meta/meta.dart';

/// GURPS rpm.6: Where the core skill of Thaumatology represents theoretical knowledge, all practical spellcasting is
/// done with the following nine Path skills.
@immutable
class Path {
  const Path(this.name, this.aspect);

  factory Path.fromString(String name) {
    return _values[name];
  }

  static const body =
      Path('Body', 'Targets the tissues and fluids of living things.');
  static const chance = Path('Chance', 'Affects luck, odds, and entropy.');
  static const crossroads = Path('Crossroads',
      'Targets or creates the connections between locations, times, and planes of existence.');
  static const energy = Path('Energy',
      'Energy includes fire, electricity, kinetic energy, light, sound, and more.');
  static const magic =
      Path('Magic', 'Governs spells, magical energy, and the act of casting.');
  static const matter =
      Path('Matter', 'Governs tangible, unliving, inanimate objects.');
  static const mind =
      Path('Mind', 'Governs the thought processes of sentient, living beings.');
  static const spirit = Path('Spirit',
      'Governs any being whose spirit and body are one, and who was never "alive" in the sense that we know it.');
  static const undead = Path('Undead',
      'Governs any being who lived, then died, but is still hanging around for some reason.');

  static Map<String, Path> _values = {
    body.name: body,
    chance.name: chance,
    crossroads.name: crossroads,
    energy.name: energy,
    magic.name: magic,
    matter.name: matter,
    mind.name: mind,
    spirit.name: spirit,
    undead.name: undead,
  };

  final String name;
  final String aspect;

  @override
  String toString() => name;
}
