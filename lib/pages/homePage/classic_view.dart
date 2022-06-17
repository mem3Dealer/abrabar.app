import 'package:abrabar/pages/coctailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../../logic/bloc/bloc/coctail_bloc.dart';
import '../../logic/coctail.dart';
import '../../shared/picPaths.dart';

class ClassicView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cockBloc = GetIt.I.get<CoctailBloc>();
    final theme = Theme.of(context);
    final paths = PicPaths();

    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        List<Coctail> classicCoctails = [];
        cockBloc.state.allCoctails.forEach((element) {
          if (element.categories!.contains('classic')) {
            classicCoctails.add(element);
          }
        });

        return GridView.builder(
            // physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: classicCoctails.length,
            itemBuilder: (BuildContext ctx, index) {
              return classicCoctails[index].createGridCell(
                  context: context,
                  child: SvgPicture.asset(
                      paths.previews + classicCoctails[index].picPreview!),
                  coctail: classicCoctails[index]);
              // return InkWell(
              //   onTap: () async {
              //     cockBloc.add(SelectCoctail(classicCoctails[index], context));
              //   },
            });
      },
    );
  }
}
