import 'package:meta/meta.dart';

/// GURPS rpm.7: Each spell effect can be broken into Lesser and Greater effects.
@immutable
class Level {
  const Level(this.name);

  factory Level.fromString(String name) {
    return _values[name];
  }

  static const greater = const Level('Greater');
  static const lesser = const Level('Lesser');

  static Map<String, Level> _values = {
    greater.name: greater,
    lesser.name: lesser,
  };

  final String name;

  @override
  String toString() => name;

  static List<String> get labels => _values.keys.toList();
}
