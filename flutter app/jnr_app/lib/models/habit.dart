class Habit {
  final String id;
  final String title;
  final String timeOfDay;
  final List<String> completedDates;

  Habit({
    required this.id,
    required this.title,
    required this.timeOfDay,
    required this.completedDates,
  });

  factory Habit.fromMap(String id, Map<String, dynamic> data) {
    return Habit(
      id: id,
      title: data['title'],
      timeOfDay: data['timeOfDay'],
      completedDates: List<String>.from(data['completedDates'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'timeOfDay': timeOfDay,
      'completedDates': completedDates,
    };
  }
}

