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
        // debugPrint("before remove: $elementSet");
        elements.remove(elem);
        // debugPrint("after remove: $elementSet");
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

///
/// Class Computed
///
class Computed {
  Function _value;

  Computed(this._value);

  /// Getter of the value.
  get value {
    final res = _value();
    return res;
  }

  /// Setter of the value.
  set value(newValue) {
    assert(newValue is Function);
    if (newValue != _value) {
      _value = newValue;
    }
  }
}

/// ***
/// Class Rx
/// ***
class RxImpl<T> {
  static _SubscriberTag rxTagCounter = 0;

  /// Member functions:
  /// Register the aspects to the widget.
  void _addRxAspects() {
    if (_currentBuildingElement != null) {
      for (final aspect in rxAspects) {
        final elements = _subscribersList[aspect];
        elements.add(_currentBuildingElement!);
      }
    }
  }

  /// Members:
  /// Aspects attached to this mediator variable.
  final _SubscriberTagSet rxAspects = {};

  /// Constructor of RxImpl.
  RxImpl(this._value) {
    assert(_value is! Type);

    if (_value is! Function) {
      final tag = rxTagCounter++;
      rxAspects.add(tag);

      /// add to _subscriberList
      _subscribersList.add({});
      assert(_subscribersList.length == rxTagCounter);
    }
  }

  /// The underlying value with type of T.
  T _value;

  /// Getter of the value.
  T get value {
    _addRxAspects();
    return _value;
  }

  /// Setter of the value.
  /// If the newValue != _value, then rebuild widgets according to the rxAspects.
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      Subscriber.setToRebuild(rxAspects);
    }
  }

  /// Notify to rebuild widgets according to the rxAspects.
  ///
  /// Used when the type of the Mediator Variable is of type `Class`.
  T get notify {
    Subscriber.setToRebuild(rxAspects);
    return _value;
  }

  /// Return a Subscriber widget for indirect use of this mediator variable.
  ///
  /// **Indirect use** means the Subscriber widget doesn't use the value
  ///  of this mediator variable but depends on it.
  Widget subscribe(Widget Function() builder, {Key? key}) {
    wrapFn() {
      _addRxAspects();
      final widget = builder();
      return widget;
    }

    return Subscriber(
      key: key,
      builder: wrapFn,
    );
  }

  /// Add [other.rxAspects] to the aspects of this mediator variable.
  void addAspects(RxImpl other) {
    rxAspects.addAll(other.rxAspects);
  }

  /// Remove [other.rxAspects] from the aspects of this mediator variable.
  void removeAspects(RxImpl other) {
    rxAspects.removeAll(other.rxAspects);
  }

  /// Retain [other.rxAspects] of this mediator variable.
  void retainAspects(RxImpl other) {
    rxAspects.retainAll(other.rxAspects);
  }

  // /// Clear all the Rx aspects.
  // void clearRxAspects() => rxAspects.clear();

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
