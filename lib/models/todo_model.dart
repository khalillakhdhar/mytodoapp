class Todo {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  // Convertir un objet Todo en map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  // Créer un objet Todo depuis un map SQLite
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}
