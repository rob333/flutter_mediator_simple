// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart';

import 'dart:async';

typedef _SubscriberTag = int;
typedef _SubscriberTagSet = Set<_SubscriberTag>;
typedef SubscriberFn = Widget Function(Widget Function() builder, {Key? key});

/// Static Methods/Top Level Functions
final List<Set<Element>> _subscribersList = [];
final _SubscriberTagSet _rebuildSet = {};

Element? _currentBuildingElement;

void _regFutureQueue() {
  // scheduleMicrotask(() {
  // Future.value(0).then((value) {
  Future.microtask(() {
    assert(_rebuildSet.isNotEmpty);
    _shouldRebuild();
    _rebuildSet.clear();
  });
}

void _shouldRebuild() {
  assert(_rebuildSet.isNotEmpty);

  for (final aspect in _rebuildSet) {
    final elements = _subscribersList[aspect];

    var i = 0;
    while (i < elements.length) {
      final elem = elements.elementAt(i);
      if (elem.mounted) {
        i++;
        if (!elem.dirty) {
          elem.markNeedsBuild();
        }
      } else {
        elements.remove(elem);
      }
    }
    // for (final elem in elementSet) {
    //   if (elem.mounted) {
    //     newSet.add(elem);
    //     if (!elem.dirty) {
    //       elem.markNeedsBuild();
    //     }
    //   }
    // }
    // _subscriberList[aspect] = newSet;
  }
}

/// Subscriber Class:
///
/// To register mediator variables used in the builder function to automatically rebuild the widget.
class Subscriber extends StatefulWidget {
  /// Method for rx setter: notify to rebuild widget with aspects.
  static void setToRebuild(_SubscriberTagSet aspects) {
    if (_rebuildSet.isEmpty) {
      _regFutureQueue();
    }
    _rebuildSet.addAll(aspects);
  }

  /// class members:
  final Widget Function() builder;

  /// Contrustor:
  const Subscriber({
    super.key,
    required this.builder,
  });

  @override
  State<Subscriber> createState() => _SubscriberState();
}

class _SubscriberState extends State<Subscriber> {
  @override
  Widget build(BuildContext context) {
    _currentBuildingElement = context as Element;
    final child = widget.builder();
    _currentBuildingElement = null;

    return child;
  }
}

/// ********
/// Class Rx
/// ********
class RxImpl<T> {
  static _SubscriberTag tagCounter = 0;

  /// Members:
  /// Aspects attached to this mediator variable.
  final _SubscriberTagSet aspects = {};

  /// Constructor of RxImpl.
  RxImpl(this._value) {
    assert(_value is! Type);
    final tag = tagCounter++;
    aspects.add(tag);

    /// add to _subscriberList
    _subscribersList.add({});
    assert(_subscribersList.length == tagCounter);
  }

  /// Member functions:
  /// Register the widget with the aspects.
  void _addAspects() {
    if (_currentBuildingElement != null) {
      for (final aspect in aspects) {
        final elements = _subscribersList[aspect];
        elements.add(_currentBuildingElement!);
      }
    }
  }

  /// Underlying value.
  T _value;

  /// Getter of the value.
  get value {
    _addAspects();

    /// WET: getter of value
    if (_value is! Function) {
      return _value;
    }
    // This is a computed mediator variable.
    final fn = _value as Function;
    final res = fn();
    return res;
  }

  /// Setter of the value.
  /// If the newValue != _value, then rebuild widgets according to the aspects.
  set value(newValue) {
    if (_value != newValue) {
      _value = newValue;
      Subscriber.setToRebuild(aspects);
    }
  }

  /// Notify to rebuild widgets according to the aspects.
  ///
  /// Used when the type of the Mediator Variable is of type `Class`.
  get notify {
    Subscriber.setToRebuild(aspects);

    /// WET: getter of value
    if (_value is! Function) {
      return _value;
    }
    // This is a computed mediator variable.
    final fn = _value as Function;
    final res = fn();
    return res;
  }

  /// Return a Subscriber widget for indirect use of this mediator variable.
  ///
  /// **Indirect use** means the Subscriber widget doesn't use the value
  ///  of this mediator variable but depends on it.
  Widget subscribe(Widget Function() builder, {Key? key}) {
    wrapFn() {
      _addAspects();
      final widget = builder();
      return widget;
    }

    final widget = Subscriber(
      key: key,
      builder: wrapFn,
    );
    return widget;
  }

  /// Add [other.aspects] to the aspects of this mediator variable.
  void addAspects(RxImpl other) {
    aspects.addAll(other.aspects);
  }

  /// Remove [other.aspects] from the aspects of this mediator variable.
  void removeAspects(RxImpl other) {
    aspects.removeAll(other.aspects);
  }

  /// Retain [other.aspects] of this mediator variable.
  void retainAspects(RxImpl other) {
    aspects.retainAll(other.aspects);
  }

  // /// Clear all the Rx aspects.
  // void clearAspects() => aspects.clear();

  //* override method
  @override
  String toString() => _value.toString();
}

/// Class for general Mediator Variables
/// Rx<T> class
final class Rx<T> extends RxImpl<T> {
  /// Constructor: With `initial` as initial value.
  Rx(T initial) : super(initial);
}

/// Extension for Rx Class.
/// `rx` extension of Rx
extension RxExt<T> on T {
  /// Returns a `Rx` instace with [this] of type `T` as the initial value.
  Rx<T> get rx => Rx<T>(this);
}
