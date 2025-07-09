import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/constants/appColors.dart';
import '../cubit/home/home_cubit.dart';
import '../model/jobs.dart';

class HomeTech extends StatefulWidget {
  final String userRole;
  final String technicianName;

  const HomeTech({
    super.key,
    required this.userRole,
    required this.technicianName,
  });

  @override
  State<HomeTech> createState() => _HomeTechState();
}

class _HomeTechState extends State<HomeTech> {
  @override
  void initState() {
    super.initState();
    final technicianName = widget.technicianName;
    context.read<JobsCubit>().loadJobsForTechnician(technicianName);
  }

  @override
  Widget build(BuildContext context) {
    print('اسم الفني من الحساب: ${widget.technicianName}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const Text(
          'الوظائف',
          style: TextStyle(color: AppColors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.black),
            onPressed: () {
              context.read<JobsCubit>().loadJobs();
            },
          ),
        ],
      ),

      body: BlocBuilder<JobsCubit, JobsState>(
        builder: (context, state) {
          print('عدد المهام المستلمة: ${state.jobs.length}');
          for (var job in state.jobs) {
            print('المهمة: ${job.title}, الفني: ${job.technician}');
          }

          final availableJobs = state.jobs
              .where((job) =>
          !job.isCompleted &&
              job.technician.trim() == widget.technicianName.trim()) // مهم جداً
              .toList();

          return buildJobTable(availableJobs);
        },
      ),

      ),
    );
  }

  Widget buildJobTable(List<Job> jobs) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'التاريخ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DataColumn(
                  label: Padding(
                    padding: EdgeInsets.only(left: 70.0),
                    child: Text(
                      'المهمة',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
              rows: jobs.map((job) {
                return DataRow(cells: [
                  DataCell(Text(job.date)),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Text(job.title),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}


