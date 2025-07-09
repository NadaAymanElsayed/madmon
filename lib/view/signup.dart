import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/constants/appAssets.dart';
import '../constants/appColors.dart';
import '../core/utils/validation.dart';
import '../cubit/signUp/signup_cubit.dart';
import '../cubit/signUp/signup_state.dart';
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
                        child: Image.asset(AppAssets.logo, height: 200),
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
                                  onChanged: (value) => cubit.nameChanged(value),
                                ),
                                SizedBox(height: 10),
                                customTextField(
                                  labelText: 'الحساب',
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(Icons.email, color: AppColors.basic),
                                  validator: Validators.validateEmail,
                                  hintText: 'ادخل حسابك',
                                  onChanged: (value) => cubit.emailChanged(value),
                                ),
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
                                  onChanged: (value) => cubit.passwordChanged(value),
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
                                  onChanged: (value) => cubit.confirmPasswordChanged(value),
                                ),

                                SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "اختر نوع الحساب",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.build),
                                            label: Text("فني"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: state.role == 'technician' ? AppColors.basic : Colors.grey[300],
                                              foregroundColor: Colors.white,
                                              minimumSize: Size(130, 50),
                                            ),
                                            onPressed: () {
                                              cubit.roleChanged('technician');
                                            },
                                          ),
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.admin_panel_settings),
                                            label: Text("إداري"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: state.role == 'admin' ? AppColors.basic : Colors.grey[300],
                                              foregroundColor: Colors.white,
                                              minimumSize: Size(130, 50),
                                            ),
                                            onPressed: () {
                                              cubit.roleChanged('admin');
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),


                                SizedBox(height: 10),

                                if (state.isLoading)
                                  CircularProgressIndicator(),

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
                                        if (_formKey.currentState!.validate()) {
                                          cubit.registerWithEmail(context);
                                        }
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