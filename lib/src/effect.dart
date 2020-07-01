import 'package:meta/meta.dart';

@immutable
class Effect {
  const Effect(this.name, this.energyCost, this.description);

  factory Effect.fromString(String name) {
    return _values[name];
  }

  static const sense = Effect(
      'Sense', 2, 'Learn something about, or communicate with, the subject.');
  static const strengthen = Effect(
      'Strengthen', 3, 'Protect, enhance, or otherwise augment the subject.');
  static const restore =
      Effect('Restore', 4, 'Heal or repair subject or undo a transformation.');
  static const control = Effect('Control', 5,
      'Direct or move the subject without changing it fundamentally.');
  static const destroy = Effect('Destroy', 5, 'Damage or weaken the subject.');
  static const create =
      Effect('Create', 6, 'Bring subject into being from nothing.');
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
