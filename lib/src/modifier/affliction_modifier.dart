import 'ritual_modifier.dart';

/// Adds the Affliction: Stun (p. B36) effect to a spell.
class AfflictionStun extends RitualModifier {
  const AfflictionStun({bool inherent: false})
      : super('Affliction, Stunning', inherent: inherent);

  /// GURPS rpm.16: Stunning a foe (mentally or physically) adds no additional
  /// energy; the spell effect is enough.
  @override
  int get energyCost => 0;

  @override
  RitualModifier incrementEffect(int value) => this;
}

/// Adds an Affliction (p. B36) effect to a spell.
class Affliction extends RitualModifier {
  const Affliction({String effect, int percent: 0, bool inherent: false})
      : percent = percent ?? 0,
        effect = effect ?? 'undefined',
        super('Afflictions', inherent: inherent);

  Affliction copyWith({String effect, int percent, bool inherent}) {
    return Affliction(
      effect: effect ?? this.effect,
      percent: percent ?? this.percent,
      inherent: inherent ?? this.inherent,
    );
  }

  @override
  Affliction incrementEffect(int energyIncrement) {
    int percent = (this.energyCost + energyIncrement) * 5;
    return Affliction(
        effect: 'undefined', percent: percent, inherent: this.inherent);
  }

  final String effect;

  final int percent;

  /// GURPS rpm.16: For the other states on pp. B428-429, this costs +1 energy
  /// for every +5% it’s worth as an enhancement to Affliction (pp. B35-36).
  @override
  int get energyCost => (percent / 5.0).ceil();
}
