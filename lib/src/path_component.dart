import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import 'effect.dart';
import 'level.dart';
import 'path.dart';

@immutable
class PathComponent {
  const PathComponent(
    this.path, {
    Level level: Level.lesser,
    bool inherent: false,
    Effect effect: Effect.sense,
    String notes: '',
  })  : _level = level,
        _inherent = inherent,
        _effect = effect,
        _notes = notes;

  PathComponent withLevel(Level newLevel) => PathComponent(path,
      level: newLevel, inherent: _inherent, effect: _effect, notes: _notes);

  PathComponent withEffect(Effect newEffect) => PathComponent(path,
      level: _level, inherent: _inherent, effect: newEffect, notes: _notes);

  PathComponent withInherent(bool newInherent) => PathComponent(path,
      level: _level, inherent: newInherent, effect: _effect, notes: _notes);

  PathComponent withNotes(String text) => PathComponent(path,
      level: _level, inherent: _inherent, effect: _effect, notes: text?.trim());

  final Path path;
  final Level _level;
  final bool _inherent;
  final Effect _effect;
  final String _notes;

  int get cost => _effect.energyCost;

  Level get level => _level;

  bool get inherent => _inherent;

  Effect get effect => _effect;
  String get notes => _notes == null ? '' : _notes;

  @override
  bool operator ==(Object any) {
    return any is PathComponent &&
        any.path == path &&
        any._level == _level &&
        any._effect == _effect &&
        any._inherent == _inherent;
  }

  @override
  int get hashCode => hash4(path, _level, _effect, _inherent);

  @override
  String toString() => '${_level} ${_effect} ${path}';
}
