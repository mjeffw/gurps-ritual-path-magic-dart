class Level {
  static const greater = Level('Greater');
  static const lesser = Level('Lesser');

  static Map<String, Level> _values = {
    greater.name: greater,
    lesser.name: lesser,
  };

  factory Level.fromString(String name) {
    return _values[name];
  }

  const Level(this.name);

  final String name;

  @override
  String toString() => name;
}
