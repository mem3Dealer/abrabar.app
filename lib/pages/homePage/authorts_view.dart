import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import '../../logic/coctail.dart';
import '../../shared/widgets.dart';

class AuthortsView extends StatelessWidget {
  AuthortsView({Key? key}) : super(key: key);
  final paths = PicPaths();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: BlocConsumer<CoctailBloc, CoctailState>(
          listener: (context, state) {},
          builder: (context, state) {
            List<Coctail> authors = [];
            for (Coctail coc in state.allCoctails) {
              if (coc.categories!.contains('authors')) {
                authors.add(coc);
              }
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: authors.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return authors[index].createGridCell(
                          collectionName: 'authors',
                          setName: null,
                          context: context,
                          coctail: authors[index]);
                    }),
                OverlayWithLock(
                  isSeasonal: false,
                  screenName: 'authors',
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
