import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import '../../core/utils/dialogUtils.dart';
import '../../view/homePageAdmin.dart';
import '../../view/homeTech.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, errorMessage: null));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login(BuildContext context) async {
    final email = state.email.trim();
    final password = state.password.trim();

    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(errorMessage: 'يرجى إدخال البريد الإلكتروني وكلمة المرور'));
      print('Login error: empty email or password');
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

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeAdmin(userRole: 'admin')),
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
        print('Login error: $unknownRoleMsg');
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
      print('FirebaseAuthException: $errorMsg');
    } catch (e) {
      DialogUtils.hideLoading(context);
      final errorMsg = 'حدث خطأ غير متوقع: $e';
      emit(state.copyWith(errorMessage: errorMsg));
      print(errorMsg);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
