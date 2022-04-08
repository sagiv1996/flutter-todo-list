import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'view/page/notes_page.dart';


// This value relavant only with user back from notification
 int? noteId;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainClass());
}

class MainClass extends StatelessWidget {
  static String title = 'Todo list app';

  const MainClass({Key? key}) : super(key: key);

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
      home: NotesPage()
      );
}
