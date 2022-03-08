import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quick_actions/quick_actions.dart';
import 'view/page/note_detail_page.dart';
import 'view/page/notes_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final QuickActions quickActions = QuickActions();

// This value relavant only with user back from notification
int? noteId;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = const AndroidInitializationSettings(
    'icon',
  );
  var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: null);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      noteId = int.tryParse(payload!);
    },
  );

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();

  await quickActions.initialize((String shortcutType) {
    noteId = int.tryParse(shortcutType);
  });

  runApp(myApp());
}

class myApp extends StatelessWidget {
  static final String title = 'Notes SQLite';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.blueGrey.shade900,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent, elevation: 0)),
        home: noteId == null
            ? NotesPage()
            : NoteDetailPage(noteId: noteId as int),
      );
}
