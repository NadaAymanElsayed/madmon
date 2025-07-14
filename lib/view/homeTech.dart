import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/constants/appColors.dart';
import '../cubit/jobs/jobs_cubit.dart';
import '../model/jobs.dart';


class HomeTech extends StatefulWidget {
  final String userRole;
  final String technicianName;

  const HomeTech({required this.userRole, required this.technicianName, Key? key}) : super(key: key);

  @override
  State<HomeTech> createState() => _HomeTechState();
}

class _HomeTechState extends State<HomeTech> {
  final _taskController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<JobsCubit>().loadJobsForTechnician(widget.technicianName);
  }

  @override
  void dispose() {
    _taskController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showEditDialog(Job job) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackblue,
      appBar: AppBar(
        title: Text('مهام الفني ${widget.technicianName}'),
        backgroundColor: AppColors.white,
      ),
      body: BlocBuilder<JobsCubit, JobsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.basic));
          }

          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final technicianJobs = state.jobs
              .where((job) => job.technician.trim() == widget.technicianName.trim())
              .toList();

          if (technicianJobs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد مهام',
                style: TextStyle(color: AppColors.white.withOpacity(0.8), fontSize: 18),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(AppColors.basic),
                dataRowColor: MaterialStateProperty.all(AppColors.white.withOpacity(0.1)),
                columns: const [
                  DataColumn(label: Text('المهمة', style: TextStyle(color: AppColors.blackblue))),
                  DataColumn(label: Text('التاريخ', style: TextStyle(color: AppColors.blackblue))),
                  DataColumn(label: Text('ملاحظات', style: TextStyle(color: AppColors.blackblue))),
                  DataColumn(label: Text('')),
                ],
                rows: technicianJobs.map((job) {
                  return DataRow(cells: [
                    DataCell(Text(job.title, style: const TextStyle(color: Colors.white70))),
                    DataCell(Text(job.date, style: const TextStyle(color: Colors.white70))),
                    DataCell(Text(job.notes ?? '', style: const TextStyle(color: Colors.white70))),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.basic),
                        onPressed: () => _showEditDialog(job),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: AppColors.blackblue,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إضافة مهمة جديدة',
              style: TextStyle(fontSize: 18, color: AppColors.basic),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'اسم المهمة',
                labelStyle: TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.basic),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.basic, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'التاريخ',
                labelStyle: TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.basic),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.basic, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'ملاحظات',
                labelStyle: TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.basic),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.basic, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.basic,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (_taskController.text.isEmpty || _dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('يرجى تعبئة المهمة والتاريخ')),
                  );
                  return;
                }

                final newJob = Job(
                  id: '',
                  title: _taskController.text,
                  technician: widget.technicianName,
                  date: _dateController.text,
                  notes: _notesController.text,
                  isCompleted: false,
                );

                context.read<JobsCubit>().addJob(newJob);

                _taskController.clear();
                _dateController.clear();
                _notesController.clear();
              },
              child: const Text('إضافة المهمة'),
            ),
          ],
        ),
      ),
    );
  }
}














