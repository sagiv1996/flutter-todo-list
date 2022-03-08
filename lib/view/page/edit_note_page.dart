import 'package:flutter/material.dart';
import 'package:fluuter_todo_list_app/controller/controller_note.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:fluuter_todo_list_app/view/widget/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;

  late String description;

  late bool isCompleted;

  late DateTime? timeForNotfication;

  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    isCompleted = widget.note?.isCompleted ?? false;
    timeForNotfication =
        DateTime.tryParse((widget.note?.timeForNotification).toString());
    timeForNotfication = timeForNotfication != null &&
            timeForNotfication!.isAfter(DateTime.now())
        ? timeForNotfication
        : null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildCompletedButton(), buildSaveButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            title: title,
            description: description,
            timeForNotfication: timeForNotfication,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
            onChangeDateTime: (newTime) => setState(() =>
                timeForNotfication = DateTime.tryParse(newTime.toString())),
          ),
        ),
      );

  Widget buildCompletedButton() => Checkbox(
      value: isCompleted,
      onChanged: (isCompleted) {
        setState(() {
          this.isCompleted = isCompleted!;
        });
      });

  Widget buildSaveButton() =>
      IconButton(icon: const Icon(Icons.save), onPressed: addOrUpdateNote);

  void addOrUpdateNote() async {
    // Vaild from
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      // Update note
      if (widget.note != null) {
        updateNote();
      } else {
        addNote();
      }

      Navigator.of(context).pop();
    }
  }

  void addNote() async {
    // Create a new note
    final note = Note(
        title: title,
        description: description,
        createdTime: DateTime.now(),
        isCompleted: isCompleted,
        timeForNotification: timeForNotfication.toString());
    await ControllerNote.addNote(note);
  }

  void updateNote() async {
    final note = widget.note!.copy(
        title: title,
        description: description,
        timeForNotification: timeForNotfication.toString(),
        isCompleted: isCompleted);
    await ControllerNote.updateNote(note);
  }
}
