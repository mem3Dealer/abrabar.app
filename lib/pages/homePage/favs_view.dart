import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/bloc/coctail_bloc.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        return GridView.builder(
            // physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: state.favoriteCoctails.length,
            itemBuilder: (BuildContext ctx, index) {
              return state.favoriteCoctails[index].createGridCell(
                  context: context, coctail: state.favoriteCoctails[index]);
            });
      },
    );
  }
}
