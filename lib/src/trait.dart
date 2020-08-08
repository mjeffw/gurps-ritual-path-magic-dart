import 'package:meta/meta.dart';

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
  Trait(
      {String name: '',
      int baseCost: 0,
      int costPerLevel: 0,
      int levels: 0,
      bool hasLevels: false})
      : this.name = name,
        this.baseCost = baseCost,
        this.costPerLevel = costPerLevel,
        this.levels = levels,
        this.hasLevels = hasLevels;

  final String name;
  final int baseCost;
  final int costPerLevel;
  final int levels;
  final bool hasLevels;

  int get totalCost => baseCost + (costPerLevel * levels);
}