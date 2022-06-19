import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import '../logic/bloc/bloc/coctail_bloc.dart';

class IngredientNet extends StatelessWidget {
  bool isPreview;
  IngredientNet({
    Key? key,
    required this.isPreview,
  }) : super(key: key);
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final picPaths = PicPaths();
  String path = 'assets/images/test/';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        String? image(index) {
          if (isPreview == true) {
            if (index <= state.currentCoctail.steps!.length) {
              return state.currentCoctail.steps!.last['images'][index];
            } else {
              return null;
            }
          } else if (index <= state.currentIngredients!.length - 1) {
            return state.currentIngredients!.elementAt(index);
          } else {
            return null;
          }
        }

        return Stack(
          alignment: Alignment.bottomCenter,
          // fit: StackFit.,
          children: [
            SizedBox(
                width: 72.5.w,
                height: 35.h,
                // color: Colors.red,
                child: SvgPicture.asset(picPaths.glassPics +
                    cockBloc.state.currentCoctail.steps!
                        .elementAt(0)['images']
                        .first)),

            //6
            Align(
              alignment: const Alignment(0.5, 0.54),
              child: element(image: image(6), size: 13.8.w),
            ),

            //1
            Align(
              alignment: const Alignment(0.45, 0.15),
              child: element(image: image(1), size: 25.8.w),
            ),

            //2
            Align(
              alignment: const Alignment(-0.45, 0.65),
              child: element(image: image(2), size: 23.w),
            ),

            //3
            Align(
              alignment: const Alignment(-0.24, -0.3),
              child: element(image: image(3), size: 19.7.w),
            ),

            //4
            Align(
              alignment: const Alignment(0.6, -0.15),
              child: element(image: image(4), size: 14.1.w),
            ),

            //5
            Align(
              alignment: const Alignment(-0.4, 0.05),
              child: element(image: image(5), size: 13.8.w),
            ),

            //7
            Align(
              alignment: const Alignment(0.32, -0.45),
              child: element(image: image(7), size: 19.7.w),
            ),

            //8
            Align(
              alignment: const Alignment(-0.45, -0.5),
              child: element(image: image(8), size: 14.2.w),
            ),

            //9
            Align(
              alignment: const Alignment(-0.0, -0.7),
              child: element(image: image(9), size: 16.1.w),
            ),

            //10
            Align(
              alignment: const Alignment(-0.35, -0.8),
              child: element(image: image(10), size: 10.w),
            ),

            //11
            Align(
              alignment: const Alignment(0.35, -0.9),
              child: element(image: image(11), size: 11.4.w),
            ),
          ],
        );
      },
    );
  }

  Widget? element({
    required double size,
    String? image,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
          child: image != null
              ? SvgPicture.asset('assets/images/test/$image')
              : Container()),
    );
  }
}
