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
  late TextEditingController controller;
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
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
    final theme = Theme.of(context);
    List<Tab> _tabS() {
      List<Tab> _r = [];
      for (var name in _names) {
        _r.add(Tab(
          height: 32,
          child: Container(
            child: Text(
              name,
              // style: theme.textTheme.subtitle1!.copyWith(color: null),
            ),
          ),
        ));
      }
      return _r;
    }

    return Scaffold(
      appBar: AppBar(
        leading: isSearch ? closeSearhButton() : settingsButton(context),
        title: Text(
          isSearch ? 'ПОИСК' : 'ABRABAR',
          style: theme.textTheme.headline1,
        ),
        actions: [
          !isSearch
              ? IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      isSearch = true;
                    });
                  },
                  icon: Image.asset('assets/images/loopa.png'))
              : Container()
        ],
        bottom: isSearch ? searchMode(context) : tabBar(_tabS),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: views,
        ),
      ),
    );
  }

  IconButton settingsButton(BuildContext context) {
    return IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Image.asset('assets/images/gaika.png'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const SettingsPage(),
            ),
          );
        });
  }

  TabBar tabBar(List<Tab> _tabS()) {
    return TabBar(
      labelStyle: const TextStyle(fontSize: 20, fontFamily: 'zet_regular'),
      padding: const EdgeInsets.all(10),
      labelColor: Colors.black,
      indicator: const BoxDecoration(color: Colors.white),
      unselectedLabelColor: const Color(0xffFFBE3F),
      isScrollable: true,
      controller: _tabController,
      tabs: _tabS(),
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

  PreferredSizeWidget searchMode(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: TextField(
          cursorColor: Colors.white,
          controller: controller,
          style: theme.textTheme.headline1!.copyWith(fontSize: 32),
          decoration: InputDecoration(
              suffixIconConstraints:
                  const BoxConstraints(minHeight: 15, minWidth: 20),
              suffixIcon: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      side: MaterialStateProperty.all(BorderSide(
                          color: const Color(0xffFFBE3F).withOpacity(0.3)))),
                  onPressed: () => controller.clear(),
                  child: const Text(
                    'УДАЛИТЬ',
                    style: TextStyle(
                        color: Color(0xffFFBE3F),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ))),
        ),
      ),
    );
  }

  IconButton closeSearhButton() {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () {
        setState(() {
          isSearch = false;
        });
      },
      icon: Image.asset('assets/images/close.png'),
    );
  }
}
