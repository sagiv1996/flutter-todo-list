import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'page/note_detail_page.dart';
import 'page/notes_page.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();


  var initializationSettingsAndroid =
  AndroidInitializationSettings('icon', );
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: null);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
          runApp(MaterialApp(
            home: NoteDetailPage(noteId: int.parse(payload!))
          )
          );
      },

  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); WidgetsFlutterBinding.ensureInitialized();



      runApp(myApp());
}

class myApp extends StatelessWidget {
  static final String title = 'Notes SQLite';

  @override
  Widget build(BuildContext context) => MaterialApp(
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child as Widget,

      ),


     // builder: (context, child) =>
       // MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child as Widget),
    debugShowCheckedModeBanner: false,
    title: title,
    themeMode: ThemeMode.dark,
    theme: ThemeData(
     primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.blueGrey.shade900,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0
      )
    ),
    home: NotesPage(),
  );
}
