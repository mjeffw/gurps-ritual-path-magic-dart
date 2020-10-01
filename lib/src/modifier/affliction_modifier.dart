import 'package:quiver/core.dart';

import 'ritual_modifier.dart';

/// Adds the Affliction: Stun (p. B36) effect to a spell.
class AfflictionStun extends RitualModifier {
  const AfflictionStun() : super(AfflictionStun.label);

  static const String label = 'Affliction, Stunning';

  /// GURPS rpm.16: Stunning a foe (mentally or physically) adds no additional
  /// energy; the spell effect is enough.
  @override
  int get energyCost => 0;

  @override
  RitualModifier incrementEffect(int value) => this;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is AfflictionStun;
}

/// Adds an Affliction (p. B36) effect to a spell.
class Affliction extends RitualModifier {
  const Affliction({String effect, int percent: 0})
      : percent = (percent == null) ? 0 : (percent < 0) ? 0 : percent,
        effect = effect ?? 'Undefined',
        super(label);

  static const String label = 'Affliction';

  Affliction copyWith({String effect, int percent}) {
    return Affliction(
        effect: effect ?? this.effect, percent: percent ?? this.percent);
  }

  @override
  Affliction incrementEffect(int energyIncrement) => Affliction(
      effect: this.effect, percent: (this.energyCost + energyIncrement) * 5);

  final String effect;

  final int percent;

  /// GURPS rpm.16: For the other states on pp. B428-429, this costs +1 energy
  /// for every +5% it’s worth as an enhancement to Affliction (pp. B35-36).
  @override
  int get energyCost => (percent / 5.0).ceil();

  @override
  int get hashCode => hash2(effect, percent);

  @override
  bool operator ==(Object other) =>
      other is Affliction && other.effect == effect && other.percent == percent;
}
