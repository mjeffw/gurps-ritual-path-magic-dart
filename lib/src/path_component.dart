import 'path.dart';
import 'level.dart';
import 'effect.dart';

class PathComponent {
  final Path path;
  Level level = Level.Lesser;
  bool inherent = false;
  String _notes;
  Effect effect = Effect.Sense;

  PathComponent(this.path);

  String get notes => _notes == null ? '' : _notes;

  set notes(String text) {
    _notes = text.trim();
  }

  int get cost => effect.energyCost;

  @override
  String toString() => '${level} ${effect} ${path}';
}
