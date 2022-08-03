import 'package:abrabar/logic/services/analytic_service.dart';
import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import 'package:abrabar/pages/homePage/allCoctails_view.dart';
import 'package:abrabar/pages/homePage/authorts_view.dart';
import 'package:abrabar/pages/homePage/classic_view.dart';
import 'package:abrabar/pages/homePage/occasional_view.dart';
import 'package:abrabar/pages/homePage/season_view.dart';
import 'package:abrabar/shared/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import '../../logic/bloc/bloc/monetizationBloc/monetization_bloc.dart';
import '../../logic/bloc/bloc/monetizationBloc/monetization_state.dart';
import '../../shared/picPaths.dart';
import '../paywallScreen.dart';
import 'favs_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final moneyBloc = GetIt.I.get<MonetizationBloc>();
  final anal = GetIt.I.get<AnalyticsService>();
  final paths = PicPaths();
  late TabController _tabController;
  late TextEditingController controller;
  bool isSearch = false;
  final double _tabHeight = 5.h;
  List<String> collectionNames = [
    'all_cocktails',
    'favs',
    'classic',
    'authors',
    'occasional',
    'season'
  ];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.animation!.isCompleted ||
          _tabController.indexIsChanging) {
        anal.changeCollection(getTarget());
      }
    });
    if (moneyBloc.state.isPurchased == false) {
      _tabController.animateTo(2);
    }
  }

  String getTarget() {
    return collectionNames[_tabController.index];
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
    final List<String> names = [
      t.allCoctails,
      t.favs,
      t.classic,
      t.authors,
      t.occasional,
      t.season
    ];

    final theme = Theme.of(context);
    List<Tab> _tabS() {
      List<Tab> r = [];
      for (var name in names) {
        r.add(Tab(
          height: _tabHeight,
          child: Text(name),
        ));
      }
      return r;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(18.h),
        child: AppBar(
          title: Text(
            isSearch ? t.search : 'ABRABAR',
            style: theme.textTheme.headline1!
                .copyWith(fontFamily: 'zet_expanded', fontSize: 30.sp),
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
                  child: BlocConsumer<MonetizationBloc, MonetizationState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: state.isPurchased == true
                            ? () {
                                showSearch(
                                    context: context,
                                    delegate: SearchCoctails(
                                        allCoctails:
                                            cockBloc.state.allCoctails));
                              }
                            : () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      PaywallScreen(),
                                  settings: const RouteSettings(
                                      name: 'PaywallScreen'),
                                ));
                                anal.paywallOpened(
                                    fromWhere: 'search',
                                    basePrice: 399,
                                    actualPrice: 999);
                              },
                        child:
                            SvgPicture.asset("${paths.systemImages}loopa.svg"),
                      );
                    },
                  ),
                ),
              )
            else
              Container()
          ],
          bottom: tabBar(_tabS),
        ),
      ),
      body: BlocConsumer<CoctailBloc, CoctailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            bottom: false,
            child: TabBarView(
              controller: _tabController,
              children: views,
            ),
          );
        },
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
    AllCotailsView(),
    const FavoritesView(),
    ClassicView(),
    AuthortsView(),
    const OccasionalView(),
    SeasonView()
  ];
}
