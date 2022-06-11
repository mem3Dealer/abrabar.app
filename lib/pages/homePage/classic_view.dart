import 'package:abrabar/pages/coctailPage.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ClassicView extends StatelessWidget {
  final List<String> _names = [
    'АПЕРОЛЬ ШПРИЦ',
    "КУБА ЛИБРЕ",
    "БЕЛЫЙ РУССКИЙ",
    "МАРГАРИТА",
    "Б-52",
    "ФРАНЦУЗСКИЙ СВЯЗНОЙ",
    "ЧЕРНЫЙ РУССКИЙ",
    "СЕКС НА ПЛЯЖЕ"
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
        // physics: const BouncingScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _names.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => CoctailPage(
                  name: _names[index],
                ),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: Text(
                _names[index],
                textAlign: TextAlign.center,
                style: theme.textTheme.headline2,
              ),
            ),
          );
        });
  }
}
