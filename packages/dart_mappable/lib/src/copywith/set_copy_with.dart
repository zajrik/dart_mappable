import 'copywith_base.dart';
import 'list_copy_with.dart';

/// Interface used for [Set]s in chained copyWith methods.
/// All methods return a new modified set and do not modify the original set.
///
/// {@category Copy-With}
abstract class SetCopyWith<Result, Elem, Copy> {
  factory SetCopyWith(
    Set<Elem> value,
    ItemCopyWith<Copy, Elem, Result> item,
    Then<Set<Elem>, Result> then,
  ) = _SetCopyWith;

  /// Returns a new set with the element [e] added
  Result add(Elem e);

  /// Returns a new set with all items in [e] added
  Result addAll(Iterable<Elem> e);

  /// Returns a new set without the element [e]
  Result remove(Elem e);

  /// Returns a new set with the element [a] replaced with [b]
  Result replace(Elem a, Elem b);

  /// Returns a filtered set with only the items the pass [test]
  Result where(bool Function(Elem) test);

  /// Returns a new empty set.
  Result clear();

  /// Applies any transformer function on the value
  Result $update(Set<Elem> Function(Set<Elem>) transform);
}

class _SetCopyWith<Result, Elem, Copy>
    extends CopyWithBase<Result, Set<Elem>, Set<Elem>>
    implements SetCopyWith<Result, Elem, Copy> {
  _SetCopyWith(Set<Elem> value, _, Then<Set<Elem>, Result> then)
    : super(value, $identity, then);

  @override
  Result add(Elem e) => addAll([e]);

  @override
  Result addAll(Iterable<Elem> e) => $then({...$value}..addAll(e));

  @override
  Result remove(Elem e) => $then({...$value}..remove(e));

  @override
  Result replace(Elem a, Elem b) => $then({...$value}..remove(a)..add(b));

  @override
  Result where(bool Function(Elem) test) => $then($value.where(test).toSet());

  @override
  Result clear() => $then(const {});
}
