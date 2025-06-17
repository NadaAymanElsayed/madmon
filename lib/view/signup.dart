import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/constants/appAssets.dart';
import '../constants/appColors.dart';
import '../core/utils/validation.dart';
import '../cubit/signUp/signup_cubit.dart';
import '../widgets/customTextField.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  icon: Icon(Icons.arrow_circle_left_outlined, color: AppColors.white, size: 40),
                ),
              ),
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColors.basic,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Image.asset(AppAssets.logo, height: 220, ),
                      ),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                customTextField(
                                  labelText: 'الاسم',
                                  controller: nameController,
                                  keyboardType: TextInputType.text,
                                  prefixIcon: Icon(Icons.person, color: AppColors.basic),
                                  hintText: 'ادخل الاسم',
                                ),
                                SizedBox(height: 10),
                                customTextField(
                                  labelText: 'الحساب',
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(Icons.email, color: AppColors.basic),
                                  validator: Validators.validateEmail,
                                  hintText: 'ادخل حسابك',),
                                SizedBox(height: 10),
                                customTextField(
                                  labelText: 'كلمة المرور',
                                  controller: passwordController,
                                  obscureText: !state.isPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: AppColors.basic,
                                    ),
                                    onPressed: () => cubit.togglePasswordVisibility(),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  prefixIcon: Icon(Icons.password, color: AppColors.basic),
                                  validator: Validators.validatePassword,
                                  hintText: 'ادخل كلمة المرور',
                                ),
                                SizedBox(height: 10),
                                customTextField(
                                  labelText: 'تأكيد كلمة المرور',
                                  controller: confirmPasswordController,
                                  obscureText: !state.isConfirmPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      state.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: AppColors.basic,
                                    ),
                                    onPressed: () => cubit.toggleConfirmPasswordVisibility(),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  prefixIcon: Icon(Icons.password, color: AppColors.basic),
                                  validator: Validators.validatePassword,
                                  hintText: 'تأكيد كلمة المرور',
                                ),
                                SizedBox(height: 80),
                                if (state.isLoading) CircularProgressIndicator(),
                                SizedBox(height: 10),
                                if (state.errorMessage != null)
                                  Text(
                                    state.errorMessage!,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.basic,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 127, vertical: 14),
                                        child: Text(
                                          'التسجيل',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontFamily: 'ArialRounded',
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        onTap: () {
                                          if (_formKey.currentState!.validate()) {
                                            cubit.registerWithEmail(context);
                                          }
                                        };
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}