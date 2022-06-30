import 'package:abrabar/logic/bloc/bloc/monetizationBloc/monetization_bloc.dart';

import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import 'package:abrabar/logic/services/analytic_service.dart';
import 'package:abrabar/shared/sharedExtensions.dart';
import 'package:abrabar/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'package:get_it/get_it.dart';
import 'logic/api/recipes_api.dart';
import 'logic/services/notifications_service.dart';
import 'pages/splashScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

var notes = Notifications();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await RecipesApi.init();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_key',
        channelName: 'basic_channel',
        channelDescription: 'Самые обычные пуши :)',
        playSound: true,
        enableLights: true,
        enableVibration: true,
        importance: NotificationImportance.Max),
    // NotificationChannel(
    //     channelKey: 'default_notification_channel_id',
    //     channelName: 'default_notification_channel_id',
    //     channelDescription: '?????',
    //     playSound: true,
    //     enableLights: true,
    //     enableVibration: true,
    //     importance: NotificationImportance.Max),
  ]);
  notes.subscribeToNotes();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  GetIt.instance
    ..registerSingleton<AnalyticsService>(AnalyticsService())
    ..registerSingleton<CoctailBloc>(CoctailBloc()..add(CoctailsInitialize()))
    ..registerSingleton<MonetizationBloc>(MonetizationBloc());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  notes.onBackGroundNotification(message);
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final moneyBloc = GetIt.I.get<MonetizationBloc>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoctailBloc>(
          create: (context) => cockBloc,
        ),
        BlocProvider<MonetizationBloc>(create: (context) => moneyBloc)
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
            builder: (context, child) {
              return ScrollConfiguration(behavior: MyBehavior(), child: child!);
            },
            navigatorObservers: [
              GetIt.instance<AnalyticsService>().getAnalyticsObserver()
            ],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AbrabarTheme.lightTheme,
            title: 'Flutter Demo',
            home: const SplashScreen());
      }),
    );
  }
}
