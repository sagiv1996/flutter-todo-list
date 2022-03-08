import 'package:fluuter_todo_list_app/model/note.dart';
import 'package:quick_actions/quick_actions.dart';

class ShortcuteService {
  List<ShortcutItem> returnShortcuts(List<Note> notes) =>
      notes.map((note) => noteToShortcutItem(note)).toList();

  ShortcutItem noteToShortcutItem(Note note) => ShortcutItem(
      type: note.id.toString(), localizedTitle: note.title, icon: 'AppIcon');
}
