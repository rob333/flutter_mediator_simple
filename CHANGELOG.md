## 1.1.2

- Add `Computed` class, for compound mediator variables.


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For example,
```dart
final _sum = Computed(() => int1 + int2 + int3);
get sum => _sum.value;
set sum(value) => _sum.value = value;
```


## 1.1.1

- Minor improvement.


## 1.0.0

- A rework of the flutter mediator package, simple, efficient and easy to use.
