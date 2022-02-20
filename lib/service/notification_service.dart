import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';


class NotificationService {

  static final NotificationService notificationService =
  NotificationService.internal();

  factory NotificationService() {
    return notificationService;
  }

  NotificationService.internal();


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const  IOSNotificationDetails iosNotification = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
  );

  static const AndroidNotificationDetails androidNotification = AndroidNotificationDetails(
    'todolist_notif',
    'todolist_notif',

  );

  static const platformChannelSpecifics = NotificationDetails(android: androidNotification, iOS: iosNotification);


  void scheduleNotification(DateTime scheduledNotificationDateTime, Note note) async {

//    await flutterLocalNotificationsPlugin.schedule(note.id as int, note.title, note.description,
//        DateTime.parse(scheduledNotificationDateTime.toString()), platformChannelSpecifics, payload: note.id.toString());
//
//;

  // Set time zone for israel
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jerusalem'));
    print(DateTime.parse(note.timeForNotfication.toString()));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        note.id as int,
        note.title,
        note.description,
        tz.TZDateTime.from(DateTime.parse(note.timeForNotfication.toString()), tz.local),
        platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }


  void cancelNotfication(int id){
    flutterLocalNotificationsPlugin.cancel(id);
  }
}