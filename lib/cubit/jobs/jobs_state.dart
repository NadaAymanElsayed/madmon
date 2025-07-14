part of 'jobs_cubit.dart';

@immutable

class JobsState {
  final List<Job> jobs;
  final bool isLoading;
  final String? error;

  JobsState({
    required this.jobs,
    required this.isLoading,
    this.error,
  });

  factory JobsState.initial() => JobsState(
    jobs: [],
    isLoading: false,
    error: null,
  );

  JobsState copyWith({
    List<Job>? jobs,
    bool? isLoading,
    String? error,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}


