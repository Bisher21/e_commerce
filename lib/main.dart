import 'package:e_commerce/utils/app_routers.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/auth_cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  await initializeApp();

  runApp(const MyApp());
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await handleMyNotification();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> handleMyNotification() async {
  //handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //request permission
  FirebaseMessaging message = FirebaseMessaging.instance;
  NotificationSettings settings = await message.requestPermission();
  debugPrint("user granted permission:${settings.authorizationStatus}");

  //handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      String title = message.notification!.title ?? 'Notification';
      String body = message.notification!.body ?? '';
      debugPrint('Message also contained a notification: Title $title');
      debugPrint('Message also contained a notification: Body $body');

      if (navigatorKey.currentContext != null) {
        showDialog<void>(
          context: navigatorKey.currentContext!,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('A new onMessageOpenedApp event was published!');
    debugPrint('Message data: ${message.data}');
    final messageData = message.data;
    if (messageData['product_id'] != null) {
      navigatorKey.currentState!.pushNamed(
        AppRoutes.productDetailsRoute,
        arguments: messageData['product_id'],
      );
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AuthCubit();
        cubit.checkAuth();
        return cubit;
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) =>
            current is AuthInitial || current is AuthDone,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-commerce App',
            navigatorKey: navigatorKey,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF8F7FC),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
                iconTheme: IconThemeData(color: Colors.black87),
              ),

              cardTheme: const CardThemeData(
                elevation: 0,
                color: Colors.white,
                margin: EdgeInsets.zero,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFE53935),
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFE53935),
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.0,
                ),
                headlineLarge: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
                headlineMedium: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
                headlineSmall: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
                titleLarge: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
                titleMedium: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
                bodyMedium: TextStyle(letterSpacing: 0, height: 1.5),
              ),
            ),
            initialRoute: state is AuthDone
                ? AppRoutes.homeRoute
                : AppRoutes.loginRoute,
            onGenerateRoute: AppRouters.onGenerateRoute,
          );
        },
      ),
    );
  }
}
