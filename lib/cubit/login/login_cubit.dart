import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/dialogUtils.dart';
import '../../view/homeTech.dart';
import '../../view/techList.dart';
part 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState()) {
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe) {
      final email = prefs.getString('email') ?? '';
      final password = prefs.getString('password') ?? '';
      emit(state.copyWith(
        rememberMe: true,
        email: email,
        password: password,
      ));
    }
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, errorMessage: null));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleRememberMe(bool? value) async {
    final newValue = value ?? false;
    emit(state.copyWith(rememberMe: newValue));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', newValue);

    if (!newValue) {
      // لو حذف "تذكرني"، نمسح البيانات
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future<void> login(BuildContext context) async {
    final email = state.email.trim();
    final password = state.password.trim();

    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(errorMessage: 'يرجى إدخال البريد الإلكتروني وكلمة المرور'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      DialogUtils.showLoading(context: context, message: 'جاري تسجيل الدخول...');

      final userCredential = await fb_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = doc.data()?['role'];

      DialogUtils.hideLoading(context);

      if (state.rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      }

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TechnicianListScreen()),
        );
      } else if (role == 'technician') {
        final technicianName = doc.data()?['name'] ?? '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeTech(
              userRole: 'technician',
              technicianName: technicianName,
            ),
          ),
        );
      } else {
        final unknownRoleMsg = 'نوع الحساب غير معروف.';
        emit(state.copyWith(errorMessage: unknownRoleMsg));
        DialogUtils.showMessage(
          context: context,
          title: 'خطأ',
          message: unknownRoleMsg,
        );
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context);
      final errorMsg = e.message ?? 'حدث خطأ أثناء تسجيل الدخول';
      emit(state.copyWith(errorMessage: errorMsg));
    } catch (e) {
      DialogUtils.hideLoading(context);
      final errorMsg = 'حدث خطأ غير متوقع: $e';
      emit(state.copyWith(errorMessage: errorMsg));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
