import 'dart:math';

import 'rx.dart';

class RxList<E> extends RxImpl<List<E>> implements List<E> {
  RxList(List<E> initial) : super(initial);

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  void operator []=(int index, E val) {
    value[index] = val;
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  RxList<E> operator +(Iterable<E> val) {
    addAll(val);
    return this;
  }

  @override
  E operator [](int index) {
    return value[index];
  }

  @override
  void add(E item) {
    value.add(item);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void addAll(Iterable<E> item) {
    value.addAll(item);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void insert(int index, E item) {
    value.insert(index, item);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    value.insertAll(index, iterable);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  int get length => value.length;

  @override
  bool remove(Object? item) {
    final hasRemoved = value.remove(item);
    if (hasRemoved) {
      Subscriber.setToRebuild(rxAspects);
    }
    return hasRemoved;
  }

  @override
  E removeAt(int index) {
    final item = value.removeAt(index);
    Subscriber.setToRebuild(rxAspects);
    return item;
  }

  @override
  E removeLast() {
    final item = value.removeLast();
    Subscriber.setToRebuild(rxAspects);
    return item;
  }

  @override
  void removeRange(int start, int end) {
    value.removeRange(start, end);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void removeWhere(bool Function(E) test) {
    value.removeWhere(test);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void clear() {
    value.clear();
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    value.sort(compare);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  E get first => value.first;

  @override
  E get last => value.last;

  @override
  bool any(bool Function(E) test) {
    return value.any(test);
  }

  @override
  Map<int, E> asMap() {
    return value.asMap();
  }

  @override
  List<R> cast<R>() {
    return value.cast<R>();
  }

  @override
  bool contains(Object? element) {
    return value.contains(element);
  }

  @override
  E elementAt(int index) {
    return value.elementAt(index);
  }

  @override
  bool every(bool Function(E) test) {
    return value.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E) f) {
    return value.expand(f);
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    value.fillRange(start, end, fillValue);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  E firstWhere(bool Function(E) test, {E Function()? orElse}) {
    return value.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T, E) combine) {
    return value.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return value.followedBy(other);
  }

  @override
  void forEach(void Function(E) f) {
    value.forEach(f);
  }

  @override
  Iterable<E> getRange(int start, int end) {
    return value.getRange(start, end);
  }

  @override
  int indexOf(E element, [int start = 0]) {
    return value.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(E) test, [int start = 0]) {
    return value.indexWhere(test, start);
  }

  @override
  String join([String separator = '']) {
    return value.join(separator);
  }

  @override
  int lastIndexOf(E element, [int? start]) {
    return value.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(E) test, [int? start]) {
    return value.lastIndexWhere(test, start);
  }

  @override
  E lastWhere(bool Function(E) test, {E Function()? orElse}) {
    return value.lastWhere(test, orElse: orElse);
  }

  @override
  set length(int newLength) {
    value.length = newLength;
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  Iterable<T> map<T>(T Function(E) f) {
    return value.map(f);
  }

  @override
  E reduce(E Function(E, E) combine) {
    return value.reduce(combine);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    value.replaceRange(start, end, replacement);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void retainWhere(bool Function(E) test) {
    value.retainWhere(test);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  Iterable<E> get reversed => value.reversed;

  @override
  void setAll(int index, Iterable<E> iterable) {
    value.setAll(index, iterable);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    value.setRange(start, end, iterable, skipCount);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  void shuffle([Random? random]) {
    value.shuffle(random);
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  E get single => value.single;

  @override
  E singleWhere(bool Function(E) test, {E Function()? orElse}) {
    return value.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return value.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E) test) {
    return value.skipWhile(test);
  }

  @override
  List<E> sublist(int start, [int? end]) {
    return value.sublist(start, end);
  }

  @override
  Iterable<E> take(int count) {
    return value.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E) test) {
    return value.takeWhile(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return value.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return value.toSet();
  }

  @override
  Iterable<E> where(bool Function(E) test) {
    return value.where(test);
  }

  @override
  Iterable<W> whereType<W>() {
    return value.whereType<W>();
  }

  @override
  set first(E value) {
    this[0] = value;
    // value.first = value;
    Subscriber.setToRebuild(rxAspects);
  }

  @override
  set last(E value) {
    this[length - 1] = value;
    // value.last = value;
    Subscriber.setToRebuild(rxAspects);
  }
}

/// `rx` extension of RxList
extension RxListExt<E> on List<E> {
  RxList<E> get rx => RxList<E>(this);
}
