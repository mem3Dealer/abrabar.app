import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import '../logic/bloc/bloc/coctail_bloc.dart';

class CookingPage extends StatefulWidget {
  const CookingPage({Key? key}) : super(key: key);

  @override
  State<CookingPage> createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  final cockBloc = GetIt.I.get<CoctailBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        // leading: SizedBox(
        //   width: 5.5.w,
        //   height: 2.5.h,
        //   child: SvgPicture.asset('assets/images/close.svg'),
        // ),
      ),
      backgroundColor: theme.primaryColor,
      body: Center(
        child: Text(cockBloc.state.toString()),
      ),
    );
  }
}
