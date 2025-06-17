import 'package:flutter/material.dart';
import 'package:madmon/constants/appAssets.dart';
import 'package:madmon/constants/appColors.dart';
import 'package:madmon/view/home.dart';
import 'package:madmon/view/signup.dart';

import '../core/utils/validation.dart';
import '../widgets/customTextField.dart';
import 'fotgetPassword.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }
    bool isPasswordVisible = false;
    bool isConfirmPasswordVisible = false;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
          Container(
          decoration: BoxDecoration(
            color: AppColors.basic,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          ),
            Image.asset(AppAssets.login),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    customTextField(
                      labelText: 'البريد الالكتروني',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email,
                          color: AppColors.basic),
                      validator: Validators.validateEmail,
                      hintText: 'أدخل البريد الالكتروني',
                      style: TextStyle(color: AppColors.basic, fontSize: 16),
                    ),
                    SizedBox(height: 20,),
                    customTextField(
                        labelText: 'كلمة المرور',
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.basic,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icon(Icons.password,
                            color: AppColors.basic),
                        validator: Validators.validatePassword,
                        hintText: 'ادخل كلمة المرور',
                        style: TextStyle(color: AppColors.basic, fontSize: 16)
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only( left: 80 ,right: 20),
                          child: Text('تذكرني',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'ArialRounded',
                            ),),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => ForgetPassword()),);
                            },
                            child: Text('نسيت كلمة المرور',
                              style: TextStyle(color: AppColors.basic, fontSize: 15,
                                fontFamily: 'ArialRounded',),)
                        )

                      ],
                    ),
                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.basic,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 110, vertical: 18),
                              child: Text('تسجيل الدخول',
                                style: TextStyle(
                                    fontFamily: 'ArialRounded',
                                    color: AppColors.white,
                                    fontSize: 20
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            }
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("ليس لدي بريد الكتروني",
                              style: TextStyle(
                                fontFamily: 'ArialRounded',
                                fontSize: 15,
                              ),),
                            SizedBox(height: 48, width: 20,),
                            InkWell(
                              onTap: (){
                                Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => SignUp()),);
                              },
                              child: Text('التسجيل',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.basic,
                                  fontFamily: 'ArialRounded',
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
          ],
          ),
        ),
      ),
    );
  }
}