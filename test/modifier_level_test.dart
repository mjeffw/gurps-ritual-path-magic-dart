import 'package:gurps_ritual_path_magic_model/src/modifier_level.dart';
import 'package:test/test.dart';

void main() {
  test('should have specialization', () {
    ModifierLevel level = ModifierLevel(DamageSpecialization());
    expect(level.specialization, isA<DamageSpecialization>());
    expect(level.value, equals(0));
  });
}
