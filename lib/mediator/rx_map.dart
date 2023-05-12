import 'rx.dart';

class RxMap<K, V> extends RxImpl<Map<K, V>> implements Map<K, V> {
  RxMap(Map<K, V> initial) : super(initial);

  @override
  V operator [](Object? key) {
    return value[key]!;
  }

  @override
  void operator []=(K key, V newValue) {
    value[key] = newValue;
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void addAll(Map<K, V> other) {
    value.addAll(other);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    value.addEntries(entries);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void clear() {
    value.clear();
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  Map<K2, V2> cast<K2, V2>() => value.cast<K2, V2>();

  @override
  bool containsKey(Object? key) => value.containsKey(key);

  @override
  bool containsValue(Object? comp) => value.containsValue(comp);

  @override
  Iterable<MapEntry<K, V>> get entries => value.entries;

  @override
  void forEach(void Function(K, V) f) {
    value.forEach(f);
  }

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  Iterable<K> get keys => value.keys;

  @override
  int get length => value.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform) =>
      value.map(transform);

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final val = value.putIfAbsent(key, ifAbsent);
    Subscriber.setToRebuild(rxAspects);
    return val;
  }

  @override
  V remove(Object? key) {
    final val = value.remove(key);
    Subscriber.setToRebuild(rxAspects);
    return val!;
  }

  @override
  void removeWhere(bool Function(K, V) test) {
    value.removeWhere(test);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  Iterable<V> get values => value.values;

  @override
  String toString() => value.toString();

  @override
  V update(K key, V Function(V) update, {V Function()? ifAbsent}) {
    final val = value.update(key, update, ifAbsent: ifAbsent);
    Subscriber.setToRebuild(rxAspects);
    return val;
  }

  @override
  void updateAll(V Function(K, V) update) {
    value.updateAll(update);
    Subscriber.setToRebuild(rxAspects);
  }
}

/// `rx` extension of RxMap
extension RxMapExt<K, V> on Map<K, V> {
  RxMap<K, V> get rx => RxMap<K, V>(this);
}
