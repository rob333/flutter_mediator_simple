import 'package:flutter/material.dart';
import 'package:flutter_mediator_simple/flutter_mediator_simple.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

import 'var.dart';

void main() async {
  await initPersistence();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mediator Simple Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Mediator Simple Demo'),
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
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = [
    const Tab(icon: Icon(Icons.cloud_outlined), text: "int1"),
    const Tab(icon: Icon(Icons.beach_access_sharp), text: "int2"),
    const Tab(icon: Icon(Icons.brightness_5_sharp), text: "int3"),
    const Tab(icon: Icon(Icons.power_input_rounded), text: "list"),
    const Tab(icon: Icon(Icons.local_airport_outlined), text: "locale"),
  ];
  final myPages = [
    const Intpage(),
    const Intpage(),
    const Intpage(),
    const ListPage(),
    const LocalePage(),
  ];

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: myPages,
        ),
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
          tooltip: 'functions',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class Intpage extends StatelessWidget {
  const Intpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Subscriber(
            builder: () {
              return Text(
                'int1: $int1', // using the `_int1` mediator variable
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
          Subscriber(
            builder: () {
              return Text(
                'int2: $int2', // using the `_int2` mediator variable
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
          Subscriber(
            builder: () {
              return Text(
                'int3: $int3', // using the `_int3` mediator variable
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Demo')),
      //* Step: Create Subscriber widget
      body: Subscriber(
        builder: () => GridView.builder(
          itemCount: data.length, // using the `_data` mediator variable
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 5
                      : 10),
          itemBuilder: (context, index) {
            final item = data[index];
            return Padding(
              padding: const EdgeInsets.all(7.0),
              child: Card(
                color: item.color,
                child: GridTile(
                  footer: Text(item.units.toString()),
                  child: Text(item.item),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LocalePage extends StatelessWidget {
  const LocalePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Text(
          'Locale demo',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 25),
        Subscriber(
          builder: () => Text(
            'You have pressed the button at the first page $int1 times',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Subscriber(
          builder: () => Text(
            'Data length at the list page ${data.length}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            RadioGroup(),
            LocalePanel(),
          ],
        ),
      ],
    );
  }
}

class LocalePanel extends StatelessWidget {
  const LocalePanel({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (final name in names) localeTxt(context, name),
      ],
    );
  }
}

class RadioGroup extends StatefulWidget {
  const RadioGroup({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  final locales = [
    'en',
    'fr',
    'nl',
    'de',
    'it',
    'jp',
    'kr',
  ];
  final languages = [
    'English',
    'français',
    'Dutch',
    'Deutsch',
    'Italiano',
    '日本語',
    '한국어',
  ];

  Future<void> _handleRadioValueChange1(Object? value) async {
    await changeLocale(context, value!.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final radioValue1 = locale;

    Widget panel(int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio(
            value: locales[index],
            groupValue: radioValue1,
            onChanged: _handleRadioValueChange1,
          ),
          Text(
            languages[index],
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      );
    }

    return SizedBox(
      width: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int i = 0; i < locales.length; i++) panel(i),
        ],
      ),
    );
  }
}

final names = [
  'Aarron',
  'Josh',
  'Ibraheem',
  'Rosemary',
  'Clement',
  'Kayleigh',
  'Elisa',
  'Pearl',
  'Aneesah',
  'Tom',
  'Jordana',
  'Taran',
  'Bethan',
  'Haydon',
  'Olivia-Mae',
  'Anam',
  'Kelsie',
  'Denise',
  'Jenson',
  'Piotr',
];
