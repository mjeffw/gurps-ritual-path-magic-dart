class Level {
  static const Greater = Level('Greater');
  static const Lesser = Level('Lesser');

  static Map<String, Level> _values = {
    Greater.name: Greater,
    Lesser.name: Lesser,
  };

  factory Level.fromString(String name) {
    return _values[name];
  }

  const Level(this.name);

  final String name;

  @override
  String toString() => name;
}
