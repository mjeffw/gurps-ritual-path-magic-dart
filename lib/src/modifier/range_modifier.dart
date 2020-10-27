import 'package:gurps_dart/gurps_dart.dart';

import 'ritual_modifier.dart';

class Range extends RitualModifier {
  const Range({GDistance distance})
      : distance = distance ?? const GDistance(yards: 2),
        super(Range.label);

  static const String label = 'Range';

  Range copyWith({GDistance distance}) =>
      Range(distance: distance ?? this.distance);

  final GDistance distance;

  static SizeAndSpeedRangeTable _table = SizeAndSpeedRangeTable();

  @override
  int get energyCost => _table.sizeFor(distance);

  @override
  Range incrementEffect(int value) {
    int size = _table.sizeFor(distance);
    GDistance d =
        _table.linearMeasureFor((size + value < 0) ? 0 : size + value);
    return Range(distance: d);
  }

  @override
  String toStringDetailed() {
    return 'Range, $distance ($energyCost)';
  }

  @override
  int get hashCode => distance.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Range && other.distance == distance;
}

// used by both RangeInfo and RangeCrossTime
const _table = RepeatingSequenceConverter([1, 3]);

class RangeInfo extends RitualModifier {
  const RangeInfo({GDistance distance})
      : distance = distance ?? const GDistance(yards: 200),
        super(RangeInfo.label);

  static const String label = 'Range, Information';

  RangeInfo copyWith({GDistance distance}) =>
      RangeInfo(distance: distance ?? this.distance);

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

    return RangeInfo(distance: d);
  }

  @override
  int get hashCode => distance.hashCode;

  @override
  bool operator ==(Object other) =>
      other is RangeInfo && other.distance == distance;
}

class RangeCrossTime extends RitualModifier {
  const RangeCrossTime({GDuration duration = const GDuration(hours: 2)})
      : duration = duration ?? const GDuration(hours: 2),
        super(RangeCrossTime.label);

  static const String label = 'Range, Cross-Time';

  RangeCrossTime copyWith({GDuration duration}) =>
      RangeCrossTime(duration: duration ?? this.duration);

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

    return RangeCrossTime(duration: GDuration(hours: hours));
  }

  String effectToString() {
    if (duration.inHours <= 2) return '2 hours';
    if (duration.inHours < 24) return '${duration.inHours} hours';
    return '${duration.inDays} days';
  }

  @override
  int get hashCode => duration.hashCode;

  @override
  bool operator ==(Object other) {
    return other is RangeCrossTime && other.duration == duration;
  }
}

class RangeDimensional extends RitualModifier {
  const RangeDimensional({int numberDimensions = 0})
      : numberDimensions = numberDimensions ?? 0,
        super(RangeDimensional.label);

  static const String label = 'Range, Extradimensional';

  final int numberDimensions;

  @override
  int get energyCost => 10 * numberDimensions;

  @override
  RangeDimensional incrementEffect(int value) =>
      new RangeDimensional(numberDimensions: this.numberDimensions + value);

  @override
  int get hashCode => numberDimensions.hashCode;

  @override
  bool operator ==(Object other) =>
      other is RangeDimensional && other.numberDimensions == numberDimensions;
}
