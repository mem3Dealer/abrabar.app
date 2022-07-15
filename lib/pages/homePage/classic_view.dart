import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import '../../logic/coctail.dart';

class ClassicView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cockBloc = GetIt.I.get<CoctailBloc>();

    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Coctail> classicCoctails = [];
        for (Coctail element in cockBloc.state.allCoctails) {
          if (element.categories!.contains('classic')) {
            classicCoctails.add(element);
          }
        }

        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: classicCoctails.length,
            itemBuilder: (BuildContext ctx, index) {
              return classicCoctails[index].createGridCell(
                  collectionName: 'classic',
                  setName: null,
                  context: context,
                  coctail: classicCoctails[index]);
            });
      },
    );
  }
}
