## 1.1.5

- Migrate to Flutter 3.13.0

## 1.1.3

- Adds a type alias of Rx class as `Signal`. Allows you to initialize mediator variables with the `Signal` annotation.
  
  For example,
```dart
final _int1 = 0.signal;
final _int2 = Signal(0); 
final _int3 = Signal(0); 
// computed mediator variable
final _sum = Signal(() => int1 + int2 + int3);
```


## 1.1.2

- Upgrade sdk to dart 3.0.0, and use final class.
- Support mediator variable of type `Function`, to use as a **computed** mediator variable.

  For example,
```dart
final _sum = Rx(() => int1 + int2 + int3 as dynamic); // use `dynamic` if the return type along with the computed function will change
get sum => _sum.value;
set sum(value) => _sum.value = value;
```


## 1.1.1

- Minor improvement.


## 1.0.0

- A rework of the flutter mediator package, simple, efficient and easy to use.
