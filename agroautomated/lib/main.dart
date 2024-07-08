import 'package:agroautomated/notification_class.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:agroautomated/pages/auth_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'functions/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await NotificationHelper.initialize();

  NotificationService().initNotification(); // sonradan videodan eklendi

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Initialize Firebase with the current platform options
  );

  final messaging = FirebaseMessaging.instance;
  // subscribe to a topic.
  const topic = 'app_promotion';
  await messaging.subscribeToTopic(topic);
  // Abone olma işlemi
  //const topic = 'app_promotion';
  // await messaging.subscribeToTopic(topic);

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // TODO: Register with FCM
// It requests a registration token for sending messages to users from your App server or other trusted server environment.
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }

  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  // TODO: Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    String? title = message.notification?.title;
    String? body = message.notification?.body;

    NotificationService().showNotification(title: title, body: body);

    _messageStreamController.sink.add(message);
  });

  // TODO: Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: MainApp()));
}

// TODO: Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }

  String? title = message.notification?.title;
  String? body = message.notification?.body;

  NotificationService().showNotification(title: title, body: body);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'AgroAutomated',
        debugShowCheckedModeBanner: false,
        //  theme: AppTheme.lightTheme,
        //  darkTheme: AppTheme.darkTheme,
        home: const AuthPage(),
      ),
    );
  }
}
