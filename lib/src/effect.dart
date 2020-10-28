import 'package:meta/meta.dart';

/// GURPS rpm.7: There are seven spell effects for each Path: Sense, Strengthen, Restore, Control, Destroy, Create, and
/// Transform.
@immutable
abstract class Effect {
  const Effect(this.name, this.energyCost, this.description);

  factory Effect.fromString(String name) {
    return _values[name];
  }

  static const sense =const _Sense();
  static const strengthen = const _Strengthen();
  static const restore = const _Restore();
  static const control = const _Control();
  static const destroy = const _Destroy();
  static const create = const _Create();
  static const transform = const _Transform();

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

  static List<String> get labels => _values.keys.toList();
}

/// GURPS rpm.15: Sense: Cost 2
class _Sense extends Effect {
  const _Sense()
      : super('Sense', 2,
            'Learn something about, or communicate with, the subject.');
}

/// GURPS rpm.16: Strengthen: Cost 3
class _Strengthen extends Effect {
  const _Strengthen()
      : super('Strengthen', 3,
            'Protect, enhance, or otherwise augment the subject.');
}

/// GURPS rpm.16: Restore: Cost 4
class _Restore extends Effect {
  const _Restore()
      : super('Restore', 4, 'Heal or repair subject or undo a transformation.');
}

/// GURPS rpm.16: Control: Cost 5
class _Control extends Effect {
  const _Control()
      : super('Control', 5,
            'Direct or move the subject without changing it fundamentally.');
}

/// GURPS rpm.16: Destroy: Cost 5
class _Destroy extends Effect {
  const _Destroy() : super('Destroy', 5, 'Damage or weaken the subject.');
}

/// GURPS rpm.16: Create: Cost 6
class _Create extends Effect {
  const _Create()
      : super('Create', 6, 'Bring subject into being from nothing.');
}

/// GURPS rpm.16: Transform: Cost 8
class _Transform extends Effect {
  const _Transform()
      : super('Transform', 8, 'Significantly alter the subject.');
}
