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
      expect(m.inherent, equals(false));
      expect(m.characterPoints, equals(0));
      expect(m.name, equals('Altered Traits'));
      expect(m.energyCost, equals(0));
    });

    test('has inherent', () {
      var alt = AlteredTraits.copyWith(m, inherent: true);
      expect(alt.inherent, equals(true));
    });

    test('adds +1 SP for every 5 cps removed', () {
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: -1)).energyCost,
          equals(1));
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: -5)).energyCost,
          equals(1));
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: -6)).energyCost,
          equals(2));
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: -10)).energyCost,
          equals(2));
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: -11)).energyCost,
          equals(3));
    });

    test('adds +1 energy for every cp added', () {
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: 1)).energyCost,
          equals(1));
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: 11)).energyCost,
          equals(11));
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: 24)).energyCost,
          equals(24));
      expect(AlteredTraits.copyWith(m, trait: Trait(baseCost: 100)).energyCost,
          equals(100));
    });

    test('allows for Limitations/Enhancements', () {
      var alt = AlteredTraits.copyWith(m, trait: Trait(baseCost: 24));
      alt = AlteredTraits.addModifier(alt, TraitModifier(percent: 10));
      expect(alt.energyCost, equals(27));

      alt = AlteredTraits.addModifier(alt, TraitModifier(percent: 5));
      expect(alt.energyCost, equals(28));

      alt = AlteredTraits.addModifier(alt, TraitModifier(percent: -10));
      expect(alt.energyCost, equals(26));
    });

    test('another test for Limitations/Enhancements', () {
      var alt = AlteredTraits.addModifier(m, TraitModifier(percent: 35));
      alt = AlteredTraits.addModifier(alt, TraitModifier(percent: -10));

      expect(alt.energyCost, equals(0));

      expect(AlteredTraits.copyWith(alt, trait: Trait(baseCost: 30)).energyCost,
          equals(38));
      expect(
          AlteredTraits.copyWith(alt, trait: Trait(baseCost: 100)).energyCost,
          equals(125));
      expect(
          AlteredTraits.copyWith(alt, trait: Trait(baseCost: -10)).energyCost,
          equals(3));
      expect(
          AlteredTraits.copyWith(alt, trait: Trait(baseCost: -40)).energyCost,
          equals(10));
    });
  });

  group('Area of Effect', () {
    AreaOfEffect m;

    setUp(() async {
      m = AreaOfEffect();
    });

    test('has initial state', () {
      expect(m.inherent, equals(false));
      expect(m.radius, equals(0));
      expect(m.name, equals('Area of Effect'));
      expect(m.energyCost, equals(0));
    });

    test('has inherent', () {
      expect(AreaOfEffect.copyWith(m, inherent: true).inherent, equals(true));
    });

    test('radius calculation', () {
      expect(AreaOfEffect.copyWith(m, radius: 1).energyCost, equals(2));
      expect(AreaOfEffect.copyWith(m, radius: 3).energyCost, equals(2));
      expect(AreaOfEffect.copyWith(m, radius: 4).energyCost, equals(4));
      expect(AreaOfEffect.copyWith(m, radius: 5).energyCost, equals(4));
      expect(AreaOfEffect.copyWith(m, radius: 6).energyCost, equals(6));
      expect(AreaOfEffect.copyWith(m, radius: 15).energyCost, equals(10));
      expect(AreaOfEffect.copyWith(m, radius: 20).energyCost, equals(12));
      expect(AreaOfEffect.copyWith(m, radius: 300).energyCost, equals(26));
    });

    test('add +1 energy for every two specific subjects not affected', () {
      var alt = AreaOfEffect.copyWith(m, radius: 15, numberTargets: 2);
      expect(alt.energyCost, equals(11));

      expect(
          AreaOfEffect.copyWith(alt, numberTargets: 6).energyCost, equals(13));
      expect(
          AreaOfEffect.copyWith(alt, numberTargets: 7).energyCost, equals(14));
    });
  });

  group('Bestows a (Bonus or Penalty)', () {
    Bestows m;

    setUp(() async {
      m = new Bestows('Test');
    });

    test('has initial state', () {
      expect(m.inherent, equals(false));
      expect(m.name, equals("Bestows a (Bonus or Penalty)"));
      expect(m.energyCost, equals(0));
      expect(m.roll, equals('Test'));
      expect(m.range, equals(BestowsRange.narrow));
    });

    test('has inherent', () {
      expect(Bestows.copyWith(m, inherent: true).inherent, equals(true));
    });

    test('has range', () {
      expect(Bestows.copyWith(m, range: BestowsRange.moderate).range,
          equals(BestowsRange.moderate));
      expect(Bestows.copyWith(m, range: BestowsRange.broad).range,
          equals(BestowsRange.broad));
    });

    test('has Narrow roll cost', () {
      expect(Bestows.copyWith(m, value: -4).energyCost, equals(8));
      expect(Bestows.copyWith(m, value: -3).energyCost, equals(4));
      expect(Bestows.copyWith(m, value: -2).energyCost, equals(2));
      expect(Bestows.copyWith(m, value: -1).energyCost, equals(1));
      expect(Bestows.copyWith(m, value: 0).energyCost, equals(0));
      expect(Bestows.copyWith(m, value: 1).energyCost, equals(1));
      expect(Bestows.copyWith(m, value: 2).energyCost, equals(2));
      expect(Bestows.copyWith(m, value: 3).energyCost, equals(4));
      expect(Bestows.copyWith(m, value: 4).energyCost, equals(8));
    });

    test("has Moderate cost", () {
      var b = Bestows.copyWith(m, range: BestowsRange.moderate);

      expect(Bestows.copyWith(b, value: -4).energyCost, equals(16));
      expect(Bestows.copyWith(b, value: -3).energyCost, equals(8));
      expect(Bestows.copyWith(b, value: -2).energyCost, equals(4));
      expect(Bestows.copyWith(b, value: -1).energyCost, equals(2));
      expect(Bestows.copyWith(b, value: 0).energyCost, equals(0));
      expect(Bestows.copyWith(b, value: 1).energyCost, equals(2));
      expect(Bestows.copyWith(b, value: 2).energyCost, equals(4));
      expect(Bestows.copyWith(b, value: 3).energyCost, equals(8));
      expect(Bestows.copyWith(b, value: 4).energyCost, equals(16));
    });

    test("has Broad cost", () {
      var b = Bestows.copyWith(m, range: BestowsRange.broad);

      expect(Bestows.copyWith(b, value: -4).energyCost, equals(40));
      expect(Bestows.copyWith(b, value: -3).energyCost, equals(20));
      expect(Bestows.copyWith(b, value: -2).energyCost, equals(10));
      expect(Bestows.copyWith(b, value: -1).energyCost, equals(5));
      expect(Bestows.copyWith(b, value: 0).energyCost, equals(0));
      expect(Bestows.copyWith(b, value: 1).energyCost, equals(5));
      expect(Bestows.copyWith(b, value: 2).energyCost, equals(10));
      expect(Bestows.copyWith(b, value: 3).energyCost, equals(20));
      expect(Bestows.copyWith(b, value: 4).energyCost, equals(40));
    });
  });

  group('Duration', () {
    DurationModifier dur;

    setUp(() async {
      dur = new DurationModifier();
    });

    test('has initial state', () {
      expect(dur.inherent, equals(false));
      expect(dur.name, equals('Duration'));
      expect(dur.energyCost, equals(0));
      expect(dur.duration, equals(GDuration.momentary));
    });

    test('has inherent', () {
      var d = DurationModifier.copyWith(dur, inherent: true);
      expect(d.inherent, equals(true));
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
      var d = DurationModifier.copyWith(dur, duration: GDuration(minutes: 10));
      expect(d.energyCost, equals(1));

      d = DurationModifier.copyWith(dur, duration: GDuration(minutes: 30));
      expect(d.energyCost, equals(2));

      d = DurationModifier.copyWith(dur, duration: GDuration(hours: 1));
      expect(d.energyCost, equals(3));

      d = DurationModifier.copyWith(dur, duration: GDuration(hours: 3));
      expect(d.energyCost, equals(4));

      d = DurationModifier.copyWith(dur, duration: GDuration(hours: 6));
      expect(d.energyCost, equals(5));

      d = DurationModifier.copyWith(dur, duration: GDuration(hours: 12));
      expect(d.energyCost, equals(6));

      d = DurationModifier.copyWith(dur, duration: GDuration(days: 1));
      expect(d.energyCost, equals(7));

      d = DurationModifier.copyWith(dur, duration: GDuration(days: 3));
      expect(d.energyCost, equals(8));

      d = DurationModifier.copyWith(dur, duration: GDuration(weeks: 1));
      expect(d.energyCost, equals(9));

      d = DurationModifier.copyWith(dur, duration: GDuration(weeks: 2));
      expect(d.energyCost, equals(10));

      d = DurationModifier.copyWith(dur, duration: GDuration(months: 1));
      expect(d.energyCost, equals(11));

      d = DurationModifier.copyWith(dur, duration: GDuration(months: 2));
      expect(d.energyCost, equals(12));

      d = DurationModifier.copyWith(dur, duration: GDuration(months: 3));
      expect(d.energyCost, equals(13));

      d = DurationModifier.copyWith(dur, duration: GDuration(months: 11));
      expect(d.energyCost, equals(21));

      d = DurationModifier.copyWith(dur,
          duration: GDuration(months: 11, seconds: 1));
      expect(d.energyCost, equals(22));

      d = DurationModifier.copyWith(dur, duration: GDuration(years: 1));
      expect(d.energyCost, equals(22));

      d = DurationModifier.copyWith(dur, duration: GDuration(years: 5));
      expect(d.energyCost, equals(26));

      d = DurationModifier.copyWith(dur, duration: GDuration(years: 100));
      expect(d.energyCost, equals(121));
    });
  });

  group('Extra Energy', () {
    ExtraEnergy energy;

    setUp(() async {
      energy = new ExtraEnergy();
    });

    test('has initial state', () {
      expect(energy.inherent, equals(false));
      expect(energy.name, equals('Extra Energy'));
      expect(energy.energyCost, equals(0));
      expect(energy.energy, 0);
    });

    test('has inherent', () {
      var d = ExtraEnergy.copyWith(energy, inherent: true);
      expect(d.inherent, equals(true));
    });

    test('has energy', () {
      expect(ExtraEnergy.copyWith(energy, energy: 5).energy, equals(5));
      expect(ExtraEnergy.copyWith(energy, energy: 7).energy, equals(7));
      expect(ExtraEnergy.copyWith(energy, energy: 20).energy, equals(20));
    });

    test('has energy cost', () {
      expect(ExtraEnergy.copyWith(energy, energy: 5).energyCost, equals(5));
      expect(ExtraEnergy.copyWith(energy, energy: 7).energyCost, equals(7));
      expect(ExtraEnergy.copyWith(energy, energy: 20).energyCost, equals(20));
    });
  });

  group('Healing', () {
    Healing heal;

    setUp(() async {
      heal = new Healing();
    });

    test('has initial state', () {
      expect(heal.inherent, equals(false));
      expect(heal.name, equals('Healing'));
      expect(heal.energyCost, equals(0));
      expect(heal.dice, equals(DieRoll(1, 0)));
      expect(heal.type, equals(HealingType.hp));
    });

    test('has inherent', () {
      var d = Healing.copyWith(heal, inherent: true);
      expect(d.inherent, equals(true));
    });

    test('has Dice', () {
      expect(Healing.copyWith(heal, dice: DieRoll(2, 0)).dice,
          equals(DieRoll(2, 0)));
      expect(Healing.copyWith(heal, dice: DieRoll(4, -1)).dice,
          equals(DieRoll(4, -1)));
    });

    test('has energy cost', () {
      expect(Healing.copyWith(heal, dice: DieRoll(2, 0)).energyCost, equals(4));
      expect(
          Healing.copyWith(heal, dice: DieRoll(4, -1)).energyCost, equals(11));
    });

    test('has type', () {
      expect(Healing.copyWith(heal, type: HealingType.fp).type,
          equals(HealingType.fp));
    });
  });

  group('Meta-Magic', () {
    MetaMagic meta;

    setUp(() async {
      meta = MetaMagic();
    });

    test('has initial state', () {
      expect(meta.inherent, equals(false));
      expect(meta.name, equals('Meta-Magic'));
      expect(meta.energyCost, equals(0));
      expect(meta.energy, 0);
    });

    test('has inherent', () {
      var d = MetaMagic.copyWith(meta, inherent: true);
      expect(d.inherent, equals(true));
    });

    test('has energy', () {
      expect(MetaMagic.copyWith(meta, energy: 5).energy, equals(5));
      expect(MetaMagic.copyWith(meta, energy: 7).energy, equals(7));
      expect(MetaMagic.copyWith(meta, energy: 20).energy, equals(20));
    });

    test('has energy cost', () {
      expect(MetaMagic.copyWith(meta, energy: 5).energyCost, equals(5));
      expect(MetaMagic.copyWith(meta, energy: 7).energyCost, equals(7));
      expect(MetaMagic.copyWith(meta, energy: 20).energyCost, equals(20));
    });
  });

  group('Speed', () {
    Speed m;

    setUp(() async {
      m = new Speed();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.energyCost, equals(0));
      expect(m.name, equals("Speed"));
      expect(m.yardsPerSecond, equals(GDistance()));
    });

    test("has inherent", () {
      expect(Speed.copyWith(m, inherent: true).inherent, equals(true));
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
      expect(Speed.copyWith(m, yardsPerSecond: GDistance(yards: 0)).energyCost,
          equals(0));

      expect(Speed.copyWith(m, yardsPerSecond: GDistance(yards: 3)).energyCost,
          equals(1));

      expect(Speed.copyWith(m, yardsPerSecond: GDistance(yards: 5)).energyCost,
          equals(2));

      expect(Speed.copyWith(m, yardsPerSecond: GDistance(yards: 7)).energyCost,
          equals(3));

      expect(Speed.copyWith(m, yardsPerSecond: GDistance(yards: 10)).energyCost,
          equals(4));

      expect(Speed.copyWith(m, yardsPerSecond: GDistance(yards: 15)).energyCost,
          equals(5));

      expect(
          Speed.copyWith(m, yardsPerSecond: GDistance(yards: 150)).energyCost,
          equals(11));

      expect(
          Speed.copyWith(m, yardsPerSecond: GDistance(yards: 200)).energyCost,
          equals(12));

      expect(
          Speed.copyWith(m, yardsPerSecond: GDistance(yards: 300)).energyCost,
          equals(13));
    });
  });

  group("SubjectWeight:", () {
    SubjectWeight m;

    setUp(() async {
      m = SubjectWeight();
    });

    test("has initial state", () {
      expect(m.inherent, equals(false));
      expect(m.energyCost, equals(0));
      expect(m.name, equals("Subject GWeight"));
      expect(m.weight, equals(GWeight(pounds: 10)));
    });

    test("has inherent", () {
      expect(SubjectWeight.copyWith(m, inherent: true).inherent, equals(true));
    });

    test("should have energyCost and weight", () {
      var w = SubjectWeight.copyWith(m, weight: GWeight(pounds: 0));
      expect(w.energyCost, equals(0));

      w = SubjectWeight.copyWith(m, weight: GWeight(pounds: 10));
      expect(w.energyCost, equals(0));

      w = SubjectWeight.copyWith(m, weight: GWeight(pounds: 11));
      expect(w.energyCost, equals(1));

      w = SubjectWeight.copyWith(m, weight: GWeight(pounds: 30));
      expect(w.energyCost, equals(1));

      w = SubjectWeight.copyWith(m, weight: GWeight(pounds: 31));
      expect(w.energyCost, equals(2));

      w = SubjectWeight.copyWith(m, weight: GWeight(pounds: 100));
      expect(w.energyCost, equals(2));

      w = SubjectWeight.copyWith(m, weight: GWeight(pounds: 300));
      expect(w.energyCost, equals(3));

      w = SubjectWeight.copyWith(m, weight: GWeight(pounds: 1000));
      expect(w.energyCost, equals(4));

      w = SubjectWeight.copyWith(m, weight: GWeight(tons: 5));
      expect(w.energyCost, equals(6));

      w = SubjectWeight.copyWith(m, weight: GWeight(tons: 15));
      expect(w.energyCost, equals(7));
    });
  });
}
