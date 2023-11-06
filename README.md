# Flutter Mediator Simple

<table cellpadding="0" border="0">
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator_simple">Flutter Mediator Simple</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator_simple"><img src="https://img.shields.io/pub/v/flutter_mediator_simple.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_simple/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator_simple.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_simple/actions"><img src="https://github.com/rob333/flutter_mediator_simple/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    A rework of the Flutter Mediator, simple, efficient and easy to use.
    </td>
  </tr>
</table>

<br>

Flutter Mediator Simple is a state management package for flutter. Simple, efficient and easy to use.

<table border="0" align="center">
  <tr>
    <td>
      <img src="https://raw.githubusercontent.com/rob333/flutter_mediator_simple/main/flutter_mediator_simple.webp">
    </td>
  </tr>
</table>

---

## Table of Contents

- [Flutter Mediator Simple](#flutter-mediator-simple)
  - [Table of Contents](#table-of-contents)
  - [Getting started](#getting-started)
    - [Import it](#import-it)
  - [Usage](#usage)
  - [Use Case 1: Mediator Variable of type `Int`](#use-case-1-mediator-variable-of-type-int)
  - [Use Case 2: Mediator Variable of type `List`](#use-case-2-mediator-variable-of-type-list)
  - [Use Case 3: Indirect use of Mediator Variable and Persistence](#use-case-3-indirect-use-of-mediator-variable-and-persistence)
  - [Use Case 4: Computed Mediator Variable](#use-case-4-computed-mediator-variable)
  - [`subscribe`](#subscribe)
  - [`notify`](#notify)
  - [`Signal`](#signal)
  - [VS Code Snippet](#vs-code-snippet)
  - [State Management with Animation](#state-management-with-animation)
  - [Changelog](#changelog)
  - [License](#license)

<hr>

## Getting started

Run this command:

With Flutter:

```
 $ flutter pub add flutter_mediator_simple
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```yaml
dependencies:
  flutter_mediator_simple: "^1.2.0"
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.


### Import it

Now in your Dart code, you can use:

```dart
import 'package:flutter_mediator_simple/flutter_mediator_simple.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.dev/docs).


&emsp; [Table of Contents]

## Usage

1. Declare variable which needs to be managed with `.rx` suffix, to make it a mediator variable.
   <br>**Suggest to put mediator variables into the file [var.dart][example/lib/var.dart] and then import it(with show, hide capability of the import).**

2. Create `Subscriber` widgets. Any mediator variables used inside the `Subscriber` widget will automatically rebuild the widget when updated.

&emsp; [Table of Contents]

---

## Use Case 1: Mediator Variable of type `Int`

Step 1: Declare the mediator variable `_int1` in [var.dart][example/lib/var.dart].

```dart
/// Mediator Variable: int1
final _int1 = 0.rx; // or `final _int1 = Rx(0);`
int get int1 => _int1.value;
set int1(value) => _int1.value = value;
// optional
get int1Subscribe => _int1.subscribe;
String get int1Notify => _int1.notify;
```

Step 2: Create a `Subscriber` widget using `int1` which is `_int1.value`.

```dart
          Subscriber(
            builder: () {
              return Text(
                'int1: $int1', // using the `_int1` mediator variable
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
```

Update `int1` will rebuild corresponding Subscriber widgets automatically.

```dart
@override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: myTabs.length,
      child: Scaffold(
        // ...
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            switch (_tabController.index) {
              case 0:
                int1++;
                break;
              case 1:
                int2++;
                break;
              case 2:
                int3++;
                break;
              case 3:
                updateListItem();
                break;
              case 4:
                int1++;
                break;
              default:
            }
          },
          // ...
        ),
      ),
    );
```

&emsp; [Table of Contents]

---

## Use Case 2: Mediator Variable of type `List`

Step 1: Declare the mediator variable `_data` in [var.dart][example/lib/var.dart].

```dart
/// Mediator Variable: data
final _data = <ListItem>[].rx; //or `RxList(<ListItem>[]);`
List<ListItem> get data => _data.value;
set data(List<ListItem> value) => _data.value = value;
SubscriberFn get dataSubscribe => _data.subscribe;
List<ListItem> get dataNotify => _data.notify;
```

Step 2: Create a `Subscriber` widget using `data` which is `_data.value`.

```dart
    return Scaffold(
      appBar: AppBar(title: const Text('List Demo')),
        //* Step: Create Subscriber widget
      body: Subscriber(
        builder: () => GridView.builder(
          itemCount: data.length, // using the `_data` mediator variable
        // ...
```

Step 3: Implement an update function for `data`.

```dart
void updateListItem() {
  final units = Random().nextInt(maxUnits) + 1;
  final itemIdx = Random().nextInt(itemNames.length);
  final itemName = itemNames[itemIdx];
  final color = itemColors[Random().nextInt(itemColors.length)];
  if (data.length >= maxItems) data.clear();

  //* Make an update to the collection type mediator variable.
  // data.add(ListItem(itemName, units, color));
  _data.notify.add(ListItem(itemName, units, color)); // notify the widget to rebuild
}
```

Use `notify` to notify the Subscribe widget to rebuild when the type of the mediator variable is a class and add items by method.

&emsp; [Table of Contents]

## Use Case 3: Indirect use of Mediator Variable and Persistence

> **Indirect use** means the Subscriber widget doesn't use the value of the mediator variable but depends on it.

Step 1: Install i18n package [flutter_i18n](https://pub.dev/packages/flutter_i18n) and follow the instructions to set it up.

Step 1-1: Setup locale delegates in [main.dart][example/lib/main.dart].

```dart
    return MaterialApp(
      // ...
      // add flutter_i18n support
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            forcedLocale: Locale(locale),
            // useCountryCode: true,
            fallbackFile: 'en',
            basePath: 'assets/flutter_i18n',
            decodeStrategies: [JsonDecodeStrategy()],
          ),
          missingTranslationHandler: (key, locale) {
            // ignore: avoid_print
            print(
                '--- Missing Key: $key, languageCode: ${locale!.languageCode}');
          },
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
```

Step 1-2: Add assets in [pubspec.yaml][] and prepare locale files in that [folder][flutter_i18n]

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/flutter_i18n/
```

Step 2: Install the persistence package [shared_preferences](https://pub.dev/packages/shared_preferences)

Step 3: Declare the mediator variable `_locale` and SharedPreferences in [var.dart][example/lib/var.dart].

```dart
/// Locale page
late SharedPreferences prefs; // for persistence
// Mediator Variable: locale
late Rx<String> _locale;
String get locale => _locale.value;
// set locale(String value) => _locale.value = value; // comment out
get localeSubscribe => _locale.subscribe;
String get localeNotify => _locale.notify;
```

Step 4: Implement a function to initial the persistence.
```dart
initPersistence() async {
  WidgetsFlutterBinding.ensureInitialized(); // for shared_Preferences
  prefs = await SharedPreferences.getInstance();
  final loc = prefs.getString("locale") ?? 'en'; // default locale to 'en'
  _locale = loc.rx; // make _locale a mediator variable of type `Rx<String>`
}
```

Step 5: Implement setter of `_locale` to use persistence.
```dart
set locale(String value) {
  _locale.value = value;
  prefs.setString("locale", value);
}
```

Step 6: Implement a function to change locale.
```dart
/// Change the locale, by `String`[countryCode]
Future<void> changeLocale(BuildContext context, String countryCode) async {
  if (countryCode != locale) {
    final loc = Locale(countryCode);
    await FlutterI18n.refresh(context, loc);

    locale = countryCode; // Rebuild associate Subscriber widgets.
  }
}
```

Step 7: Initial the persistence in [main.dart][example/lib/main.dart].
```dart
void main() async {
  await initPersistence();
  runApp(const MyApp());
}
```

Step 8(optional): Implement extensions on `String` to help building `Subscriber` widget of locale in [var.dart][example/lib/var.dart].
```dart
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
```


Step 9: Create `Subscriber` widgets of locale in [main.dart][example/lib/main.dart].

```dart
Widget localeTxt(BuildContext context, String name) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          //* Step: Create a Subscriber widget
          localeSubscribe(() => Text('${'app.hello'.i18n(context)} ')),
          Text('$name, '),
          //* Or use the string extension `sub18n`(in var.dart)
          'app.thanks'.sub18n(context),
        ],
      ),
    );
  }
```

Step 10: Handle radio status to change locale in class `_RadioGroupState` at [main.dart][example/lib/main.dart].

```dart
  Future<void> _handleRadioValueChange1(Object? value) async {
    await changeLocale(context, value!.toString());
    setState(() {});
  }
```

&emsp; [Table of Contents]


## Use Case 4: Computed Mediator Variable

Step 1: Declare the computed mediator variable `_sum` with a computed function of compound of mediator variables in [var.dart][example/lib/var.dart].

Specify the return type of the computed function as dynamic if the return type along with the function will change.

```dart
/// Computed Mediator Variable: sum
final _sum = Rx(() => int1 + int2 + int3 as dynamic);
get sum => _sum.value;
set sum(value) => _sum.value = value;
```

Step 2: Create a `Subscriber` widget using `sum` which is `_sum.value`.

```dart
          Subscriber(
            builder: () {
              return Text(
                'sum(computed): $sum',
                style: Theme.of(context).textTheme.headlineLarge,
              );
            },
          ),
```

Step 2a(Optional): Change the computed function when needed.

```dart
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (sum is int && sum >= 10) {
              sum = () => "excess upper bound($sum)";
            }
            // ...
          }
        ),  
``` 

Or, combine into the computed function.

```dart
final _sum = Rx(() {
  final res = int1 + int2 + int3;
  if (res <= 10) {
    return res;
  }
  return "excess upper bound($res)";
});
```

&emsp; [Table of Contents]


## `subscribe`
To create a Subscriber widget for indirect use of the mediator variable.

**Indirect use** means the Subscriber widget doesn't use the value of the mediator variable but depends on it.

For example, the locale use case.

&emsp; [Table of Contents]


## `notify`
Notify to rebuild with the aspects of the mediator variable.

Used when the type of the mediator variable is a `Class`.

Mediator variable uses setter to automatically notify the rebuild. When it comes to a class value and adds item by method, then `notify` is needed to inform the rebuild.

&emsp; [Table of Contents]


## `Signal`

Mediator variables can be initialled by the `Signal` annotation, through type alias.

For example,
```dart
final _int1 = 0.signal;
final _int2 = Signal(0); 
final _int3 = Signal(0); 
// computed mediator variable
final _sum = Signal(() => int1 + int2 + int3);
```

&emsp; [Table of Contents]


## VS Code Snippet
Use VS Code snippet to help typing the boilerplates.
Take for example [snippet_Flutter_Mediator__statelessful.code-snippets][vscSnippet],
- `getset` - Getter/Setter for Mediator Variable
- `cgetset` - Getter/Setter for Computed Mediator Variable
- `sub1` - Create a Subscriber Widget (Arrow Function)
- `subs` - Create a Subscriber Widget (Multiline)
```json
{
  "Getter/Setter for Mediator Variable": {
    "prefix": "getset",
    "body": [
      "/// Mediator Variable: ${1:var}",
      "final _${1:var} = ${2:initialValue}.rx;",
      "${3:type} get $1 => _${1:var}.value;",
      "set $1(${3:type} value) => _${1:var}.value = value;",
      "SubscriberFn get ${1:var}Subscribe => _${1:var}.subscribe;",
      "${3:type} get ${1:var}Notify => _${1:var}.notify;",
      "$0"
    ],
    "description": "Getter/Setter for Mediator Variable"
  },

  "Getter/Setter for Computed Mediator Variable": {
    "prefix": "cgetset",
    "body": [
      "/// Computed Mediator Variable: ${1:var}",
      "final _${1:var} = Rx(() => ${2:initialValue});",
      "get $1 => _${1:var}.value;",
      "set $1(value) => _${1:var}.value = value;",
      "$0"
    ],
    "description": "Getter/Setter for Computed Mediator Variable"
  },
  
  "Create a Subscriber Widget (Arrow Function)": {
    "prefix": "sub1",
    "body": [
      "${1:Subscriber}(",
      "\tbuilder: () => ${2:Text}(\"$3\"),",
      "),",
      "$0"
    ],
    "description": "Create a Subscriber Widget (Arrow Function)"
  },

  "Create a Subscriber Widget (Multiline)": {
    "prefix": "subs",
    "body": [
      "${1:Subscriber}(",
      "\tbuilder: () {",
      "\t\treturn ${2:Text}(\"$3\");",
      "\t},",
      "),",
      "$0"
    ],
    "description": "Create a Subscriber Widget (Multiline)"
  },
}
```


&emsp; [Table of Contents]


## State Management with Animation
By using [flutter_animate] animation can easily add to the mediator variable. If animation is needed every time the mediator variable changes, just add a `ValueKey` to the `animate`. For example, [example/lib/main.dart]
```dart
  Subscriber(
    builder: () {
      return Text(
        'int1: $int1', // using the `_int1` mediator variable
        style: Theme.of(context).textTheme.headlineMedium,
      )
          .animate(key: ValueKey(int1))
          .fade(duration: 125.ms)
          .scale(delay: 125.ms);
    },
```


&emsp; [Table of Contents]


<br>

[table of contents]: #table-of-contents
[example/lib/main.dart]: https://github.com/rob333/flutter_mediator_simple/blob/main/example/lib/main.dart
[example/lib/var.dart]: https://github.com/rob333/flutter_mediator_simple/blob/main/example/lib/var.dart
[pubspec.yaml]: https://github.com/rob333/flutter_mediator_simple/blob/main/example/pubspec.yaml
[flutter_i18n]: https://github.com/rob333/flutter_mediator_simple/tree/main/example/assets/flutter_i18n
[vscSnippet]: https://github.com/rob333/flutter_mediator_simple/blob/main/.vscode/snippet_Flutter_Mediator__statelessful.code-snippets
[flutter_animate]: https://pub.dev/packages/flutter_animate


## Changelog

Please see the [Changelog](https://github.com/rob333/flutter_mediator_simple/blob/main/CHANGELOG.md) page.

<br>

## License

Flutter Mediator Simple is distributed under the MIT License. See [LICENSE](https://github.com/rob333/flutter_mediator_simple/blob/main/LICENSE) for more information.

&emsp; [Table of Contents]
