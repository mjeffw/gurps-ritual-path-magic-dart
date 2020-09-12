import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_ritual_path_magic_model/src/modifier/range_modifier.dart';
import 'package:test/test.dart';

void main() {
  group('Range', () {
    Range m;

    setUp(() async {
      m = Range();
    });

    test('has initial state', () {
      expect(m.inherent, equals(false));
      expect(m.energyCost, equals(0));
      expect(m.name, equals('Range'));
      expect(m.distance, equals(GDistance(yards: 2)));
    });

    test('has inherent', () {
      expect(Range.copyWith(m, inherent: true).inherent, equals(true));
    });

    test('has distance', () {
      expect(Range.copyWith(m, distance: GDistance(yards: 5)).distance,
          equals(GDistance(yards: 5)));
    });

    test('has energy Cost', () {
      var r = Range.copyWith(m, distance: GDistance(yards: 2));
      expect(r.energyCost, equals(0));

      expect(Range.copyWith(m, distance: GDistance(yards: 3)).energyCost,
          equals(1));

      expect(Range.copyWith(m, distance: GDistance(yards: 4)).energyCost,
          equals(2));
      expect(Range.copyWith(m, distance: GDistance(yards: 5)).energyCost,
          equals(2));

      expect(Range.copyWith(m, distance: GDistance(yards: 7)).energyCost,
          equals(3));

      expect(Range.copyWith(m, distance: GDistance(yards: 10)).energyCost,
          equals(4));

      expect(Range.copyWith(m, distance: GDistance(yards: 11)).energyCost,
          equals(5));
      expect(Range.copyWith(m, distance: GDistance(yards: 12)).energyCost,
          equals(5));
      expect(Range.copyWith(m, distance: GDistance(yards: 13)).energyCost,
          equals(5));
      expect(Range.copyWith(m, distance: GDistance(yards: 14)).energyCost,
          equals(5));
      expect(Range.copyWith(m, distance: GDistance(yards: 15)).energyCost,
          equals(5));

      expect(Range.copyWith(m, distance: GDistance(yards: 20)).energyCost,
          equals(6));

      expect(Range.copyWith(m, distance: GDistance(yards: 30)).energyCost,
          equals(7));

      expect(Range.copyWith(m, distance: GDistance(yards: 50)).energyCost,
          equals(8));

      expect(Range.copyWith(m, distance: GDistance(yards: 70)).energyCost,
          equals(9));

      expect(Range.copyWith(m, distance: GDistance(yards: 100)).energyCost,
          equals(10));

      expect(Range.copyWith(m, distance: GDistance(yards: 150)).energyCost,
          equals(11));

      expect(Range.copyWith(m, distance: GDistance(miles: 1)).energyCost,
          equals(18));

      expect(Range.copyWith(m, distance: GDistance(miles: 100)).energyCost,
          equals(30));
    });
  });

  group('Range, Informational', () {
    RangeInfo r;

    setUp(() async {
      r = new RangeInfo();
    });

    test('has initial state', () {
      expect(r.inherent, equals(false));
      expect(r.energyCost, equals(0));
      expect(r.name, equals('Range, Informational'));
      expect(r.distance, equals(GDistance(yards: 200)));
    });

    test('has inherent', () {
      expect(RangeInfo.copyWith(r, inherent: true).inherent, equals(true));
    });

    test('has distance', () {
      var x = RangeInfo.copyWith(r, distance: GDistance(yards: 1000));
      expect(x.distance, equals(GDistance(yards: 1000)));

      x = RangeInfo.copyWith(r, distance: GDistance(miles: 1));
      expect(x.distance, equals(GDistance(miles: 1)));
    });

    test('cost energy', () {
      expect(RangeInfo.copyWith(r, distance: GDistance(yards: 201)).energyCost,
          equals(1));
      expect(RangeInfo.copyWith(r, distance: GDistance(yards: 1001)).energyCost,
          equals(2));
      expect(RangeInfo.copyWith(r, distance: GDistance(miles: 1)).energyCost,
          equals(2));
      expect(
          RangeInfo.copyWith(r, distance: GDistance(miles: 1, yards: 1))
              .energyCost,
          equals(3));
      expect(RangeInfo.copyWith(r, distance: GDistance(miles: 3)).energyCost,
          equals(3));
      expect(RangeInfo.copyWith(r, distance: GDistance(miles: 10)).energyCost,
          equals(4));
      expect(RangeInfo.copyWith(r, distance: GDistance(miles: 30)).energyCost,
          equals(5));
      expect(RangeInfo.copyWith(r, distance: GDistance(miles: 1000)).energyCost,
          equals(8));
      expect(RangeInfo.copyWith(r, distance: GDistance(miles: 3000)).energyCost,
          equals(9));
      expect(
          RangeInfo.copyWith(r, distance: GDistance(miles: 10000)).energyCost,
          equals(10));
    });
  });

  group('Range, Cross-Time:', () {
    RangeCrossTime m;

    setUp(() async {
      m = new RangeCrossTime();
    });

    test('has initial state', () {
      expect(m.inherent, equals(false));
      expect(m.duration, equals(GDuration(hours: 2)));
      expect(m.name, equals('Range, Cross-Time'));
      expect(m.energyCost, equals(0));
    });

    test('has inherent', () {
      // m.inherent = true;
      expect(RangeCrossTime.copyWith(m, inherent: true).inherent, equals(true));
    });

    test('has duration', () {
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(hours: 12)).duration,
          equals(GDuration(hours: 12)));
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(hours: 48)).duration,
          equals(GDuration(days: 2)));
    });

    test('has energy cost', () {
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(hours: 12)).energyCost,
          equals(1));
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(hours: 48)).energyCost,
          equals(3));
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(days: 10)).energyCost,
          equals(4));
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(days: 300)).energyCost,
          equals(7));
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(days: 301)).energyCost,
          equals(8));
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(days: 3000))
              .energyCost,
          equals(9));
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(days: 10000))
              .energyCost,
          equals(10));
      expect(
          RangeCrossTime.copyWith(m, duration: GDuration(years: 10)).energyCost,
          equals(10));
    });
  });

  group("Range, Extradimensional:", () {
    RangeDimensional m;

    setUp(() async {
      m = new RangeDimensional();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.numberDimensions, equals(0));
      expect(m.name, equals("Range, Extradimensional"));
      expect(m.energyCost, equals(0));
    });

    test("has inherent", () {
      expect(
          RangeDimensional.copyWith(m, inherent: true).inherent, equals(true));
    });

    test("cost 10 energy per Dimension crossed", () {
      expect(RangeDimensional.copyWith(m, numberDimensions: 1).energyCost,
          equals(10));
      expect(RangeDimensional.copyWith(m, numberDimensions: 2).energyCost,
          equals(20));
      expect(RangeDimensional.copyWith(m, numberDimensions: 5).energyCost,
          equals(50));
    });
  });
}
