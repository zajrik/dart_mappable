import 'copywith_base.dart';
import 'list_copy_with.dart' show ItemCopyWith;

typedef _Filter<Key, Value> = bool Function(Key, Value);
typedef _Transform<Key, Value> = MapEntry<Key, Value> Function(Key, Value);

/// Interface used for [Map]s in chained copyWith methods
/// All methods return a new modified map and do not modify the original map.
///
/// {@category Copy-With}
abstract class MapCopyWith<Result, Key, Value, Copy> {
  factory MapCopyWith(
    Map<Key, Value> value,
    ItemCopyWith<Copy, Value, Result> item,
    Then<Map<Key, Value>, Result> then,
  ) = _MapCopyWith;

  /// Access the copyWith interface for the value of [key]
  Copy? operator [](Key key);

  /// Access the copyWith interface for the value of [key]
  Copy? get(Key key);

  /// Returns a new map with [value] inserted at [key]
  Result put(Key key, Value v);

  /// Returns a new map with all entries inserted to the map
  Result putAll(Map<Key, Value> v);

  /// Returns a new map with the value at [key] replaced with a new value
  Result replace(Key key, Value v);

  /// Returns a new map without [key]
  Result remove(Key key);

  /// Returns a new map with all entries where [filter] returns `true` removed.
  Result removeWhere(bool Function(Key key, Value value) filter);

  /// Returns a new map with all entries transformed by [transform].
  Result map(MapEntry<Key, Value> Function(Key key, Value value) transform);

  /// Returns a new empty map.
  Result clear();

  /// Applies any transformer function on the value
  Result $update(Map<Key, Value> Function(Map<Key, Value>) transform);
}

class _MapCopyWith<Result, Key, Value, Copy>
    extends CopyWithBase<Result, Map<Key, Value>, Map<Key, Value>>
    implements MapCopyWith<Result, Key, Value, Copy> {
  _MapCopyWith(
    Map<Key, Value> value,
    this._item,
    Then<Map<Key, Value>, Result> then,
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
  Result put(Key key, Value v) => putAll({key: v});

  @override
  Result putAll(Map<Key, Value> v) => $then({...$value, ...v});

  @override
  Result replace(Key key, Value v) => $then({...$value, key: v});

  @override
  Result remove(Key key) => $then({...$value}..remove(key));

  @override
  Result removeWhere(_Filter<Key, Value> filter) => $then({...$value}..removeWhere(filter));

  @override
  Result map(_Transform<Key, Value> transform) => $then($value.map(transform));

  @override
  Result clear() => $then(const {});
}
