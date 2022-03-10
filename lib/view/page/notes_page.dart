import 'package:flutter/material.dart';
import 'package:fluuter_todo_list_app/controller/controller_note.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:fluuter_todo_list_app/db/notes_database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluuter_todo_list_app/service/shortcut_service.dart';
import 'package:fluuter_todo_list_app/view/widget/note_card_widget.dart';
import '../../main.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;

//
//  final QuickActions quickActions = QuickActions().;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    refreshNotes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'All notes',
            style: TextStyle(fontSize: 24.0),
          ),
          actions: [
            createInfoButton(),
            const SizedBox(
              width: 12.0,
            )
          ],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text('Add notes')
                  : buildNotes(),
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
      isLoading = true;
    });
    notes = await NotesDataBase.instance.readAllNotes();

    // Set shortcuts items
    quickActions.setShortcutItems(ShortcuteService().returnShortcuts(notes));

    setState(() {
      isLoading = false;
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
            builder: (_) => const AlertDialog(
                  content: Text('Long press change note to completed'),
                ));
      },
      icon: const Icon(Icons.info_outline));
}
