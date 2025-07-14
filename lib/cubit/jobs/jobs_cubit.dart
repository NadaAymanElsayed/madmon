import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../model/jobs.dart';
part 'jobs_state.dart';


class JobsCubit extends Cubit<JobsState> {
  final FirebaseFirestore firestore;

  JobsCubit(this.firestore) : super(JobsState.initial()) {
    loadJobs();
  }

  Future<void> loadJobs() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final snapshot = await firestore.collection('jobs').get();

      final jobs = snapshot.docs.map((doc) {
        final data = doc.data();
        return Job(
          id: doc.id,
          title: data['title'] ?? '',
          technician: data['technician'] ?? '',
          date: data['date'] ?? '',
          notes: data['notes'],
          isCompleted: data['isCompleted'] ?? false,
        );
      }).toList();

      emit(state.copyWith(jobs: jobs, isLoading: false));
    } catch (e) {
      print('Error loading jobs: $e');
      emit(state.copyWith(jobs: [], isLoading: false, error: 'فشل تحميل المهام'));
    }
  }

  Future<void> addJob(Job job) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final docRef = firestore.collection('jobs').doc();
      final newJob = job.copyWith(id: docRef.id);

      await docRef.set({
        'title': newJob.title,
        'technician': newJob.technician,
        'date': newJob.date,
        'notes': newJob.notes,
        'isCompleted': newJob.isCompleted,
      });
      await loadJobs();
    } catch (e) {
      print('Error adding job: $e');
      emit(state.copyWith(isLoading: false, error: 'حدث خطأ أثناء إضافة المهمة'));
    }
  }

  Future<void> loadJobsForTechnician(String technicianName) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final snapshot = await firestore
          .collection('jobs')
          .where('technician', isEqualTo: technicianName)
          .get();

      final jobs = snapshot.docs.map((doc) {
        final data = doc.data();
        return Job(
          id: doc.id,
          title: data['title'] ?? '',
          technician: data['technician'] ?? '',
          date: data['date'] ?? '',
          notes: data['notes'],
          isCompleted: data['isCompleted'] ?? false,
        );
      }).toList();

      emit(state.copyWith(jobs: jobs, isLoading: false));
    } catch (e) {
      print('Error loading technician jobs: $e');
      emit(state.copyWith(jobs: [], isLoading: false, error: 'حدث خطأ أثناء تحميل مهام الفني'));
    }
  }

  Future<void> updateJob(Job updatedJob) async {
    try {
      await firestore.collection('jobs').doc(updatedJob.id).update({
        'title': updatedJob.title,
        'technician': updatedJob.technician,
        'date': updatedJob.date,
        'notes': updatedJob.notes,
        'isCompleted': updatedJob.isCompleted,
      });

      await loadJobs(); // لتحديث الحالة بعد التعديل
    } catch (e) {
      print('Error updating job: $e');
      emit(state.copyWith(error: 'حدث خطأ أثناء تعديل المهمة'));
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await firestore.collection('jobs').doc(jobId).delete();
      await loadJobs(); // لتحديث الحالة بعد الحذف
    } catch (e) {
      print('Error deleting job: $e');
      emit(state.copyWith(error: 'حدث خطأ أثناء حذف المهمة'));
    }
  }
}


