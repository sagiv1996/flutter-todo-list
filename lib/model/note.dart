final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, title, description, createdTime, isCompleted, timeForNotification
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String createdTime = 'createdTime';
  static final String isCompleted = 'isCompleted';
  static final String timeForNotification = 'timeForNotfication';
}

class Note {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;
  final bool isCompleted;
  final String? timeForNotification;

  const Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.isCompleted,
    this.timeForNotification
  });


  Note copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdTime,
    bool? isCompleted,
    String? timeForNotification
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
        isCompleted: isCompleted ?? this.isCompleted,
        timeForNotification: timeForNotification?? this.timeForNotification
      );

  static Note fromJson(Map<String, Object?> json)=>
  Note(
      id: json[NoteFields.id] as int?,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      createdTime: DateTime.parse(json[NoteFields.createdTime] as String),
      isCompleted: json[NoteFields.isCompleted] == 1,
      timeForNotification: json[NoteFields.timeForNotification] as String

  );

  Map<String, Object?> toJson() => {
    NoteFields.id: id,
    NoteFields.title: title,
    NoteFields.description: description,
    NoteFields.createdTime: createdTime.toIso8601String(),
    NoteFields.isCompleted: isCompleted == true? '1' : 0,
    NoteFields.timeForNotification: timeForNotification
  };

}