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
      String title = message.notification!.title!;
      String body = message.notification!.body!;
      debugPrint('Message also contained a notification: Title $title');
      debugPrint('Message also contained a notification: Body $body');

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
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
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
      child: Builder(
        builder: (context) {
          final cubit = BlocProvider.of<AuthCubit>(context);
          return BlocBuilder<AuthCubit, AuthState>(
            bloc: cubit,
            buildWhen: (previous, current) =>
                current is AuthInitial || current is AuthDone,

            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'E-commerce App',
                navigatorKey: navigatorKey,
                theme: ThemeData(
                  colorScheme: .fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),

                initialRoute: state is AuthDone
                    ? AppRoutes.homeRoute
                    : AppRoutes.loginRoute,
                onGenerateRoute: AppRouters.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
