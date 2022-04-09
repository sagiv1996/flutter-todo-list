import 'package:flutter/material.dart';
import 'package:fluuter_todo_list_app/controller/controller_note.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:fluuter_todo_list_app/db/notes_database.dart';
import 'package:intl/intl.dart';
import 'edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  // This value be true is user come from the desktop (from shortcut or from notification)
  final bool isComingFromOut;

  const NoteDetailPage(
      {Key? key, required this.noteId, this.isComingFromOut = false})
      : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;

  bool isLoading = false;
  bool clickOnCloseDialog = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NotesDataBase.instance.readNote(widget.noteId);
    if (note == null) {
      Navigator.of(context).pop();
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  children: [
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                        children: [
                          const WidgetSpan(
                              child: Icon(Icons.note, color: Colors.white70)),
                          TextSpan(text: ' ${note.title}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 18),
                        children: [
                          const WidgetSpan(
                              child: Icon(Icons.speaker_notes,
                                  color: Colors.white70)),
                          TextSpan(text: ' ${note.description}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    note.timeForNotification == 'null'
                        ? const Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.white70),
                              children: [
                                WidgetSpan(
                                    child: Icon(Icons.notifications_off,
                                        color: Colors.white70)),
                                TextSpan(text: ' No notification set'),
                              ],
                            ),
                          )
                        : Text.rich(
                            TextSpan(
                              style: const TextStyle(color: Colors.white70),
                              children: [
                                const WidgetSpan(
                                    child: Icon(Icons.notifications_active,
                                        color: Colors.white70)),
                                TextSpan(
                                    text:
                                        ' ${DateFormat("y MMM d, H:mm").format(DateTime.parse(note.timeForNotification as String))}'),
                              ],
                            ),
                          ),
                    if (widget.isComingFromOut && !clickOnCloseDialog)
                      AlertDialog(
                        title: const Text('Choose your actions'),
                        actions: [
                          completedNote(),
                          remindMeLater(5),
                          remindMeLater(15),
                          remindMeLater(30),
                          remindMeLater(60),
                          closeDialog()
                        ],
                      )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await ControllerNote.deleteNote(note.id as int);
          Navigator.of(context).pop();
        },
      );

  Widget completedNote() => TextButton(
      child: const Text('Completed'),
      onPressed: () async {
        Note newNote = note.copy(isCompleted: true);
        await ControllerNote.updateNote(newNote);
        Navigator.of(context).pop();
      });

  Widget remindMeLater(int minutes) => TextButton(
      onPressed: () async {
        Note newNote = note.copy(
            timeForNotification:
                DateTime.now().add(Duration(minutes: minutes)).toString());

        await ControllerNote.updateNote(newNote);
        Navigator.of(context).pop();
      },
      child: Text('$minutes minutes'));

  closeDialog() => TextButton(
    onPressed: () => setState(() {
      clickOnCloseDialog = true;
    }),
    child: const Text('Close dialog'),
  );
}
