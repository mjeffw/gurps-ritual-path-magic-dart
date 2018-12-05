import 'modifier.dart';

class ModifierComponent {
  final Modifier modifier;
  bool isInherent;

  ModifierComponent(Modifier m, {bool inherent: false})
      : assert(m != null),
        this.modifier = m,
        this.isInherent = inherent;

  int get cost => 0;

  int get level => 0;

  String get notes => '';
}
