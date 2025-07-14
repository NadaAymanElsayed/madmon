import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String title;
  final String technician;
  final String date;
  final String? notes;
  final bool isCompleted;

  Job({
    required this.id,
    required this.title,
    required this.technician,
    required this.date,
    this.notes,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'technician': technician,
      'date': date,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  factory Job.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Job(
      id: doc.id,
      title: map['title'] ?? '',
      technician: map['technician'] ?? '',
      date: map['date'] ?? '',
      notes: map['notes'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Job copyWith({
    String? id,
    String? title,
    String? technician,
    String? date,
    String? notes,
    bool? isCompleted,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      technician: technician ?? this.technician,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
