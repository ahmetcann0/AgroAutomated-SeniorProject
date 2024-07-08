import 'package:agroautomated/notification_class.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _lastMessage = "";

  // Define _messageStreamController
  late final BehaviorSubject<RemoteMessage> _messageStreamController;

  @override
  void initState() {
    super.initState();

    // Initialize _messageStreamController
    _messageStreamController = BehaviorSubject<RemoteMessage>();

    // Listen for incoming FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _messageStreamController.add(message);
    });

    // Listen to messages from _messageStreamController
    _messageStreamController.listen((message) {
      setState(() {
        if (message.notification != null) {
          _lastMessage = 'Received a notification message:'
              '\nTitle=${message.notification?.title},'
              '\nBody=${message.notification?.body},'
              '\nData=${message.data}';
        } else {
          _lastMessage = 'Received a data message: ${message.data}';
        }
      });
    });
  }

  @override
  void dispose() {
    // Dispose _messageStreamController
    _messageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  NotificationService().showNotification();
                },
                child: Text("send Notification")),
            Text('Last message from Firebase Messaging:',
                style: Theme.of(context).textTheme.headline6),
            Text(_lastMessage, style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
      ),
    );
  }
}
