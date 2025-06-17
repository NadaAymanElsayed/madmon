import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/utils/dialogUtils.dart';
import '../../model/signUp.dart';

part 'signup_state.dart';


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

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      emit(state.copyWith(errorMessage: "Please fill in all fields."));
      return;
    }

    if (password != confirmPassword) {
      emit(state.copyWith(errorMessage: "Passwords do not match."));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      DialogUtils.showLoading(context: context, message: "Registering...");

      final credential = await fb_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid != null) {
        DialogUtils.showLoading(context: context, message: "Saving data...");

        final user = AppUser(name: name, email: email);
        await FirebaseFirestore.instance.collection('users').doc(uid).set(user.toMap());

        DialogUtils.hideLoading(context);

        await Future.delayed(Duration(milliseconds: 200));

        DialogUtils.showMessage(
          context: context,
          message: "Registration successful!",
          title: "Success",
          posActionName: "Go to Home",
          posAction: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        );
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context);

      String errorMsg;
      if (e.code == 'weak-password') {
        errorMsg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMsg = 'The email is already registered.';
      } else {
        errorMsg = 'Registration error: ${e.message}';
      }
      emit(state.copyWith(errorMessage: errorMsg));
      DialogUtils.showMessage(
        context: context,
        message: errorMsg,
        title: "Error",
        negActionName: "Try again",
      );
    } catch (e) {
      DialogUtils.hideLoading(context);
      final errorMsg = 'An unexpected error occurred: $e';
      emit(state.copyWith(errorMessage: errorMsg));
      DialogUtils.showMessage(
        context: context,
        message: errorMsg,
        title: "Error",
      );
    } finally {
      emit(state.copyWith(isLoading: false));
      if (context.mounted) DialogUtils.hideLoading(context);
    }
  }
}

