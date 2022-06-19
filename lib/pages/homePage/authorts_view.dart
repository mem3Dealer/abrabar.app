import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/bloc/coctail_bloc.dart';
import '../../logic/coctail.dart';

class AuthortsView extends StatelessWidget {
  const AuthortsView({Key? key}) : super(key: key);

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
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: authors.length,
                itemBuilder: (BuildContext ctx, index) {
                  return authors[index].createGridCell(
                      context: context, coctail: authors[index]);
                });
          },
        ),
      ),
    );
  }
}
