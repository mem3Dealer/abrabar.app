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
  @override
  void initState() {
    controller = PageController();
    // listController.jumpTo(0.0);
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
        return SafeArea(
          top: false,
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
              backgroundColor: theme.primaryColor,
              // backgroundColor: Colors.black54,
              body: Center(
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
                                    '${pageIndex + 1} ШАГ ИЗ ${curCoc.steps!.length}',
                                    style: theme.textTheme.headline3!.copyWith(
                                        color: Colors.white.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                              Container(
                                // color: Colors.green,
                                width: 100.w,
                                height: 25.h,
                                child: PageView.builder(
                                  onPageChanged: (index) {
                                    setState(() {
                                      pageIndex = index;
                                    });
                                    cockBloc.add(AnotherStep(index: index));
                                  },
                                  controller: controller,
                                  itemCount: curCoc.steps!.length,
                                  itemBuilder: (context, position) {
                                    return Text(
                                      curCoc.steps![position]['step'],
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headline1!
                                          .copyWith(fontSize: 32.sp),
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
                                      onPressed: pageIndex == 0
                                          ? null
                                          : () {
                                              anal.stepChanged(
                                                  isForward: false,
                                                  name: curCoc.name!,
                                                  stepNum: pageIndex,
                                                  totalSteps:
                                                      curCoc.steps!.length);
                                              controller.previousPage(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  curve: Curves.ease);
                                            },
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
                                      onPressed:
                                          pageIndex == curCoc.steps!.length - 1
                                              ? null
                                              : () {
                                                  controller.nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 1000),
                                                      curve: Curves.ease);
                                                  anal.stepChanged(
                                                      isForward: true,
                                                      name: curCoc.name!,
                                                      stepNum: pageIndex + 2,
                                                      totalSteps:
                                                          curCoc.steps!.length);
                                                },
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
              )),
        );
      },
    );
  }
}
