class Path {
  static Path Body =
      Path('Body', 'Targets the tissues and fluids of living things.');
  static Path Chance = Path('Chance', 'Affects luck, odds, and entropy.');
  static Path Crossroads = Path('Crossroads',
      'Targets or creates the connections between locations, times, and planes of existence.');
  static Path Energy = Path('Energy',
      'Energy includes fire, electricity, kinetic energy, light, sound, and more.');
  static Path Magic =
      Path('Magic', 'Governs spells, magical energy, and the act of casting.');
  static Path Matter =
      Path('Matter', 'Governs tangible, unliving, inanimate objects.');
  static Path Mind =
      Path('Mind', 'Governs the thought processes of sentient, living beings.');
  static Path Spirit = Path('Spirit',
      'Governs any being whose spirit and body are one, and who was never "alive" in the sense that we know it.');
  static Path Undead = Path('Undead',
      'Governs any being who lived, then died, but is still hanging around for some reason.');

  static Map<String, Path> _values = {
    Body.name: Body,
    Chance.name: Chance,
    Crossroads.name: Crossroads,
    Energy.name: Energy,
    Magic.name: Magic,
    Matter.name: Matter,
    Mind.name: Mind,
    Spirit.name: Spirit,
    Undead.name: Undead,
  };

  factory Path.fromString(String name) {
    return _values[name];
  }

  Path(this.name, this.aspect);

  final String name;
  final String aspect;

  @override
  String toString() => name;
}
