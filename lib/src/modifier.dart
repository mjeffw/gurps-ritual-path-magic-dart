import 'package:meta/meta.dart';

/// Modifiers add specific traits to a given ritual; for example, adding duration or range or area of effect, or the
/// ability to effect larger targets, etc.
@immutable
class Modifier {
  const Modifier(this.name, {this.defaultLevel: 0});

  final String name;
  final int defaultLevel;

  ModifierDetail get specialization => null;

  @override
  String toString() => name;

  static const affliction = Modifier('Affliction');
  static const alteredTrait = Modifier('Altered Traits');
  static const areaOfEffect = Modifier('Area of Effect', defaultLevel: 1);
  static const bestowsBonus = const BestowsABonus();
  static const bestowsPenalty = Modifier('Bestows a Penalty');
  static const damage = Modifier('Damage');
  static const duration = Modifier('Duration');
  static const extraEnergy = Modifier('Extra Energy');
  static const healing = Modifier('Healing');
  static const metaMagic = Modifier('Meta-Magic');
  static const range = Modifier('Range');
  static const speed = Modifier('Speed');
  static const subjectWeight = Modifier('Subject Weight');
  static const traditionalTrappings = Modifier('Traditional Trappings');

  static Map<String, Modifier> _values = {
    affliction.name: affliction,
    alteredTrait.name: alteredTrait,
    areaOfEffect.name: areaOfEffect,
    bestowsBonus.name: bestowsBonus,
    bestowsPenalty.name: bestowsPenalty,
    damage.name: damage,
    duration.name: duration,
    extraEnergy.name: extraEnergy,
    healing.name: healing,
    metaMagic.name: metaMagic,
    range.name: range,
    speed.name: speed,
    subjectWeight.name: subjectWeight,
    traditionalTrappings.name: traditionalTrappings,
  };

  static Modifier fromString(String name) => _values[name];
  static Iterable<String> labels = _values.keys;

  bool isValidLevel(int level) {
    return level == defaultLevel;
  }

  bool validVariation(String variation) {
    return false;
  }
}

class ModifierDetail {}

class AfflictionDetail extends ModifierDetail {}

class BestowsABonus extends Modifier {
  const BestowsABonus() : super('Bestows a Bonus');

  static const variations = <String>['Broad', 'Moderate', 'Narrow'];

  @override
  bool validVariation(String variation) => variations.contains(variation);
}
