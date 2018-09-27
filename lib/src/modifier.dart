class Modifier {
  const Modifier(this.name, { this.defaultLevel: 0});

  final String name;
  final int defaultLevel;

  @override
  String toString() => name;

  static var affliction = Modifier('Affliction');
  static var alteredTrait = Modifier('Altered Traits');
  static var areaOfEffect = Modifier('Area of Effect', defaultLevel: 1);
  static var bestowsBonus = Modifier('Bestows a Bonus');
  static var bestowsPenalty = Modifier('Bestows a Penalty');
  static var damage = Modifier('Damage');
  static var duration = Modifier('Duration');
  static var extraEnergy = Modifier('Extra Energy');
  static var healing = Modifier('Healing');
  static var metaMagic = Modifier('Meta-Magic');
  static var range = Modifier('Range');
  static var speed = Modifier('Speed');
  static var subjectWeight = Modifier('Subject Weight');

  static Map<String, Modifier> _values = {
    affliction.name: affliction,
    alteredTrait.name: alteredTrait,
    areaOfEffect.name: areaOfEffect,
    bestowsBonus.name: bestowsBonus,
    bestowsPenalty.name: bestowsPenalty,
    damage.name: damage,
    duration.name: duration,
    extraEnergy.name: extraEnergy,
    healing.name: healing,
    metaMagic.name: metaMagic,
    range.name: range,
    speed.name: speed,
    subjectWeight.name: subjectWeight,
  };

  static Modifier fromString(String name) => _values[name];
}
