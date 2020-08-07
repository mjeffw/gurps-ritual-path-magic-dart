class ModifierLevel {
  ModifierLevel(this.specialization);

  ModifierSpecialization specialization;

  int get value => null;
}

class ModifierSpecialization {}

class DamageSpecialization extends ModifierSpecialization {}
