import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/constants/appColors.dart';
import '../core/utils/dialogUtils.dart';
import '../cubit/home/home_cubit.dart';
import '../model/jobs.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basic,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('الوظائف (إداري)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddJobDialog(context),
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
          final availableJobs =
          state.jobs.where((job) => !job.isCompleted).toList();
          final completedJobs =
          state.jobs.where((job) => job.isCompleted).toList();

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('المهمة')),
          DataColumn(label: Text('الفني')),
          DataColumn(label: Text('التاريخ')),
          DataColumn(label: Text('')),
        ],
        rows: jobs.map((job) {
          return DataRow(cells: [
            DataCell(Text(job.title)),
            DataCell(Text(job.technician)),
            DataCell(Text(job.date)),
            DataCell(
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  DialogUtils.showEditDialog(context, job);
                },
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  void _showAddJobDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController technicianController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('إضافة مهمة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  isCompleted: false,
                );

                context.read<JobsCubit>().addJob(job);

                Navigator.pop(context);
              },
              child: Text('حفظ'),
            ),

          ],
        );
      },
    );
  }
}
