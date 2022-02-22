import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluuter_todo_list_app/model/note.dart';

class NotesDataBase {
  static final NotesDataBase instance = NotesDataBase._init();

  static Database

  ?

  _database

  ;

  NotesDataBase._init();

  Future

  <

  Database

  ?

  >

  get database async {
    if (_database != null) return _database;
    _database = await _initDb('notes.db');
    return _database;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 3, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final dateTimeType = 'DATETIME';
    final boolType = 'BOOLEAN DEFAULT 0';
    await db.execute('''
    CREATE TABLE $tableNotes ( 
      ${NoteFields.id} $idType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.createdTime} $dateTimeType,
      ${NoteFields.isCompleted} $boolType,
      ${NoteFields.timeForNotification} $textType
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db
    !.insert(tableNotes, note.toJson());
    return note.copy(id:id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db
    !.query(
    tableNotes,
    columns: NoteFields.values,
    where: '${NoteFields.id} = ?',
    whereArgs: [id]
    );
    if(maps.isNotEmpty) return Note.fromJson(maps.first);
    else throw Exception('Id $id not found');
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.isCompleted}, ${NoteFields.createdTime} ASC';
    final result = await db
    !.query(
    tableNotes,
    columns: NoteFields.values,
    orderBy: orderBy
    );

    return result.map((json) => Note.fromJson(json)
    )
    .
    toList
    (
    );
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db
    !.update(tableNotes, note.toJson(), where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db
    !.delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]
    );
  }

  Future close() async {
    final db = await instance.database;
    db
    !
    .
    close
    (
    );
  }
}
