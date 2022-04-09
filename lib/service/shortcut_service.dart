import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:quick_actions/quick_actions.dart';

class ShortcuteService {
  List<ShortcutItem> returnShortcuts(List<Note> notes) {
    // Cut list note
    notes = notes.sublist(0, 4);

    List<ShortcutItem> shortcutItems =
        notes.map((note) => noteToShortcutItem(note)).toList();
    // type = -1 is mean new note
    shortcutItems.insert(
        0, ShortcutItem(localizedTitle: 'New note', type: '-1', icon: 'add_note'));
    return shortcutItems;
  }

  ShortcutItem noteToShortcutItem(Note note) => ShortcutItem(
      type: note.id.toString(), localizedTitle: note.title, icon: note.isCompleted? 'completed' : 'not_completed');
}
