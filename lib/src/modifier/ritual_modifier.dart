import 'dart:math';

import 'package:gurps_dart/gurps_dart.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../trait.dart';

/// Describes a modifier to an Ritual.
///
/// Modifiers add Damage, Range, GDuration, and other features to a ritual,
/// and the energy cost of the spell is adjusted by the value of the modifiers.
/// Modifiers are identified by their name, and can be inherent (intrisic) or
/// not.
///
/// For example, a spell might momentarily open a Gate between dimensions; a
/// GDuration modifier can be added to make the Gate remain for a longer
/// time. The GDuration is not inherent or intrinsic in this case.
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

  /// Adjust the 'level' of this modifier. The meaning of level depends on the
  /// modifier. E.g., +1 level to AreaOfEffect increases the radius to the next
  /// Linear Measurement on the Size and Speed/Range table; +1 to an Affliction
  /// gives another +5% to the value of the enhancement, etc.
  RitualModifier incrementEffect(int value);
}

/// SizeAndSpeedRange Table for use by modifiers
final _sizeSpeedRangeTable = const SizeAndSpeedRangeTable();

/// Any ritual that adds, removes or modifies advantages or disadvantages, or
/// increases or lowers attributes or characteristics.
class AlteredTraits extends RitualModifier {
  const AlteredTraits(this.trait,
      {bool inherent = false, List<TraitModifier> modifiers})
      : _modifiers = modifiers ?? const [],
        super('Altered Traits', inherent: inherent);

  AlteredTraits copyWith({Trait trait, bool inherent}) => AlteredTraits(
        trait ?? this.trait,
        inherent: inherent ?? this.inherent,
        modifiers: this._modifiers,
      );

  AlteredTraits addModifier(TraitModifier traitModifier) =>
      AlteredTraits(this.trait,
          inherent: this.inherent,
          modifiers: [...this._modifiers, traitModifier]);

  @override
  AlteredTraits incrementEffect(int value) {
    int energy = energyCost + value;
    Trait t = Trait(
        name: 'undefined',
        baseCost: (characterPoints.isNegative) ? -5 * energy : energy,
        hasLevels: false);

    return AlteredTraits(t, inherent: this.inherent);
  }

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

  @override
  int get hashCode => hash3(trait, _modifiers, inherent);

  @override
  bool operator ==(Object other) {
    return other is AlteredTraits &&
        trait == other.trait &&
        _modifiers == other._modifiers &&
        inherent == other.inherent;
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

  AreaOfEffect copyWith(
      {int radius, int numberTargets, bool excludes, bool inherent}) {
    return AreaOfEffect(
      inherent: inherent ?? this.inherent,
      radius: radius ?? this.radius,
      numberTargets: numberTargets ?? this.numberTargets,
      excludes: excludes ?? this.excludes,
    );
  }

  @override
  AreaOfEffect incrementEffect(int value) => AreaOfEffect(
      radius: radius + value,
      numberTargets: this.numberTargets,
      excludes: this.excludes,
      inherent: this.inherent);

  final int radius;

  final int numberTargets;

  final bool excludes;

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
    var energy = _sizeSpeedRangeTable.sizeForLinearMeasurement(radius) * 2;
    var i = (energy < 2) ? 2 : energy;

    return i + (numberTargets / 2.0).ceil();
  }

  @override
  int get hashCode => hash4(radius, numberTargets, excludes, inherent);

  @override
  bool operator ==(Object other) {
    return other is AreaOfEffect &&
        other.radius == radius &&
        other.numberTargets == numberTargets &&
        other.excludes == excludes &&
        other.inherent == inherent;
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

  Bestows copyWith({int value, bool inherent, BestowsRange range}) =>
      Bestows(this.roll,
          value: value ?? this.value,
          inherent: inherent ?? this.inherent,
          range: range ?? this.range);

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

  @override
  Bestows incrementEffect(int value) => Bestows(this.roll,
      value: this.value + value, inherent: this.inherent, range: this.range);

  @override
  int get hashCode => hash4(inherent, range, roll, value);

  @override
  bool operator ==(Object other) =>
      other is Bestows &&
      other.inherent == inherent &&
      other.range == range &&
      other.roll == roll &&
      other.value == value;
}

class DurationModifier extends RitualModifier {
  const DurationModifier(
      {GDuration duration: GDuration.momentary, bool inherent: false})
      : duration = duration ?? GDuration.momentary,
        super('Duration', inherent: inherent ?? false);

  DurationModifier copyWith({GDuration duration, bool inherent}) {
    return DurationModifier(
        duration: duration ?? this.duration,
        inherent: inherent ?? this.inherent);
  }

  static List<GDuration> _durationTable = [
    GDuration.momentary,
    GDuration(minutes: 10),
    GDuration(minutes: 30),
    GDuration(hours: 1),
    GDuration(hours: 3),
    GDuration(hours: 6),
    GDuration(hours: 12),
    GDuration(days: 1),
    GDuration(days: 3),
    GDuration(weeks: 1),
    GDuration(weeks: 2),
    ...List<GDuration>.generate(
        12, (int index) => GDuration(months: index + 1)),
  ];

  final GDuration duration;

  @override
  int get energyCost {
    int index = _durationTableIndex(duration);
    return (index != -1) ? index : _years + 21;
  }

  int get _years => (duration.inSeconds / GDuration.secondsPerYear).ceil();

  int _durationTableIndex(GDuration duration) =>
      _durationTable.indexWhere((element) => element >= duration);

