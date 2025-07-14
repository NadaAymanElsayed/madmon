import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TechnicianState {
  final List<String> technicians;
  final bool isLoading;
  final String? error;

  TechnicianState({
    required this.technicians,
    required this.isLoading,
    this.error,
  });

  factory TechnicianState.initial() => TechnicianState(
    technicians: [],
    isLoading: false,
    error: null,
  );

  TechnicianState copyWith({
    List<String>? technicians,
    bool? isLoading,
    String? error,
  }) {
    return TechnicianState(
      technicians: technicians ?? this.technicians,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}


class TechniciansCubit extends Cubit<List<String>> {
  final FirebaseFirestore firestore;

  TechniciansCubit(this.firestore) : super([]);

  Future<void> loadTechnicians() async {
    try {
      final snapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'technician')
          .get();

      final names = snapshot.docs.map((doc) {
        return (doc.data()['name'] ?? '').toString().trim();
      }).where((name) => name.isNotEmpty).toSet().toList();

      names.sort();
      emit(names);
    } catch (e) {
      print("Error loading technicians: $e");
      emit([]);
    }
  }
}

