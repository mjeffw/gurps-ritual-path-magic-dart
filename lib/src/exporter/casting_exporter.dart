abstract class RitualExporter {
  String title;
  List<String> spellEffects = [];
  List<String> spellEffectsDetailed = [];
  List<String> modifiers = [];
  List<String> modifiersDetailed = [];
  int greaterEffects;
  int effectsMultiplier;
  String description;
}

class CastingExporter extends RitualExporter {
  @override
  String toString() {
    return '';
  }

  List<String> get components =>
      [...spellEffectsDetailed, ...modifiersDetailed];

  int energy;
  int baseEnergyCost;
  int totalEffectsMultiplier;
}

class MarkdownCastingExporter extends CastingExporter {
  @override
  String get title => '##${super.title}';

  @override
  String toString() {
    return '''
$title
   _Spell Effects:_ ${spellEffects.reduce(_fold)}.
   _Inherent Modifiers:_ ${modifiers.reduce(_fold)}.
   _Greater Effects:_ $greaterEffects (×$effectsMultiplier).

   $description

   _Typical Casting:_ ${components.reduce(_foldWithPlus)}. _$energy energy ($baseEnergyCost×$totalEffectsMultiplier)._
''';
  }

  String _fold(String a, String b) => '$a $b'.trim();
  String _foldWithPlus(String a, String b) => '$a + $b'.trim();
}
