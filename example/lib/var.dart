import 'dart:math';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mediator_simple/flutter_mediator_simple.dart';

/// Mediator Variable: int1
final _int1 = 0.rx; // or `final _int1 = Rx(0);`
int get int1 => _int1.value;
set int1(value) => _int1.value = value;

/// Mediator Variable: int2
final _int2 = 0.signal; // or `final _int2 = Signal(0);`
int get int2 => _int2.value;
set int2(value) => _int2.value = value;

/// Mediator Variable: int3
final _int3 = Signal(0); // or `final _int3 = 0.signal;`
int get int3 => _int3.value;
set int3(value) => _int3.value = value;

/// Computed Mediator Variable: sum
// final _sum = Rx(() => int1 + int2 + int3 as dynamic);
final _sum = Rx(() {
  final res = int1 + int2 + int3;
  if (res <= 10) {
    return res;
  }
  return "excess upper bound($res)";
});
get sum => _sum.value;
set sum(value) => _sum.value = value;

/// List page
/// Mediator Variable: data
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
  final item = ListItem(itemName, units, color);

  // Notify to rebuild. Actually, `RxList.add` notifies itself.
  _data.notify.add(item); // data.add(item);
}

/// Locale page
late SharedPreferences prefs; // for Preferences
late Rx<String> _locale;
initPersistence() async {
  WidgetsFlutterBinding.ensureInitialized(); // for shared_Preferences
  prefs = await SharedPreferences.getInstance();
  final loc = prefs.getString("locale") ?? "en"; // default locale to 'en'
  _locale = loc.rx; // make _locale a mediator variable of type `Rx<String>`
}

/// Mediator Variable: locale
String get locale => _locale.value;
set locale(String value) {
  _locale.value = value;
  prefs.setString("locale", value);
}

get localeSubscribe => _locale.subscribe;
String get localeNotify => _locale.notify;

/// Change the locale, by `String`[countryCode]
Future<void> changeLocale(BuildContext context, String countryCode) async {
  if (countryCode != locale) {
    final loc = Locale(countryCode);
    await FlutterI18n.refresh(context, loc);

    locale = countryCode; // Rebuild associate Subscriber widgets.
  }
}

extension StringI18n on String {
  /// String extension for i18n.
  String i18n(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }

  /// String extension for i18n
  /// use `_locale.subscribe` to create Subscriber widget of locale.
  Widget sub18n(BuildContext context, {TextStyle? style}) {
    return _locale.subscribe(
      () => Text(FlutterI18n.translate(context, this), style: style),
    );
  }
}
