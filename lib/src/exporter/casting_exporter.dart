import '../spell_effect.dart';

abstract class RitualExporter {
  String title;
  List<String> ritualEffects = [];
  List<String> ritualEffectsDetailed = [];
  List<String> ritualModifiers = [];
  List<String> ritualModifiersDetailed = [];
  int greaterEffects;
  int effectsMultiplier;
  String description;
}

class CastingExporter extends RitualExporter {
  List<String> castingModifiersDetailed = [];
  List<String> castingEffectsDetailed = [];

  @override
  String toString() {
    return '';
  }

  List<String> get allEffects =>
      <String>[...ritualEffectsDetailed, ...castingEffectsDetailed]..sort();

  List<String> get allModifiers =>
      <String>[...ritualModifiersDetailed, ...castingModifiersDetailed]..sort();

  List<String> get components => [...allEffects, ...allModifiers];

  int energy;
  int baseEnergyCost;
  int totalEffectsMultiplier;
}

class MarkdownCastingExporter extends CastingExporter {
  @override
  String get title => '##${super.title}';

  @override
  String toString() {
    return '$title\n'
        '   _Spell Effects:_ ${ritualEffects.reduce(_fold)}.\n'
        '   _Inherent Modifiers:_ ${ritualModifiers.reduce(_fold)}.\n'
        '   _Greater Effects:_ $greaterEffects (×$effectsMultiplier).\n'
        '\n'
        '   $description\n'
        '\n'
        '   _Typical Casting:_ ${components.reduce(_foldWithPlus)}. '
        '_$energy energy ($baseEnergyCost×$totalEffectsMultiplier)._';
  }

  String _fold(String a, String b) => '$a $b'.trim();
  String _foldWithPlus(String a, String b) => '$a + $b'.trim();
}
