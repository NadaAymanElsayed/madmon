import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/view/fotgetPassword.dart';
import 'package:madmon/view/signup.dart';
import '../constants/appAssets.dart';
import '../constants/appColors.dart';
import '../core/utils/validation.dart';
import '../cubit/login/login_cubit.dart';
import '../widgets/customTextField.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    final state = context.read<LoginCubit>().state;
    emailController = TextEditingController(text: state.email);
    passwordController = TextEditingController(text: state.password);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: AppColors.white,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Image.asset(AppAssets.login),
                        SizedBox(height: 15),
                        customTextField(
                          labelText: 'البريد الالكتروني',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.email, color: AppColors.basic),
                          validator: Validators.validateEmail,
                          hintText: 'أدخل البريد الالكتروني',
                          onChanged: cubit.emailChanged,
                        ),
                        SizedBox(height: 20),
                        customTextField(
                          labelText: 'كلمة المرور',
                          controller: passwordController,
                          obscureText: !state.isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.basic,
                            ),
                            onPressed: cubit.togglePasswordVisibility,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          prefixIcon: Icon(Icons.password, color: AppColors.basic),
                          validator: Validators.validatePassword,
                          hintText: 'ادخل كلمة المرور',
                          onChanged: cubit.passwordChanged,
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: state.rememberMe,
                                  onChanged: cubit.toggleRememberMe,
                                  activeColor: AppColors.basic,
                                ),
                                Text('تذكرني', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForgetPassword()),
                                );
                              },
                              child: Text(
                                'نسيت كلمة المرور',
                                style: TextStyle(color: AppColors.black, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (state.errorMessage != null)
                          Text(
                            state.errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        SizedBox(height: 20),
                        state.isLoading
                            ? CircularProgressIndicator()
                            : InkWell(
                          onTap: () => cubit.login(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.basic,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontFamily: 'droid',
                                color: AppColors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("ليس لديك حساب؟ "),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUp()),
                                );
                              },
                              child: Text(
                                'سجل حساب جديد',
                                style: TextStyle(
                                    color: AppColors.basic, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
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




