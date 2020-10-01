import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

/// A placeholder for a GURPS trait.
///
/// GURPS Traits are anything you spend points on during character creation
/// that are intrinsic to your character, that isn't also an attribute (ST, IQ,
/// DX, HT) or a characteristic (Dmg, BL, HP, FP, Will, Per, etc...)
///
/// Traits can also have Modifiers applied to them.
///
/// Examples are Ads, Disads, Skills, Techniques, and Spells.
@immutable
class Trait {
  const Trait(
      {String name: '',
      int baseCost: 0,
      int costPerLevel: 0,
      int levels: 0,
      bool hasLevels: false})
      : this.name = name,
        this.baseCost = baseCost,
        this._costPerLevel = costPerLevel,
        this._levels = levels,
        this.hasLevels = hasLevels;

  final String name;
  final int baseCost;
  final int _costPerLevel;
  final int _levels;
  final bool hasLevels;

  int get levels => hasLevels ? _levels : 0;
  int get costPerLevel => hasLevels ? _costPerLevel : 0;

  int get totalCost => baseCost + (costPerLevel * levels);

  String get nameLevel => hasLevels ? '$name $levels' : name;

  @override
  int get hashCode =>
      hashObjects(<dynamic>[name, baseCost, costPerLevel, levels, hasLevels]);

  @override
  bool operator ==(Object other) {
    return other is Trait &&
        other.name == name &&
        other.baseCost == baseCost &&
        other.costPerLevel == costPerLevel &&
        other.levels == levels &&
        other.hasLevels == hasLevels;
  }
}
