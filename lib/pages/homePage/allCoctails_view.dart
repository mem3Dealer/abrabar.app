import 'package:abrabar/logic/coctail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';

class AllCotailsView extends StatelessWidget {
  AllCotailsView({Key? key}) : super(key: key);
  final cockBloc = GetIt.I.get<CoctailBloc>();

  @override
  Widget build(BuildContext context) {
    List<Coctail> list = [];
    list = cockBloc.state.allCoctails;
    list.shuffle();
    return SafeArea(
        child: Center(
      child: BlocConsumer<CoctailBloc, CoctailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return GridView.builder(
              // physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: list.length,
              itemBuilder: (BuildContext ctx, index) {
                return list[index].createGridCell(
                    collectionName: 'all_cocktails',
                    setName: null,
                    context: context,
                    coctail: list[index]);
              });
        },
      ),
    ));
  }
}
