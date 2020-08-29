import 'dart:math';

import 'package:gurps_dart/gurps_dart.dart';
import 'package:meta/meta.dart';

import '../trait.dart';

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
  const RitualModifier(this.name, {bool inherent})
      : inherent = inherent ?? false;

  /// the name of this Modifier
  final String name;

  /// is this Modifier instance inherent to the spell?
  final bool inherent;

  /// the energy cost of the modifier
  int get energyCost;
}

/// Any ritual that adds, removes or modifies advantages or disadvantages, or
/// increases or lowers attributes or characteristics.
class AlteredTraits extends RitualModifier {
  const AlteredTraits(this.trait,
      {bool inherent = false, List<TraitModifier> modifiers})
      : _modifiers = modifiers ?? const [],
        super('Altered Traits', inherent: inherent);

  factory AlteredTraits.copyWith(AlteredTraits src,
          {Trait trait, bool inherent}) =>
      AlteredTraits(
        trait ?? src.trait,
        inherent: inherent ?? src.inherent,
        modifiers: src._modifiers,
      );

  factory AlteredTraits.addModifier(
          AlteredTraits m, TraitModifier traitModifier) =>
      AlteredTraits(m.trait,
          inherent: m.inherent, modifiers: [...m._modifiers, traitModifier]);

  final Trait trait;

  final List<TraitModifier> _modifiers;

  @override
  int get energyCost => (_baseEnergy * _modifierMultiplier).ceil();

  int get characterPoints => trait.totalCost;

  /// GURPS rpm.16: Any spell that adds or worsens disadvantages, reduces or
  /// removes advantages, or lowers attributes or characteristics adds +1 energy
  /// for every 5 character points removed.
  ///
  /// GURPS rpm.17: One that adds or improves advantages, reduces or removes
  /// disadvantages, or increases attributes or characteristics adds +1 energy
  /// for every 1 character point added.
  int get _baseEnergy => (characterPoints.isNegative)
      ? (characterPoints.abs() / 5.0).ceil()
      : characterPoints;

  double get _modifierMultiplier {
    double x =
        _modifiers.map((i) => i.percent / 100.0).fold(0.0, (a, b) => a + b);

    return 1 + x;
  }
}

