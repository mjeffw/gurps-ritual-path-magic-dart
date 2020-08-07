import 'package:meta/meta.dart';

import 'ritual_modifier.dart';

@immutable
class ModifierComponent {
  ModifierComponent(RitualModifier m,
      {bool inherent: false, String variation, int level, this.detail})
      : assert(m != null),
        this.modifier = m,
        this.isInherent = inherent,
        this.variation = _validVariation(m, variation),
        this.level = _calculateLevel(m, level);

  final RitualModifier modifier;
  final bool isInherent;
  final String variation;
  final int level;
  final String detail;

  int get cost => 0;

  String get notes => '';

  static int _calculateLevel(RitualModifier m, int level) {
    return m.isValidLevel(level) ? level : m.defaultLevel;
  }

  static String _validVariation(RitualModifier m, String variation) {
    if (variation != null && !m.validVariation(variation)) {
      throw 'Invalid variation "$variation" for modifier ${m.name}';
    }
    return variation;
  }
}
