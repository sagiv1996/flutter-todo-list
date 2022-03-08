import 'package:fluuter_todo_list_app/db/notes_database.dart';
import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:quick_actions/quick_actions.dart';

class ShortcuteService {
  Future<List<ShortcutItem>> returnShortscute() async {
    List<ShortcutItem> shortcutItems = [];
    List<Note> notes = await NotesDataBase.instance.readAllNotes();
    shortcutItems.addAll(notes.map((e) => noteToShortcutItem(e)));
    shortcutItems
        .add(ShortcutItem(type: 'new_note', localizedTitle: 'New note'));
    return shortcutItems;
  }

  List<ShortcutItem> returnShortcuts(List<Note> notes) =>
      notes.map((note) => noteToShortcutItem(note)).toList();

  ShortcutItem noteToShortcutItem(Note note) => ShortcutItem(
      type: note.id.toString(), localizedTitle: note.title, icon: 'AppIcon');
}
