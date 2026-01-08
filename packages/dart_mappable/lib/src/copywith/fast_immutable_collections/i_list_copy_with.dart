import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../copywith_base.dart';
import '../list_copy_with.dart';

/// Interface used for [IList]s in chained copyWith methods
///
/// {@category Copy-With}
abstract class IListCopyWith<Result, Elem, Copy> {
  factory IListCopyWith(
    IList<Elem> value,
    ItemCopyWith<Copy, Elem, Result> item,
    Then<IList<Elem>, Result> then,
  ) = _IListCopyWith;

  /// Access the copyWith interface for the item at [index]
  Copy operator [](int index);

  /// Access the copyWith interface for the item at [index]
  Copy at(int index);

  /// Returns a new list with the item added to the end of the list
  Result add(Elem v);

  /// Returns a new list with the items added to the end of the list
  Result addAll(Iterable<Elem> v);

  /// Returns a new list with the item at [index] replaced with a new value
  Result replace(int index, Elem v);

  /// Returns a new list with the item inserted at [index]
  Result insert(int index, Elem v);

  /// Returns a new list with the items inserted at [index]
  Result insertAll(int index, Iterable<Elem> v);

  /// Returns a new list without the item at [index]
  Result removeAt(int index);

  /// Returns a new spliced list with [removeCount] items removed and [toInsert] inserted at [index]
  Result splice(int index, int removeCount, [Iterable<Elem>? toInsert]);

  /// Returns a new list with only the first [count] items
  Result take(int count);

  /// Returns a new list without the first [count] items
  Result skip(int count);

  /// Returns a filtered list with only the items the pass [test]
  Result where(bool Function(Elem) test);

  /// Returns a new list with items at index [start] inclusive to [end] exclusive.
  Result sublist(int start, [int? end]);

  /// Applies any transformer function on the value
  Result $update(IList<Elem> Function(IList<Elem>) transform);
}

class _IListCopyWith<Result, Elem, Copy>
    extends CopyWithBase<Result, IList<Elem>, IList<Elem>>
    implements IListCopyWith<Result, Elem, Copy> {
  _IListCopyWith(IList<Elem> value, this._item, Then<IList<Elem>, Result> then)
    : super(value, $identity, then);
  final ItemCopyWith<Copy, Elem, Result> _item;

  @override
  Copy operator [](int index) => at(index);

  @override
  Copy at(int index) => _item($value[index], (v) => replace(index, v));

  @override
  Result add(Elem v) => addAll([v]);

  @override
  Result addAll(Iterable<Elem> v) => $then($value.addAll(v));

  @override
  Result replace(int index, Elem v) => splice(index, 1, [v]);

  @override
  Result insert(int index, Elem v) => insertAll(index, [v]);

  @override
  Result insertAll(int index, Iterable<Elem> v) => splice(index, 0, v);

  @override
  Result removeAt(int index) => splice(index, 1);

  @override
  Result splice(int index, int removeCount, [Iterable<Elem>? toInsert]) =>
      $then([
        ...$value.take(index),
        if (toInsert != null) ...toInsert,
        ...$value.skip(index + removeCount),
      ].lock);

  @override
  Result take(int count) => $then($value.take(count).toIList());

  @override
  Result skip(int count) => $then($value.skip(count).toIList());

  @override
  Result where(bool Function(Elem) test) => $then($value.where(test).toIList());

  @override
  Result sublist(int start, [int? end]) => $then($value.sublist(start, end));
}
