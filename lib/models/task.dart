class Task {
  final String id;
  final String title;
  final DateTime? duedate;
  bool isCompleted;
  Task(
      {required this.id,
      required this.title,
      required this.duedate,
      this.isCompleted = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      duedate: json['duedate'] != null ? DateTime.parse(json['duedate']) : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duedate': duedate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
