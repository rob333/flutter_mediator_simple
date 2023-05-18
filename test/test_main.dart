import 'package:flutter/material.dart';
import 'package:flutter_mediator_simple/flutter_mediator_simple.dart';

import 'test_var.dart';

void main() async {
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
    const Tab(icon: Icon(Icons.beach_access_sharp), text: "int1,2"),
    const Tab(icon: Icon(Icons.brightness_5_sharp), text: "int1,2,3"),
    const Tab(icon: Icon(Icons.power_input_rounded), text: "list"),
    // const Tab(icon: Icon(Icons.local_airport_outlined), text: "locale"),
  ];
  final myPages = [
    const Intpage(),
    const Intpage(),
    const Intpage(),
    const ListPage(),
    // const LocalePage(),
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
          title: [
            Text(widget.title),
            [
              Subscriber(
                builder: () => Text("int1:$int1"),
              ),
              Subscriber(
                builder: () => Text("int2:$int2"),
              ),
              Subscriber(
                builder: () => Text("int3:$int3"),
              ),
            ].row(mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ].column(),
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
            if (sum2 is int && sum2 >= 10) {
              sum2 = () => "excess upper bound";
            }
            switch (_tabController.index) {
              case 0:
                int1++;
                break;
              case 1:
                int1++;
                int2++;
                break;
              case 2:
                int1++;
                int2++;
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
          Container(
            height: 3,
            width: 150,
            alignment: Alignment.center,
            // color: const Color.fromARGB(255, 54, 48, 44),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color.fromARGB(255, 55, 45, 0),
            ),
          ),
          Subscriber(
            builder: () {
              return Text(
                'sum: ${int1 + int2 + int3}',
                style: Theme.of(context).textTheme.headlineLarge,
              );
            },
          ),
          Subscriber(
            builder: () {
              return Text(
                'sum(computed): $sum',
                style: Theme.of(context).textTheme.headlineLarge,
              );
            },
          ),
          Subscriber(
            builder: () {
              return Text(
                'sum2(computed): $sum2',
                style: Theme.of(context).textTheme.headlineLarge,
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

extension ListWidgetModifier on List<Widget> {
  MultiChildRenderObjectWidget row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  MultiChildRenderObjectWidget column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }

  MultiChildRenderObjectWidget stack({
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
      children: this,
    );
  }
}
