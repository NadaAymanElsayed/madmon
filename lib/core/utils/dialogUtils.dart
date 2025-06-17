import 'package:flutter/material.dart';

class DialogUtils {
  static bool _isDialogShowing = false;

  /// عرض Dialog تحميل
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

  /// إغلاق Dialog التحميل
  static void hideLoading(BuildContext context) {
    if (_isDialogShowing && Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogShowing = false;
    }
  }

  /// عرض Dialog رسالة عامة
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

  /// إغلاق التحميل ثم عرض الرسالة
  static void showMessageAfterLoading({
    required BuildContext context,
    required String message,
    String title = '',
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    hideLoading(context); // تأكد من إغلاق Dialog التحميل أولاً

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
}