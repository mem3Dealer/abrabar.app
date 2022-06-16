import 'package:abrabar/shared/ingredientNet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import '../logic/bloc/bloc/coctail_bloc.dart';
import '../logic/coctail.dart';

class CookingPage extends StatefulWidget {
  const CookingPage({Key? key}) : super(key: key);

  @override
  State<CookingPage> createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  late PageController controller;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> _stepsSquares() {
    Coctail curcoc = cockBloc.state.currentCoctail;
    List<Widget> aga = [];
    for (var i = 0; i < curcoc.steps!.length; i++) {
      aga.add(Container(
        color: Colors.white,
        width: 7.3.w,
        height: 4.5.h,
        child: Text(
          '${i + 1}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.sp),
        ),
      ));
    }
    return aga;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        Coctail _curCoc = state.currentCoctail;
        return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 8.h,
                // backgroundColor: Colors.blue,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  state.currentCoctail.name!,
                  style: theme.textTheme.headline3,
                ),
                // leading: SizedBox(
                //   width: 5.5.w,
                //   height: 2.5.h,
                //   child: SvgPicture.asset('assets/images/close.svg'),
                // ),
              ),
              backgroundColor: theme.primaryColor,
              body: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
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
                            padding: EdgeInsets.only(top: 3.h, bottom: 2.3.h),
                            child: Center(
                              child: Text(
                                '4 ШАГ ИЗ ${_curCoc.steps!.length}',
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
                                cockBloc.add(AnotherStep(index: index));
                              },
                              controller: controller,
                              itemCount: _curCoc.steps!.length,
                              itemBuilder: (context, position) {
                                return Text(
                                  _curCoc.steps![position]['step'],
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headline1!
                                      .copyWith(fontSize: 32.sp),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.h, bottom: 5.6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _stepsSquares(),
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
