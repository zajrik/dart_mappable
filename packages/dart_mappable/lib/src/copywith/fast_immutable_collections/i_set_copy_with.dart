import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../copywith_base.dart';
import '../list_copy_with.dart';

/// Interface used for [ISet]s in chained copyWith methods
///
/// {@category Copy-With}
abstract class ISetCopyWith<Result, Elem, Copy> {
  factory ISetCopyWith(
    ISet<Elem> value,
    ItemCopyWith<Copy, Elem, Result> item,
    Then<ISet<Elem>, Result> then,
  ) = _ISetCopyWith;

  /// Returns a new iset with the element [e] added
  Result add(Elem e);

  /// Returns a new iset with all items in [e] added
  Result addAll(Iterable<Elem> e);

  /// Returns a new iset without the element [e]
  Result remove(Elem e);

  /// Returns a new iset with the element [a] replaced with [b]
  Result replace(Elem a, Elem b);

  /// Returns a filtered iset with only the items the pass [test]
  Result where(bool Function(Elem) test);

  /// Returns a new empty iset.
  Result clear();

  /// Applies any transformer function on the value
  Result $update(ISet<Elem> Function(ISet<Elem>) transform);
}

class _ISetCopyWith<Result, Elem, Copy>
    extends CopyWithBase<Result, ISet<Elem>, ISet<Elem>>
    implements ISetCopyWith<Result, Elem, Copy> {
  _ISetCopyWith(ISet<Elem> value, _, Then<ISet<Elem>, Result> then)
    : super(value, $identity, then);

  @override
  Result add(Elem e) => addAll([e]);

  @override
  Result addAll(Iterable<Elem> e) => $then($value.addAll(e));

  @override
  Result remove(Elem e) => $then($value.remove(e));

  @override
  Result replace(Elem a, Elem b) => $then($value.remove(a).add(b));

  @override
  Result where(bool Function(Elem) test) => $then($value.where(test).toISet());

  @override
  Result clear() => $then($value.clear());
}
