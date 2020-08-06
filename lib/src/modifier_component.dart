import 'package:meta/meta.dart';

import 'modifier.dart';

@immutable
class ModifierComponent {
  ModifierComponent(Modifier m,
      {bool inherent: false, String variation, int level, this.detail})
      : assert(m != null),
        this.modifier = m,
        this.isInherent = inherent,
        this.variation = _validVariation(m, variation),
        this.level = _calculateLevel(m, level);

  final Modifier modifier;
  final bool isInherent;
  final String variation;
  final int level;
  final String detail;

  int get cost => 0;

  String get notes => '';

  static int _calculateLevel(Modifier m, int level) {
    return m.isValidLevel(level) ? level : m.defaultLevel;
  }

  static String _validVariation(Modifier m, String variation) {
    if (variation != null && !m.validVariation(variation)) {
      throw 'Invalid variation "$variation" for modifier ${m.name}';
    }
    return variation;
  }
}
