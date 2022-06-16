import 'package:abrabar/logic/coctail.dart';
import 'package:abrabar/pages/cookingPage.dart';
import 'package:abrabar/shared/ingredientNet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import '../logic/bloc/bloc/coctail_bloc.dart';

class CoctailPage extends StatelessWidget {
  String title = 'CLASSIC';
  String name;
  CoctailPage({
    Key? key,
    // required this.title,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cockBloc = GetIt.I.get<CoctailBloc>();
    cockBloc.add(AnotherStep(index: 0));
    // print();
    final theme = Theme.of(context);
    String _way = 'assets/images/parts/';
    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        Coctail coc = state.currentCoctail;
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: SizedBox(
                width: 4.w,
                height: 4.h,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      'assets/images/back_arrow.svg',
                      fit: BoxFit.scaleDown,
                    )),
              ),
            ),
            toolbarHeight: 9.25.h,
            backgroundColor: theme.primaryColor,
            title: Text(
              title,
              style: theme.textTheme.headline3,
            ),
          ),
          body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Container(
                color: theme.primaryColor,
                // height: MediaQuery.of(context).size.height -
                //     AppBar().preferredSize.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      // color: Colors.black,
                      width: 90.w,
                      height: 90.w,
                      child: IngredientNet(
                        isPreview: true,
                      ),
                      // child: Stack(
                      //   fit: StackFit.expand,
                      //   children: [
                      //     Align(
                      //       alignment: const Alignment(-0.35, -0.72),
                      //       child: SizedBox(
                      //           width: 19.4.w,
                      //           height: 8.1.h,
                      //           child:
                      //               SvgPicture.asset("${_way}bubbles.svg")),
                      //     ),
                      //     Align(
                      //       alignment: const Alignment(-0.35, 0.1),
                      //       child: SizedBox(
                      //         width: 28.w,
                      //         height: 9.h,
                      //         child: SvgPicture.asset("${_way}wine.svg"),
                      //       ),
                      //     ),
                      //     Align(
                      //       alignment: Alignment.center,
                      //       child: SizedBox(
                      //           // color: Colors.green,
                      //           width: 20.w,
                      //           height: 34.h,
                      //           child: SvgPicture.asset(
                      //               '${_way}high_glass.svg')),
                      //     ),
                      //     Align(
                      //         alignment: const Alignment(0.2, -0.9),
                      //         child: SizedBox(
                      //             // color: Colors.green,
                      //             width: 29.5.w,
                      //             height: 13.6.h,
                      //             child:
                      //                 SvgPicture.asset('${_way}orange.svg'))),
                      //     Align(
                      //         alignment: const Alignment(-0.2, -0.1),
                      //         child: SizedBox(
                      //             // color: Colors.green,
                      //             width: 16.6.w,
                      //             height: 5.3.h,
                      //             child:
                      //                 SvgPicture.asset('${_way}pinky.svg'))),
                      //     Align(
                      //         alignment: const Alignment(0.2, 0.01),
                      //         child: SizedBox(
                      //             // color: Colors.green,
                      //             width: 14.5.w,
                      //             height: 6.5.h,
                      //             child: SvgPicture.asset('${_way}ice.svg'))),
                      //   ],
                      // )
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      coc.name!,
                      style:
                          theme.textTheme.headline1!.copyWith(fontSize: 32.sp),
                    ),
                    Text(
                      coc.description!,
                      style:
                          theme.textTheme.headline1!.copyWith(fontSize: 20.sp),
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
                              onTap: () {},
                              child: SvgPicture.asset('assets/images/star.svg'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 55.w,
                          height: 8.h,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push<void>(
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const CookingPage(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xffFFBE3F))),
                              child: Text('КАК ГОТОВИТЬ',
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
                    )
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: coc.ingredients!.length,
                itemBuilder: (BuildContext context, int index) {
                  var _pos = coc.ingredients![index];
                  return ListTile(
                    tileColor: Colors.transparent,
                    title: Text(
                      _pos['what']!,
                      style: theme.textTheme.headline4,
                    ),
                    trailing: Text(
                      _pos['howMuch'].toString(),
                      style: theme.textTheme.subtitle1!
                          .copyWith(color: const Color(0xff86837B)),
                    ),
                  );
                },
              )
            ],
          ),
        ));
      },
    );
  }
}
