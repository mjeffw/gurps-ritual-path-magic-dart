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
      expect(m.copyWith(inherent: true).inherent, equals(true));
    });

    test('has distance', () {
      expect(m.copyWith(distance: GDistance(yards: 5)).distance,
          equals(GDistance(yards: 5)));
    });

    test('has energy Cost', () {
      var r = m.copyWith(distance: GDistance(yards: 2));
      expect(r.energyCost, equals(0));

      expect(m.copyWith(distance: GDistance(yards: 3)).energyCost, equals(1));
      expect(m.copyWith(distance: GDistance(yards: 4)).energyCost, equals(2));
      expect(m.copyWith(distance: GDistance(yards: 5)).energyCost, equals(2));
      expect(m.copyWith(distance: GDistance(yards: 7)).energyCost, equals(3));
      expect(m.copyWith(distance: GDistance(yards: 10)).energyCost, equals(4));
      expect(m.copyWith(distance: GDistance(yards: 11)).energyCost, equals(5));
      expect(m.copyWith(distance: GDistance(yards: 12)).energyCost, equals(5));
      expect(m.copyWith(distance: GDistance(yards: 13)).energyCost, equals(5));
      expect(m.copyWith(distance: GDistance(yards: 14)).energyCost, equals(5));
      expect(m.copyWith(distance: GDistance(yards: 15)).energyCost, equals(5));
      expect(m.copyWith(distance: GDistance(yards: 20)).energyCost, equals(6));
      expect(m.copyWith(distance: GDistance(yards: 30)).energyCost, equals(7));
      expect(m.copyWith(distance: GDistance(yards: 50)).energyCost, equals(8));
      expect(m.copyWith(distance: GDistance(yards: 70)).energyCost, equals(9));
      expect(
          m.copyWith(distance: GDistance(yards: 100)).energyCost, equals(10));
      expect(
          m.copyWith(distance: GDistance(yards: 150)).energyCost, equals(11));
      expect(m.copyWith(distance: GDistance(miles: 1)).energyCost, equals(18));
      expect(
          m.copyWith(distance: GDistance(miles: 100)).energyCost, equals(30));
    });

    test('has increment effect', () {
      expect(m.incrementEffect(1).distance, equals(GDistance(yards: 3)));
      expect(m.incrementEffect(9).distance, equals(GDistance(yards: 70)));
      expect(m.incrementEffect(19).distance, equals(GDistance(yards: 3000)));

      var x = m.incrementEffect(9);
      expect(x.incrementEffect(10).distance, equals(GDistance(yards: 3000)));
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
      expect(r.copyWith(inherent: true).inherent, equals(true));
    });

    test('has distance', () {
      var x = r.copyWith(distance: GDistance(yards: 1000));
      expect(x.distance, equals(GDistance(yards: 1000)));

      x = r.copyWith(distance: GDistance(miles: 1));
      expect(x.distance, equals(GDistance(miles: 1)));
    });

    test('has increment effect', () {
      expect(r.incrementEffect(1).distance, equals(GDistance(yards: 1000)));
      expect(r.incrementEffect(2).distance, equals(GDistance(miles: 1)));
      expect(r.incrementEffect(3).distance, equals(GDistance(miles: 3)));
      expect(r.incrementEffect(4).distance, equals(GDistance(miles: 10)));

      var x = r.incrementEffect(4);
      expect(x.incrementEffect(2).distance, equals(GDistance(miles: 100)));
    });

    test('cost energy', () {
      expect(r.copyWith(distance: GDistance(yards: 201)).energyCost, equals(1));
      expect(
          r.copyWith(distance: GDistance(yards: 1001)).energyCost, equals(2));
      expect(r.copyWith(distance: GDistance(miles: 1)).energyCost, equals(2));
      expect(r.copyWith(distance: GDistance(miles: 1, yards: 1)).energyCost,
          equals(3));
      expect(r.copyWith(distance: GDistance(miles: 3)).energyCost, equals(3));
      expect(r.copyWith(distance: GDistance(miles: 10)).energyCost, equals(4));
      expect(r.copyWith(distance: GDistance(miles: 30)).energyCost, equals(5));
      expect(
          r.copyWith(distance: GDistance(miles: 1000)).energyCost, equals(8));
      expect(
          r.copyWith(distance: GDistance(miles: 3000)).energyCost, equals(9));
      expect(
          r.copyWith(distance: GDistance(miles: 10000)).energyCost, equals(10));
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
      expect(m.copyWith(inherent: true).inherent, equals(true));
    });

    test('has duration', () {
      expect(m.copyWith(duration: GDuration(hours: 12)).duration,
          equals(GDuration(hours: 12)));
      expect(m.copyWith(duration: GDuration(hours: 48)).duration,
          equals(GDuration(days: 2)));
    });

    test('has energy cost', () {
      expect(m.copyWith(duration: GDuration(hours: 12)).energyCost, equals(1));
      expect(m.copyWith(duration: GDuration(hours: 48)).energyCost, equals(3));
      expect(m.copyWith(duration: GDuration(days: 10)).energyCost, equals(4));
      expect(m.copyWith(duration: GDuration(days: 300)).energyCost, equals(7));
      expect(m.copyWith(duration: GDuration(days: 301)).energyCost, equals(8));
      expect(m.copyWith(duration: GDuration(days: 3000)).energyCost, equals(9));
      expect(
          m.copyWith(duration: GDuration(days: 10000)).energyCost, equals(10));
      expect(m.copyWith(duration: GDuration(years: 10)).energyCost, equals(10));
    });

    test('has increment effect', () {
      expect(m.incrementEffect(1).duration, equals(GDuration(hours: 12)));
      expect(m.incrementEffect(3).duration, equals(GDuration(days: 3)));

      var x = m.incrementEffect(3);
      expect(x.incrementEffect(3).duration, equals(GDuration(days: 100)));
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
      expect(m.copyWith(inherent: true).inherent, equals(true));
    });

    test("cost 10 energy per Dimension crossed", () {
      expect(m.copyWith(numberDimensions: 1).energyCost, equals(10));
      expect(m.copyWith(numberDimensions: 2).energyCost, equals(20));
      expect(m.copyWith(numberDimensions: 5).energyCost, equals(50));
    });

    test('has increment effect', () {
      expect(m.incrementEffect(3).numberDimensions, equals(3));
      expect(
          m.incrementEffect(3).incrementEffect(4).numberDimensions, equals(7));
    });
  });
}
