import 'package:abrabar/pages/homePage/classic_view.dart';
import 'package:abrabar/pages/homePage/season_view.dart';
import 'package:abrabar/pages/settingsPage.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<String> _names = [
    'INGREDIENTS',
    'FAVS',
    'CLASSIC',
    'POPULAR',
    'SEASON'
  ];

  @override
  Widget build(BuildContext context) {
    List<Tab> _tabS() {
      List<Tab> _r = [];
      for (var name in _names) {
        _r.add(Tab(
          height: 32,
          child: Container(
            child: Text(
              name,
            ),
          ),
        ));
      }
      return _r;
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Image.asset('assets/images/gaika.png'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SettingsPage(),
                ),
              );
            }),
        // centerTitle: true,
        // backgroundColor: const Color(0xff242320),
        title: Text(
          'ABRABAR',
          style: theme.textTheme.headline1,
        ),
        actions: [
          IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {},
              icon: Image.asset('assets/images/loopa.png'))
        ],
        bottom: TabBar(
          padding: const EdgeInsets.all(10),
          labelColor: Colors.black,
          indicator: const BoxDecoration(color: Colors.white),
          unselectedLabelColor: const Color(0xffFFBE3F),
          isScrollable: true,
          controller: _tabController,
          tabs: _tabS(),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: views,
        ),
      ),
    );
  }

  List<Widget> views = [
    const Center(
      child: Text('По ингридиентам'),
    ),
    const Center(
      child: Text('Избранное'),
    ),
    ClassicView(),
    const Center(
      child: Text('Популярное'),
    ),
    SeasonView()
  ];
}
