import 'package:flutter/widgets.dart';
import '../flutter_mediator_simple.dart';

class RxImpl<T> {
  /// Member:
  static SubscriberTag rxTagCounter = 0;

  // Aspects attached to the Mediator Variable
  final SubscriberTagSet rxAspects = {};

  /// Constructor of RxImpl
  RxImpl(this._value) {
    assert(_value is! Type);
    final tag = rxTagCounter++;
    rxAspects.add(tag);
  }

  /// The underlying value with type of T
  T _value;

  /// Getter of the Rx Object:
  T get value {
    Subscriber.addRxAspects(rxAspects);
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
    Subscriber.addRxAspects(rxAspects);
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
