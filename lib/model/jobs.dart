class Job {
  final String id;
  final String title;
  final String technician;
  final String date;
  final bool isCompleted;

  Job({
    required this.id,
    required this.title,
    required this.technician,
    required this.date,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'technician': technician,
      'date': date,
      'isCompleted': isCompleted,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      technician: map['technician'] ?? '',
      date: map['date'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // اضيف copyWith هنا
  Job copyWith({
    String? id,
    String? title,
    String? technician,
    String? date,
    bool? isCompleted,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      technician: technician ?? this.technician,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
