import 'package:gurps_dart/gurps_dart.dart';
import 'package:test/test.dart';

import '../../lib/src/modifier/range_modifier.dart';

void main() {
  group('Range', () {
    Range m;

    setUp(() async {
      m = Range();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.energyCost, equals(0));
      expect(m.name, equals("Range"));
      expect(m.distance, equals(GurpsDistance(yards: 2)));
    });

    test("has inherent", () {
      expect(Range.copyWith(m, inherent: true).inherent, equals(true));
    });

    test("has distance", () {
      expect(Range.copyWith(m, distance: GurpsDistance(yards: 5)).distance,
          equals(GurpsDistance(yards: 5)));
    });

    test("has energy Cost", () {
      var r = Range.copyWith(m, distance: GurpsDistance(yards: 2));
      expect(r.energyCost, equals(0));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 3)).energyCost,
          equals(1));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 4)).energyCost,
          equals(2));
      expect(Range.copyWith(m, distance: GurpsDistance(yards: 5)).energyCost,
          equals(2));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 7)).energyCost,
          equals(3));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 10)).energyCost,
          equals(4));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 11)).energyCost,
          equals(5));
      expect(Range.copyWith(m, distance: GurpsDistance(yards: 12)).energyCost,
          equals(5));
      expect(Range.copyWith(m, distance: GurpsDistance(yards: 13)).energyCost,
          equals(5));
      expect(Range.copyWith(m, distance: GurpsDistance(yards: 14)).energyCost,
          equals(5));
      expect(Range.copyWith(m, distance: GurpsDistance(yards: 15)).energyCost,
          equals(5));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 20)).energyCost,
          equals(6));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 30)).energyCost,
          equals(7));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 50)).energyCost,
          equals(8));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 70)).energyCost,
          equals(9));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 100)).energyCost,
          equals(10));

      expect(Range.copyWith(m, distance: GurpsDistance(yards: 150)).energyCost,
          equals(11));

      expect(Range.copyWith(m, distance: GurpsDistance(miles: 1)).energyCost,
          equals(18));

      expect(Range.copyWith(m, distance: GurpsDistance(miles: 100)).energyCost,
          equals(30));
    });
  });

  group('Range, Informational', () {
    RangeInformational r;

    setUp(() async {
      r = new RangeInformational();
    });

    test("has initial state", () {
      expect(r.inherent, equals(false));
      expect(r.energyCost, equals(0));
      expect(r.name, equals("Range, Informational"));
      expect(r.distance, equals(GurpsDistance(yards: 200)));
    });
  });
}
