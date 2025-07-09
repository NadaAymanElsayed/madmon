import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/jobs.dart';
part 'home_state.dart';



class JobsCubit extends Cubit<JobsState> {
  final FirebaseFirestore firestore;

  JobsCubit(this.firestore) : super(JobsState([])) {
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      final snapshot = await firestore.collection('jobs').get();

      final jobs = snapshot.docs.map((doc) {
        final data = doc.data();
        return Job(
          id: doc.id,
          title: data['title'] ?? '',
          technician: data['technician'] ?? '',
          date: data['date'] ?? '',
          isCompleted: data['isCompleted'] ?? false,
        );
      }).toList();

      emit(JobsState(jobs));
    } catch (e) {
      print('Error loading jobs: $e');
      emit(JobsState([]));
    }

  }

  Future<void> addJob(Job job) async {
    try {
      await firestore.collection('jobs').doc(job.id).set({
        'title': job.title,
        'technician': job.technician,
        'date': job.date,
        'isCompleted': job.isCompleted,
      });

      await loadJobs();  // انتظر حتى يكتمل التحميل
    } catch (e) {
      print('Error adding job: $e');
    }
  }

  Future<void> updateJob(Job newJob) async {
    try {
      await firestore.collection('jobs').doc(newJob.id).update({
        'title': newJob.title,
        'technician': newJob.technician,
        'date': newJob.date,
        'isCompleted': newJob.isCompleted,
      });

      await loadJobs();  // انتظر حتى يكتمل التحميل
    } catch (e) {
      print('Error updating job: $e');
    }
  }

  Future<void> loadJobsForTechnician(String technicianName) async {
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
          isCompleted: data['isCompleted'] ?? false,
        );
      }).toList();

      emit(JobsState(jobs));
    } catch (e) {
      print('Error loading technician jobs: $e');
      emit(JobsState([]));
    }
  }
}


/*
class JobsCubit extends Cubit<JobsState> {
  JobsCubit() : super(JobsState([]));

  final jobsCollection = FirebaseFirestore.instance.collection('jobs');

  void loadJobs() {
    jobsCollection.snapshots().listen((snapshot) {
      final jobs = snapshot.docs.map((doc) {
        final data = doc.data();
        return Job(
          id: doc.id,
          title: data['title'],
          technician: data['technician'],
          date: data['date'],
          isCompleted: data['isCompleted'],
        );
      }).toList();

      emit(JobsState(jobs));
    });
  }

  Future<void> addJob(Job job) async {
    await jobsCollection.add({
      'title': job.title,
      'technician': job.technician,
      'date': job.date,
      'isCompleted': job.isCompleted,
    });
  }

  Future<void> updateJob(Job job) async {
    await jobsCollection.doc(job.id).update({
      'title': job.title,
      'technician': job.technician,
      'date': job.date,
      'isCompleted': job.isCompleted,
    });
  }
}
 */

