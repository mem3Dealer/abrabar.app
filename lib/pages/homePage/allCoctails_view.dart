import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';

class AllCotailsView extends StatelessWidget {
  const AllCotailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: BlocConsumer<CoctailBloc, CoctailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return GridView.builder(
              // physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: state.allCoctails.length,
              itemBuilder: (BuildContext ctx, index) {
                return state.allCoctails[index].createGridCell(
                    context: context, coctail: state.allCoctails[index]);
              });
        },
      ),
    ));
  }
}
