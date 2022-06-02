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
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            // childAspectRatio: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0),
        itemCount: _names.length,
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            alignment: Alignment.center,
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            child: Text(
              _names[index],
              textAlign: TextAlign.center,
              // overflow,
              style: theme.textTheme.headline2,
            ),
          );
        });
  }
}
