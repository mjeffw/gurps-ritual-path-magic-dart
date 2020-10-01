import 'dart:math';

import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../trait.dart';
import '../util/list_wrapper.dart';
import 'affliction_modifier.dart';

typedef Constructor = RitualModifier Function();

/// Describes a modifier to an Ritual.
///
/// Modifiers add Damage, Range, GDuration, and other features to a ritual,
/// and the energy cost of the spell is adjusted by the value of the modifiers.
/// Modifiers are identified by their name.
@immutable
abstract class RitualModifier {
  const RitualModifier(this.name);

  factory RitualModifier.fromString(String name) {
    switch (name) {
      case AfflictionStun.label:
        return AfflictionStun();
      case Affliction.label:
        return Affliction();
      case AlteredTraits.label:
        return AlteredTraits(Trait(name: 'Undefined'));
      case AreaOfEffect.label:
        return AreaOfEffect();
      case Bestows.label:
        return Bestows('Undefined');
    }
    return null;
  }

  static final List<String> labels = [
    AfflictionStun.label,
    Affliction.label,
    AlteredTraits.label,
    AreaOfEffect.label,
    Bestows.label,
  ];

  /// the name of this Modifier
  final String name;

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
  const AlteredTraits(this.trait, {List<TraitModifier> modifiers})
      : _modifiers = modifiers ?? const [],
        super(AlteredTraits.label);

  AlteredTraits copyWith({Trait trait}) =>
      AlteredTraits(trait ?? this.trait, modifiers: this._modifiers);

  AlteredTraits addModifier(TraitModifier traitModifier) =>
      AlteredTraits(this.trait, modifiers: [...this._modifiers, traitModifier]);

  @override
  AlteredTraits incrementEffect(int value) {
    if (trait.hasLevels) {
      return AlteredTraits(Trait(
          baseCost: trait.baseCost,
          costPerLevel: trait.costPerLevel,
          hasLevels: true,
          levels: (trait.levels + value < 0) ? 0 : trait.levels + value,
          name: trait.name));
    } else {
      int numberOfSteps = value.abs();
      int sign = (value >= 0) ? 1 : -1;
      int oldValue = trait.baseCost;
      for (var i = 0; i < numberOfSteps; i++) {
        if (oldValue < 1) {
          if (sign.isNegative) {
            oldValue += -5;
          } else {
            oldValue = (oldValue == 0) ? oldValue + 1 : min(0, oldValue + 5);
          }
        } else {
          oldValue += sign;
        }
      }

      return AlteredTraits(
          Trait(baseCost: oldValue, hasLevels: false, name: trait.name));
    }
  }

  static const String label = 'Altered Trait';

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
  int get hashCode => hash2(trait, ListWrapper(_modifiers));

  @override
  bool operator ==(Object other) {
    return other is AlteredTraits &&
        trait == other.trait &&
        ListWrapper(_modifiers).equals(other._modifiers);
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
  const AreaOfEffect({
    int radius: 0,
    int numberTargets: 0,
    bool excludes: true,
  })  : radius = radius ?? 0,
        numberTargets = numberTargets ?? 0,
        excludes = excludes ?? true,
        super(AreaOfEffect.label);

  AreaOfEffect copyWith({int radius, int numberTargets, bool excludes}) {
    return AreaOfEffect(
      radius: radius ?? this.radius,
      numberTargets: numberTargets ?? this.numberTargets,
      excludes: excludes ?? this.excludes,
    );
  }

  static const label = 'Area of Effect';

  @override
  AreaOfEffect incrementEffect(int value) {
    int size = AreaOfEffect.radiusToStep(radius);

    return AreaOfEffect(
        radius:
            (size + value <= 0) ? 0 : AreaOfEffect.stepToRadius(size + value),
        numberTargets: this.numberTargets,
        excludes: this.excludes);
  }

  static int radiusToStep(int radius) {
    return _sizeSpeedRangeTable.sizeForLinearMeasurement(radius);
  }

  static int stepToRadius(int step) {
    return _sizeSpeedRangeTable.linearMeasureForSize(step);
  }

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
    var energy = AreaOfEffect.radiusToStep(radius) * 2;
    var i = (energy < 2) ? 2 : energy;

    return i + (numberTargets / 2.0).ceil();
  }

  @override
  int get hashCode => hash3(radius, numberTargets, excludes);

