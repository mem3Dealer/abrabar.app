import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import '../../logic/bloc/bloc/coctail_bloc.dart';
import '../../logic/coctail.dart';
import '../../shared/picPaths.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cockBloc = GetIt.I.get<CoctailBloc>();
    final paths = PicPaths();
    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        final theme = Theme.of(context);
        return GridView.builder(
            // physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: state.favoriteCoctails.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: () async {
                  cockBloc.add(
                      SelectCoctail(state.favoriteCoctails[index], context));
                },
                child: SvgPicture.asset(
                    paths.previews + state.favoriteCoctails[index].picPreview!),
              );
            });
      },
    );
  }
}
