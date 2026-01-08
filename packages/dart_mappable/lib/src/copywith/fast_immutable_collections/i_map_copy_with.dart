import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../copywith_base.dart';
import '../list_copy_with.dart' show ItemCopyWith;

typedef _Filter<Key, Value> = bool Function(Key, Value);
typedef _Transform<Key, Value> = MapEntry<Key, Value> Function(Key, Value);

/// Interface used for [IMap]s in chained copyWith methods
///
/// {@category Copy-With}
abstract class IMapCopyWith<Result, Key, Value, Copy> {
  factory IMapCopyWith(
    IMap<Key, Value> value,
    ItemCopyWith<Copy, Value, Result> item,
    Then<IMap<Key, Value>, Result> then,
  ) = _IMapCopyWith;

  /// Access the copyWith interface for the value of [key]
  Copy? operator [](Key key);

  /// Access the copyWith interface for the value of [key]
  Copy? get(Key key);

  /// Returns a new imap with [value] inserted at [key]
  Result put(Key key, Value v);

  /// Returns a new imap with all entries inserted to the map
  Result putAll(IMap<Key, Value> v);

  /// Returns a new imap with the value at [key] replaced with a new value
  Result replace(Key key, Value v);

  /// Returns a new imap without [key]
  Result remove(Key key);

  /// Returns a new map with all entries where `filter` returns `true` removed.
  Result removeWhere(bool Function(Key key, Value value) filter);

  /// Returns a new map with all entries transformed by [transform].
  Result map(MapEntry<Key, Value> Function(Key key, Value value) transform);

  /// Returns a new empty map.
  Result clear();

  /// Applies any transformer function on the value
  Result $update(IMap<Key, Value> Function(IMap<Key, Value>) transform);
}

class _IMapCopyWith<Result, Key, Value, Copy>
    extends CopyWithBase<Result, IMap<Key, Value>, IMap<Key, Value>>
    implements IMapCopyWith<Result, Key, Value, Copy> {
  _IMapCopyWith(
    IMap<Key, Value> value,
    this._item,
    Then<IMap<Key, Value>, Result> then,
  ) : super(value, $identity, then);
  final ItemCopyWith<Copy, Value, Result> _item;

  @override
  Copy? operator [](Key key) => get(key);

  @override
  Copy? get(Key key) =>
      $value[key] is Value
          ? _item($value[key] as Value, (v) => replace(key, v))
          : null;

  @override
  Result put(Key key, Value v) => $then($value.add(key, v));

  @override
  Result putAll(IMap<Key, Value> v) => $then($value.addAll(v));

  @override
  Result replace(Key key, Value v) => $then($value.add(key, v));

  @override
  Result remove(Key key) => $then($value.remove(key));

  @override
  Result removeWhere(_Filter<Key, Value> filter) => $then($value.removeWhere(filter));

  @override
  Result map(_Transform<Key, Value> transform) => $then($value.map(transform));

  @override
  Result clear() => $then($value.clear());
}
