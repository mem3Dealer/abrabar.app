import 'dart:io';

import 'package:abrabar/logic/services/analytic_service.dart';
import 'package:abrabar/shared/ingredientNet.dart';
import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import '../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import '../logic/coctail.dart';
import 'dart:math' as math;

class CookingPage extends StatefulWidget {
  const CookingPage({Key? key}) : super(key: key);

  @override
  State<CookingPage> createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final anal = GetIt.I.get<AnalyticsService>();
  final paths = PicPaths();
  late PageController controller;
  int pageIndex = 0;
  final listController = ScrollController();
  final String defaultLocale = Platform.localeName;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paths = PicPaths();
    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        Coctail curCoc = state.currentCoctail;

        Function? _swipeBack() {
          if (pageIndex == 0) {
            return null;
          } else {
            anal.stepChanged(
                isForward: false,
                name: curCoc.name!,
                stepNum: pageIndex,
                totalSteps: curCoc.steps!.length);
            controller.previousPage(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.ease);
          }
        }

        Function? _swipeForward() {
          if (pageIndex == curCoc.steps!.length - 1) {
            return null;
          } else {
            controller.nextPage(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.ease);
            anal.stepChanged(
                isForward: true,
                name: curCoc.name!,
                stepNum: pageIndex + 2,
                totalSteps: curCoc.steps!.length);
          }
        }

        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  state.currentCoctail.name!,
                  style: theme.textTheme.headline3,
                ),
                leading: IconButton(
                  onPressed: () {
                    cockBloc.add(StartAndEndCooking(
                        coctail: curCoc, isStart: false, context: context));
                  },
                  icon: SvgPicture.asset('${paths.systemImages}close.svg'),
                ),
              ),
              backgroundColor: state.currentCoctail.color,
              // backgroundColor: Colors.black54,
              body: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    // User swiped Left
                    _swipeBack();
                  } else if (details.primaryVelocity! < 0) {
                    // User swiped Right
                    _swipeForward();
                  }
                },
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ListView(
                              controller: listController,
                              shrinkWrap: true,
                              children: [
                                Container(
                                    // color: Colors.black,
                                    width: 100.w,
                                    height: 100.w,
                                    child: IngredientNet(
                                      isPreview: false,
                                    )),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 3.h, bottom: 2.3.h),
                                  child: Center(
                                    child: Text(
                                      defaultLocale.contains('ru') ||
                                              defaultLocale.contains('RU')
                                          ? '${pageIndex + 1} ШАГ ИЗ ${curCoc.steps!.length}'
                                          : 'Step ${pageIndex + 1} OUT OF ${curCoc.steps!.length}',
                                      style: theme.textTheme.headline3!
                                          .copyWith(
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                    ),
                                  ),
                                ),
                                Container(
                                  // color: Colors.green,
                                  width: 100.w,
                                  height: 25.h,
                                  child: PageView.builder(
                                    onPageChanged: (index) {
                                      bool isForward = pageIndex < index;
                                      setState(() {
                                        pageIndex = index;
                                      });
                                      cockBloc.add(AnotherStep(
                                          index: index, isForward: isForward));
                                    },
                                    controller: controller,
                                    itemCount: curCoc.steps!.length,
                                    itemBuilder: (context, position) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 15,
                                        ),
                                        child: Text(
                                          curCoc.steps![position]['step'],
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.headline1!
                                              .copyWith(fontSize: 28.sp),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                  '${paths.systemImages}grade1.png',
                                  color: state.currentCoctail.color
                                  // color: Colors.white.withOpacity(0.8),
                                  ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        // onPressed: null,
                                        onPressed: () => _swipeBack(),
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        icon: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(math.pi),
                                          child: SvgPicture.asset(
                                            '${paths.systemImages}cooking_arrow.svg',
                                            color: pageIndex == 0
                                                ? Colors.white.withOpacity(0.5)
                                                : null,
                                          ),
                                        )),
                                    IconButton(
                                        onPressed: () => _swipeForward(),
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        icon: SvgPicture.asset(
                                          '${paths.systemImages}cooking_arrow.svg',
                                          color: pageIndex ==
                                                  curCoc.steps!.length - 1
                                              ? Colors.white.withOpacity(0.5)
                                              : null,
                                        )),
                                  ]),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }
}
