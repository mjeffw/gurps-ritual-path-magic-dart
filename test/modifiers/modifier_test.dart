import 'package:gurps_dart/gurps_dart.dart';
import 'package:test/test.dart';

import '../../lib/src/modifier/ritual_modifier.dart';
import '../../lib/src/trait.dart';

void main() {
  group('Altered Traits', () {
    AlteredTraits m;

    setUp(() async {
      Trait trait = Trait(name: 'foo');
      m = AlteredTraits(trait);
    });

    test('has initial state', () {
      expect(m.characterPoints, equals(0));
      expect(m.name, equals('Altered Traits'));
      expect(m.energyCost, equals(0));
      expect(m.trait, equals(Trait(name: 'foo')));
    });

    test('adds +1 energy for every 5 cps removed', () {
      expect(m.copyWith(trait: Trait(baseCost: -1)).energyCost, equals(1));
      expect(m.copyWith(trait: Trait(baseCost: -5)).energyCost, equals(1));
      expect(m.copyWith(trait: Trait(baseCost: -6)).energyCost, equals(2));
      expect(m.copyWith(trait: Trait(baseCost: -10)).energyCost, equals(2));
      expect(m.copyWith(trait: Trait(baseCost: -11)).energyCost, equals(3));
    });

    test('adds +1 energy for every cp added', () {
      expect(m.copyWith(trait: Trait(baseCost: 1)).energyCost, equals(1));
      expect(m.copyWith(trait: Trait(baseCost: 11)).energyCost, equals(11));
      expect(m.copyWith(trait: Trait(baseCost: 24)).energyCost, equals(24));
      expect(m.copyWith(trait: Trait(baseCost: 100)).energyCost, equals(100));
    });

    test('allows for Limitations/Enhancements', () {
      var alt = m.copyWith(trait: Trait(baseCost: 24));
      alt = alt.addModifier(TraitModifier(percent: 10));
      expect(alt.energyCost, equals(27));

      alt = alt.addModifier(TraitModifier(percent: 5));
      expect(alt.energyCost, equals(28));

      alt = alt.addModifier(TraitModifier(percent: -10));
      expect(alt.energyCost, equals(26));
    });

    test('another test for Limitations/Enhancements', () {
      var alt = m.addModifier(TraitModifier(percent: 35));
      alt = alt.addModifier(TraitModifier(percent: -10));

      expect(alt.energyCost, equals(0));

      expect(alt.copyWith(trait: Trait(baseCost: 30)).energyCost, equals(38));
      expect(alt.copyWith(trait: Trait(baseCost: 100)).energyCost, equals(125));
      expect(alt.copyWith(trait: Trait(baseCost: -10)).energyCost, equals(3));
      expect(alt.copyWith(trait: Trait(baseCost: -40)).energyCost, equals(10));
    });

    test('incrementEnergy', () {
      var alt = m.copyWith(trait: Trait(baseCost: -1));
      expect(alt.incrementEffect(1).characterPoints, equals(-10));
      expect(alt.incrementEffect(2).characterPoints, equals(-15));
      expect(alt.incrementEffect(3).characterPoints, equals(-20));

      alt = m.copyWith(trait: Trait(baseCost: 1));
      expect(alt.incrementEffect(1).characterPoints, equals(2));
      expect(alt.incrementEffect(2).characterPoints, equals(3));
      expect(alt.incrementEffect(3).characterPoints, equals(4));

      // zero-cost trait defaults to adding character points
      expect(m.incrementEffect(1).characterPoints, equals(1));
      expect(m.incrementEffect(2).characterPoints, equals(2));
      expect(m.incrementEffect(3).characterPoints, equals(3));
    });

    test('implements == and hashCode', () {
      expect(m, equals(AlteredTraits(Trait(name: 'foo'))));
      expect(m, isNot(equals(AlteredTraits(Trait(name: 'bar')))));
      expect(m.hashCode, equals(AlteredTraits(Trait(name: 'foo')).hashCode));
      expect(m.hashCode,
          isNot(equals(AlteredTraits(Trait(name: 'bar')).hashCode)));
    });
  });

  group('Area of Effect', () {
    AreaOfEffect m;

    setUp(() async {
      m = AreaOfEffect();
    });

    test('has initial state', () {
      expect(m.radius, equals(0));
      expect(m.name, equals('Area of Effect'));
      expect(m.energyCost, equals(0));
    });

    test('radius calculation', () {
      expect(m.copyWith(radius: 1).energyCost, equals(2));
      expect(m.copyWith(radius: 3).energyCost, equals(2));
      expect(m.copyWith(radius: 4).energyCost, equals(4));
      expect(m.copyWith(radius: 5).energyCost, equals(4));
      expect(m.copyWith(radius: 6).energyCost, equals(6));
      expect(m.copyWith(radius: 15).energyCost, equals(10));
      expect(m.copyWith(radius: 20).energyCost, equals(12));
      expect(m.copyWith(radius: 300).energyCost, equals(26));
    });

    test('add +1 energy for every two specific subjects not affected', () {
      var alt = m.copyWith(radius: 15, numberTargets: 2);
      expect(alt.energyCost, equals(11));

      expect(alt.copyWith(numberTargets: 6).energyCost, equals(13));
      expect(alt.copyWith(numberTargets: 7).energyCost, equals(14));
    });

    test('incrementRadius', () {
      // minimum cost of 2
      expect(m.incrementEffect(1).energyCost, equals(2));
    });

    test('implements == and hashCode', () {
      expect(m, equals(AreaOfEffect()));
      expect(m, isNot(equals(AreaOfEffect(radius: 5))));
      expect(m.hashCode, equals(AreaOfEffect().hashCode));
      expect(m.hashCode, isNot(equals(AreaOfEffect(radius: 3).hashCode)));
    });
  });

  group('Bestows a (Bonus or Penalty)', () {
    Bestows m;

    setUp(() async {
      m = Bestows('Test');
    });

    test('has initial state', () {
      expect(m.name, equals("Bestows a (Bonus or Penalty)"));
      expect(m.energyCost, equals(0));
      expect(m.roll, equals('Test'));
      expect(m.range, equals(BestowsRange.narrow));
    });

    test('has range', () {
      expect(m.copyWith(range: BestowsRange.moderate).range,
          equals(BestowsRange.moderate));
      expect(m.copyWith(range: BestowsRange.broad).range,
          equals(BestowsRange.broad));
    });

    test('has Narrow roll cost', () {
      expect(m.copyWith(value: -4).energyCost, equals(8));
      expect(m.copyWith(value: -3).energyCost, equals(4));
      expect(m.copyWith(value: -2).energyCost, equals(2));
      expect(m.copyWith(value: -1).energyCost, equals(1));
      expect(m.copyWith(value: 0).energyCost, equals(0));
      expect(m.copyWith(value: 1).energyCost, equals(1));
      expect(m.copyWith(value: 2).energyCost, equals(2));
      expect(m.copyWith(value: 3).energyCost, equals(4));
      expect(m.copyWith(value: 4).energyCost, equals(8));
    });

    test("has Moderate cost", () {
      var b = m.copyWith(range: BestowsRange.moderate);

      expect(b.copyWith(value: -4).energyCost, equals(16));
      expect(b.copyWith(value: -3).energyCost, equals(8));
      expect(b.copyWith(value: -2).energyCost, equals(4));
      expect(b.copyWith(value: -1).energyCost, equals(2));
      expect(b.copyWith(value: 0).energyCost, equals(0));
      expect(b.copyWith(value: 1).energyCost, equals(2));
      expect(b.copyWith(value: 2).energyCost, equals(4));
      expect(b.copyWith(value: 3).energyCost, equals(8));
      expect(b.copyWith(value: 4).energyCost, equals(16));
    });

    test("has Broad cost", () {
      var b = m.copyWith(range: BestowsRange.broad);

      expect(b.copyWith(value: -4).energyCost, equals(40));
      expect(b.copyWith(value: -3).energyCost, equals(20));
      expect(b.copyWith(value: -2).energyCost, equals(10));
      expect(b.copyWith(value: -1).energyCost, equals(5));
      expect(b.copyWith(value: 0).energyCost, equals(0));
      expect(b.copyWith(value: 1).energyCost, equals(5));
      expect(b.copyWith(value: 2).energyCost, equals(10));
      expect(b.copyWith(value: 3).energyCost, equals(20));
      expect(b.copyWith(value: 4).energyCost, equals(40));
    });

    test('has incrementEffect', () {
      expect(m.incrementEffect(2).energyCost, equals(2));
      expect(m.incrementEffect(2).value, equals(2));
      expect(m.incrementEffect(-2).energyCost, equals(2));
      expect(m.incrementEffect(-2).value, equals(-2));
      expect(m.incrementEffect(6).energyCost, equals(32));
      expect(m.incrementEffect(6).value, equals(6));
    });

    test('implements == and hashCode', () {
      expect(m, equals(Bestows('Test')));
      expect(m, isNot(equals(Bestows('Bar'))));
      expect(m, isNot(equals(m.copyWith(value: 1))));
      expect(m, isNot(equals(m.copyWith(range: BestowsRange.moderate))));

      expect(m.hashCode, equals(Bestows('Test').hashCode));
      expect(m.hashCode, isNot(equals(Bestows('Bar').hashCode)));
      expect(m.hashCode, isNot(equals(m.copyWith(value: 1).hashCode)));
      expect(m.hashCode,
          isNot(equals(m.copyWith(range: BestowsRange.moderate).hashCode)));
    });
  });

  group('Duration', () {
    DurationModifier m;

    setUp(() async {
      m = DurationModifier();
    });

    test('has initial state', () {
      expect(m.name, equals('Duration'));
      expect(m.energyCost, equals(0));
      expect(m.duration, equals(GDuration.momentary));
    });

    /*
       | Duration      | Energy |
       | Momentary     |      0 |
       | 10 minutes    |      1 |
       | 30 minutes    |      2 |
       | 1 hour        |      3 |
       | 3 hours       |      4 |
       | 6 hours       |      5 |
       | 12 hours      |      6 |
       | 1 day         |      7 |
       | 3 days        |      8 |
       | 1 week        |      9 |
       | 2 weeks       |     10 |
       | 1 month       |     11 |
       | +1 month      |     +1 |
       | 11 months     |     21 |
       | 1 year        |     22 |
       | +1 year       |     +1 |
     */
    test('should have Energy cost', () {
      expect(
          m.copyWith(duration: GDuration(minutes: 10)).energyCost, equals(1));
      expect(
          m.copyWith(duration: GDuration(minutes: 30)).energyCost, equals(2));
      expect(m.copyWith(duration: GDuration(hours: 1)).energyCost, equals(3));
      expect(m.copyWith(duration: GDuration(hours: 3)).energyCost, equals(4));
      expect(m.copyWith(duration: GDuration(hours: 6)).energyCost, equals(5));
      expect(m.copyWith(duration: GDuration(hours: 12)).energyCost, equals(6));
      expect(m.copyWith(duration: GDuration(days: 1)).energyCost, equals(7));
      expect(m.copyWith(duration: GDuration(days: 3)).energyCost, equals(8));
      expect(m.copyWith(duration: GDuration(weeks: 1)).energyCost, equals(9));
      expect(m.copyWith(duration: GDuration(weeks: 2)).energyCost, equals(10));
      expect(m.copyWith(duration: GDuration(months: 1)).energyCost, equals(11));
      expect(m.copyWith(duration: GDuration(months: 2)).energyCost, equals(12));
      expect(m.copyWith(duration: GDuration(months: 3)).energyCost, equals(13));
      expect(
          m.copyWith(duration: GDuration(months: 11)).energyCost, equals(21));
      expect(m.copyWith(duration: GDuration(months: 11, seconds: 1)).energyCost,
          equals(22));
      expect(m.copyWith(duration: GDuration(years: 1)).energyCost, equals(22));
      expect(m.copyWith(duration: GDuration(years: 5)).energyCost, equals(26));
      expect(
          m.copyWith(duration: GDuration(years: 100)).energyCost, equals(121));
    });

    test('should have incrementEffect', () {
      expect(m.incrementEffect(1).energyCost, equals(1));
      expect(m.incrementEffect(1).duration, equals(GDuration(minutes: 10)));

      expect(m.incrementEffect(11).energyCost, equals(11));
      expect(m.incrementEffect(11).duration, equals(GDuration(months: 1)));

      expect(m.incrementEffect(21).energyCost, equals(21));
      expect(m.incrementEffect(21).duration, equals(GDuration(months: 11)));

      var years = m.incrementEffect(25);
      expect(years.energyCost, equals(25));
      expect(years.duration, equals(GDuration(years: 4)));
      expect(years.incrementEffect(-4).duration, equals(GDuration(months: 11)));
      // can't go below zero
      expect(m.incrementEffect(-4).energyCost, equals(0));
      expect(m.incrementEffect(-4).duration, equals(GDuration.momentary));
    });

    test('implements == and hashCode', () {
      expect(m, equals(DurationModifier()));
      expect(
          m, isNot(equals(DurationModifier(duration: GDuration(minutes: 10)))));

      expect(m.hashCode, equals(DurationModifier().hashCode));
      expect(m.hashCode,
          isNot(equals(m.copyWith(duration: GDuration(hours: 1)).hashCode)));
    });
  });

  group('Extra Energy', () {
    ExtraEnergy energy;

    setUp(() async {
      energy = ExtraEnergy();
    });

    test('has initial state', () {
      expect(energy.name, equals('Extra Energy'));
      expect(energy.energyCost, equals(0));
      expect(energy.energy, 0);
    });

    test('has energy', () {
      expect(energy.copyWith(energy: 5).energy, equals(5));
      expect(energy.copyWith(energy: 7).energy, equals(7));
      expect(energy.copyWith(energy: 20).energy, equals(20));
    });

    test('has energy cost', () {
      expect(energy.copyWith(energy: 5).energyCost, equals(5));
      expect(energy.copyWith(energy: 7).energyCost, equals(7));
      expect(energy.copyWith(energy: 20).energyCost, equals(20));
    });

    test('has increment effect', () {
      expect(energy.incrementEffect(5).energyCost, equals(5));
      expect(energy.incrementEffect(7).energy, equals(7));
      expect(energy.incrementEffect(20).energyCost, equals(20));
    });

    test('implements == and hashCode', () {
      expect(energy, equals(ExtraEnergy()));
      expect(energy, isNot(equals(ExtraEnergy(energy: 2))));

      expect(energy.hashCode, equals(ExtraEnergy().hashCode));
      expect(
          energy.hashCode, isNot(equals(energy.copyWith(energy: 3).hashCode)));
    });
  });

  group('Healing', () {
    Healing heal;

    setUp(() async {
      heal = new Healing();
    });

    test('has initial state', () {
      expect(heal.name, equals('Healing'));
      expect(heal.energyCost, equals(0));
      expect(heal.dice, equals(DieRoll(1, 0)));
      expect(heal.type, equals(HealingType.hp));
    });

    test('has Dice', () {
      expect(heal.copyWith(dice: DieRoll(2, 0)).dice, equals(DieRoll(2, 0)));
      expect(heal.copyWith(dice: DieRoll(4, -1)).dice, equals(DieRoll(4, -1)));
    });

    test('has energy cost', () {
      expect(heal.copyWith(dice: DieRoll(2, 0)).energyCost, equals(4));
      expect(heal.copyWith(dice: DieRoll(4, -1)).energyCost, equals(11));
    });

    test('has type', () {
      expect(heal.copyWith(type: HealingType.fp).type, equals(HealingType.fp));
    });

    test('has increment effect', () {
      expect(heal.incrementEffect(2).dice, equals(DieRoll(1, 2)));
      expect(heal.incrementEffect(8).dice, equals(DieRoll(3, 0)));
    });

    test('implements == and hashCode', () {
      expect(heal, equals(Healing()));
      expect(heal, isNot(equals(Healing(dice: DieRoll(2, 0)))));
      expect(heal, isNot(equals(heal.copyWith(type: HealingType.fp))));

      expect(heal.hashCode, equals(Healing().hashCode));
      expect(heal.hashCode,
          isNot(equals(heal.copyWith(dice: DieRoll(2, 0)).hashCode)));
      expect(heal.hashCode,
          isNot(equals(heal.copyWith(type: HealingType.fp).hashCode)));
    });
  });

  group('Meta-Magic', () {
    MetaMagic meta;

    setUp(() async {
      meta = MetaMagic();
    });

    test('has initial state', () {
      expect(meta.name, equals('Meta-Magic'));
      expect(meta.energyCost, equals(0));
      expect(meta.energy, 0);
    });

    test('has energy', () {
      expect(meta.copyWith(energy: 5).energy, equals(5));
      expect(meta.copyWith(energy: 7).energy, equals(7));
      expect(meta.copyWith(energy: 20).energy, equals(20));
    });

    test('has energy cost', () {
      expect(meta.copyWith(energy: 5).energyCost, equals(5));
      expect(meta.copyWith(energy: 7).energyCost, equals(7));
      expect(meta.copyWith(energy: 20).energyCost, equals(20));
    });

    test('has increment effect', () {
      expect(meta.incrementEffect(5).energyCost, equals(5));
      expect(meta.incrementEffect(7).energyCost, equals(7));
      expect(meta.incrementEffect(20).energyCost, equals(20));
    });

    test('implements == and hashCode', () {
      expect(meta, equals(MetaMagic()));
      expect(meta, isNot(equals(MetaMagic(energy: 2))));

      expect(meta.hashCode, equals(MetaMagic().hashCode));
      expect(meta.hashCode, isNot(equals(meta.copyWith(energy: 3).hashCode)));
    });
  });

  group('Speed', () {
    Speed m;

    setUp(() async {
      m = new Speed();
    });

    test("has initial state", () {
      expect(m.energyCost, equals(0));
      expect(m.name, equals("Speed"));
      expect(m.yardsPerSecond, equals(GDistance(yards: 2)));
    });

    // For movement spells (e.g., spells that use telekinesis or allow a subject to fly), look up the speed
    // in yards/second on the Size and Speed/Range Table (p. B550) and add the Size value for that line
    // (minimum +0) to SP.
    // Speed/Range Table:
    //  | Range | Size || Range | Size || Range | Size |
    //  |   0-2 |    0 ||    20 |    6 ||   200 |   12 |
    //  |     3 |    1 ||    30 |    7 ||   300 |   13 |
    //  |     5 |    2 ||    50 |    8 ||   500 |   14 |
    //  |     7 |    3 ||    70 |    9 ||   700 |   15 |
    //  |    10 |    4 ||   100 |   10 ||  1000 |   16 |
    //  |    15 |    5 ||   150 |   11 ||  1500 |   17 |
    test("has yardsPerSecond and energyCost", () {
      expect(m.copyWith(yardsPerSecond: GDistance(yards: 0)).energyCost,
          equals(0));

      expect(m.copyWith(yardsPerSecond: GDistance(yards: 3)).energyCost,
          equals(1));

      expect(m.copyWith(yardsPerSecond: GDistance(yards: 5)).energyCost,
          equals(2));

      expect(m.copyWith(yardsPerSecond: GDistance(yards: 7)).energyCost,
          equals(3));

      expect(m.copyWith(yardsPerSecond: GDistance(yards: 10)).energyCost,
          equals(4));

      expect(m.copyWith(yardsPerSecond: GDistance(yards: 15)).energyCost,
          equals(5));

      expect(m.copyWith(yardsPerSecond: GDistance(yards: 150)).energyCost,
          equals(11));

      expect(m.copyWith(yardsPerSecond: GDistance(yards: 200)).energyCost,
          equals(12));

      expect(m.copyWith(yardsPerSecond: GDistance(yards: 300)).energyCost,
          equals(13));
    });

    test('has increment Effect', () {
      expect(m.incrementEffect(1).yardsPerSecond, equals(GDistance(yards: 3)));
      expect(
          m.incrementEffect(10).yardsPerSecond, equals(GDistance(yards: 100)));
      expect(
          m.incrementEffect(26).yardsPerSecond, equals(GDistance(miles: 25)));
    });

    test('implements == and hashCode', () {
      expect(m, equals(Speed()));
      expect(m, isNot(equals(Speed(yardsPerSecond: GDistance(yards: 3)))));

      expect(m.hashCode, equals(Speed().hashCode));
      expect(
          m.hashCode,
          isNot(equals(
              m.copyWith(yardsPerSecond: GDistance(yards: 3)).hashCode)));
    });
  });

  group("SubjectWeight:", () {
    SubjectWeight m;

    setUp(() async => m = SubjectWeight());

    test("has initial state", () {
      expect(m.energyCost, equals(0));
      expect(m.name, equals("Subject Weight"));
      expect(m.weight, equals(GWeight(pounds: 10)));
    });

    test("should have energyCost and weight", () {
      expect(m.copyWith(weight: GWeight(pounds: 0)).energyCost, equals(0));
      expect(m.copyWith(weight: GWeight(pounds: 0)).weight,
          equals(GWeight(pounds: 10)));
      expect(m.copyWith(weight: GWeight(pounds: 10)).energyCost, equals(0));
      expect(m.copyWith(weight: GWeight(pounds: 10)).weight,
          equals(GWeight(pounds: 10)));
      expect(m.copyWith(weight: GWeight(pounds: 11)).energyCost, equals(1));
      expect(m.copyWith(weight: GWeight(pounds: 11)).weight,
          equals(GWeight(pounds: 30)));
      expect(m.copyWith(weight: GWeight(pounds: 30)).energyCost, equals(1));
      expect(m.copyWith(weight: GWeight(pounds: 30)).weight,
          equals(GWeight(pounds: 30)));
      expect(m.copyWith(weight: GWeight(pounds: 31)).energyCost, equals(2));
      expect(m.copyWith(weight: GWeight(pounds: 31)).weight,
          equals(GWeight(pounds: 100)));
      expect(m.copyWith(weight: GWeight(pounds: 100)).energyCost, equals(2));
      expect(m.copyWith(weight: GWeight(pounds: 300)).energyCost, equals(3));
      expect(m.copyWith(weight: GWeight(pounds: 1000)).energyCost, equals(4));
      expect(m.copyWith(weight: GWeight(tons: 5)).energyCost, equals(6));
      expect(m.copyWith(weight: GWeight(tons: 15)).energyCost, equals(7));
    });

    test('should have increment effect', () {
      expect(m.incrementEffect(1).weight, equals(GWeight(pounds: 30)));
      expect(m.incrementEffect(2).weight, equals(GWeight(pounds: 100)));
      expect(m.incrementEffect(3).weight, equals(GWeight(pounds: 300)));
      expect(m.incrementEffect(5).weight, equals(GWeight(pounds: 3000)));
      expect(m.incrementEffect(8).weight, equals(GWeight(tons: 50)));
    });

    test('implements == and hashCode', () {
      expect(m, equals(SubjectWeight()));
      expect(m, isNot(equals(SubjectWeight(weight: GWeight(pounds: 30)))));

      expect(m.hashCode, equals(SubjectWeight().hashCode));
      expect(m.hashCode,
          isNot(equals(m.copyWith(weight: GWeight(pounds: 30)).hashCode)));
    });
  });
}
