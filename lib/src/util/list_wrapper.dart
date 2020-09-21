import 'package:collection/collection.dart';

/// Use this to get a proper hashCode and == implementation for lists.
class ListWrapper {
  const ListWrapper(this.source);

  final List<dynamic> source;

  @override
  int get hashCode => DeepCollectionEquality.unordered().hash(source);

  bool equals(Object other) =>
      DeepCollectionEquality.unordered().equals(other, source);

  @override
  bool operator ==(Object other) => equals(other);
}
