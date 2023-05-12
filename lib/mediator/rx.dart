// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart';

import 'dart:async';

typedef _SubscriberTag = int;
typedef _SubscriberTagSet = Set<_SubscriberTag>;
typedef SubscriberFn = Widget Function(Widget Function() builder, {Key? key});

/// Static Methods/Top Level functions
final List<Set<BuildContext>> _subscriberList = [];
final _SubscriberTagSet _rebuildSet = {};

BuildContext? _currentBuildingContext;
bool _isSetRebuild = false;

void _regFutureQueue() {
  assert(_isSetRebuild == true);
  // scheduleMicrotask(() {
  // Future.value(0).then((value) {
  Future.microtask(() {
    assert(_rebuildSet.isNotEmpty);

    _shouldRebuild();
    _rebuildSet.clear();
    _isSetRebuild = false;
  });
}

void _shouldRebuild() {
  assert(_rebuildSet.isNotEmpty);

  for (final aspect in _rebuildSet) {
    final contextSet = _subscriberList[aspect];
    final Set<BuildContext> newSet = {};

    for (final context in contextSet) {
      final elem = context as Element;
      if (elem.mounted) {
        if (!elem.dirty) {
          elem.markNeedsBuild();
        }
        newSet.add(context);
      }
    }

    _subscriberList[aspect] = newSet;
  }
}

/// Subscriber widget class
///
/// To register Mediator Variables for automatic rebuild.
class Subscriber extends StatefulWidget {
  /// Method for rx getter: register the widget with aspects.
  static void _addRxAspects(_SubscriberTagSet aspects) {
    if (_currentBuildingContext != null) {
      for (final aspect in aspects) {
        final contextList = _subscriberList[aspect];
        contextList.add(_currentBuildingContext!);
      }
    }
  }

  /// Method for rx setter: notify to rebuild widget with aspects.
  static void setToRebuild(_SubscriberTagSet aspects) {
    _rebuildSet.addAll(aspects);
    if (!_isSetRebuild) {
      _isSetRebuild = true;
      _regFutureQueue();
    }
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
    _currentBuildingContext = context;
    final child = widget.builder();
    _currentBuildingContext = null;

    return child;
  }
}

/// ***
/// Class Rx
/// ***
class RxImpl<T> {
  /// Member:
  static _SubscriberTag rxTagCounter = 0;

  // Aspects attached to the Mediator Variable
  final _SubscriberTagSet rxAspects = {};

  /// Constructor of RxImpl
  RxImpl(this._value) {
    assert(_value is! Type);
    final tag = rxTagCounter++;
    rxAspects.add(tag);

    // add context list to _subscriberList
    // final Set<BuildContext> contextList = {};
    _subscriberList.add({});
    assert(_subscriberList.length == rxTagCounter);
  }

  /// The underlying value with type of T
  T _value;

  /// Getter of the Rx Object:
  T get value {
    Subscriber._addRxAspects(rxAspects);
    return _value;
  }

  /// Setter of the Rx object:
  /// If the `newValue` != _value, then it will set to rebuild the corresponding widgets.
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      Subscriber.setToRebuild(rxAspects);
    }
  }

  /// Notify to rebuild with the aspects of this Mediator Variable.
  ///
  /// Used when the type of the Mediator Variable is of type `Class`.
  T get notify {
    Subscriber.setToRebuild(rxAspects);
    return _value;
  }

  /// Add the aspects of this Mediator Variable to update set.
  void touch() {
    Subscriber._addRxAspects(rxAspects);
  }

  /// To create a Subscriber widget for indirect use of the mediator variable.
  ///
  /// **Indirect use** means the Subscriber widget doesn't use the value
  ///  of the mediator variable but depends on it.
  Widget subscribe(Widget Function() builder, {Key? key}) {
    wrapFn() {
      touch();
      return builder();
    }

    return Subscriber(
      key: key,
      builder: wrapFn,
    );
  }

  /// Add [other.rxAspects] to the aspects of this Mediator Variable.
  void addAspects(RxImpl other) {
    rxAspects.addAll(other.rxAspects);
  }

  /// Remove [other.rxAspects] from the aspects of this Mediator Variable.
  void removeAspects(RxImpl other) {
    rxAspects.removeAll(other.rxAspects);
  }

  /// Retain [other.rxAspects] of this Mediator Variable.
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
class Rx<T> extends RxImpl<T> {
  /// Constructor: With `initial` as initial value.
  Rx(T initial) : super(initial);
}

/// Extension for Rx Class.
/// `rx` extension of Rx
extension RxExt<T> on T {
  /// Returns a `Rx` instace with [this] of type `T` as the initial value.
  Rx<T> get rx => Rx<T>(this);
}
