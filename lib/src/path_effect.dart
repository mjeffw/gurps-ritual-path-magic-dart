import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import 'effect.dart';
import 'level.dart';
import 'path.dart';

/// A PathEffect is a "fully-qualified" path component of a specific ritual.
/// It consists of a Path, Effect, and Level. Example: Greater Control Matter.
///
/// A PathEffect also has a flag to indicate if the PathEffect is 'inherent' to
/// the ritual (i.e., it is a required part of the ritual, without which this
/// would not be the same ritual). Non-inherent PathEffects can be added to
/// many rituals to allow them to be cast as a charm, for example.
///
/// Also optional is a free-form notes field, for explaining what the
/// PathEffect adds to the ritual, in way of an explanation.
@immutable
class PathEffect {
  const PathEffect(
    this.path, {
    Level level: Level.lesser,
    bool inherent: false,
    Effect effect: Effect.sense,
    String notes: '',
  })  : _level = level,
        _inherent = inherent,
        _effect = effect,
        _notes = notes;

  PathEffect withLevel(Level newLevel) => PathEffect(path,
      level: newLevel, inherent: _inherent, effect: _effect, notes: _notes);

  PathEffect withEffect(Effect newEffect) => PathEffect(path,
      level: _level, inherent: _inherent, effect: newEffect, notes: _notes);

  PathEffect withInherent(bool newInherent) => PathEffect(path,
      level: _level, inherent: newInherent, effect: _effect, notes: _notes);

  PathEffect withNotes(String text) => PathEffect(path,
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
    return any is PathEffect &&
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
