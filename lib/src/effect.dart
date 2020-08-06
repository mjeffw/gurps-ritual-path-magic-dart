import 'package:meta/meta.dart';

/// GURPS rpm.7: There are seven spell effects for each Path: Sense, Strengthen, Restore, Control, Destroy, Create, and
/// Transform.
@immutable
class Effect {
  const Effect(this.name, this.energyCost, this.description);

  factory Effect.fromString(String name) {
    return _values[name];
  }

  /// GURPS rpm.15: Sense: Cost 2
  static const sense = Effect(
      'Sense', 2, 'Learn something about, or communicate with, the subject.');

  /// GURPS rpm.16: Strengthen: Cost 3
  static const strengthen = Effect(
      'Strengthen', 3, 'Protect, enhance, or otherwise augment the subject.');

  /// GURPS rpm.16: Restore: Cost 4
  static const restore =
      Effect('Restore', 4, 'Heal or repair subject or undo a transformation.');

  /// GURPS rpm.16: Control: Cost 5
  static const control = Effect('Control', 5,
      'Direct or move the subject without changing it fundamentally.');

  /// GURPS rpm.16: Destroy: Cost 5
  static const destroy = Effect('Destroy', 5, 'Damage or weaken the subject.');

  /// GURPS rpm.16: Create: Cost 6
  static const create =
      Effect('Create', 6, 'Bring subject into being from nothing.');

  /// GURPS rpm.16: Transform: Cost 8
  static const transform =
      Effect('Transform', 8, 'Significantly alter the subject.');

  static Map<String, Effect> _values = {
    sense.name: sense,
    strengthen.name: strengthen,
    restore.name: restore,
    control.name: control,
    destroy.name: destroy,
    create.name: create,
    transform.name: transform,
  };

  final String name;
  final String description;
  final int energyCost;

  @override
  String toString() => name;
}
