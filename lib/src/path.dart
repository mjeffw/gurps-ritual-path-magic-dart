import 'package:meta/meta.dart';

/// GURPS rpm.6: Where the core skill of Thaumatology represents theoretical knowledge, all practical spellcasting is
/// done with the following nine Path skills.
@immutable
abstract class Path {
  const Path(this.name, this.aspect);

  factory Path.fromString(String name) {
    return _values[name];
  }

  static const body = const _Body();
  static const chance = const _Chance();
  static const crossroads = const _Crossroads();
  static const energy = const _Energy();
  static const magic = const _Magic();
  static const matter = const _Matter();
  static const mind = const _Mind();
  static const spirit = const _Spirit();
  static const undead = const _Undead();

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

  static List<String> get labels => _values.keys.toList();
}

class _Body extends Path {
  const _Body()
      : super('Body', 'Targets the tissues and fluids of living things.');
}

class _Chance extends Path {
  const _Chance() : super('Chance', 'Affects luck, odds, and entropy.');
}

class _Crossroads extends Path {
  const _Crossroads()
      : super('Crossroads',
            'Targets or creates the connections between locations, times, and planes of existence.');
}

class _Energy extends Path {
  const _Energy()
      : super('Energy',
            'Energy includes fire, electricity, kinetic energy, light, sound, and more.');
}

class _Magic extends Path {
  const _Magic()
      : super(
            'Magic', 'Governs spells, magical energy, and the act of casting.');
}

class _Matter extends Path {
  const _Matter()
      : super('Matter', 'Governs tangible, unliving, inanimate objects.');
}

class _Mind extends Path {
  const _Mind()
      : super('Mind',
            'Governs the thought processes of sentient, living beings.');
}

class _Spirit extends Path {
  const _Spirit()
      : super('Spirit',
            'Governs any being whose spirit and body are one, and who was never "alive" in the sense that we know it.');
}

class _Undead extends Path {
  const _Undead()
      : super('Undead',
            'Governs any being who lived, then died, but is still hanging around for some reason.');
}