/// Adds an Area of Effect, optionally including or excluding specific targets
/// in the area, to the spell.
///
/// Figure the circular area and add 10 SP per yard of radius from its center.
/// Excluding potential targets is possible – add another +1 SP for every two
/// specific subjects in the area that won’t be affected by the spell.
///
/// Alternatively, you may exclude everyone in the area, but then include
/// willing potential targets for +1 SP per two specific subjects.
class AreaOfEffect extends RitualModifier {
  const AreaOfEffect(
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

  final _table = const SizeAndSpeedRangeTable();

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

/// Range of rolls affected by a Bestows modifier.
enum BestowsRange { narrow, moderate, broad }

typedef int EnergyFunction(int value);

/// Use Bestows to determine the energy cost of bonuses or penalties, based on
/// whether the ritual will add a modifier to a broad range of rolls (e.g.,
/// active defense rolls, Sense rolls, or a wildcard skill), a moderate range
/// (e.g., rolls to hide or Vision rolls), or a narrow range (e.g., Climbing
/// rolls or social rolls affecting a specific person).
class Bestows extends RitualModifier {
  const Bestows(this.roll,
      {BestowsRange range: BestowsRange.narrow,
      int value: 0,
      bool inherent: false})
      : range = range ?? BestowsRange.narrow,
        value = value ?? 0,
        super('Bestows a (Bonus or Penalty)', inherent: inherent ?? false);

  factory Bestows.copyWith(Bestows src,
      {int value, bool inherent, BestowsRange range}) {
    return Bestows(src.roll,
        value: value ?? src.value,
        inherent: inherent ?? src.inherent,
        range: range ?? src.range);
  }

  /// Name of range of traits being modified,
  final String roll;

  /// Bonus or penalty value applied to the traits.
  final int value;

  /// "Range" of the bonus/penalty (or, how many traits are effected).
  final BestowsRange range;

  static Map<BestowsRange, EnergyFunction> _rangeEnergy = {
    BestowsRange.narrow: _narrowCost,
    BestowsRange.moderate: _moderateCost,
    BestowsRange.broad: _broadCost,
  };

  static int _narrowCost(int v) => pow(2, v.abs() - 1).toInt();
  static int _moderateCost(int x) => pow(2, x.abs()).toInt();
  static int _broadCost(int x) => _narrowCost(x) * 5;

  @override
  int get energyCost => value == 0 ? 0 : _rangeEnergy[range](value);
}

class DurationModifier extends RitualModifier {
  const DurationModifier(
      {GurpsDuration duration: GurpsDuration.momentary, bool inherent: false})
      : duration = duration ?? GurpsDuration.momentary,
        super('Duration', inherent: inherent ?? false);

  factory DurationModifier.copyWith(DurationModifier src,
      {GurpsDuration duration, bool inherent}) {
    return DurationModifier(
        duration: duration ?? src.duration, inherent: inherent ?? src.inherent);
  }

  static List<GurpsDuration> array = [
    GurpsDuration.momentary,
    const GurpsDuration(minutes: 10),
    const GurpsDuration(minutes: 30),
    const GurpsDuration(hours: 1),
    const GurpsDuration(hours: 3),
    const GurpsDuration(hours: 6),
    const GurpsDuration(hours: 12),
    const GurpsDuration(days: 1),
    const GurpsDuration(days: 3),
    const GurpsDuration(weeks: 1),
    const GurpsDuration(weeks: 2),
    const GurpsDuration(months: 1),
  ];

  final GurpsDuration duration;

  @override
  int get energyCost {
    int index = _indexOfLeastElementNoSmallerThan(duration, array);
    if (index != null) return index;

    index = _indexOfLeastElementNoSmallerThan(duration,
        Iterable.generate(10, (index) => GurpsDuration(months: index + 2)));
    if (index != null) return 12 + index;

    int years = (duration.inSeconds / GurpsDuration.secondsPerYear).ceil();

    return years + 21;
  }

  int _indexOfLeastElementNoSmallerThan(
      GurpsDuration duration, Iterable<GurpsDuration> list) {
    var temp = 0;
    for (var d in list) {
      if (duration == d) return temp;
      if (d < duration) temp++;
      if (d > duration) return temp - 1;
    }
    return null;
  }
}

class _EnergyPoolModifier extends RitualModifier {
  const _EnergyPoolModifier(String name, {int energy: 0, bool inherent = false})
      : energy = energy ?? 0,
        super(name, inherent: inherent);

  final int energy;

  @override
  int get energyCost => energy;
}

class ExtraEnergy extends _EnergyPoolModifier {
  const ExtraEnergy({int energy: 0, bool inherent = false})
      : super('Extra Energy', energy: energy, inherent: inherent);

  factory ExtraEnergy.copyWith(ExtraEnergy src, {int energy, bool inherent}) {
    return ExtraEnergy(
        energy: energy ?? src.energy, inherent: inherent ?? src.inherent);
  }
}

enum HealingType { hp, fp }

class Healing extends RitualModifier {
  const Healing({HealingType type, DieRoll dice, bool inherent})
      : type = type ?? HealingType.hp,
        dice = dice ?? const DieRoll(1, 0),
        super('Healing', inherent: inherent);

  factory Healing.copyWith(Healing src,
      {HealingType type, DieRoll dice, bool inherent}) {
    return Healing(
        type: type ?? src.type,
        dice: dice ?? src.dice,
        inherent: inherent ?? src.inherent);
  }

  final DieRoll dice;

  final HealingType type;

  @override
  int get energyCost => DieRoll.denormalize(dice);
}

class MetaMagic extends _EnergyPoolModifier {
  const MetaMagic({int energy: 0, bool inherent = false})
      : super('Meta-Magic', energy: energy, inherent: inherent);

  factory MetaMagic.copyWith(MetaMagic src, {int energy, bool inherent}) {
    return MetaMagic(
        energy: energy ?? src.energy, inherent: inherent ?? src.inherent);
  }
}
