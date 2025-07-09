import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:madmon/cubit/signUp/signup_state.dart';
import '../../core/utils/dialogUtils.dart';
import '../../model/signUp.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void nameChanged(String value) {
    emit(state.copyWith(name: value));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(confirmPassword: value));
  }

  void roleChanged(String value) {
    emit(state.copyWith(role: value));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
  }

  Future<void> registerWithEmail(BuildContext context) async {
    final name = state.name.trim();
    final email = state.email.trim();
    final password = state.password.trim();
    final confirmPassword = state.confirmPassword.trim();
    final role = state.role;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || role.isEmpty) {
      emit(state.copyWith(errorMessage: "يرجى ملء جميع الحقول واختيار نوع الحساب."));
      return;
    }

    if (password != confirmPassword) {
      emit(state.copyWith(errorMessage: "كلمتا المرور غير متطابقتين."));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      DialogUtils.showLoading(context: context, message: "جاري التسجيل...");

      final credential = await fb_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;

      if (uid != null) {
        final user = AppUser(name: name, email: email, role: role);

        await FirebaseFirestore.instance.collection('users').doc(uid).set(user.toMap());


        if (context.mounted) {
          DialogUtils.hideLoading(context);

          await Future.delayed(const Duration(milliseconds: 200));

          DialogUtils.showMessage(
            context: context,
            message: "تم إنشاء الحساب بنجاح. يرجى التحقق من بريدك الإلكتروني لتفعيل الحساب.",
            title: "تم التسجيل",
            posActionName: "الذهاب لتسجيل الدخول",
            posAction: () async {
              await fb_auth.FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          );
        }
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      if (context.mounted) DialogUtils.hideLoading(context);

      String errorMsg;
      if (e.code == 'weak-password') {
        errorMsg = 'كلمة المرور ضعيفة جدًا.';
      } else if (e.code == 'email-already-in-use') {
        errorMsg = 'البريد الإلكتروني مستخدم مسبقًا.';
      } else {
        errorMsg = 'خطأ في التسجيل: ${e.message}';
      }

      print('FirebaseAuthException during registration: $errorMsg');

      emit(state.copyWith(errorMessage: errorMsg));

      if (context.mounted) {
        DialogUtils.showMessage(
          context: context,
          message: errorMsg,
          title: "خطأ",
          negActionName: "حاول مرة أخرى",
        );
      }
    } catch (e, stacktrace) {
      if (context.mounted) DialogUtils.hideLoading(context);

      print('Unexpected error during registration: $e');
      print('Stacktrace: $stacktrace');

      final errorMsg = 'حدث خطأ غير متوقع: $e';
      emit(state.copyWith(errorMessage: errorMsg));

      if (context.mounted) {
        DialogUtils.showMessage(
          context: context,
          message: errorMsg,
          title: "خطأ",
        );
      }
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
