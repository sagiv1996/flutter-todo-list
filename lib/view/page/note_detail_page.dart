import 'package:flutter/material.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:fluuter_todo_list_app/db/notes_database.dart';
import 'package:intl/intl.dart';

import 'edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDataBase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: EdgeInsets.all(12),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        children: [
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold),
              children: [
                WidgetSpan(child:
                Icon(Icons.note, color: Colors.white70)),
                TextSpan(text:  ' ${note.title}'),

              ],
            ),
          ),


          SizedBox(height: 8),

          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white70, fontSize: 18),
              children: [
                WidgetSpan(child:
                Icon(Icons.speaker_notes, color: Colors.white70)),
                TextSpan(text:  ' ${note.description}'),
              ],
            ),
          ),

          SizedBox(height: 8),
          note.timeForNotification == 'null' ?
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white70),
              children: [
                WidgetSpan(child:
                Icon(Icons.notifications_off, color: Colors.white70)),
                TextSpan(text:  'לא הוגדרה התראה '),
              ],
            ),
          ):
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white70),
              children: [
                WidgetSpan(child: Icon(Icons.notifications_active, color: Colors.white70)),
                TextSpan(text:  ' ${DateFormat("y MMM d, H:mm").format(DateTime.parse(note.timeForNotification as String))}'),
              ],
            ),
          )
        ],
      ),
    ),
  );


  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await NotesDataBase.instance.delete(widget.noteId);

      Navigator.of(context).pop();
    },
  );

}

