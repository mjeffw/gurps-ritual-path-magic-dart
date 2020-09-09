import 'package:gurps_dart/gurps_dart.dart';

import 'ritual_modifier.dart';

class Range extends RitualModifier {
  const Range({GDistance distance, bool inherent})
      : distance = distance ?? const GDistance(yards: 2),
        super('Range', inherent: inherent);

  factory Range.copyWith(Range src, {GDistance distance, bool inherent}) {
    return Range(
        distance: distance ?? src.distance, inherent: inherent ?? src.inherent);
  }

  final GDistance distance;

  static SizeAndSpeedRangeTable _table = SizeAndSpeedRangeTable();

  @override
  int get energyCost => _table.sizeForLinearMeasurement(distance.inYards);
}

class RangeInfo extends RitualModifier {
  const RangeInfo({GDistance distance, bool inherent})
      : distance = distance ?? const GDistance(yards: 200),
        super('Range, Informational', inherent: inherent ?? false);

  factory RangeInfo.copyWith(RangeInfo src,
      {GDistance distance, bool inherent}) {
    return RangeInfo(
        distance: distance ?? src.distance, inherent: inherent ?? src.inherent);
  }

  final GDistance distance;

  @override
  // TODO: implement energyCost
  int get energyCost {
    if (distance <= GDistance(yards: 200)) return 0;
    if (distance <= GDistance(yards: 1000)) return 1;
    return _table.valueToOrdinal(
            (distance.inYards / GDistance.yardsPerMile).ceil()) +
        2;
  }
}

// used by both RangeInfo and RangeCrossTime
const _table = RepeatingSequenceConverter([1, 3]);

class RangeCrossTime extends RitualModifier {
  const RangeCrossTime(
      {GDuration duration = const GDuration(hours: 2), bool inherent = false})
      : duration = duration ?? const GDuration(hours: 2),
        super('Range, Cross-Time', inherent: inherent ?? false);

  factory RangeCrossTime.copyWith(RangeCrossTime src,
      {GDuration duration, bool inherent}) {
    return RangeCrossTime(
        duration: duration ?? src.duration, inherent: inherent ?? src.inherent);
  }

  final GDuration duration;

  @override
  int get energyCost {
    if (duration <= GDuration(hours: 2)) return 0;
    if (duration <= GDuration(hours: 12)) return 1;
    return _table.valueToOrdinal((duration.inHours / 24).ceil()) + 2;
  }
}

class RangeDimensional extends RitualModifier {
  RangeDimensional({int numberDimensions = 0, bool inherent = false})
      : numberDimensions = numberDimensions ?? 0,
        super('Range, Extradimensional', inherent: inherent ?? false);

  factory RangeDimensional.copyWith(RangeDimensional src,
      {int numberDimensions, bool inherent}) {
    return RangeDimensional(
        numberDimensions: numberDimensions ?? src.numberDimensions,
        inherent: inherent ?? src.inherent);
  }

  final int numberDimensions;

  @override
  int get energyCost => 10 * numberDimensions;
}
