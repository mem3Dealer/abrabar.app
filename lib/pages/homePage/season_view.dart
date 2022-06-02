import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class SeasonView extends StatelessWidget {
  final List<Map<String, String>> _names = [
    {'name': 'НОВЫЙ ГОД И РОЖДЕСТВО', 'cocks': '12 КОКТЕЙЛЕЙ'},
    {'name': 'ПАСХА', 'cocks': '4 КОКТЕЙЛЯ'},
    {'name': 'ДЕНЬ СВЯТОГО ПАТРИКА', 'cocks': '2 КОКТЕЙЛЯ'},
    {'name': '8 МАРТА', 'cocks': '2 КОКТЕЙЛЯ'},
    {'name': 'ДЕНЬ СВЯТОГО НИКОЛАЯ', "cocks": "5 коктейлей"}
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _names.length,
        itemBuilder: (BuildContext ctx, index) {
          var _item = _names[index];
          return thatTile(
              title: _item['name']!,
              subtitle: _item['cocks']!,
              context: context);
        });
  }

  Widget thatTile(
      {required String title,
      required String subtitle,
      required BuildContext context}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 161,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        child: Padding(
          padding:
              const EdgeInsets.only(left: 22, top: 23, bottom: 14, right: 116),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.headline2,
              ),
              Text(
                subtitle,
                style: theme.textTheme.subtitle2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
