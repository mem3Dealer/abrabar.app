import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'НАСТРОЙКИ',
          style: theme.textTheme.headline3,
        ),
        leading: IconButton(
            onPressed: () {},
            icon: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).pop();
              },
              // icon: Image.asset('assets/images/close.png')
              icon: const Icon(
                Icons.close,
                color: Color(0xffFFBE3F),
              ),
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {},
                child: Text(
                  'ПО-РУССКИ',
                  style: theme.textTheme.headline1,
                )),
            const SizedBox(
              height: 168,
            ),
            TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
                onPressed: () {},
                child: Text('ENGLISH', style: theme.textTheme.headline1))
          ],
        ),
      ),
    );
  }
}
