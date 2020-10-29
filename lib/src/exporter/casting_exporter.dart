import 'dart:collection';

String foldWithPlus(String a, String b) => '$a + $b'.trim();

class EffectsExporter implements Comparable<EffectsExporter> {
  String path;
  String level;
  String effect;
  int energyCost;

  @override
  int compareTo(EffectsExporter other) => '$path $effect $level'
      .compareTo('${other.path} ${other.effect} ${other.level}');

  String toStringDetailed() => '$level $effect $path ($energyCost)';

  String toStringShort() => '$level $effect $path';
}

class EffectsExporterList with ListMixin<EffectsExporter> {
  List<EffectsExporter> _source = [];

  @override
  int get length => _source.length;

  @override
  void set length(int newLength) => _source.length = newLength;

  @override
  EffectsExporter operator [](int index) => _source[index];

  @override
  void operator []=(int index, EffectsExporter value) => _source[index] = value;

  List<EffectsExporter> get sorted => _source..sort();

  List<String> get asShortText {
    var list = sorted.map((e) => e.toStringShort()).toList();

    var result = <String>[];

    while (list.isNotEmpty) {
      String item = list.removeAt(0);

      var repetitions = list.where((element) => item == element).length + 1;
      if (repetitions > 1) {
        list.removeWhere((element) => item == element);
        item = '$item ×$repetitions';
      }

      result.add(item);
    }
    return result;
  }

  List<String> get asDetailedText =>
      sorted.map((e) => e.toStringDetailed()).toList();
}

class ModifiersExporter implements Comparable<ModifiersExporter> {
  String name;
  String shortText;
  String detailedText;

  @override
  int compareTo(ModifiersExporter other) =>
      '$name $shortText'.compareTo('${other.name} ${other.shortText}');
}

class ModifiersExporterList with ListMixin<ModifiersExporter> {
  List<ModifiersExporter> _source = [];

  @override
  int get length => _source.length;

  @override
  void set length(int newLength) => _source.length = newLength;

  @override
  ModifiersExporter operator [](int index) => _source[index];

  @override
  void operator []=(int index, ModifiersExporter value) =>
      _source[index] = value;

  List<ModifiersExporter> get sorted => _source..sort();

  List<String> get asShortText => sorted.map((e) => e.shortText).toList();

  List<String> get asDetailedText => sorted.map((e) => e.detailedText).toList();
}

abstract class RitualExporter {
  String title;
  EffectsExporterList ritualEffects = EffectsExporterList();
  ModifiersExporterList ritualModifiers = ModifiersExporterList();
  int greaterEffects;
  int effectsMultiplier;
  String description;
}

class CastingExporter extends RitualExporter {
  ModifiersExporterList castingModifiers = ModifiersExporterList();
  EffectsExporterList castingEffects = EffectsExporterList();

  @override
  String toString() {
    return '';
  }

  List<EffectsExporter> get allEffects =>
      [...ritualEffects.sorted, ...castingEffects.sorted];

  List<String> get allEffectsAsDetailedString =>
      allEffects.map((a) => a.toStringDetailed()).toList();

  List<ModifiersExporter> get allModifiers =>
      <ModifiersExporter>[...ritualModifiers, ...castingModifiers]..sort();

  List<String> get allModifiersAsDetailedString =>
      allModifiers.map((a) => a.detailedText).toList();

  List<String> get components =>
      [...allEffectsAsDetailedString, ...allModifiersAsDetailedString];

  int energy;
  int baseEnergyCost;
  int totalEffectsMultiplier;
}

class MarkdownCastingExporter extends CastingExporter {
  @override
  String get title => '## ${super.title ?? ''}';

  @override
  String toString() => '$title\n'
      ' *  _Spell Effects:_ $_inherentEffects.\n'
      ' *  _Inherent Modifiers:_ ${_inherentModifiers()}.\n'
      ' *  _Greater Effects:_ $greaterEffects (×$effectsMultiplier).\n'
      '\n'
      '${description ?? ''}\n'
      '\n'
      ' *  _Typical Casting:_ ${_allComponents}. '
      '_$energy energy ($baseEnergyCost×$totalEffectsMultiplier)._\n';

  String _inherentModifiers() => ritualModifiers.isNotEmpty
      ? ritualModifiers.map((a) => a.shortText).reduce(foldWithPlus)
      : 'None';

  String get _inherentEffects => ritualEffects.isNotEmpty
      ? ritualEffects.asShortText.reduce(foldWithPlus)
      : 'None';

  String get _allComponents =>
      components.isNotEmpty ? components.reduce(foldWithPlus) : 'None';
}
