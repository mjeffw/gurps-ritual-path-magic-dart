class Effect {
  static const Sense = Effect(
      'Sense', 2, 'Learn something about, or communicate with, the subject.');
  static const Strengthen = Effect(
      'Strengthen', 3, 'Protect, enhance, or otherwise augment the subject.');
  static const Restore =
      Effect('Restore', 4, 'Heal or repair subject or undo a transformation.');
  static const Control = Effect('Control', 5,
      'Direct or move the subject without changing it fundamentally.');
  static const Destroy = Effect('Destroy', 5, 'Damage or weaken the subject.');
  static const Create =
      Effect('Create', 6, 'Bring subject into being from nothing.');
  static const Transform =
      Effect('Transform', 8, 'Significantly alter the subject.');

  static Map<String, Effect> _values = {
    Sense.name: Sense,
    Strengthen.name: Strengthen,
    Restore.name: Restore,
    Control.name: Control,
    Destroy.name: Destroy,
    Create.name: Create,
    Transform.name: Transform,
  };

  final String name;
  final String description;
  final int energyCost;

  factory Effect.fromString(String name) {
    return _values[name];
  }

  const Effect(this.name, this.energyCost, this.description);

  @override
  String toString() => name;
}
