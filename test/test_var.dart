import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mediator_simple/flutter_mediator_simple.dart';

// Mediator Variable: int1
final _int1 = 0.rx; // or `final _int1 = Rx(0);`
int get int1 => _int1.value;
set int1(value) => _int1.value = value;

/// Mediator Variable: int2
final _int2 = 0.rx; // or `final _int2 = Rx(0);`
int get int2 => _int2.value;
set int2(value) => _int2.value = value;

/// Mediator Variable: int3
final _int3 = Rx(0); // or `final _int3 = 0.rx;`
int get int3 => _int3.value;
set int3(value) => _int3.value = value;

/// Computed Mediator Variable: sum
final _sum = Rx(() => int1 + int2 + int3 as dynamic);
get sum => _sum.value;
set sum(value) => _sum.value = value;

/// List page
// Mediator Variable: data
final _data = <ListItem>[].rx; //or `RxList(<ListItem>[]);`
List<ListItem> get data => _data.value;
set data(List<ListItem> value) => _data.value = value;
SubscriberFn get dataSubscribe => _data.subscribe;
List<ListItem> get dataNotify => _data.notify;

class ListItem {
  const ListItem(this.item, this.units, this.color);

  final String item;
  final int units;
  final Color color;
}

//* item data
const int maxItems = 35;
const int maxUnits = 100;
const List<String> itemNames = [
  'Pencil',
  'Binder',
  'Pen',
  'Desk',
  'Pen Set',
];
const List<Color> itemColors = [
  Colors.pink,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.lightGreen,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

void updateListItem() {
  final units = Random().nextInt(maxUnits) + 1;
  final itemIdx = Random().nextInt(itemNames.length);
  final itemName = itemNames[itemIdx];
  final color = itemColors[Random().nextInt(itemColors.length)];
  if (data.length >= maxItems) data.clear();

  //* Make an update to the collection type mediator variable.
  // data.add(ListItem(itemName, units, color));
  _data.notify.add(ListItem(itemName, units, color)); // notify  to rebuild
}
