import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import '../../logic/coctail.dart';
import '../paywallScreen.dart';

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
                          context: context, coctail: authors[index]);
                    }),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const PaywallScreen(),
                              settings:
                                  const RouteSettings(name: 'PaywallScreen'),
                            )),
                        child:
                            SvgPicture.asset('${paths.systemImages}lock.svg')),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
