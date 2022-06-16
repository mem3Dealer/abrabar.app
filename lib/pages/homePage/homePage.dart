import 'package:abrabar/logic/bloc/bloc/coctail_bloc.dart';
import 'package:abrabar/pages/homePage/classic_view.dart';
import 'package:abrabar/pages/homePage/season_view.dart';
import 'package:abrabar/pages/settingsPage.dart';
import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final paths = PicPath();
  late TabController _tabController;
  late TextEditingController controller;
  bool isSearch = false;
  final double _tabHeight = 5.h;

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

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    final List<String> _names = [
      t.ingredients,
      t.favs,
      t.classic,
      t.popular,
      t.season
    ];

    final theme = Theme.of(context);
    List<Tab> _tabS() {
      List<Tab> _r = [];
      for (var name in _names) {
        _r.add(Tab(
          height: _tabHeight,
          child: Container(
            child: Text(name
                //никакого стиля потому что табБары определяют стиль лучше
                ),
          ),
        ));
      }
      return _r;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 9.25.h,
        leading: isSearch ? closeSearhButton() : Container(),
        title: Text(
          isSearch ? t.search : 'ABRABAR',
          style: theme.textTheme.headline1,
        ),
        actions: [
          if (!isSearch)
            Padding(
              padding: EdgeInsets.only(
                right: 3.5.w,
              ),
              child: SizedBox(
                width: 6.1.w,
                height: 2.75.h,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearch = true;
                    });
                  },
                  child: SvgPicture.asset("${paths.systemImages}loopa.svg"),
                ),
              ),
            )
          else
            Container()
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

  TabBar tabBar(List<Tab> _tabS()) {
    final theme = Theme.of(context).textTheme;
    return TabBar(
      labelStyle: theme.subtitle1,
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
    var t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(110),
      child: Padding(
        padding: EdgeInsets.only(left: 4.2.w, right: 4.2.w, bottom: 2.2.h),
        child: TextField(
          cursorColor: Colors.white,
          controller: controller,
          style: theme.textTheme.headline1!.copyWith(fontSize: 32),
          decoration: InputDecoration(
              // suffixIconConstraints: _deleteButtonMinConst,
              suffixIcon: Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: TextButton(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(15.2.w, 3.h)),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero)),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    side: MaterialStateProperty.all(BorderSide(
                        color: const Color(0xffFFBE3F).withOpacity(0.3)))),
                onPressed: () => controller.clear(),
                child: Text(
                  t.delete,
                  style: theme.textTheme.subtitle1!.copyWith(fontSize: 12.sp),
                )),
          )),
        ),
      ),
    );
    // return AppBar(
    //   toolbarHeight: 4.h,
    //   title:
    // );
  }

  //TODO
  // надо доаботать чтобы не делать три разные кнопки
  // Widget myIconButton(String path, Function onTap, bool isLeft) {
  //   return Padding(
  //     padding:
  //         isLeft ? EdgeInsets.only(left: 3.5.w) : EdgeInsets.only(right: 3.5.w),
  //     child: SizedBox(
  //       width: 6.1.w,
  //       height: 2.75.h,
  //       child: GestureDetector(
  //         onTap: onTap(),
  //         child: SvgPicture.asset(path),
  //       ),
  //     ),
  //   );
  // }

  Widget closeSearhButton() {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () {
        setState(() {
          isSearch = false;
        });
      },
      icon: SvgPicture.asset('${paths.systemImages}close.svg'),
    );
  }
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
