class Task {
  String title;
  DateTime dateTime;

  Task({
    required this.title,
    required this.dateTime,
  });

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(
          json['dateTime'],
        );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
