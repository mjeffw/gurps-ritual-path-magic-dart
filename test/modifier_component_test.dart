import 'package:test/test.dart';

import '../lib/src/modifier.dart';
import '../lib/src/modifier_component.dart';

void main() {
  test('should throw if Modifier is null', () {
    expect(() => ModifierComponent(null), throwsA(anything));
  });

  test('should require a Modifier', () {
    ModifierComponent m = ModifierComponent(Modifier.range);
    expect(m.modifier, same(Modifier.range));
    expect(m.isInherent, equals(false));
    expect(m.cost, equals(0));
  });
}
