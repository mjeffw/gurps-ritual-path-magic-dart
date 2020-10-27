import 'dart:collection';

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

  List<String> get asShortText => sorted.map((e) => e.toStringShort()).toList();

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

  List<EffectsExporter> get _allEffects =>
      [...ritualEffects.sorted, ...castingEffects.sorted];

  List<String> get _allEffectsAsDetailedString =>
      _allEffects.map((a) => a.toStringDetailed()).toList();

  List<ModifiersExporter> get _allModifiers =>
      <ModifiersExporter>[...ritualModifiers, ...castingModifiers]..sort();

  List<String> get _allModifiersAsDetailedString =>
      _allModifiers.map((a) => a.detailedText).toList();

  List<String> get _components =>
      [..._allEffectsAsDetailedString, ..._allModifiersAsDetailedString];

  int energy;
  int baseEnergyCost;
  int totalEffectsMultiplier;
}

class MarkdownCastingExporter extends CastingExporter {
  @override
  String get title => '## ${super.title}';

  @override
  String toString() {
    return '$title\n'
        ' *  _Spell Effects:_ ${ritualEffects.asShortText.reduce(_foldWithPlus)}.\n'
        ' *  _Inherent Modifiers:_ ${_inherentModifiers()}.\n'
        ' *  _Greater Effects:_ $greaterEffects (×$effectsMultiplier).\n'
        '\n'
        '$description\n'
        '\n'
        ' *  _Typical Casting:_ ${_components.reduce(_foldWithPlus)}. '
        '_$energy energy ($baseEnergyCost×$totalEffectsMultiplier)._\n';
  }

  String _inherentModifiers() => ritualModifiers.isNotEmpty
      ? ritualModifiers.map((a) => a.shortText).reduce(_foldWithPlus)
      : 'None';

  String _foldWithPlus(String a, String b) => '$a + $b'.trim();
}