  @override
  DurationModifier incrementEffect(int value) {
    int oldIndex = (duration > _durationTable.last)
        ? _years + 21
        : _durationTableIndex(duration);

    int newIndex = (oldIndex + value < 0) ? 0 : oldIndex + value;

    GDuration dur = (newIndex <= _durationTable.length)
        ? _durationTable[newIndex]
        : GDuration(years: newIndex - 21);

    return DurationModifier(duration: dur, inherent: this.inherent);
  }

  @override
  int get hashCode => hash2(duration, inherent);

  @override
  bool operator ==(Object other) {
    return other is DurationModifier &&
        other.duration == duration &&
        other.inherent == inherent;
  }
}

abstract class _EnergyPoolModifier extends RitualModifier {
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

  ExtraEnergy copyWith({int energy, bool inherent}) => ExtraEnergy(
      energy: energy ?? this.energy, inherent: inherent ?? this.inherent);

  @override
  ExtraEnergy incrementEffect(int value) =>
      ExtraEnergy(energy: this.energy + value, inherent: this.inherent);

  @override
  int get hashCode => hash2(energy, inherent);

  @override
  bool operator ==(Object other) {
    return other is ExtraEnergy &&
        other.energy == energy &&
        other.inherent == inherent;
  }
}

enum HealingType { hp, fp }

class Healing extends RitualModifier {
  const Healing({HealingType type, DieRoll dice, bool inherent})
      : type = type ?? HealingType.hp,
        dice = dice ?? const DieRoll(1, 0),
        super('Healing', inherent: inherent);

  Healing copyWith({HealingType type, DieRoll dice, bool inherent}) => Healing(
      type: type ?? this.type,
      dice: dice ?? this.dice,
      inherent: inherent ?? this.inherent);

  final DieRoll dice;

  final HealingType type;

  @override
  int get energyCost => DieRoll.denormalize(dice);

  @override
  Healing incrementEffect(int value) => Healing(
      dice: this.dice + value, type: this.type, inherent: this.inherent);

  @override
  int get hashCode => hash3(dice, type, inherent);

  @override
  bool operator ==(Object other) {
    return other is Healing &&
        other.dice == dice &&
        other.inherent == inherent &&
        other.type == type;
  }
}

class MetaMagic extends _EnergyPoolModifier {
  const MetaMagic({int energy: 0, bool inherent = false})
      : super('Meta-Magic', energy: energy, inherent: inherent);

  MetaMagic copyWith({int energy, bool inherent}) => MetaMagic(
      energy: energy ?? this.energy, inherent: inherent ?? this.inherent);

  @override
  MetaMagic incrementEffect(int value) =>
      MetaMagic(energy: this.energy + value, inherent: this.inherent);

  @override
  int get hashCode => hash2(energy, inherent);

  @override
  bool operator ==(Object other) {
    return other is MetaMagic &&
        other.energy == energy &&
        other.inherent == inherent;
  }
}

class Speed extends RitualModifier {
  const Speed({GDistance yardsPerSecond, bool inherent})
      : _yardsPerSecond = yardsPerSecond ?? const GDistance(yards: 0),
        super('Speed', inherent: inherent ?? false);

  Speed copyWith({GDistance yardsPerSecond, bool inherent}) => Speed(
      yardsPerSecond: yardsPerSecond ?? this._yardsPerSecond,
      inherent: inherent ?? this.inherent);

  final GDistance _yardsPerSecond;

  GDistance get yardsPerSecond => _sizeSpeedRangeTable
      .linearMeasureFor(_sizeSpeedRangeTable.sizeFor(_yardsPerSecond));

  @override
  int get energyCost => _sizeSpeedRangeTable.sizeFor(_yardsPerSecond);

  @override
  Speed incrementEffect(int value) {
    int size = _sizeSpeedRangeTable.sizeFor(_yardsPerSecond) + value;
    GDistance speed =
        _sizeSpeedRangeTable.linearMeasureFor((size < 0) ? 0 : size);

    return Speed(yardsPerSecond: speed, inherent: this.inherent);
  }

  @override
  int get hashCode => hash2(_yardsPerSecond, inherent);

  @override
  bool operator ==(Object other) {
    return other is Speed &&
        other._yardsPerSecond == _yardsPerSecond &&
        other.inherent == inherent;
  }
}

class SubjectWeight extends RitualModifier {
  const SubjectWeight({GWeight weight, bool inherent = false})
      : _weight = weight ?? const GWeight(pounds: 10),
        super('Subject GWeight', inherent: inherent ?? false);

  SubjectWeight copyWith({GWeight weight, bool inherent}) => SubjectWeight(
      weight: weight ?? this._weight, inherent: inherent ?? this.inherent);

  final GWeight _weight;

  GWeight get weight => GWeight(pounds: _sequence.ceil(_weight.inPounds));

  @override
  int get energyCost => _sequence.valueToIndex(_weight.inPounds);

  static RepeatingSequenceConverter _sequence =
      new RepeatingSequenceConverter([10, 30]);

  @override
  SubjectWeight incrementEffect(int value) {
    int index = _sequence.valueToIndex(_weight.inPounds) + value;
    int pounds = _sequence.indexToValue(index);
    GWeight weight = GWeight(pounds: pounds);
    return SubjectWeight(weight: weight, inherent: this.inherent);
  }

  @override
  int get hashCode => hash2(_weight, inherent);

  @override
  bool operator ==(Object other) {
    return other is SubjectWeight &&
        other._weight == _weight &&
        other.inherent == inherent;
  }
}
