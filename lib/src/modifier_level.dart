import 'package:gurps_ritual_path_magic_model/src/damage_specialization.dart';

class ModifierLevel {
  ModifierLevel(this.specialization);

  ModifierSpecialization specialization;

  int get value => null;
}

class ModifierSpecialization {}

class DamageSpecialization extends ModifierSpecialization {}
