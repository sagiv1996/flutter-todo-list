import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluuter_todo_list_app/controller/controller_note.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:fluuter_todo_list_app/db/notes_database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluuter_todo_list_app/service/shortcut_service.dart';
import 'package:fluuter_todo_list_app/view/widget/note_card_widget.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = <Note>[];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final QuickActions quickActions = QuickActions();

  bool isLoading = false;
  int offset = 0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var initializationSettingsIOS = const IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    quickActions.initialize((type) {
      navigateRoute(int.parse(type));
    });

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) {
        navigateRoute(int.parse(payload!));
      },
    );

    super.initState();

    refreshNotes();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        offset++;
        refreshNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'All notes',
            style: TextStyle(fontSize: 24.0),
          ),
          actions: [
            createFilterButton(),
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
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditNotePage()),
            );
            notes.clear();
            offset = 0;
            refreshNotes();
          },
        ),
      );

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    List<Note> newNotes =
        await NotesDataBase.instance.readAllNotes(offset: offset);

    if (newNotes.isNotEmpty) {
      if (notes.isEmpty) {
        notes = newNotes;
      } else {
        notes.addAll(newNotes);
      }

      // Set shortcuts items
      if (notes.isNotEmpty) {
        quickActions
            .setShortcutItems(ShortcuteService().returnShortcuts(notes));
      }
    }

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
        padding: const EdgeInsets.all(8),
        controller: scrollController,
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
              notes.clear();
              offset = 0;
              refreshNotes();
            },
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(
                  noteId: note.id!,
                ),
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

  IconButton createFilterButton() => IconButton(
        icon: const Icon(Icons.filter_alt),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          showModalBottomSheet<void>(
              isScrollControlled: true,
              isDismissible: true,
              context: context,
              builder: (BuildContext context) {
                List<RadioTemp> noteStatusOptions = [
                  RadioTemp(true, 'Completed'),
                  RadioTemp(false, 'Not completed')
                ];
                Object? noteStatus = prefs.getBool('noteStatus');
                List<RadioTemp> notificationOptions = [
                  RadioTemp('not null', 'No alert set'),
                  RadioTemp('null', 'An alert has been set'),
                  RadioTemp('this day', 'Today'),
                  RadioTemp('this month', 'In This month'),
                ];
                Object? notification = prefs.getString('notificationExist');

                return StatefulBuilder(
                  builder: (context, setState) {
                    return SizedBox(
                      height: 300,
                      child: ListView(
                        children: [
                          ListView.builder(
                              itemCount: noteStatusOptions.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, pos) => RadioListTile(
                                    title: Text(noteStatusOptions[pos]
                                        .title
                                        .toString()),
                                    groupValue: noteStatus,
                                    value: noteStatusOptions[pos].value,
                                    toggleable: true,
                                    onChanged: (value) async {
                                      setState(() {
                                        noteStatus = value;
                                      });
                                      // Check if clear value or update value
                                      value == null
                                          ? await prefs.remove('noteStatus')
                                          : await prefs.setBool(
                                              'noteStatus', value as bool);
                                      notes.clear();
                                      offset = 0;
                                      refreshNotes();
                                    },
                                  )),
                          ListView.builder(
                              itemCount: notificationOptions.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, pos) => RadioListTile(
                                    toggleable: true,
                                    title: Text(notificationOptions[pos]
                                        .title
                                        .toString()),
                                    groupValue: notification,
                                    value: notificationOptions[pos].value,
                                    onChanged: (value) async {
                                      setState(() {
                                        notification = value;
                                      });
                                      value == null
                                          ? await prefs
                                              .remove('notificationExist')
                                          : await prefs.setString(
                                              'notificationExist',
                                              value as String);
                                      notes.clear();
                                      offset = 0;
                                      refreshNotes();
                                    },
                                  ))
                        ],
                      ),
                    );
                  },
                );
              });
        },
      );

  ListView createCustomList(Object? grValue, List<String> items) =>
      ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, pos) => RadioListTile(
                title: Text(items[pos]),
                groupValue: grValue,
                value: items[pos],
                onChanged: (value) {
                  setState(() {
                    grValue = value;
                  });
                },
              ));

  void navigateRoute(int noteId) async {
    if (noteId == -1) {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AddEditNotePage(),
      ));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteDetailPage(
          noteId: noteId,
          isComingFromOut: true,
        ),
      ));
    }
    notes.clear();
    offset = 0;
    refreshNotes();
  }
}

// This class contains fields for radio filters. the fields is value and title.
class RadioTemp {
  Object value;
  Object title;

  RadioTemp(this.value, this.title);
}
