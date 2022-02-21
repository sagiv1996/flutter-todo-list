import 'package:fluuter_todo_list_app/db/notes_database.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:fluuter_todo_list_app/service/notification_service.dart';

class controllerNote{

  // This method create note and create notification
  static Future addNote(Note note) async {
    Note newNote =  await NotesDataBase.instance.create(note);
    if(note.timeForNotification != null){
      NotificationService().scheduleNotification(newNote);
    }
  }

  // This method update note and create / cancel notifiation
  static Future updateNote(Note note) async{
    await NotesDataBase.instance.update(note);

    // Cancel notificatin and create new notification if datetime is valid
    NotificationService().cancelNotfication(note.id as int );

    // timeForNotification is save string at database . is why i used 'null'
     if (note.timeForNotification != null &&
         note.timeForNotification != 'null' &&
         note.isCompleted == false &&
         DateTime.parse(note.timeForNotification.toString()).isAfter(DateTime.now()
         )){
        NotificationService().scheduleNotification(note);
    }
  }
}