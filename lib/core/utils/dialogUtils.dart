import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/jobs/jobs_cubit.dart';
import '../../model/jobs.dart';

class DialogUtils {
  static bool _isDialogShowing = false;

  static void showLoading({required BuildContext context, required String message}) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    if (_isDialogShowing && Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogShowing = false;
    }
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String title = '',
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    List<Widget> actions = [];

    if (posActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            if (posAction != null) {
              Future.delayed(const Duration(milliseconds: 200), () {
                posAction.call();
              });
            }
          },
          child: Text(posActionName),
        ),
      );
    }

    if (negActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            if (negAction != null) {
              negAction.call();
            }
          },
          child: Text(negActionName),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: title.isNotEmpty ? Text(title) : null,
          content: Text(message),
          actions: actions,
        );
      },
    );
  }

  static void showMessageAfterLoading({
    required BuildContext context,
    required String message,
    String title = '',
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    hideLoading(context);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (context.mounted) {
        showMessage(
          context: context,
          message: message,
          title: title,
          posActionName: posActionName,
          posAction: posAction,
          negActionName: negActionName,
          negAction: negAction,
        );
        debugPrint("تم عرض رسالة النجاح");
      }
    });
  }

  static void showAddJobDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController technicianController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
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
                  decoration: const InputDecoration(labelText: 'تاريخ'),
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
              onPressed: () async {
                final job = Job(
                  id: FirebaseFirestore.instance.collection('jobs').doc().id,
                  title: titleController.text,
                  technician: technicianController.text,
                  date: dateController.text,
                  isCompleted: false,
                );

                await context.read<JobsCubit>().addJob(job);
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  static void showEditDialog(BuildContext context, Job job) {
    TextEditingController titleController = TextEditingController(text: job.title);
    TextEditingController technicianController = TextEditingController(text: job.technician);
    TextEditingController dateController = TextEditingController(text: job.date);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل المهمة'),
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
                  decoration: const InputDecoration(labelText: 'تاريخ'),
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
              onPressed: () async {
                final updatedJob = job.copyWith(
                  title: titleController.text,
                  technician: technicianController.text,
                  date: dateController.text,
                );

                await context.read<JobsCubit>().updateJob(updatedJob);
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}