  @override
  bool operator ==(Object other) {
    return other is AreaOfEffect &&
        other.radius == radius &&
        other.numberTargets == numberTargets &&
        other.excludes == excludes;
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
  const Bestows(
    this.roll, {
    BestowsRange range: BestowsRange.narrow,
    int value: 0,
  })  : range = range ?? BestowsRange.narrow,
        value = value ?? 0,
        super(label);

  Bestows copyWith({int value, BestowsRange range}) => Bestows(this.roll,
      value: value ?? this.value, range: range ?? this.range);

  static const String label = 'Bestows a (Bonus or Penalty)';

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
  Bestows incrementEffect(int value) =>
      Bestows(this.roll, value: this.value + value, range: this.range);

  @override
  int get hashCode => hash3(range, roll, value);

  @override
  bool operator ==(Object other) =>
      other is Bestows &&
      other.range == range &&
      other.roll == roll &&
      other.value == value;
}

class DurationModifier extends RitualModifier {
  const DurationModifier({GDuration duration: GDuration.momentary})
      : duration = duration ?? GDuration.momentary,
        super('Duration');

  DurationModifier copyWith({GDuration duration}) =>
      DurationModifier(duration: duration ?? this.duration);

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

    return DurationModifier(duration: dur);
  }

  @override
  int get hashCode => duration.hashCode;

  @override
  bool operator ==(Object other) =>
      other is DurationModifier && other.duration == duration;
}

abstract class _EnergyPoolModifier extends RitualModifier {
  const _EnergyPoolModifier(String name, {int energy: 0})
      : energy = energy ?? 0,
        super(name);

  final int energy;

  @override
  int get energyCost => energy;
}

class ExtraEnergy extends _EnergyPoolModifier {
  const ExtraEnergy({int energy: 0}) : super('Extra Energy', energy: energy);

  ExtraEnergy copyWith({int energy}) =>
      ExtraEnergy(energy: energy ?? this.energy);

  @override
  ExtraEnergy incrementEffect(int value) =>
      ExtraEnergy(energy: this.energy + value);

  @override
  int get hashCode => energy.hashCode;

  @override
  bool operator ==(Object other) {
    return other is ExtraEnergy && other.energy == energy;
  }
}

enum HealingType { hp, fp }

class Healing extends RitualModifier {
  const Healing({HealingType type, DieRoll dice})
      : type = type ?? HealingType.hp,
        dice = dice ?? const DieRoll(dice: 1, adds: 0),
        super('Healing');

  Healing copyWith({HealingType type, DieRoll dice}) =>
      Healing(type: type ?? this.type, dice: dice ?? this.dice);
  final DieRoll dice;

  final HealingType type;

  @override
  int get energyCost => DieRoll.denormalize(dice);

  @override
  Healing incrementEffect(int value) =>
      Healing(dice: this.dice + value, type: this.type);

  @override
  int get hashCode => hash2(dice, type);

  @override
  bool operator ==(Object other) =>
      other is Healing && other.dice == dice && other.type == type;
}

class MetaMagic extends _EnergyPoolModifier {
  const MetaMagic({int energy: 0}) : super('Meta-Magic', energy: energy);

  MetaMagic copyWith({int energy}) => MetaMagic(energy: energy ?? this.energy);

  @override
  MetaMagic incrementEffect(int value) =>
      MetaMagic(energy: this.energy + value);

  @override
  int get hashCode => energy.hashCode;

  @override
  bool operator ==(Object other) =>
      other is MetaMagic && other.energy == energy;
}

class Speed extends RitualModifier {
  const Speed({GDistance yardsPerSecond})
      : _yardsPerSecond = yardsPerSecond ?? const GDistance(yards: 0),
        super('Speed');

  Speed copyWith({GDistance yardsPerSecond}) =>
      Speed(yardsPerSecond: yardsPerSecond ?? this._yardsPerSecond);

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

    return Speed(yardsPerSecond: speed);
  }

  @override
  int get hashCode => _yardsPerSecond.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Speed && other._yardsPerSecond == _yardsPerSecond;
}

class SubjectWeight extends RitualModifier {
  const SubjectWeight({GWeight weight})
      : _weight = weight ?? const GWeight(pounds: 10),
        super('Subject Weight');

  SubjectWeight copyWith({GWeight weight}) =>
      SubjectWeight(weight: weight ?? this._weight);

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
    return SubjectWeight(weight: weight);
  }

  @override
  int get hashCode => _weight.hashCode;

  @override
  bool operator ==(Object other) =>
      other is SubjectWeight && other._weight == _weight;
}
