import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class CoctailPage extends StatelessWidget {
  String title = 'CLASSIC';
  String name;
  CoctailPage({
    Key? key,
    // required this.title,
    required this.name,
  }) : super(key: key);

  List<Map<String, String>> recepie = [
    {'what': 'Ром', 'howMuch': '50 грамм'},
    {'what': 'Мята', 'howMuch': '3 листика'},
    {'what': 'Водка', 'howMuch': '500 грамм'},
    {'what': 'Кола', 'howMuch': 'Дохуища'},
    {'what': 'Малиновый сок', 'howMuch': 'Ну, его поменьше'},
    {'what': 'Апельсин', 'howMuch': 'целиком сувай'},
    {'what': 'Блю кюрасау', 'howMuch': 'положи где взял'},
    {'what': 'Спирт', 'howMuch': '1 чайная ложка'},
    {'what': 'Клей', 'howMuch': 'На кончике ножа'},
    {'what': 'Вино', 'howMuch': 'для храбрости'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String _way = 'assets/images/parts/';
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text(title),
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
                Container(
                    // color: Colors.black,
                    width: 90.w,
                    height: 90.w,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Align(
                          alignment: const Alignment(-0.35, -0.72),
                          child: SizedBox(
                              width: 19.4.w,
                              height: 8.1.h,
                              child: SvgPicture.asset("${_way}bubbles.svg")),
                        ),
                        Align(
                          alignment: const Alignment(-0.35, 0.1),
                          child: SizedBox(
                            width: 28.w,
                            height: 9.h,
                            child: SvgPicture.asset("${_way}wine.svg"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              // color: Colors.green,
                              width: 20.w,
                              height: 34.h,
                              child: SvgPicture.asset('${_way}high_glass.svg')),
                        ),
                        Align(
                            alignment: const Alignment(0.2, -0.9),
                            child: SizedBox(
                                // color: Colors.green,
                                width: 29.5.w,
                                height: 13.6.h,
                                child: SvgPicture.asset('${_way}orange.svg'))),
                        Align(
                            alignment: const Alignment(-0.2, -0.1),
                            child: SizedBox(
                                // color: Colors.green,
                                width: 16.6.w,
                                height: 5.3.h,
                                child: SvgPicture.asset('${_way}pinky.svg'))),
                        Align(
                            alignment: const Alignment(0.2, 0.01),
                            child: SizedBox(
                                // color: Colors.green,
                                width: 14.5.w,
                                height: 6.5.h,
                                child: SvgPicture.asset('${_way}ice.svg'))),
                      ],
                    )),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  name,
                  style: theme.textTheme.headline1!.copyWith(fontSize: 32),
                ),
                Text(
                  'Горький ∙ Билд',
                  style: theme.textTheme.headline1!.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 22.5.w,
                      child: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/images/star.svg')),
                    ),
                    SizedBox(
                      width: 55.w,
                      height: 8.h,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffFFBE3F))),
                          child: Text('КАК ГОТОВИТЬ',
                              style: theme.textTheme.subtitle2!
                                  .copyWith(fontSize: 24))),
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
            itemCount: recepie.length,
            itemBuilder: (BuildContext context, int index) {
              var _pos = recepie[index];
              return ListTile(
                tileColor: Colors.transparent,
                title: Text(
                  _pos['what']!,
                  style: theme.textTheme.headline4,
                ),
                trailing: Text(
                  _pos['howMuch']!,
                  style: theme.textTheme.subtitle1!
                      .copyWith(color: const Color(0xff86837B)),
                ),
              );
            },
          )
        ],
      ),
    ));
  }
}
