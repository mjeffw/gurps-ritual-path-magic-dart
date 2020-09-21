import 'package:gurps_dart/gurps_dart.dart';
import 'package:quiver/core.dart';

import 'ritual_modifier.dart';

class Range extends RitualModifier {
  const Range({GDistance distance, bool inherent})
      : distance = distance ?? const GDistance(yards: 2),
        super('Range', inherent: inherent);

  Range copyWith({GDistance distance, bool inherent}) => Range(
      distance: distance ?? this.distance, inherent: inherent ?? this.inherent);

  final GDistance distance;

  static SizeAndSpeedRangeTable _table = SizeAndSpeedRangeTable();

  @override
  int get energyCost => _table.sizeFor(distance);

  @override
  Range incrementEffect(int value) {
    int size = _table.sizeFor(distance);
    GDistance d = _table.linearMeasureFor(size + value);
    return Range(distance: d, inherent: this.inherent);
  }

  @override
  int get hashCode => hash2(distance, inherent);

  @override
  bool operator ==(Object other) {
    return other is Range &&
        other.distance == distance &&
        other.inherent == inherent;
  }
}

// used by both RangeInfo and RangeCrossTime
const _table = RepeatingSequenceConverter([1, 3]);

class RangeInfo extends RitualModifier {
  const RangeInfo({GDistance distance, bool inherent})
      : distance = distance ?? const GDistance(yards: 200),
        super('Range, Informational', inherent: inherent ?? false);

  RangeInfo copyWith({GDistance distance, bool inherent}) => RangeInfo(
      distance: distance ?? this.distance, inherent: inherent ?? this.inherent);

  final GDistance distance;

  @override
  int get energyCost {
    if (distance <= GDistance(yards: 200)) return 0;
    if (distance <= GDistance(yards: 1000)) return 1;
    return _table
            .valueToIndex((distance.inYards / GDistance.yardsPerMile).ceil()) +
        2;
  }

  @override
  RangeInfo incrementEffect(int value) {
    int newIndex = energyCost + value;

    GDistance d = (newIndex <= 0)
        ? GDistance(yards: 200)
        : (newIndex == 1)
            ? GDistance(yards: 1000)
            : GDistance(miles: _table.indexToValue(newIndex - 2));

    return RangeInfo(distance: d, inherent: this.inherent);
  }

  @override
  int get hashCode => hash2(distance, inherent);

  @override
  bool operator ==(Object other) {
    return other is RangeInfo &&
        other.distance == distance &&
        other.inherent == inherent;
  }
}

class RangeCrossTime extends RitualModifier {
  const RangeCrossTime(
      {GDuration duration = const GDuration(hours: 2), bool inherent = false})
      : duration = duration ?? const GDuration(hours: 2),
        super('Range, Cross-Time', inherent: inherent ?? false);

  RangeCrossTime copyWith({GDuration duration, bool inherent}) =>
      RangeCrossTime(
          duration: duration ?? this.duration,
          inherent: inherent ?? this.inherent);

  final GDuration duration;

  @override
  int get energyCost {
    if (duration <= GDuration(hours: 2)) return 0;
    if (duration <= GDuration(hours: 12)) return 1;
    return _table.valueToIndex((duration.inHours / 24).ceil()) + 2;
  }

  @override
  RangeCrossTime incrementEffect(int value) {
    int newIndex = energyCost + value;

    int hours = (newIndex == 0)
        ? 2
        : (newIndex == 1) ? 12 : _table.indexToValue(newIndex - 2) * 24;

    return RangeCrossTime(
        duration: GDuration(hours: hours), inherent: this.inherent);
  }

  @override
  int get hashCode => hash2(duration, inherent);

  @override
  bool operator ==(Object other) {
    return other is RangeCrossTime &&
        other.duration == duration &&
        other.inherent == inherent;
  }
}

class RangeDimensional extends RitualModifier {
  const RangeDimensional({int numberDimensions = 0, bool inherent = false})
      : numberDimensions = numberDimensions ?? 0,
        super('Range, Extradimensional', inherent: inherent ?? false);

  RangeDimensional copyWith({int numberDimensions, bool inherent}) =>
      RangeDimensional(
          numberDimensions: numberDimensions ?? this.numberDimensions,
          inherent: inherent ?? this.inherent);

  final int numberDimensions;

  @override
  int get energyCost => 10 * numberDimensions;

  @override
  RangeDimensional incrementEffect(int value) => new RangeDimensional(
      numberDimensions: this.numberDimensions + value, inherent: this.inherent);

  @override
  int get hashCode => hash2(numberDimensions, inherent);

  @override
  bool operator ==(Object other) {
    return other is RangeDimensional &&
        other.numberDimensions == numberDimensions &&
        other.inherent == inherent;
  }
}
