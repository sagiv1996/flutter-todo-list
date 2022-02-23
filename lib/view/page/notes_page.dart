import 'package:flutter/material.dart';
import 'package:fluuter_todo_list_app/controller/controller_note.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:fluuter_todo_list_app/db/notes_database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluuter_todo_list_app/view/widget/note_card_widget.dart';
import 'package:quick_actions/quick_actions.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;

  bool isLoading = false;

  String shortcut = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        if (shortcutType != null) shortcut = shortcutType;
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'Notification',
        localizedTitle: 'New note',
        icon: 'add',
      ),
    ]).then((value) => {
          if (shortcut == 'Notification')
            {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddEditNotePage()))
            }
        });
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'כל המשימות',
            style: TextStyle(fontSize: 24.0),
          ),
          actions: [
            createInfoButton(),
            SizedBox(
              width: 12.0,
            )
          ],
        ),
        body: Center(
          child: this.isLoading
              ? CircularProgressIndicator()
              : this.notes.isEmpty
                  ? const Text('הוסף משימות')
                  : this.buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  Future refreshNotes() async {
    setState(() {
      this.isLoading = true;
    });
    this.notes = await NotesDataBase.instance.readAllNotes();

    setState(() {
      this.isLoading = false;
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    NotesDataBase.instance.close();

    super.deactivate();
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onLongPress: () async {
              // Update record
              Note noteToUpdate =
                  note.copy(id: note.id, isCompleted: !note.isCompleted);
              await ControllerNote.updateNote(noteToUpdate);

              refreshNotes();
            },
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );

  IconButton createInfoButton() => IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Text('לחיצה ארוכה על המשימה תסמן אותה כבוצעה'),
                ));
      },
      icon: Icon(Icons.info_outline));
}
