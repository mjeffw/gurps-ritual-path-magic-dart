import 'package:meta/meta.dart';

import 'trait.dart';

/// Describes a modifier to an Ritual.
///
/// Modifiers add Damage, Range, GurpsDuration, and other features to a ritual,
/// and the energy cost of the spell is adjusted by the value of the modifiers.
/// Modifiers are identified by their name, and can be inherent (intrisic) or
/// not.
///
/// For example, a spell might momentarily open a Gate between dimensions; a
/// GurpsDuration modifier can be added to make the Gate remain for a longer
/// time. The GurpsDuration is not inherent or intrinsic in this case.
///
/// A spell that adds +2 to the subject's Strength would need a Bestows a Bonus
///  modifier; this effect is inherent to the spell.
@immutable
abstract class RitualModifier {
  const RitualModifier(this.name, {this.inherent, this.value});

  /// the name of this Modifier
  final String name;

  /// is this Modifier instance inherent to the spell?
  final bool inherent;

  /// the energy cost of the modifier
  int get energyCost;

  /// the current value of this modifier - depends on the modifier, it could
  /// represent character points, a time unit, distance unit, a percentage
  /// modifier, etc.
  final int value;
}

class AfflictionStun extends RitualModifier {
  AfflictionStun({bool inherent: false})
      : super("Affliction, Stunning", inherent: inherent);

  /// GURPS rpm.16: Stunning a foe (mentally or physically) adds no additional
  /// energy; the spell effect is enough.
  @override
  int get energyCost => 0;
}

class Affliction extends RitualModifier {
  Affliction(this.specialization, {int value: 0, bool inherent: false})
      : super("Afflictions", value: value, inherent: inherent);

  factory Affliction.copyWith(Affliction a,
      {String specialization, int value, bool inherent}) {
    return Affliction(specialization ?? a.specialization,
        value: value ?? a.value, inherent: inherent ?? a.inherent);
  }

  final String specialization;

  /// GURPS rpm.16: For the other states on pp. B428-429, this costs +1 energy
  /// for every +5% it’s worth as an enhancement to Affliction (pp. B35-36).
  @override
  int get energyCost => (value / 5.0).ceil();
}

/// Any ritual that adds, removes or modifies advantages or disadvantages, or
/// increases or lowers attributes or characteristics.
class AlteredTraits extends RitualModifier {
  AlteredTraits(this.trait, {bool inherent = false, int value = 0})
      : super("Altered Traits", inherent: inherent, value: value);

  factory AlteredTraits.copyWith(AlteredTraits src,
      {Trait trait, bool inherent, int value}) {
    return AlteredTraits(trait ?? src.trait,
        inherent: inherent ?? src.inherent, value: value ?? src.value);
  }

  final Trait trait;

  @override
  int get energyCost => throw UnimplementedError();
}

// class ModifierDetail {}

// class AfflictionDetail extends ModifierDetail {}

// class BestowsABonus extends RitualModifier {
//   const BestowsABonus() : super('Bestows a Bonus');

//   static const variations = <String>['Broad', 'Moderate', 'Narrow'];

//   @override
//   bool validVariation(String variation) => variations.contains(variation);
// }
