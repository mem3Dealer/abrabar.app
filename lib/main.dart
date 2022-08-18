import 'package:abrabar/logic/bloc/bloc/monetizationBloc/monetization_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'channelId',
  'Channel name',
  importance: Importance.max,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flnPlugin =
    FlutterLocalNotificationsPlugin();

final initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_abrabar_note');

final initializationSettingsIOS = IOSInitializationSettings();

final initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

var api = RecipesApi();
var notes = Notifications();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FlutterBranchSdk.validateSDKIntegration();
  FlutterBranchSdk.initSession().listen((data) {});

  //Чтобы стянуть джейсон рецептов нужно сначачала раскоментить это, и перейти в RecipesApi.
  // await RecipesApi.init();

  notes.subscribeToNotes(flnPlugin, channel);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flnPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  GetIt.instance
    ..registerSingleton<AnalyticsService>(AnalyticsService())
    ..registerSingleton<CoctailBloc>(CoctailBloc()..add(CoctailsInitialize()))
    ..registerSingleton<MonetizationBloc>(
        MonetizationBloc()..add(MonetizationInit()));

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(MyApp());
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   notes.onBackGroundNotification(message);
// }

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    moneyBloc.dispose();
    super.dispose();
  }

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
            title: 'abrabar',
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return ScrollConfiguration(behavior: MyBehavior(), child: child!);
            },
            navigatorObservers: [
              GetIt.instance<AnalyticsService>().getAnalyticsObserver()
            ],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AbrabarTheme.lightTheme,
            home: const SplashScreen());
      }),
    );
  }
}
