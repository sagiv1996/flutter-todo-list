import 'package:flutter/material.dart';
import 'package:fluuter_todo_list_app/db/notes_database.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:fluuter_todo_list_app/service/notification_service.dart';
import 'package:fluuter_todo_list_app/widget/note_form_widget.dart';

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
    timeForNotfication = DateTime.tryParse((widget.note?.timeForNotfication).toString());
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          actions: [ buildCompletedButton(), buildSaveButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            title: title,
            description: description,
            timeForNotfication: timeForNotfication,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) => setState(() => this.description = description),
            onChangeDateTime: (newTime) => setState(() => this.timeForNotfication = DateTime.tryParse(newTime.toString())),
          ),


        ),
      );




  Widget buildCompletedButton() => Checkbox(
    value: isCompleted,
    onChanged:(isCompleted){
      setState(() {
        this.isCompleted = isCompleted!;
      });
    }
  );

  Widget buildSaveButton() => IconButton(
      icon: Icon(Icons.save),
      onPressed: addOrUpdateNote
      );


  void addOrUpdateNote() async {
    final isValid = _formKey.currentState
    !.validate();

    if (isValid) {
    final isUpdating = widget.note != null;

    if (isUpdating) {
    await updateNote();

    } else {
    await addNote();
    }

    Navigator.of(context).pop();


    }
  }

  Future updateNote() async {
    final note = widget.note
    !.copy(
      title: title,
      description: description,
      timeForNotfication: timeForNotfication.toString(),
      isCompleted: isCompleted
    );

    await NotesDataBase.instance.update(note);
    NotificationService().cancelNotfication(note.id as int );
     if (timeForNotfication != null && timeForNotfication!.isAfter(DateTime.now())){
      NotificationService().scheduleNotification(timeForNotfication!, note);
    }

  }

  Future addNote() async {
    final note = Note(
      title: title,
      description: description,
      createdTime: DateTime.now(),
      isCompleted: isCompleted,
      timeForNotfication: timeForNotfication.toString()
    );

    Note newNote =  await NotesDataBase.instance.create(note);
      NotificationService().scheduleNotification(timeForNotfication!, newNote);

  }
}