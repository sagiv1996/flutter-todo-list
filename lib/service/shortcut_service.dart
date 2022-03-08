import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:quick_actions/quick_actions.dart';

class ShortcuteService {
  List<ShortcutItem> returnShortcuts(List<Note> notes) {
    List<ShortcutItem> shortcutItems =
        notes.map((note) => noteToShortcutItem(note)).toList();
    // type = -1 is mean new note
    shortcutItems.insert(
        0, ShortcutItem(localizedTitle: 'New note', type: '-1'));
    return shortcutItems;
  }

  ShortcutItem noteToShortcutItem(Note note) => ShortcutItem(
      type: note.id.toString(), localizedTitle: note.title, icon: 'AppIcon');
}
