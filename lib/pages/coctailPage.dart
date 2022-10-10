import 'package:abrabar/logic/coctail.dart';
import 'package:abrabar/logic/services/analytic_service.dart';
import 'package:abrabar/shared/ingredientNet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import '../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import '../shared/picPaths.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';

class CoctailPage extends StatefulWidget {
  CoctailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CoctailPage> createState() => _CoctailPageState();
}

class _CoctailPageState extends State<CoctailPage>
    with SingleTickerProviderStateMixin {
  final anal = GetIt.I.get<AnalyticsService>();
  final cockBloc = GetIt.I.get<CoctailBloc>();
  late ScrollController controller;
  bool needsAnalytic = true;

  @override
  void initState() {
    controller = ScrollController()
      ..addListener(() {
        bool isTop = controller.position.pixels == 0;
        if (controller.position.atEdge) {
          isTop
              ? null
              : needsAnalytic
                  ? setState(() {
                      anal.readIngredients(cockBloc.state.currentCoctail);
                      needsAnalytic = false;
                    })
                  : null;
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    needsAnalytic = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paths = PicPaths();
    var t = AppLocalizations.of(context)!;
    cockBloc.add(AnotherStep(index: 0));
    final theme = Theme.of(context);
    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        Coctail coc = state.currentCoctail;

        return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniStartTop,
              extendBodyBehindAppBar: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              body: buildBody(coc.color!, coc, theme, state, paths, context, t),
              floatingActionButton: FloatingActionButton(
                  hoverElevation: 0,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    '${paths.systemImages}back_arrow.svg',
                    fit: BoxFit.scaleDown,
                  )),
            ));
      },
    );
  }

  SingleChildScrollView buildBody(
      Color color,
      Coctail coc,
      ThemeData theme,
      CoctailState state,
      PicPaths paths,
      BuildContext context,
      AppLocalizations t) {
    return SingleChildScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            color: color,
            child: Column(
              children: [
                Container(
                  // color: Colors.black,
                  width: 100.w,
                  height: 100.w,

                  child: IngredientNet(
                    isPreview: true,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w),
                  child: Text(
                    coc.name ?? '',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline1!.copyWith(fontSize: 32.sp),
                  ),
                ),
                Text(
                  coc.description!,
                  style: theme.textTheme.headline1!
                      .copyWith(fontSize: 20.sp, fontFamily: 'zet_light'),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      // color: Colors.white,
                      width: 22.5.w,
                      child: SizedBox(
                        height: 3.75.h,
                        width: 8.3.w,
                        child: GestureDetector(
                            onTap: () {
                              cockBloc.add(ChangeFavorite(
                                  coctail: coc,
                                  isFav: !state.currentCoctail.isFav));
                            },
                            child: SvgPicture.asset(state.currentCoctail.isFav
                                ? '${paths.systemImages}star_filled.svg'
                                : '${paths.systemImages}star_empty.svg')),
                      ),
                    ),
                    SizedBox(
                      width: 55.w,
                      height: 8.h,
                      child: ElevatedButton(
                          onPressed: () {
                            cockBloc.add(StartAndEndCooking(
                                coctail: coc, isStart: true, context: context));
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffFFBE3F))),
                          child: Text(t.howToCook,
                              style: theme.textTheme.subtitle2!
                                  .copyWith(fontSize: 24.sp))),
                    ),
                    SizedBox(
                      width: 22.5.w,
                    )
                  ],
                ),
                SizedBox(
                  height: 5.1.h,
                ),
              ],
            ),
          ),
          Container(
            color: theme.scaffoldBackgroundColor,
            // color: Colors.black,
            // height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: coc.ingredients!.length,
              itemBuilder: (BuildContext context, int index) {
                var pos = coc.ingredients![index];

                return ListTile(
                  title: Text(
                    pos['what']!,
                    style: theme.textTheme.headline4,
                  ),
                  trailing: Text(
                    pos['howMuch'].toString(),
                    style: theme.textTheme.subtitle1!.copyWith(
                        color: const Color(0xff86837B),
                        fontFamily: 'zet_light'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
