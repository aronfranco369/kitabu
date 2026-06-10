import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FcmService {
  static Future<void> init(BuildContext context) async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await Future.wait([
      FirebaseMessaging.instance.subscribeToTopic('new_content'),
      FirebaseMessaging.instance.subscribeToTopic('new_episodes'),
    ]);

    // Foreground: show snackbar with Watch action
    FirebaseMessaging.onMessage.listen((message) {
      final n = message.notification;
      if (n == null || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${n.title}: ${n.body}'),
          action: message.data['media_id'] != null
              ? SnackBarAction(
                  label: 'Watch',
                  onPressed: () {
                    if (context.mounted) {
                      context.push('/detail/${message.data['media_id']}');
                    }
                  },
                )
              : null,
        ),
      );
    });

    // Background tap → navigate to detail
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final mediaId = message.data['media_id'];
      if (mediaId != null && context.mounted) {
        context.push('/detail/$mediaId');
      }
    });

    // Terminated tap → navigate to detail
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      final mediaId = initial.data['media_id'];
      if (mediaId != null && context.mounted) {
        context.push('/detail/$mediaId');
      }
    }
  }
}
