import 'package:gurps_dart/gurps_dart.dart';
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
  const RitualModifier(this.name, {this.inherent});

  /// the name of this Modifier
  final String name;

  /// is this Modifier instance inherent to the spell?
  final bool inherent;

  /// the energy cost of the modifier
  int get energyCost;
}

/// Adds the Affliction: Stun (p. B36) effect to a spell.
class AfflictionStun extends RitualModifier {
  AfflictionStun({bool inherent: false, int value: 0})
      : super("Affliction, Stunning", inherent: inherent);

  /// GURPS rpm.16: Stunning a foe (mentally or physically) adds no additional
  /// energy; the spell effect is enough.
  @override
  int get energyCost => 0;
}

/// Adds an Affliction (p. B36) effect to a spell.
class Affliction extends RitualModifier {
  Affliction(this.specialization, {int percent: 0, bool inherent: false})
      : percent = percent ?? 0,
        super("Afflictions", inherent: inherent);

  factory Affliction.copyWith(Affliction a,
      {String specialization, int percent, bool inherent}) {
    return Affliction(
      specialization ?? a.specialization,
      percent: percent ?? a.percent,
      inherent: inherent ?? a.inherent,
    );
  }

  final String specialization;

  final int percent;

  /// GURPS rpm.16: For the other states on pp. B428-429, this costs +1 energy
  /// for every +5% it’s worth as an enhancement to Affliction (pp. B35-36).
  @override
  int get energyCost => (percent / 5.0).ceil();
}

/// Any ritual that adds, removes or modifies advantages or disadvantages, or
/// increases or lowers attributes or characteristics.
class AlteredTraits extends RitualModifier {
  AlteredTraits(this.trait,
      {bool inherent = false, List<TraitModifier> modifiers})
      : super("Altered Traits", inherent: inherent) {
    _modifiers.addAll([if (modifiers != null) ...modifiers]);
  }

  factory AlteredTraits.copyWith(AlteredTraits src,
          {Trait trait, bool inherent}) =>
      AlteredTraits(
        trait ?? src.trait,
        inherent: inherent ?? src.inherent,
        modifiers: src._modifiers,
      );

  factory AlteredTraits.addModifier(
          AlteredTraits m, TraitModifier traitModifier) =>
      AlteredTraits(m.trait, inherent: m.inherent, modifiers: [
        if (m._modifiers != null) ...m._modifiers,
        traitModifier
      ]);

  final Trait trait;

  final List<TraitModifier> _modifiers = [];

  @override
  int get energyCost => (_baseEnergy * _modifierMultiplier).ceil();

  int get characterPoints => trait.totalCost;

  /// GURPS rpm.16: Any spell that adds or worsens disadvantages, reduces or removes advantages, or lowers attributes or
  /// characteristics adds +1 energy for every 5 character points removed.
  ///
  /// GURPS rpm.17: One that adds or improves advantages, reduces or removes disadvantages, or increases attributes or
  /// characteristics adds +1 energy for every 1 character point added.
  int get _baseEnergy => (characterPoints.isNegative)
      ? (characterPoints.abs() / 5.0).ceil()
      : characterPoints;

  double get _modifierMultiplier {
    double x =
        _modifiers.map((i) => i.percent / 100.0).fold(0.0, (a, b) => a + b);

    return 1 + x;
  }
}

/// Adds an Area of Effect, optionally including or excluding specific targets in the area, to the spell.
///
/// Figure the circular area and add 10 SP per yard of radius from its center. Excluding potential targets is
/// possible – add another +1 SP for every two specific subjects in the area that won’t be affected by the spell.
/// Alternatively, you may exclude everyone in the area, but then include willing potential targets for +1 SP per
/// two specific subjects
class AreaOfEffect extends RitualModifier {
  AreaOfEffect(
      {int radius: 0,
      int numberTargets: 0,
      bool excludes: true,
      bool inherent: false})
      : radius = radius ?? 0,
        numberTargets = numberTargets ?? 0,
        excludes = excludes ?? true,
        super('Area of Effect', inherent: inherent);

  factory AreaOfEffect.copyWith(AreaOfEffect m,
      {int radius, int numberTargets, bool excludes, bool inherent}) {
    return AreaOfEffect(
      inherent: inherent ?? m.inherent,
      radius: radius ?? m.radius,
      numberTargets: numberTargets ?? m.numberTargets,
      excludes: excludes ?? m.excludes,
    );
  }

  final int radius;

  final int numberTargets;

  final bool excludes;

  final _table = SizeAndSpeedRangeTable();

  /// GURPS rpm.17: Figure the spherical area of effect, find its radius in
  /// yards on the Size and Speed/Range Table (p. B550), and add twice the
  /// “Size” value for that line to the energy cost (minimum +2).
  ///
  /// GURPS rpm.17: Excluding potential targets is harder – add another +1
  /// energy for every two specific subjects in the area that won’t be affected
  /// by the spell.
  @override
  int get energyCost {
    if (radius == 0) return 0;
    var energy = _table.sizeForLinearMeasurement(radius) * 2;
    var i = (energy < 2) ? 2 : energy;

    return i + (numberTargets / 2.0).ceil();
  }
}

// class ModifierDetail {}

// class AfflictionDetail extends ModifierDetail {}

// class BestowsABonus extends RitualModifier {
//   const BestowsABonus() : super('Bestows a Bonus');

//   static const variations = <String>['Broad', 'Moderate', 'Narrow'];

//   @override
//   bool validVariation(String variation) => variations.contains(variation);
// }
