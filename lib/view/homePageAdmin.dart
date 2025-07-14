import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/constants/appColors.dart';
import '../cubit/jobs/jobs_cubit.dart';
import '../model/jobs.dart';
import 'homeTech.dart';


class HomeAdmin extends StatefulWidget {
  final String userRole;

  const HomeAdmin({super.key, required this.userRole});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<JobsCubit>().loadJobs();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void showEditDialog(Job job) {
    final titleController = TextEditingController(text: job.title);
    final dateController = TextEditingController(text: job.date);
    final notesController = TextEditingController(text: job.notes ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل المهمة'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'المهمة'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'التاريخ'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'ملاحظات'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedJob = job.copyWith(
                title: titleController.text,
                date: dateController.text,
                notes: notesController.text,
              );
              context.read<JobsCubit>().updateJob(updatedJob);
              Navigator.pop(context);
            },
            child: const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String jobId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذه المهمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<JobsCubit>().deleteJob(jobId);
              Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basic,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('الوظائف (إداري)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة مهمة',
            onPressed: () => _showAddJobDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.supervised_user_circle),
            tooltip: 'عرض مهام الفنيين',
            onPressed: () => _showTechnicianListDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'المتاحة'),
            Tab(text: 'المنتهية'),
          ],
        ),
      ),
      body: BlocBuilder<JobsCubit, JobsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!, style: const TextStyle(color: Colors.red)));
          }

          final availableJobs = state.jobs.where((job) => !job.isCompleted).toList();
          final completedJobs = state.jobs.where((job) => job.isCompleted).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              buildJobTable(availableJobs),
              buildJobTable(completedJobs),
            ],
          );
        },
      ),
    );
  }

  Widget buildJobTable(List<Job> jobs) {
    if (jobs.isEmpty) {
      return const Center(child: Text('لا توجد مهام'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('المهمة')),
          DataColumn(label: Text('الفني')),
          DataColumn(label: Text('التاريخ')),
          DataColumn(label: Text('ملاحظات')),
          DataColumn(label: Text('')),
        ],
        rows: jobs.map((job) {
          return DataRow(cells: [
            DataCell(Text(job.title)),
            DataCell(Text(job.technician)),
            DataCell(Text(job.date)),
            DataCell(Text(job.notes ?? '')),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => showEditDialog(job),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(job.id),
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  void _showAddJobDialog(BuildContext context) {
    final titleController = TextEditingController();
    final technicianController = TextEditingController();
    final dateController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('إضافة مهمة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'المهمة'),
                ),
                TextField(
                  controller: technicianController,
                  decoration: const InputDecoration(labelText: 'اسم الفني'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'التاريخ'),
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'ملاحظات'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final job = Job(
                  id: FirebaseFirestore.instance.collection('jobs').doc().id,
                  title: titleController.text,
                  technician: technicianController.text,
                  date: dateController.text,
                  notes: notesController.text,
                  isCompleted: false,
                );

                context.read<JobsCubit>().addJob(job);
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  void _showTechnicianListDialog(BuildContext context) {
    final jobs = context.read<JobsCubit>().state.jobs;
    final technicians = _extractTechnicianNames(jobs);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('اختر فنيًا'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: technicians.length,
              itemBuilder: (context, index) {
                final techName = technicians[index];
                return ListTile(
                  title: Text(techName),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeTech(
                          userRole: 'admin',
                          technicianName: techName,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<String> _extractTechnicianNames(List<Job> jobs) {
    final names = jobs
        .map((job) => job.technician.trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
    names.sort();
    return names;
  }
}





