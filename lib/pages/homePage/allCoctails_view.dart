import 'package:abrabar/logic/coctail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import '../../shared/widgets.dart';

class AllCotailsView extends StatelessWidget {
  AllCotailsView({Key? key}) : super(key: key);
  final cockBloc = GetIt.I.get<CoctailBloc>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: BlocConsumer<CoctailBloc, CoctailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Stack(
            children: [
              GridView.builder(
                  // physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: state.allCoctails.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return state.allCoctails[index].createGridCell(
                        collectionName: 'all_cocktails',
                        setName: null,
                        context: context,
                        coctail: state.allCoctails[index]);
                  }),
              OverlayWithLock(
                isSeasonal: false,
              )
            ],
          );
        },
      ),
    ));
  }
}
