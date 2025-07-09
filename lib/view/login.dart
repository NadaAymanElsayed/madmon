import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madmon/view/fotgetPassword.dart';
import 'package:madmon/view/signup.dart';
import '../constants/appAssets.dart';
import '../constants/appColors.dart';
import '../core/utils/validation.dart';
import '../cubit/login/login_cubit.dart';
import '../widgets/customTextField.dart';


class Login extends StatelessWidget {
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
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Image.asset(AppAssets.login),
                        SizedBox(height: 15,),
                        customTextField(
                          labelText: 'البريد الالكتروني',
                          controller: null,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.email, color: AppColors.basic),
                          validator: Validators.validateEmail,
                          hintText: 'أدخل البريد الالكتروني',
                          onChanged: cubit.emailChanged,
                        ),
                        SizedBox(height: 20),
                        customTextField(
                          labelText: 'كلمة المرور',
                          controller: null,
                          obscureText: !state.isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 60.0, right: 50),
                              child: Text('تذكرني',
                                style: TextStyle(
                                    fontSize: 15
                                ),),
                            ),
                            InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => ForgetPassword()),);
                                },
                                child: Text('نسيت كلمة المرور',
                                  style: TextStyle(color: AppColors.black, fontSize: 15),)
                            )
                  
                          ],
                        ),
                        SizedBox(height: 10,),
                        if (state.errorMessage != null)
                          Text(state.errorMessage!, style: TextStyle(color: Colors.red)),
                  
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
                            padding: EdgeInsets.symmetric(horizontal: 110, vertical: 18),
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
                  
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("ليس لديك حساب",
                                ),
                                SizedBox(height: 48, width: 20,),
                                InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => SignUp()),);
                                  },
                                  child: Text('سجل الدخول',
                                    style: TextStyle(
                                        color: AppColors.black,
                                    ),),
                                )
                              ],
                            ),
                          ),
                        )
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


