import 'package:meta/meta.dart';

import 'modifier.dart';

@immutable
class ModifierComponent {
  const ModifierComponent(Modifier m, {bool inherent: false})
      : assert(m != null),
        this.modifier = m,
        this.isInherent = inherent;

  final Modifier modifier;
  final bool isInherent;

  int get cost => 0;

  int get level => 0;

  String get notes => '';
}
