import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/constants/appAssets.dart';
import '../constants/appColors.dart';
import '../cubit/jobs/jobs_cubit.dart';
import '../cubit/tech/tech_cubit.dart';
import 'homeTech.dart';
import 'login.dart';
class TechnicianListScreen extends StatefulWidget {
  const TechnicianListScreen({super.key});

  @override
  State<TechnicianListScreen> createState() => _TechnicianListScreenState();
}

class _TechnicianListScreenState extends State<TechnicianListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TechniciansCubit>().loadTechnicians();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basic,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
        title: const Text('قائمة الفنيين'),
        backgroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.rotate(
              angle: 3.14159,
              child: Image.asset(
                AppAssets.techList,
                fit: BoxFit.cover,
                color: Colors.transparent.withOpacity(0.6),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          BlocBuilder<TechniciansCubit, List<String>>(
            builder: (context, technicians) {
              if (technicians.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: technicians.length,
                itemBuilder: (context, index) {
                  final name = technicians[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(name),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<JobsCubit>(),
                              child: HomeTech(
                                userRole: 'admin',
                                technicianName: name,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}


