import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:rcore/utils/color/theme.dart';
import 'package:rcore/views/landing/landing_screen.dart';

import 'bloc/auth/bloc/bloc_auth.dart';
import 'bloc/customer/bloc/bloc_customer.dart';
import 'bloc/user/bloc_user.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint("Handling a background message: ${message.messageId}");
}

void _setupDefaultOrientation() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupDefaultOrientation();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('DEVICE TOKEN: $fcmToken');

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  debugPrint('User granted permission: ${settings.authorizationStatus}');
  //end bo sung

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => BlocAuth(context: context)),
            BlocProvider(create: (context) => BlocCustomer(context: context)),
            BlocProvider(create: (context) => BlocUser(context: context)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'App Happy Home CTV',
            theme: ThemeData(fontFamily: 'NeoSans').copyWith(
              backgroundColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              primaryColor: themeColor,
            ),
            supportedLocales: const [
              Locale('vi', 'VN'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: const LoaderOverlay(child: LandingScreen()),
          )),
    );
  }
}
