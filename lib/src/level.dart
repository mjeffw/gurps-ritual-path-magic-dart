class Level {
  static Level Greater = Level('Greater');
  static Level Lesser = Level('Lesser');

  static Map<String, Level> _values = {
    Greater.name: Greater,
    Lesser.name: Lesser,
  };

  factory Level.fromString(String name) {
    return _values[name];
  }

  Level(this.name);

  final String name;

  @override
  String toString() => name;
}
