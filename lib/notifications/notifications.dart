import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationModel {
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialaze = new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializeSettings = new InitializationSettings(android: androidInitialaze);
    await flutterLocalNotificationsPlugin.initialize(initializeSettings);
  }

static Future showBigTextNotification({
  var id = 0,
  required String title,
  required String body,
  var payload,
  required FlutterLocalNotificationsPlugin fln
}) async {
 AndroidNotificationDetails androidNotificationDetails = new AndroidNotificationDetails(
    'flutterEmbedding', 
    'title',

    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
    );

    var noti = NotificationDetails(android:  androidNotificationDetails);
    await fln.show(id, title, body, noti);
 }

}