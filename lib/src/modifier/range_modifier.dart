import 'package:gurps_dart/gurps_dart.dart';

import 'ritual_modifier.dart';

class Range extends RitualModifier {
  const Range({GurpsDistance distance, bool inherent})
      : distance = distance ?? const GurpsDistance(yards: 2),
        super('Range', inherent: inherent);

  factory Range.copyWith(Range src, {GurpsDistance distance, bool inherent}) {
    return Range(
        distance: distance ?? src.distance, inherent: inherent ?? src.inherent);
  }

  final GurpsDistance distance;

  static SizeAndSpeedRangeTable _table = SizeAndSpeedRangeTable();

  @override
  int get energyCost => _table.sizeForLinearMeasurement(distance.inYards);
}

class RangeInformational extends RitualModifier {
  const RangeInformational() : super('Range, Informational');

  final GurpsDistance distance = const GurpsDistance(yards: 200);

  @override
  // TODO: implement energyCost
  int get energyCost => 0;
}
