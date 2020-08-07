import 'package:meta/meta.dart';

import 'ritual_modifier.dart';

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

  /// the current value of this modifier - depends on the modifier, it could
  /// represent character points, a time unit, distance unit, a percentage
  /// modifier, etc.
  int get value;

  // final int defaultLevel;

  // ModifierDetail get specialization => null;

  // @override
  // String toString() => name;

  // static const affliction = RitualModifier('Affliction');
  // static const alteredTrait = RitualModifier('Altered Traits');
  // static const areaOfEffect = RitualModifier('Area of Effect', defaultLevel: 1);
  // static const bestowsBonus = const BestowsABonus();
  // static const bestowsPenalty = RitualModifier('Bestows a Penalty');
  // static const damage = RitualModifier('Damage');
  // static const duration = RitualModifier('Duration');
  // static const extraEnergy = RitualModifier('Extra Energy');
  // static const healing = RitualModifier('Healing');
  // static const metaMagic = RitualModifier('Meta-Magic');
  // static const range = RitualModifier('Range');
  // static const speed = RitualModifier('Speed');
  // static const subjectWeight = RitualModifier('Subject Weight');
  // static const traditionalTrappings = RitualModifier('Traditional Trappings');

  // static Map<String, RitualModifier> _values = {
  //   affliction.name: affliction,
  //   alteredTrait.name: alteredTrait,
  //   areaOfEffect.name: areaOfEffect,
  //   bestowsBonus.name: bestowsBonus,
  //   bestowsPenalty.name: bestowsPenalty,
  //   damage.name: damage,
  //   duration.name: duration,
  //   extraEnergy.name: extraEnergy,
  //   healing.name: healing,
  //   metaMagic.name: metaMagic,
  //   range.name: range,
  //   speed.name: speed,
  //   subjectWeight.name: subjectWeight,
  //   traditionalTrappings.name: traditionalTrappings,
  // };

  // static RitualModifier fromString(String name) => _values[name];
  // static Iterable<String> labels = _values.keys;

  // bool isValidLevel(int level) {
  //   return level == defaultLevel;
  // }

  // bool validVariation(String variation) {
  //   return false;
  // }
}

class AfflictionStun extends RitualModifier {
  AfflictionStun({bool inherent: false})
      : super("Affliction, Stunning", inherent: inherent);

  @override
  int get energyCost => 0;

  @override
  int get value => 0;
}

// class ModifierDetail {}

// class AfflictionDetail extends ModifierDetail {}

// class BestowsABonus extends RitualModifier {
//   const BestowsABonus() : super('Bestows a Bonus');

//   static const variations = <String>['Broad', 'Moderate', 'Narrow'];

//   @override
//   bool validVariation(String variation) => variations.contains(variation);
// }
